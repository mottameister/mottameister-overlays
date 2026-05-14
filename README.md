# Overlays da Toca da Coruja

Overlays de livestream do `@mottameister`, feitos com Vite, React, React Router, Framer Motion e Tailwind CSS.

O projeto está publicado na Vercel e pensado para uso no OBS como Browser Source em `1920x1080`.

## Links Para OBS

```txt
https://mottameister-overlays.vercel.app/starting
https://mottameister-overlays.vercel.app/brb
https://mottameister-overlays.vercel.app/ending
https://mottameister-overlays.vercel.app/offline
https://mottameister-overlays.vercel.app/camera
https://mottameister-overlays.vercel.app/browser-camera
https://mottameister-overlays.vercel.app/gameplay
https://mottameister-overlays.vercel.app/music
https://mottameister-overlays.vercel.app/chat
https://mottameister-overlays.vercel.app/goal
https://mottameister-overlays.vercel.app/alerts
```

## O Que Tem Em Cada Rota

- `/starting`: tela de início da live, com fundo completo.
- `/brb`: tela de pausa rápida.
- `/ending`: tela de encerramento.
- `/offline`: tela para quando a live estiver offline.
- `/camera`: moldura grande para cena dedicada de câmera.
- `/browser-camera`: moldura retangular, quadrada e sem texto, para câmera sobre navegador ou cenas genéricas.
- `/gameplay`: anel circular transparente para a câmera da cena principal de gameplay.
- `/music`: overlay transparente para mostrar música atual, artista e capa.
- `/chat`: visual estático de chat.
- `/goal`: visual estático de meta.
- `/alerts`: visual estático de alerta.

## Como Usar No OBS

1. Adicione uma fonte `Navegador`.
2. Cole uma das URLs acima.
3. Configure `Largura` como `1920`.
4. Configure `Altura` como `1080`.
5. Ative `Atualizar navegador quando a cena se tornar ativa`.
6. Em overlays animados, como `/alerts`, também pode ativar `Desligar fonte quando não visível` para reiniciar a animação.

As rotas `/gameplay`, `/browser-camera`, `/camera`, `/chat`, `/goal` e `/alerts` têm fundo transparente para ficarem por cima da gameplay, câmera ou navegador.

## Música Do Spotify

A rota `/music` mostra uma caixinha com capa, título, artista e barra de progresso.

Exemplo manual:

```txt
https://mottameister-overlays.vercel.app/music?title=Nome%20da%20Musica&artist=Artista&cover=https%3A%2F%2Fexemplo.com%2Fcapa.jpg
```

Por padrão, `/music` tenta buscar a música atual em:

```txt
/api/spotify/now-playing
```

Para isso funcionar, configure a integração Spotify na Vercel.

## Integração Spotify

1. Crie um app em `developer.spotify.com`.
2. Configure este Redirect URI no app do Spotify:

```txt
https://mottameister-overlays.vercel.app/api/spotify/callback
```

3. Na Vercel, adicione as variáveis de ambiente:

```txt
SPOTIFY_CLIENT_ID
SPOTIFY_CLIENT_SECRET
SPOTIFY_REDIRECT_URI=https://mottameister-overlays.vercel.app/api/spotify/callback
```

4. Faça redeploy.
5. Abra esta URL e faça login no Spotify:

```txt
https://mottameister-overlays.vercel.app/api/spotify/login
```

6. A página vai mostrar um `refresh_token`.
7. Copie esse valor para uma nova variável na Vercel:

```txt
SPOTIFY_REFRESH_TOKEN
```

8. Faça redeploy de novo.
9. Use no OBS:

```txt
https://mottameister-overlays.vercel.app/music
```

Outros caminhos possíveis:

- Atualizar a URL da fonte no OBS via Streamer.bot, SAMMI ou automação parecida, preenchendo `title`, `artist` e `cover`.
- Servir um JSON externo e passar ele como `source`.

Formato do JSON:

```json
{
  "title": "Nome da música",
  "artist": "Nome do artista",
  "album": "Nome do álbum",
  "cover": "https://url-da-capa.jpg",
  "isPlaying": true,
  "progress": 45000,
  "duration": 180000
}
```

URL com JSON:

```txt
https://mottameister-overlays.vercel.app/music?source=https%3A%2F%2Fseu-endpoint.com%2Fnow-playing.json
```

Observação: o Spotify não libera a música atual publicamente sem autenticação. Para integração real, use um app/automação que leia o Spotify e envie esses dados para a overlay.

## Como Alterar Textos

Todos os textos editáveis ficam em:

```txt
src/data/config.js
```

Ali ficam:

- textos das telas principais;
- redes sociais;
- mensagens de exemplo do chat;
- nome e ação do alerta;
- valor atual e alvo da meta.

Depois de alterar, basta fazer commit e push na branch `main`. A Vercel publica a nova versão automaticamente.

## Painéis Da Twitch

As imagens dos painéis da página da Twitch ficam em:

```txt
assets/twitch-panels/png
```

Também há SVGs editáveis e uma prévia geral em:

