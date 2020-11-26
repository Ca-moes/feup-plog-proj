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

Para o Jogador conseguir executar uma jogada, o programa tem de retornar corretamente de dois predicados: `choose_piece(+Board, +PlayerS, -Xtemp, -Ytemp, -Directions)` e `read_direction(+List, -DirSelected)`.

No primeiro predicado é realizada a leitura dos valores `X` e `Y` para ter a posição a partir de onde o Jogador vai jogar. Estes valores têm de corresponder a uma posição dentro dos limites do tabuleiro onde esteja posicionada uma peça do Jogador, se o jogador der input de uma linha e coluna e nessa posição não estiver uma peça sua, é-lhe pedido que introduza outros valores válidos.

Assim que o input da posição esteja correto, o predicado `choose_piece(+Board, +PlayerS, -Xtemp, -Ytemp, -Directions)` retorna com os valores lidos e as direções disponiveis, estas direções são passadas ao predicado `read_direction(+List, -DirSelected)` e aqui é feita a escolha, do lado do jogador, de uma das direções disponiveis.

Assim que estes 3 valores estiverem determinados (`X-Y-dir`), é possivel executar o predicado `move(+GameState, +Move, -NewGameState)` e obter o Tabuleiro resultante desta jogada.

### Avaliação do Tabuleiro

Para analisar o "valor" de um tabuleiro, para um jogador, implementamos a função `value(+GameState, +Player, -Value)` que é constituida por duas partes. Na primeira parte, o tabuleiro é percorrido célula a célula até encontrar uma célula vazia, tendo essa célula como ponto inicial é realizado o algoritmo **Flood Fill**.

#### FloodFill
FloodFill é um algoritmo usado em arrays mutidimensionais para determinar "áreas" interligadas entre si. Para utilizar este algoritmo precisamos de uma matriz, uma posição inicial, um valor a substituir (A) e um valor que será substituido (B). O algoritmo começa na posição inicial e verifica se o valor que aí se encontra é igual a A, em caso positivo, a posição fica com o valor B e o algoritmo é aplicado nas células adjacentes á célula inicial. Nessas células faz-se a mesma verificação do valor A e substituição pelo valor B. Se a posição não tiver valor A, então o seu valor não é substituido e as posições adjacentes não são verificadas. O algoritmo termina quando não houver mais células a verificar.

![Flood Fill Demonstration](kadabra./README_files/Recursive_Flood_Fill.gif)
##### Exemplo usando um board intermédio

| Before Flood Fill | After FloodFill |
|--------|-------|
| ![Flood Fill Demonstration](kadabra./README_files/Board_before_floodfill.png)  | ![Flood Fill Demonstration](kadabra./README_files/Board_after_floodfill.png) |

> Implementação em Prolog

```prolog
% prolog implementation of the floodFill algorithm
floodFill(Board, BoardSize, X, Y, PrevCode, NewCode, FinalBoard):-
  X >= 0, X < BoardSize, Y >= 0, Y < BoardSize,
  value_in_board(Board, X, Y, PrevCode),
  replace(Board, X, Y, NewCode, BoardResult), % replaces PrevCode by NewCode
  X1 is X+1, X2 is X-1, Y1 is Y+1, Y2 is Y-1,
  floodFill(BoardResult, BoardSize, X1, Y, PrevCode, NewCode, T1) ,
  floodFill(T1, BoardSize, X2, Y, PrevCode, NewCode, T2) ,
  floodFill(T2, BoardSize, X, Y1, PrevCode, NewCode, T3) ,  
  floodFill(T3, BoardSize, X, Y2, PrevCode, NewCode, FinalBoard).
% if initial floodfill returns from every direction, returns the initial board
floodFill(Board, _, _, _, _, _, Board).
```
---

Continuando com a avaliação do tabuleiro, após ter sido realizado o algoritmo de **Flood Fill** no tabuleiro, é formada uma *mancha* pelos carácters de enchimento que será analisada na segunda parte. O valor da posição na qual foi feito o Flood Fill é guardado e este predicado é chamado recursivamente com o novo tabuleiro. Desta forma serão encontradas, e guardadas, todas as posições possiveis de sofrer Flood Fill, equivalentes a *manchas* independentes entre si. No final é retornada uma lista que contém sublistas da forma `[X-Y]`, correspondente ás posições possiveis de fazer Flood FIll.

```
Pseudocódigo parte 1:
  Percorre célula a célula
  Encontra lugar 0
    FloodFill para obter novo GameState, Guarda Posição X-Y para depois retornar e chama mesmo predicado
    com novo GameState
    Dá append a X-Y á lista de Return de ter chamado o predicado e dá return da nova lista
```

