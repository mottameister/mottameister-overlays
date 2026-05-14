const TOKEN_ENDPOINT = 'https://accounts.spotify.com/api/token';
const NOW_PLAYING_ENDPOINT = 'https://api.spotify.com/v1/me/player/currently-playing';

export function getBaseUrl(req) {
  const proto = req.headers['x-forwarded-proto'] || 'https';
  const host = req.headers['x-forwarded-host'] || req.headers.host;
  return `${proto}://${host}`;
}

export function getRedirectUri(req) {
  return process.env.SPOTIFY_REDIRECT_URI || `${getBaseUrl(req)}/api/spotify/callback`;
}

export function requireSpotifyEnv() {
  const clientId = process.env.SPOTIFY_CLIENT_ID;
  const clientSecret = process.env.SPOTIFY_CLIENT_SECRET;

  if (!clientId || !clientSecret) {
    throw new Error('Missing SPOTIFY_CLIENT_ID or SPOTIFY_CLIENT_SECRET');
  }

  return { clientId, clientSecret };
}

export async function exchangeCodeForToken({ code, req }) {
  const { clientId, clientSecret } = requireSpotifyEnv();
  const body = new URLSearchParams({
    grant_type: 'authorization_code',
    code,
    redirect_uri: getRedirectUri(req),
  });

  const response = await fetch(TOKEN_ENDPOINT, {
    method: 'POST',
    headers: {
      Authorization: `Basic ${Buffer.from(`${clientId}:${clientSecret}`).toString('base64')}`,
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body,
  });

  const payload = await response.json();
  if (!response.ok) {
    throw new Error(payload.error_description || payload.error || 'Spotify token exchange failed');
  }

  return payload;
}

export async function refreshAccessToken() {
  const { clientId, clientSecret } = requireSpotifyEnv();
  const refreshToken = process.env.SPOTIFY_REFRESH_TOKEN;

  if (!refreshToken) {
    throw new Error('Missing SPOTIFY_REFRESH_TOKEN');
  }

  const response = await fetch(TOKEN_ENDPOINT, {
    method: 'POST',
    headers: {
      Authorization: `Basic ${Buffer.from(`${clientId}:${clientSecret}`).toString('base64')}`,
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: new URLSearchParams({
      grant_type: 'refresh_token',
      refresh_token: refreshToken,
    }),
  });

  const payload = await response.json();
  if (!response.ok) {
    throw new Error(payload.error_description || payload.error || 'Spotify refresh failed');
  }

  return payload.access_token;
}

export async function getNowPlaying() {
  const accessToken = await refreshAccessToken();
  const response = await fetch(NOW_PLAYING_ENDPOINT, {
    headers: {
      Authorization: `Bearer ${accessToken}`,
    },
  });

  if (response.status === 204) {
    return {
      title: 'Nada tocando agora',
      artist: 'Spotify',
      album: '',
      cover: '',
      isPlaying: false,
      progress: 0,
      duration: 0,
    };
  }

  const payload = await response.json();
  if (!response.ok) {
    throw new Error(payload.error?.message || 'Spotify now-playing failed');
  }

  const item = payload.item;
  const image = item?.album?.images?.[0]?.url || '';

  return {
    title: item?.name || 'Nada tocando agora',
    artist: item?.artists?.map((artist) => artist.name).join(', ') || 'Spotify',
    album: item?.album?.name || '',
    cover: image,
    isPlaying: Boolean(payload.is_playing),
    progress: payload.progress_ms || 0,
    duration: item?.duration_ms || 0,
  };
}

export function sendJson(res, status, data) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Cache-Control', 'no-store');
  res.status(status).json(data);
}
