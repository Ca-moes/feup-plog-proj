# Turma 6 - Talpa_4

## Intervenientes
- [André Daniel Alves Gomes](up201806224@fe.up.pt) - up201806224
- [Gonçalo André Carneiro Teixeira](up201806562@fe.up.pt) - up201806562

## Instalação e Execução
### Windows
- Executar `spwin.exe`
- `File` -> `Consult...` -> Selecionar ficheiro `talpa.pl`
- Na consola do SicStus: `play.`
### Linux
> Deve ser os mesmos passos, necessário testar

## Talpa - Descrição do Jogo

O objetivo do jogo é criar um caminho formado por lugares vazios no tabuleiro, que conecte lados opostos do tabuleiro, sendo cada par de lados opostos atribuido a um dos jogadores. 

Tendo como estado inicial um tabuleiro 8x8 preenchido por peças quadradas de 2 cores (azul e vermelho) dispostas num padrão em *xadrez*, os jogadores, de forma alternada, começando pelo que controla as peças **vermelhas**, escolhem uma das suas peças e *capturam* uma das peças do oponente num quadrado adjacente na vertical ou horizontal. A peça capturada é removida do tabuleiro e a peça que capturou ocupa o quadrado capturado. Quando a captura é possivel esta é obrigatória, em caso contrário os jogadores removem uma das suas peças por turno.

O jogo acaba quando um caminho é formado pelos espaços livres entre dois lados do tabuleiro de um dos jogadores. Caso um jogador faça uma jogada que abra um caminho para si e para o adversário, o adversário ganha.

## Lógica do Jogo
### Representação Interna do Estado de Jogo
#### Tabuleiro
O tabuleiro é representado a partir de uma lista com sublistas, sendo cada sublista uma linha do tabuleiro. Cada elemento, durante o jogo, pode ter 1 de 3 valores possiveis:
- `0` representa uma posição vazia
- `1` representa uma posição com uma peça pertencente ao jogador 1 
- `2` representa uma posição com uma peça pertencente ao jogador 2 

Fica também reservado o valor `9` que serve como caracter de enchimento usado no algoritmo `floodFill`, explicado numa próxima secção.

```prolog
Possiveis estados de jogo:

- Inicial:
[ [ 1,-1, 1,-1, 1,-1],
  [-1, 1,-1, 1,-1, 1],
  [ 1,-1, 1,-1, 1,-1],
  [-1, 1,-1, 1,-1, 1],
  [ 1,-1, 1,-1, 1,-1],
  [-1, 1,-1, 1,-1, 1] ]

- Intermedio:
[ [ 0, 0, 1, 0, 1,-1],
  [-1, 0, 0, 0,-1, 1],
  [ 0, 0, 0,-1, 0, 0],
  [ 0, 1, 0, 1, 0, 1],
  [ 0,-1, 1, 0, 1,-1],
  [-1, 1,-1, 1, 0, 1] ]

- Final:
[ [ 0, 0, 1, 0, 1,-1],
  [-1, 0, 0, 0,-1, 1],
  [ 0, 0, 0,-1, 0, 0],
  [ 0, 1, 0, 1, 0, 1],
  [ 0,-1, 1, 0, 1,-1],
  [ 0,-1,-1, 1, 0, 1] ]

```

#### Player
O player tem does estados possiveis, ambos strings: `Player 1` e `Player 2`.
Estas strings estão associadas ao elementos do board a partir do predicado `player_piece/2`.
```prolog
player_piece('Player 1', 1).
player_piece('Player 2', -1).
```
Na representação gráfica do tabuleiro, as peças do `Player 1` são `×` e as peças do `Player 2` são `Ø`. Esta associação é feita a partir do predicado `code/2`, que associa um valor de uma peça do tabuleiro a um código ASCII, usado com `put_code` na representação gráfica para apresentar a peça:
```prolog
% Pieces codes for board representation
code(0, 32). %ascii code for space
code(-1, 216). % Ø - Player 2
code(1, 215). % × - Player 1
code(9, 181). % µ - used for floodFill
```

#### Playing 