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
O player tem dois estados possiveis, ambos strings: `Player 1` e `Player 2`.
Estas strings estão associadas ao elementos do board a partir do predicado `player_piece/2`.
```prolog
player_piece('Player 1', 1).
player_piece('Player 2', -1).
```
Na representação gráfica do tabuleiro, as peças do `Player 1` são `×` e as peças do `Player 2` são `Ø`. Esta associação é feita a partir do predicado `code/2`, que associa um valor de uma peça do tabuleiro a um código ASCII, usado com `put_code` na representação gráfica para apresentar a peça:
```prolog
% Pieces codes for board representation
code(0, 32).   % ascii code for space
code(-1, 216). % Ø - Player 2
code(1, 215).  % × - Player 1
code(9, 181).  % µ - Used for floodFill
```

#### Playing 
Neste estado final do projeto existem 3 opções para quem está a jogar:
- `Player` - Para quando for a vez de um jogador humano a decidir uma jogada
- `Easy` - Para quando for a vez do Computador, em dificuldade fácil, de fazer uma jogada
- `Normal` - Para quando for a vez do Computador, em dificuldade média, de fazer uma jogada
  
Estes valores são usados nos predicados `start_game` e `turn` para decidir a ordem dos turnos e para o programa saber, no final de um turno, a quem dá a vez no próximo. Estes valores são obtidos a partir das escolhas selecionadas nos menus.

### Visualização do Estado do Jogo

Após iniciar o jogo com o predicado `play.` o jogador tem ao seu dispor um menu inicial com as opções principais do jogo:

![placeholder image]()

Para realizar a escolha de uma opção o jogador apenas escreve o número relativo á opção que quer e prime `Enter`. Estando em qualquer ecrã de menu e escolhendo a opção `0`, o ecrã é limpo e o menu principal é exibido.

As opções `4 - Game Instructions` e `5 - Information about project` contêm apenas texto sobre as suas secções.

As primeiras 3 opções correspondem a tipos de jogo disponiveis:
```
1 - Player vs Player
2 - Player vs Computer
3 - Computer vs Computer
```
Após selecionar qualquer uma destas é apresentado um ecrã para escolher o tamanho do tabuleiro, tendo 3 tamanhos para escolha. Por norma, quanto maior for o tabuleiro, mais tempo demorará o jogo.

Para a primeira opção, após selecionar o tamanho do tabuleiro, o jogo inicia, sendo a vez do `Player 1` a jogar.

Para a segunda opção, para além do tamanho do tabuleiro,  é também necessário escolher a **dificuldade** do computador, juntamente com qual `Player` é que o jogador quer ser, tendo as opções de ser o `Player 1` ou o `Player 2`.

Para a terceira opção, para além do tamanho do tabuleiro, é possivel escolher as dificuldades de ambos os computadores.

Assim que um jogo é iniciado é apresentado o tabuleiro:
```
       | 0 | 1 | 2 | 3 | 4 | 5 |
       +---+---+---+---+---+---|
         Ø   Ø   Ø   Ø   Ø   Ø   
---+   *---+---+---+---+---+---*
 A | × | × | Ø | × | Ø | × | Ø | ×
---+   | - + - + - + - + - + - |
 B | × | Ø | × | Ø | × | Ø | × | ×
---+   | - + - + - + - + - + - |
 C | × | × | Ø | × | Ø | × | Ø | ×
---+   | - + - + - + - + - + - |
 D | × | Ø | × | Ø | × | Ø | × | ×
---+   | - + - + - + - + - + - |
 E | × | × | Ø | × | Ø | × | Ø | ×
---+   | - + - + - + - + - + - |
 F | × | Ø | × | Ø | × | Ø | × | ×
---+   *---+---+---+---+---+---*
         Ø   Ø   Ø   Ø   Ø   Ø   

```
E, dependendo se é a vez do jogador ou do computador, apresenta um diálogo a pedir input ou um diálogo com o jogada que o computador efetuará.

### Lista de Jogadas Válidas

Uma jogada é constituida por 2 componentes: Uma posição no tabuleiro e uma direção. A posição no tabuleiro é composta por um valor correspondente a uma coluna (Inteiro) e um valor correspondente a uma linha (Caráter). A direção pode tomar 1 dos 4 valores seguintes : `'up', 'right', 'down', 'left'`. 

Após ser feita a leitura do input de uma jogada, o valor da linha é transformado num Inteiro correspondente ao Indice da linha começando a 0, para facilitar durante o uso interno.

O predicado `valid_moves(+GameState, +PlayerS, -List)` usa o predicado `check_spot(+GameState, +X, +Y, +Player, -ReturnList)` para verificar, posição a posição, começando na posição (0,0) do tabuleiro (canto superior esquerdo), até á posição (`Size-1`, `Size-1`) do tabuleiro (Canto inferior direito), sendo `Size` o número de linhas e colunas do tabuleiro, se numa dada posição, a peça que lá se encontra corresponde a uma peça do jogador da qual queremos saber todas as jogadas possiveis, e caso seja, verifica se nos valores de direção possiveis, especificados acima, encontra uma peça do inimigo. Ao encontrar uma peça inimiga pode guardar os valores da posição e da direção, sendo este conjunto uma jogada possivel. No final da análise do tabuleiro inteiro o predicado `check_spot` retorna, a partir do argumento `ReturnList` uma lista com sublistas na forma `[X, Y, dir]` que contêm todas as jogadas possiveis para um jogador.

Para além do predicado `valid_moves`, temos também o predicado `valid_removes(+GameState, +PlayerS, -List)` que contempla a parte final do jogo, na qual, caso não haja movimentos possiveis, os jogadores começam a remover uma peça por turno. Este predicado difere no anterior nas sublistas da lista retornada, que ficam na forma `[X, Y]`, já que não é preciso uma direção.

### Execução de Jogadas
