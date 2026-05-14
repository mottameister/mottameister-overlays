import { useEffect, useRef, useState } from 'react';
import { AnimatePresence, motion } from 'framer-motion';
import { Bell, Gift, Heart, Radio, Sparkles, Star, Zap } from 'lucide-react';
import OwlMark from '../components/OwlMark';
import { streamConfig } from '../data/config';
import { buildSubscription, getFirstValue, getStreamerBotUrl, sendRequest, toNumber } from '../lib/streamerbot';

const desiredEvents = {
  Twitch: [
    'Follow',
    'Cheer',
    'Sub',
    'ReSub',
    'GiftSub',
    'GiftBomb',
    'Raid',
    'RewardRedemption',
    'CommunityGoalContribution',
  ],
  YouTube: ['SuperChat', 'SuperSticker', 'NewSponsor', 'MemberMileStone', 'MembershipGift', 'Subscriber'],
  Kick: ['Follow', 'Subscription', 'GiftedSubscription', 'GiftedSubscriptions', 'Raid'],
  General: ['Custom'],
  Custom: ['Event'],
};

const alertIcons = {
  follow: Heart,
  sub: Star,
  gift: Gift,
  raid: Radio,
  cheer: Zap,
  reward: Sparkles,
  default: Bell,
};

function createAlertId() {
  return `${Date.now()}-${Math.random().toString(36).slice(2)}`;
}

function getUserName(data) {
  return getFirstValue(data, ['userName', 'username', 'displayName', 'name', 'fromUserName', 'gifterUserName'], 'alguem da Toca');
}

function normalizeAlert(payload) {
  const source = payload.event?.source || payload.eventSource || payload.source || 'Streamer.bot';
  const type = payload.event?.type || payload.eventType || payload.type || 'Custom';
  const normalizedSource = String(source).toLowerCase();
  const normalizedType = String(type).toLowerCase();
  const data = payload.data || payload;
  const args = data.args || data;
  const customEventName = data.event || data.eventName;

  if (customEventName === 'overlayAlert' || customEventName === 'alert') {
    return {
      id: createAlertId(),
      kind: args.kind || 'default',
      source: args.source || source,
      eyebrow: args.eyebrow || 'Aviso da Toca',
      title: args.title || 'Novo alerta',
      user: args.user || args.userName || args.name || 'Comunidade',
      message: args.message || args.text || 'chegou junto na live',
    };
  }

  if (normalizedSource === 'twitch') {
    if (normalizedType === 'follow') {
      return {
        id: createAlertId(),
        kind: 'follow',
        source,
        eyebrow: 'Novo follow',
        title: 'Bem-vindo a Toca',
        user: getUserName(data),
        message: 'seguiu o canal',
      };
    }

    if (['sub', 'resub'].includes(normalizedType)) {
      const months = getFirstValue(data, ['cumulativeMonths', 'months', 'streakMonths'], '');
      return {
        id: createAlertId(),
        kind: 'sub',
        source,
        eyebrow: normalizedType === 'resub' ? 'Resub na Toca' : 'Novo sub',
        title: 'Apoio desbloqueado',
        user: getUserName(data),
        message: months ? `assinou por ${months} meses` : 'assinou o canal',
      };
    }

    if (['giftsub', 'giftbomb'].includes(normalizedType)) {
      const count = toNumber(getFirstValue(data, ['gifts', 'total', 'count'], 1), 1);
      return {
        id: createAlertId(),
        kind: 'gift',
        source,
        eyebrow: 'Presente na Toca',
        title: 'Sub presenteado',
        user: getUserName(data),
        message: count > 1 ? `presenteou ${count} subs` : 'presenteou um sub',
      };
    }

    if (normalizedType === 'cheer') {
      const bits = getFirstValue(data, ['bits', 'amount'], '');
      return {
        id: createAlertId(),
        kind: 'cheer',
        source,
        eyebrow: 'Bits na Toca',
        title: 'Energia recebida',
        user: getUserName(data),
        message: bits ? `mandou ${bits} bits` : 'mandou bits',
      };
    }

    if (normalizedType === 'raid') {
      const viewers = getFirstValue(data, ['viewers', 'viewerCount'], '');
      return {
        id: createAlertId(),
        kind: 'raid',
        source,
        eyebrow: 'Raid chegando',
        title: 'Portoes da Toca abertos',
        user: getUserName(data),
        message: viewers ? `chegou com ${viewers} pessoas` : 'trouxe a galera pra live',
      };
    }

    if (normalizedType === 'rewardredemption') {
      const reward = getFirstValue(data, ['rewardTitle', 'rewardName', 'title'], 'resgate');
      return {
        id: createAlertId(),
        kind: 'reward',
        source,
        eyebrow: 'Resgate da Toca',
        title: reward,
        user: getUserName(data),
        message: 'usou uma recompensa',
      };
    }
  }

  if (normalizedSource === 'youtube') {
    return {
      id: createAlertId(),
      kind: ['superchat', 'supersticker'].includes(normalizedType) ? 'cheer' : 'sub',
      source,
      eyebrow: normalizedType === 'superchat' ? 'Super Chat' : 'YouTube na Toca',
      title: normalizedType === 'supersticker' ? 'Super Sticker recebido' : 'Novo apoio',
      user: getUserName(data),
      message: getFirstValue(data, ['message', 'text', 'amount'], 'chegou junto na live'),
    };
  }

  if (normalizedSource === 'kick') {
    return {
      id: createAlertId(),
      kind: normalizedType.includes('gift') ? 'gift' : 'sub',
      source,
      eyebrow: 'Kick na Toca',
      title: normalizedType === 'follow' ? 'Novo follow' : 'Novo apoio',
      user: getUserName(data),
      message: 'chegou junto na live',
    };
  }

  return null;
}

