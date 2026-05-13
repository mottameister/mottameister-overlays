# Twitch Custom Rewards

Icones pixelados para recompensas personalizadas do canal.

Os desenhos evitam criaturas, bolas e itens oficiais de qualquer franquia. A linguagem visual usa simbolos genericos de jogos de captura/coleta: ficha de nickname, time de companheiros, inseto, esfera rara, brilho de captura e troca.

## Sugestoes De Uso

- `nickname-monstro`: nickname em monstro.
- `escolher-time`: escolher meu time.
- `lutar-so-inseto`: lutar usando so tipo inseto.
- `esfera-rara-aleatoria`: gastar uma esfera rara num monstro aleatorio.
- `capturar-brilhante`: capturar o proximo brilhante com a bola escolhida.
- `trocar-companheiro`: trocar um companheiro do time.

## Arquivos

Cada recompensa tem PNGs em `28x28`, `56x56` e `112x112` dentro de `png/`.

`preview.png` mostra o kit completo.

## Regenerar

Na raiz do repo:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\generate-twitch-custom-rewards.ps1
```

