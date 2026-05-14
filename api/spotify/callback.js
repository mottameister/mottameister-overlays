import { exchangeCodeForToken } from './_utils.js';

export default async function handler(req, res) {
  const { code, error } = req.query;

  if (error) {
    res.status(400).send(`Spotify recusou a autorização: ${error}`);
    return;
  }

  if (!code) {
    res.status(400).send('Callback sem parâmetro code.');
    return;
  }

  try {
    const token = await exchangeCodeForToken({ code, req });
    const refreshToken = token.refresh_token || '';

    res.setHeader('Content-Type', 'text/html; charset=utf-8');
    res.send(`<!doctype html>
<html lang="pt-BR">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Spotify conectado</title>
    <style>
      body { margin: 0; min-height: 100vh; display: grid; place-items: center; background: #090711; color: #f7f2ff; font-family: Inter, system-ui, sans-serif; }
      main { width: min(760px, calc(100% - 32px)); padding: 28px; border: 1px solid rgba(67,217,255,.32); background: rgba(255,255,255,.06); box-shadow: 0 0 42px rgba(181,23,255,.22); }
      h1 { margin: 0 0 12px; }
      p { color: #b9a9cb; line-height: 1.5; }
      textarea { width: 100%; min-height: 120px; padding: 14px; color: #f7f2ff; background: #05030a; border: 1px solid rgba(67,217,255,.32); }
      code { color: #43d9ff; }
    </style>
  </head>
  <body>
    <main>
      <h1>Spotify conectado</h1>
      <p>Copie este valor para a variável de ambiente <code>SPOTIFY_REFRESH_TOKEN</code> na Vercel. Depois faça redeploy.</p>
      <textarea readonly>${refreshToken}</textarea>
      <p>Depois disso, a rota <code>/music</code> vai buscar a música atual automaticamente.</p>
    </main>
  </body>
</html>`);
  } catch (err) {
    res.status(500).send(`Erro ao conectar Spotify: ${err.message}`);
  }
}