export default function Alerts() {
  const [alert, setAlert] = useState(null);
  const [connected, setConnected] = useState(false);
  const queueRef = useRef([]);
  const visibleRef = useRef(false);
  const socketRef = useRef(null);

  useEffect(() => {
    let reconnectTimer;
    let hideTimer;
    let closed = false;

    const showNext = () => {
      if (visibleRef.current || queueRef.current.length === 0) return;

      visibleRef.current = true;
      setAlert(queueRef.current.shift());
      hideTimer = window.setTimeout(() => {
        setAlert(null);
        visibleRef.current = false;
        window.setTimeout(showNext, 450);
      }, streamConfig.streamerbot.alertDuration);
    };

    const pushAlert = (nextAlert) => {
      if (!nextAlert) return;
      queueRef.current.push(nextAlert);
      showNext();
    };

    const connect = () => {
      const socket = new WebSocket(getStreamerBotUrl(streamConfig.streamerbot));
      socketRef.current = socket;

      socket.addEventListener('open', () => {
        setConnected(true);
        sendRequest(socket, { request: 'GetEvents', id: 'alertsGetEvents' });
      });

      socket.addEventListener('message', (event) => {
        let payload;
        try {
          payload = JSON.parse(event.data);
        } catch {
          return;
        }

        if (payload.id === 'alertsGetEvents' && payload.events) {
          const events = buildSubscription(payload.events, desiredEvents);
          if (Object.keys(events).length > 0) {
            sendRequest(socket, { request: 'Subscribe', id: 'alertsSubscribe', events });
          }
          return;
        }

        pushAlert(normalizeAlert(payload));
      });

      socket.addEventListener('close', () => {
        setConnected(false);
        if (!closed) reconnectTimer = window.setTimeout(connect, 2500);
      });

      socket.addEventListener('error', () => {
        setConnected(false);
      });
    };

    connect();

    return () => {
      closed = true;
      window.clearTimeout(reconnectTimer);
      window.clearTimeout(hideTimer);
      socketRef.current?.close();
    };
  }, []);

  const Icon = alertIcons[alert?.kind] || alertIcons.default;

  return (
    <main className="overlay-screen grid place-items-center p-12">
      <AnimatePresence>
        {alert ? (
          <motion.section
            key={alert.id}
            className="alert-overlay"
            initial={{ opacity: 0, y: -36, scale: 0.9 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: 30, scale: 0.94 }}
            transition={{ type: 'spring', stiffness: 130, damping: 15 }}
          >
            <div className="alert-overlay__icon">
              <OwlMark compact />
              <Icon className="alert-overlay__glyph" />
            </div>
            <div className="alert-overlay__content">
              <p className="alert-overlay__eyebrow">
                <span>{alert.source}</span>
                {alert.eyebrow}
              </p>
              <h1>{alert.title}</h1>
              <p className="alert-overlay__message">
                <span>{alert.user}</span> {alert.message}
              </p>
            </div>
          </motion.section>
        ) : null}
      </AnimatePresence>
      <div className="alert-overlay__status">{connected ? '' : 'aguardando Streamer.bot'}</div>
    </main>
  );
}
