import { useEffect, useMemo, useRef, useState } from 'react';
import { motion } from 'framer-motion';
import { Flame } from 'lucide-react';
import { streamConfig } from '../data/config';
import { buildSubscription, getStreamerBotUrl, sendRequest, toNumber } from '../lib/streamerbot';

const desiredGoalEvents = {
  General: ['Custom'],
  Custom: ['Event'],
};

export default function Goal() {
  const fallbackGoal = streamConfig.goal;
  const params = new URLSearchParams(window.location.search);
  const urlGoal = {
    label: params.get('label') || fallbackGoal.label,
    current: toNumber(params.get('current'), fallbackGoal.current),
    target: toNumber(params.get('target'), fallbackGoal.target),
    unit: params.get('unit') || fallbackGoal.unit,
  };
  const hasUrlGoal = ['label', 'current', 'target', 'unit'].some((key) => params.has(key));
  const [goal, setGoal] = useState({
    label: urlGoal.label,
    current: urlGoal.current,
    target: urlGoal.target,
    unit: urlGoal.unit,
  });
  const [status, setStatus] = useState('conectando');
  const socketRef = useRef(null);

  const variableByRequestId = useMemo(
    () => ({
      goalCurrent: fallbackGoal.variables.current,
      goalTarget: fallbackGoal.variables.target,
      goalLabel: fallbackGoal.variables.label,
      goalUnit: fallbackGoal.variables.unit,
    }),
    [fallbackGoal.variables.current, fallbackGoal.variables.label, fallbackGoal.variables.target, fallbackGoal.variables.unit],
  );

  useEffect(() => {
    if (hasUrlGoal) {
      setStatus('url manual');
      return undefined;
    }

    let reconnectTimer;
    let refreshTimer;
    let closed = false;

    const requestGoal = (socket) => {
      Object.entries(variableByRequestId).forEach(([id, variable]) => {
        sendRequest(socket, {
          request: 'GetGlobal',
          id,
          variable,
          persisted: true,
        });
      });
    };

    const connect = () => {
      const socket = new WebSocket(getStreamerBotUrl(streamConfig.streamerbot));
      socketRef.current = socket;

      socket.addEventListener('open', () => {
        setStatus('online');
        requestGoal(socket);
        refreshTimer = window.setInterval(() => requestGoal(socket), streamConfig.streamerbot.goalRefreshMs);
        sendRequest(socket, { request: 'GetEvents', id: 'goalGetEvents' });
      });

      socket.addEventListener('message', (event) => {
        let payload;
        try {
          payload = JSON.parse(event.data);
        } catch {
          return;
        }

        if (payload.id === 'goalGetEvents' && payload.events) {
          const events = buildSubscription(payload.events, desiredGoalEvents);
          if (Object.keys(events).length > 0) {
            sendRequest(socket, { request: 'Subscribe', id: 'goalCustomEvents', events });
          }
          return;
        }

        if (payload.id && variableByRequestId[payload.id] && (payload.variable !== undefined || payload.value !== undefined)) {
          const variableValue = payload.variable?.value ?? payload.variable ?? payload.value;
          setGoal((currentGoal) => {
            const nextGoal = { ...currentGoal };
            if (payload.id === 'goalCurrent') nextGoal.current = toNumber(variableValue, currentGoal.current);
            if (payload.id === 'goalTarget') nextGoal.target = toNumber(variableValue, currentGoal.target);
            if (payload.id === 'goalLabel') nextGoal.label = String(variableValue || currentGoal.label);
            if (payload.id === 'goalUnit') nextGoal.unit = String(variableValue || currentGoal.unit);
            return nextGoal;
          });
          return;
        }

        const data = payload.data || payload;
        const customEventName = data.event || data.eventName;
        if (customEventName !== 'overlayGoal' && customEventName !== 'goal') return;

        const args = data.args || data;
        setGoal((currentGoal) => ({
          label: args.label || currentGoal.label,
          current: toNumber(args.current, currentGoal.current),
          target: toNumber(args.target, currentGoal.target),
          unit: args.unit || currentGoal.unit,
        }));
      });

      socket.addEventListener('close', () => {
        window.clearInterval(refreshTimer);
        setStatus('offline');
        if (!closed) reconnectTimer = window.setTimeout(connect, 2500);
      });

      socket.addEventListener('error', () => {
        setStatus('offline');
      });
    };

    connect();

    return () => {
      closed = true;
      window.clearTimeout(reconnectTimer);
      window.clearInterval(refreshTimer);
      socketRef.current?.close();
    };
  }, [hasUrlGoal, variableByRequestId]);

  const { label, current, target, unit } = goal;
  const percent = target > 0 ? Math.min(100, Math.round((current / target) * 100)) : 0;

  return (
    <main className="overlay-screen">
      <motion.section
        className="goal-overlay"
        initial={{ opacity: 0, y: 28 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.65 }}
      >
        <div className="goal-overlay__header">
          <div className="goal-overlay__title">
            <Flame className="h-7 w-7 text-cyan" />
            <h1>{label}</h1>
          </div>
          <p>
            {current}/{target} {unit}
          </p>
        </div>
        <div className="goal-overlay__bar">
          <motion.div
            className="goal-overlay__bar-fill"
            initial={{ width: 0 }}
            animate={{ width: `${percent}%` }}
            transition={{ duration: 1.4, ease: 'easeOut' }}
          />
        </div>
        <div className="goal-overlay__footer">
          <span>{percent}% completo</span>
          <span>{status === 'online' ? 'Streamer.bot conectado' : 'aguardando Streamer.bot'}</span>
        </div>
      </motion.section>
    </main>
  );
}
