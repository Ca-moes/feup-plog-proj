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
O estado de Jogo é representado a partir da combinação de um **tabuleiro** e de um **jogador atual** correspondente a um dos jogadores. O tabuleiro é guardado usando uma lista de listas cujos valores representam peças, estando os códigos representados abaixo, juntamente com o tabuleiro.
```prolog
%  Tabuleiro inicial com peças em formação xadrez
initial_board([
  [1,2,1,2,1,2,1,2],
  [2,1,2,1,2,1,2,1],
  [1,2,1,2,1,2,1,2],
  [2,1,2,1,2,1,2,1],
  [1,2,1,2,1,2,1,2],
  [2,1,2,1,2,1,2,1],
  [1,2,1,2,1,2,1,2],
  [2,1,2,1,2,1,2,1]
]).

% códigos das peças na list
code(0, ' ').  % sitio sem peças
code(1, 'X').  % peças vermelhas
code(2, '+').  % peças azuis
```
O jogador atual pode ter 2 valores : `'Player 1'` ou `'Player 2'`, sendo um destes valores passado aos predicados `turn`, `select_spot` e `display_game`.
O valor do tabuleiro vai sendo alterado ao longo do jogo, podendo passar, como exemplo, pelos seguintes estados:
```prolog
% Estado Inicial
[
  [1,2,1,2,1,2,1,2],
  [2,1,2,1,2,1,2,1],
  [1,2,1,2,1,2,1,2],
  [2,1,2,1,2,1,2,1],
  [1,2,1,2,1,2,1,2],
  [2,1,2,1,2,1,2,1],
  [1,2,1,2,1,2,1,2],
  [2,1,2,1,2,1,2,1]
]

% Estado Intermédio
[
  [2,2,2,2,1,0,2,0],
  [0,1,0,0,0,0,0,2],
  [2,2,0,1,0,2,1,2],
  [0,0,0,2,0,1,2,1],
  [0,1,1,0,1,2,1,2],
  [1,0,0,0,1,0,1,1],
  [1,2,0,1,1,2,1,2],
  [2,1,2,1,2,1,2,1]
]

% Estado Final: _ representam 0 mas foram substituidos para mostrar o caminho final   
[
  [2,2,2,2,1,0,2,0],
  [0,0,0,0,0,0,0,2],
  [2,1,0,1,0,0,1,0],
  [0,0,0,2,0,2,0,2],
  [0,1,1,0,1,_,_,_],
  [2,0,_,_,_,_,1,0],
  [_,_,_,1,1,2,0,0],
  [2,1,2,0,1,1,1,0]
]
``` 
## Visualização do Estado de Jogo

### Predicado de Visualização

Ao executar o predicado `display_game`, o programa começa por desenhar o cabeçalho do tabuleiro e procede a desenhar alternadamente uma linha, fazendo uso do predicado `print_line`, e um separador no predicado `print_matrix`. Quando acaba de desenhar todas as linhas retorna.
```prolog
% quando o contador chegar a 8 significa que acabou
print_matrix([], 8).
print_matrix([L|T], N) :-
  row(N, R), write(' '), write(R), write(' | '),
  N1 is N + 1,
  print_line(L), nl,
  write('---|---|---|---|---|---|---|---|---|\n'),
  print_matrix(T, N1).

% imprime uma linha do tabuleiro
print_line([]).
print_line([C|L]) :-
  code(C, P), write(P), write(' | '),
  print_line(L).

% Imprime o tabuleiro de acordo com o estado de Board
display_game(Board, Player) :-
  % cabeçalho do tabuleiro
  nl,
  write('   | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |\n'),
  write('---|---|---|---|---|---|---|---|---|\n'),
  print_matrix(Board, 0).
```
### Estados do tabuleiro
| Inicial | Intermédio | Final |
|--------|-------|---|
| ![Estado Inicial](https://i.imgur.com/XsrXPdp.png)  | ![Estado Intermédio](https://i.imgur.com/1xufEy8.png) | ![Estado Final](https://i.imgur.com/tryYD6T.png) |