```txt
assets/twitch-panels
```

Para regenerar as artes, rode:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\generate-twitch-panels.ps1
```

## Currency Da Twitch

A currency visual `Penas de Coruja` fica em:

```txt
assets/twitch-currency/penas-de-coruja/png
```

Foram exportadas versões em `28x28`, `56x56` e `112x112`, com a imagem fonte em:

```txt
assets/twitch-currency/penas-de-coruja/source/pena.png
```

Para regenerar os tamanhos, rode:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\generate-twitch-currency.ps1
```

## Icones De Recompensas Da Twitch

Os icones das recompensas ficam em:

```txt
assets/twitch-rewards/png
```

Cada recompensa tem versoes em `28x28`, `56x56` e `112x112`. Para regenerar:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\generate-twitch-reward-icons.ps1
```

## Icones De Recompensas Personalizadas

Os icones pixelados para recompensas personalizadas ficam em:

```txt
assets/twitch-custom-rewards/png
```

Cada recompensa tem versoes em `28x28`, `56x56` e `112x112`. Os desenhos usam simbolos genericos para evitar criaturas ou itens oficiais de franquias. Para regenerar:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\generate-twitch-custom-rewards.ps1
```

## Emotes Da Twitch

Os emotes novos do canal ficam em:

```txt
assets/twitch-emotes/png
```

O primeiro pacote foi exportado em `1000x1000`, com preview em:

```txt
assets/twitch-emotes/preview.png
```

## Chat Real No OBS

Hoje `/chat` funciona como moldura visual para o chat real da live.

Use o Streamer.bot Chat como Browser Source separado e encaixe dentro da moldura.

Configuração recomendada do Streamer.bot Chat:

- `Minimum Visible Messages`: `1`
- `Maximum Visible Messages`: `6`
- `Message Timeout`: `30` a `45`
- `Show Platform Icons`: `Always`
- `Show Timestamps`: desligado
- `Show Events`: desligado
- WebSocket host: `127.0.0.1`
- WebSocket port: `8080`
- WebSocket endpoint: `/`

Configuração recomendada no OBS:

- Source visual: `https://mottameister-overlays.vercel.app/chat`
- Tamanho da source visual: `1920x1080`
- Source do Streamer.bot Chat: URL copiada em `Chat > Settings > Overlay`
- Tamanho da source do chat real: `524x214`
- Posição aproximada do chat real dentro da tela: `X 92`, `Y 820`

CSS recomendado para a source do Streamer.bot Chat no OBS:

```css
body {
  background-color: rgba(0, 0, 0, 0);
  margin: 0;
  overflow: hidden;
}
```

## Meta E Alertas Via Streamer.bot

As rotas `/goal` e `/alerts` agora centralizam no Streamer.bot WebSocket.

Configuração base no Streamer.bot:

- `Servers / Clients > WebSocket Server`
- `Auto Start`: ligado
- `Address`: `127.0.0.1`
- `Port`: `8080`
- `Endpoint`: `/`
- `Authentication`: desligado

No OBS:

- Meta: `https://mottameister-overlays.vercel.app/goal`
- Alertas: `https://mottameister-overlays.vercel.app/alerts`
- Ambas em `1920x1080`

Variáveis globais persistidas para `/goal`:

- `overlayGoalCurrent`: valor atual da meta
- `overlayGoalTarget`: valor final da meta
- `overlayGoalLabel`: nome da meta
- `overlayGoalUnit`: unidade exibida, como `subs`, `follows` ou `apoios`

O `/goal` atualiza sozinho a cada poucos segundos. Também aceita evento customizado com `event: "overlayGoal"` ou `event: "goal"`.

Os alertas escutam eventos nativos disponíveis no Streamer.bot para Twitch, YouTube e Kick. Para alertas 100% customizados, crie uma Action no Streamer.bot e use C#:

```csharp
string json = @"{
  ""event"": ""overlayAlert"",
  ""source"": ""Twitch"",
  ""kind"": ""sub"",
  ""eyebrow"": ""Novo sub"",
  ""title"": ""Apoio desbloqueado"",
  ""user"": ""%userName%"",
  ""message"": ""assinou o canal""
}";

CPH.WebsocketBroadcastJson(json);
```

Para testar a meta por evento customizado:

```csharp
string json = @"{
  ""event"": ""overlayGoal"",
  ""label"": ""Meta da Comunidade"",
  ""current"": 72,
  ""target"": 100,
  ""unit"": ""subs""
}";

CPH.WebsocketBroadcastJson(json);
```

## Desenvolvimento Local

Use Node.js 20 ou mais recente.

```bash
npm install
npm run dev
```

Exemplo local:

```txt
http://localhost:5173/starting
```

## Deploy

O projeto está conectado à Vercel via GitHub.

Configuração:

- Framework: `Vite`
- Build command: `npm run build`
- Output directory: `dist`

O `vercel.json` redireciona todas as rotas para `index.html`, então links diretos como `/starting`, `/gameplay` e `/browser-camera` funcionam direto no OBS.
