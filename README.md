# Turma 6 - Talpa_4

## Intervenientes
- [André Daniel Alves Gomes](up201806224@fe.up.pt) - up201806224
- [Gonçalo André Carneiro Teixeira](up201806562@fe.up.pt) - up201806562

## Descrição do Jogo

Tendo como estado inicial um tabuleiro 8x8 preenchido por peças quadradas de 2 cores (azul e vermelho) dispostas num padrão em *xadrez*, os jogadores, de forma alternada, começando pelo que controla as peças **vermelhas**, escolhem uma das suas peças e *capturam* uma das peças do oponente num quadrado adjacente na vertical ou horizontal. A peça capturada é removida do tabuleiro e a peça que capturou ocupa o quadrado capturado. Quando a captura é possivel esta é obrigatória, em caso contrário os jogadores removem uma das suas peças por turno. O jogo acaba quando um caminho é formado pelos quadrados livres entre duas pontas do tabuleiro de um dos jogadores. Caso um jogador faça uma jogada que abra um caminho para si e para o adversário o adversário ganha.

Fontes de informação:
- [nestorgames - Talpa](https://nestorgames.com/#talpa_detail)
- [nestorgames - Talpa rulebook](https://nestorgames.com/rulebooks/TALPA_EN.pdf)
- [BoardGameGeek](https://boardgamegeek.com/boardgame/80657/talpa)

## Representação Interna do Estado do Jogo

```prolog
initial_board([
  [0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0],
  [0,0,0,0,0,0,0,0]
]).

% códigos das peças na list
code(0, ' ').
code(1, 'X').
code(2, '+').
```
## Visualização do Estado de Jogo

![image](https://user-images.githubusercontent.com/52114623/96307391-750d2080-0ff9-11eb-955d-a0d504bf6868.png)