Na segunda parte, a lista de posições recém formada é percorrida, uma a uma, para analisar cada *mancha*. Tendo uma posição, é realizado o algoritmo de **Flood Fill** para obter um tabuleiro com uma *mancha*. Este novo tabuleiro é passado ao predicado `values_in_all_columns(+GameState, +Value, -ListResult)` que percorrerá o tabuleiro e guardará numa lista, com cada elemento a simbolizar uma coluna, os valores da soma das ocorrência de cada carácter de enchimento por coluna, formando, por exemplo, uma lista semelhante a `[4,3,3,2,0,0]` que corresponde á lista retornada por este predicado se fosse passado como argumento o tabuleiro *After FloodFill* [da secção acima](#exemplo-usando-um-board-intermédio).

Esta lista é a seguir passada como argumento para o predicado `sequence(+List, -Result)` que retorna em `Result` o valor correspondente ao comprimento da maior sequência de números formados sem usar o número 0 que, usando o exemplo de cima, retornaria `4`. É assim obtido o **value** de uma possivel mancha.

Este **value** corresponde ao **alcance** da mancha após uma jogada. Se o **value** for igual ao comprimento do tabuleiro, significa que essa jogada criou uma mancha cujo alcance vai desde um lado ao lado oposto do tabuleiro, sendo esta uma jogada que abre um caminho vencedor para o jogador. Quanto maior for o valor de **value**, maior será o alcance de uma mancha e mais próximo está o jogador de abrir um caminho entre os seus dois lados do tabuleiro.

A segunda parte do predicado value acaba no fim de verificar todos as posições que formam manchas independentes, obtendo uma lista de **values** para cada mancha. Para obter o **value** de um tabuleiro o predicado retorna o maior dos **values** da lista, que corresponde à mancha que se consegue *estender* mais.

Esta explicação abranje apenas o caso relativo ao `Player 1` porque analisa o **value** de cada *mancha* na horizontal, significando que quanto mais *extensa*, na horizontal, for a *mancha*, maior será o seu **value**. Como, para representar o tabuleiro, estamos a usar uma lista composta por sublistas, podemos usar o predicado `transpose(?X, ?Y)` com o tabuleiro quando for para analisar o caso do `Player 2`. Isto transformará as linhas do tabuleiro em colunas e vice-versa, sendo agora possivel analizar o caminha na horizontal também para o `Player 2`.
### Final do Jogo

Um caso possivel de acontecer é de um Jogador fazer uma jogada, tal que abra um caminho para si, mas também para o inimigo, sendo assim a vitória do inimigo. Para fazer esta verificação, no final de uma jogada, o predicado `game_over(+GameState, +Player , -Winner)` é chamado e é primeiro verificado se o jogador oposto tem um caminho formado entre os seus lados do tabuleiro. Caso não haja um caminho, então é que é verificado se existe um caminho para o jogador inicial.

A verificação da vitória é feita no predicado `check_win(+PlayerS, +GameState, +K, -Result)`. 
```prolog
% check_win(+PlayerS, +GameState, +K, -Result)
% to check the win for Player 1, we can check the win for Player 1 with the transposed matrix
check_win('Player 2', GameState, X):-
  transpose(GameState, Transpose),
  check_win('Player 1', Transpose, X).

check_win('Player 1', GameState, Size1):-
  Size is Size1+1,
  value(GameState, 'Player 1', Value),
  format('Size: ~d, Value: ~d', [Size, Value]),
  Value == Size.
```
Este predicado tira partido do predicado `value(+GameState, +Player, -Value)` e de algo já referido:

> Se o **value** for igual ao comprimento do tabuleiro, significa que essa jogada criou uma mancha cujo alcance vai desde um lado ao lado oposto do tabuleiro, sendo esta uma jogada que abre um caminho vencedor para o jogador.

Usando esta lógica, torna-se simples verificar se um jogador é vencedor ou não, basta verificar se o **value** do tabuleiro resultante para o jogador que acabou de jogar é igual ao comprimento do tabuleiro.

### Jogada do Computador

Neste Projeto criamos 2 dificuldades possiveis para o Computador: `Easy` e `Normal`.

Se a dificuldade for `Easy`, então o Computador, com o auxilio do predicado `valid_moves(+GameState, +PlayerS, -List)`, tem à sua disposição uma lista de movimentos possiveis de executar e escolherá, aleatóriamente, um destes movimentos da lista, usando o predicado `random_member(-Elem, +List)` da biblioteca `random`, devolvendo o movimento no último argumento do predicado `choose_move(+GameState, +Player, +Level, -Move)`.

Se a dificuldade for `Normal`, após obter a lista dos movimentos possiveis, é usado o predicado `findall(+Template, +Generator, -List)` para gerar uma lista de elementos na forma `Value-X-Y-Direction-Index`:
- `Value` - valor do board resultante da jogada
- `X-Y-Direction` - componentes de uma jogada
- `Index` - Indice da jogada na lista de todos os movimentos possiveis

A lista resultante está ordenada pelo `Index` de forma crescente, sendo assim preciso efetuar um `sort(+List1, -List2)` para que a Lista fique ordenada por ordem crescente de `Value`. Para obter o `Move` a efetuar só falta retirar as componentes `X-Y-Direction` do último elemento da lista usando o predicado `last(+List, -Last)`.

## Conclusões

> A adicionar

### Possiveis Melhorias
É possível acrescentar 2 dificuldades ao nosso jogo:
1. Ao verificar o valor de cada mancha para o jogador, verifica o valor dessa mancha para o inimigo e no final faz a diferença entre os valores. Assim o Computador escolhe a melhor jogada para ele, mas que também não seja a melhor para o adversário.
2. Para cada movimento possivel, verificar os movimentos possiveis de fazer a seguir e analisar os tabuleiros resultantes. Assim o Computador consegue não fazer a melhor jogada no momento mas poderá ser uma jogada que lhe dará mais vantagem no futuro.
## Bibliografia
- [Documentação SicStus 4.6.0](https://sicstus.sics.se/sicstus/docs/latest4/html/sicstus.html/)
- [Wikipedia - Flood Fill](https://en.wikipedia.org/wiki/Flood_fill)
- [GeeksForGeeks - Flood Fill](https://www.geeksforgeeks.org/flood-fill-algorithm-implement-fill-paint/)