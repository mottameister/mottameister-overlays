# A Toca da Coruja Stream Overlays

Vite + React + Tailwind livestream overlay pack for OBS Browser Source at `1920x1080`.

## Routes

- `/starting`
- `/brb`
- `/ending`
- `/offline`
- `/camera`
- `/chat`
- `/goal`
- `/alerts`

## Customize Text

All stream copy, social handles, chat sample messages, alert sample text, and goal values live in:

```txt
src/data/config.js
```

## Local Development

Use Node.js 20 or newer.

```bash
npm install
npm run dev
```

Open the route you want, for example:

```txt
http://localhost:5173/starting
```

## OBS Browser Source

1. Add a new `Browser Source` in OBS.
2. Set the URL to the overlay route, such as `http://localhost:5173/starting`.
3. Set `Width` to `1920`.
4. Set `Height` to `1080`.
5. Enable `Refresh browser when scene becomes active`.
6. Keep `Shutdown source when not visible` enabled for alerts or animated widgets if you want the entrance animation to replay.
7. Use `/camera`, `/chat`, `/goal`, or `/alerts` as transparent overlay layers above gameplay or camera scenes.

For deployed overlays, use your Vercel URL plus the route, for example:

```txt
https://your-project.vercel.app/starting
```

## Vercel Deployment

1. Push this project to GitHub.
2. Import the repository in Vercel.
3. Keep the default Vite settings:
   - Build command: `npm run build`
   - Output directory: `dist`
4. Deploy.

The included `vercel.json` rewrites all routes to `index.html`, so direct OBS URLs like `/starting` and `/alerts` work after deployment.

## Production Build

```bash
npm run build
npm run preview
```
