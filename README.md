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

## Chat, Meta E Alertas

Hoje `/chat`, `/goal` e `/alerts` são overlays visuais estáticos.

Eles não puxam dados reais da Twitch, StreamElements ou Streamlabs ainda. Para dados ao vivo, use widgets oficiais desses serviços no OBS junto com esses overlays, ou implemente uma integração futura via API/WebSocket.

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
