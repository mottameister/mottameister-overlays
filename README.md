# Overlays da Toca da Coruja

Projeto Vite + React + Tailwind para overlays de livestream do `@mottameister`, pensado para OBS Browser Source em `1920x1080`.

## Rotas

- `/starting`
- `/brb`
- `/ending`
- `/offline`
- `/camera`
- `/gameplay`
- `/chat`
- `/goal`
- `/alerts`

## Links de Produção

```txt
https://mottameister-overlays.vercel.app/starting
https://mottameister-overlays.vercel.app/brb
https://mottameister-overlays.vercel.app/ending
https://mottameister-overlays.vercel.app/offline
https://mottameister-overlays.vercel.app/camera
https://mottameister-overlays.vercel.app/gameplay
https://mottameister-overlays.vercel.app/chat
https://mottameister-overlays.vercel.app/goal
https://mottameister-overlays.vercel.app/alerts
```

## Como Alterar Textos

Todos os textos da live, redes sociais, mensagens de exemplo, alerta e meta ficam em:

```txt
src/data/config.js
```

Altere esse arquivo, faça commit/push na `main`, e a Vercel publica uma nova versão automaticamente.

## Chat, Meta e Alertas

Hoje `/chat`, `/goal` e `/alerts` são overlays visuais estáticos, prontos para compor cenas no OBS:

- `/chat`: mostra mensagens de exemplo configuradas em `src/data/config.js`.
- `/goal`: mostra a meta atual configurada em `streamConfig.goal`.
- `/alerts`: mostra um alerta de exemplo configurado em `streamConfig.scenes.alerts`.

Eles ainda não puxam dados reais da Twitch, StreamElements ou Streamlabs. Para dados ao vivo, use widgets oficiais desses serviços por cima/por baixo desses overlays, ou conecte uma integração futura via WebSocket/API.

## OBS Browser Source

1. Adicione uma nova fonte `Navegador`.
2. Use uma das URLs de produção acima.
3. Defina `Largura` como `1920`.
4. Defina `Altura` como `1080`.
5. Ative `Atualizar navegador quando a cena se tornar ativa`.
6. Para `/alerts`, ative `Desligar fonte quando não visível` se quiser que a animação de entrada reinicie.
7. Use `/gameplay`, `/camera`, `/chat`, `/goal` e `/alerts` como camadas transparentes sobre gameplay/camera.

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

## Deploy na Vercel

O projeto está conectado à Vercel via GitHub. Pushes na branch `main` disparam deploy de produção.

Configuração:

- Framework: `Vite`
- Build command: `npm run build`
- Output directory: `dist`

O `vercel.json` já redireciona todas as rotas para `index.html`, então links diretos como `/starting` e `/alerts` funcionam no OBS.
