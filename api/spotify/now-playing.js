import { getNowPlaying, sendJson } from './_utils.js';

export default async function handler(req, res) {
  if (req.method === 'OPTIONS') {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
    res.status(204).end();
    return;
  }

  try {
    const track = await getNowPlaying();
    sendJson(res, 200, track);
  } catch (error) {
    sendJson(res, 500, {
      title: 'Spotify não configurado',
      artist: error.message,
      album: '',
      cover: '',
      isPlaying: false,
      progress: 0,
      duration: 0,
    });
  }
}
