import { getRedirectUri, requireSpotifyEnv } from './_utils.js';

export default function handler(req, res) {
  try {
    const { clientId } = requireSpotifyEnv();
    const state = Math.random().toString(36).slice(2);
    const params = new URLSearchParams({
      client_id: clientId,
      response_type: 'code',
      redirect_uri: getRedirectUri(req),
      scope: 'user-read-currently-playing user-read-playback-state',
      state,
      show_dialog: 'true',
    });

    res.writeHead(302, {
      Location: `https://accounts.spotify.com/authorize?${params.toString()}`,
    });
    res.end();
  } catch (error) {
    res.status(500).send(`Spotify setup incompleto: ${error.message}`);
  }
}
