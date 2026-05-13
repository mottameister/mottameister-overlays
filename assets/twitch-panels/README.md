# Twitch Panels

Artes para os paineis da pagina da Twitch do `@mottameister`.

## Arquivos

- `png/`: imagens prontas para subir na Twitch.
- `svg/`: fontes editaveis de cada painel.
- `preview.png`: visao geral do kit.
- `preview.html`: preview local simples.

Os PNGs foram exportados em `640x160`, mantendo proporcao de `320x80` para ficarem mais nitidos quando a Twitch reduzir a exibicao.

## Regenerar

Na raiz do repo:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\generate-twitch-panels.ps1
```

