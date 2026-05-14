export function getStreamerBotUrl(config) {
  const host = config.host || '127.0.0.1';
  const port = config.port || 8080;
  const endpoint = config.endpoint || '/';
  const protocol = config.secure ? 'wss' : 'ws';

  return `${protocol}://${host}:${port}${endpoint}`;
}

export function getEventSourceKey(events, source) {
  return Object.keys(events || {}).find((key) => key.toLowerCase() === source.toLowerCase());
}

export function buildSubscription(events, desiredEvents) {
  const subscription = {};

  Object.entries(desiredEvents).forEach(([source, eventNames]) => {
    const sourceKey = getEventSourceKey(events, source);
    if (!sourceKey) return;

    const available = events[sourceKey] || [];
    const filtered = eventNames
      .map((eventName) =>
        available.find((availableEvent) => String(availableEvent).toLowerCase() === eventName.toLowerCase()),
      )
      .filter(Boolean);

    if (filtered.length > 0) {
      subscription[sourceKey] = filtered;
    }
  });

  return subscription;
}

export function sendRequest(socket, request) {
  if (socket.readyState !== WebSocket.OPEN) return;
  socket.send(JSON.stringify(request));
}

export function toNumber(value, fallback = 0) {
  const number = Number(value);
  return Number.isFinite(number) ? number : fallback;
}

export function getFirstValue(source, keys, fallback = '') {
  for (const key of keys) {
    const value = source?.[key];
    if (value !== undefined && value !== null && value !== '') {
      return value;
    }
  }

  return fallback;
}
