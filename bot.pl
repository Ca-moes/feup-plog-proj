/*
Avaliação do Tabuleiro: Forma(s) de avaliação do estado do jogo. O predicado
deve chamar-se 
value(+GameState, +Player, -Value).

Jogada do Computador: Escolha da jogada a efetuar pelo computador,
dependendo do nível de dificuldade. O predicado deve chamar-se
choose_move(+GameState, +Player, +Level, -Move).

Lista de Jogadas Válidas: Obtenção de lista com jogadas possíveis (com melhor á cabeça). O predicado
deve chamar-se 
valid_moves(+GameState, +Player, -ListOfMoves).
[[X,Y,'up'],[X,Y,'left']] ,
*/

/**
 * % used before calling next_index to check if current position is the last in the board. Return 1 at end of board
 *   check_end(+X, +Y, +Length, -Return)
 * % gets next index and verifies if reached end of Row, in that case switched to next row
 *   next_index(+X, +Y, +Length, -X2, -Y2)
 * % returns in Lists the numbers of the directions available to go
 *   available_dirs(+Board, +X, +Y, +PlayerS, -List)
 * % returns in Player a string representing the player or fails if space is empty.
 *   player_in_board(Board, X, Y, PlayerS)
 */


% Player Predicate  move belongs to logic.pl but need to be together with the bot predicate
make_move('Player', GameState, PlayerS, NewGameState) :-
  choose_piece(GameState, PlayerS, X, Y, Directions),
  format('- Selected spot: X : ~d -- Y : ~w \n', [X,Y]),
  read_direction(Directions, Direction),
  format('- Direction received in logic : ~s\n', Direction),
  move(GameState, X-Y-Direction, NewGameState), skip_line.
make_move(Difficulty, GameState, Player, NewGameState):-
  choose_move(GameState, Player, Difficulty, X-Y-Direction),
  row(Y, Letter), format("I'll move from X:~d Y:~s to the ~s Direction\n", [X, Letter, Direction]),
  move(GameState, X-Y-Direction, NewGameState).

% Player Predicate remove belongs to logic.pl but need to be together with the bot predicate
% instead of moving a pice and captuing a enemy piece, a player piece is removed because there aren't any available plays
remove('Player', GameState, PlayerS, NewGameState) :-
  write('- There are no pieces to replace, select one piece to remove.\n'),
  size_of_board(GameState, Size),
  read_inputs(Size, Xread, Yread),
  validate_choice(GameState, Xread, Yread, PlayerS, Xtemp, Ytemp),
  format('- Selected spot: X : ~d -- Y : ~w \n', [Xread,Yread]),
  replace(GameState, Xtemp, Ytemp, 0, NewGameState), skip_line.
remove(Difficulty, GameState, Player, NewGameState):-
  choose_remove(GameState, Player, Difficulty, X-Y),
  row(Y, Letter), format("I'll remove my piece from X:~d Y:~s\n", [X, Letter]),
  replace(GameState, X, Y, 0, NewGameState).

choose_move(GameState, Player, 'Easy', X-Y-Direction):-
  valid_moves(GameState, Player, List),
  random_member(Value, List),
  nth0(0, Value, X),
  nth0(1, Value, Y),
  nth0(2, Value, Direction).
choose_move(GameState, Player, 'Normal', X-Y-Direction):-  
  valid_moves(GameState, Player, List),
  findall(
    Value1-X1-Y1-Direction1-Index,
    (
      nth0(Index, List, SubList), 
      nth0(0, SubList, X1),
      nth0(1, SubList, Y1),
      nth0(2, SubList, Direction1),
      move(GameState, X1-Y1-Direction1, NewGameState),
      value(NewGameState, Player, Value1),
      write(Value1-X1-Y1-Direction1-Index), nl
    ),
    ListResults
    ),
  sort(ListResults, Sorted), 
  reverse(Sorted, [_-X-Y-Direction-_|_]).
choose_remove(GameState, Player, 'Easy', X-Y):-
  valid_removes(GameState, Player, List),
  random_member(Value, List),
  nth0(0, Value, X),
  nth0(1, Value, Y).
choose_remove(GameState, Player, 'Normal', X-Y):-
  valid_removes(GameState, Player, List),
  findall(
    Value1-X1-Y1-Index,
    (
      nth0(Index, List, SubList), 
      nth0(0, SubList, X1),
      nth0(1, SubList, Y1),
      replace(GameState, X1, Y1, 0, NewGameState),
      value(NewGameState, Player, Value1)
    ),
    ListResults
    ),
  sort(ListResults, Sorted), 
  reverse(Sorted, [_-X-Y-_|_]).

/**
 * max_list(+ListOfNumbers, ?Max)
 *   Max is the largest of the elements in ListOfNumbers.
 */
% peça que removida/movida cause o maior numero de celulas brancas seguidas numa linha/coluna  
  
/*
  2 passagens no board:
  1 - Vai celula a celula, encontra espaço branco, guarda essa posição e faz floodfill, continua a ir celula
  a celula com o board floodfilled, quando encontrar outra celula branca faz o mesmo e passa o board.
  Recursividade acaba quando chegar ao final do board. Retorna lista de posições X-Y

  2 - Vai a cada posição e faz floodfill no board inicial, analisa o board, adiciona valor a lista,
  vai a proxima posição e faz floodfill com board inicial, ...
  retorna lista de valores de cada mancha

  Value retorna maior dos valores de cada mancha

  Predicado 1:
  ```
  Percorre célula a célula
    Encontra lugar 0
      FloodFill para obter novo GameState, Guarda Posição X-Y para depois retornar e chama mesmo predicado
      com novo GameState
    Dá append a X-Y á lista de Return de ter chamado o predicado e dá return da nova lista
  ```
  Caso Base: Chegou ao final do Board e Retorna Lista Vazia.
  Return do Predicado: Lista da forma [X-Y,X1-Y1, ..] que contem posições por onde começar para fazer floodfill de uma mancha
  Terá sempre pelo menos 1 elemento, já que avalia o board da próxima jogada. Mesmo que fosse o primeiro a jogar já abriria 1 spot vazio

  Predicado 2:
  Percorre cada posição da lista de cima 
    Faz floodfill e forma-se um board com 1 mancha
    verifica quantos caracteres de fill há em cada coluna e põe numa lista [4,3,3,2,0,0]
      vai row a row numa coluna Y e conta os caracteres de fill, retorna esse numero
    vê qual é a maior sequencia de numeros seguidos diferentes de 0: [4,3,3,2,0,0] -> 4
    Chama predicado com resto da lista
    Append do Resultado a uma lista de return
  Caso Base: Chegou ao final da Lista de Pontos e Retorna Lista Vazia.
  Return do predicado: Uma lista de valores [X, Y, Z] com o value de cada mancha

  Value retorna o maior dos values
*/

%value aleatório entre 0 e 10
/* value(GameState, 'Player 1', Value):-	
  write('asd'),
  random(0, 11, Value). */

% analisa na horizontal
value(GameState, 'Player 1', Value):-
  value_part_1(GameState, List),
  value_part_2(GameState, List, ReturnList),
  max_member(Value, ReturnList), !.
  
value(GameState, 'Player 2', Value):-
  transpose(GameState, Transpose),
  value(Transpose, 'Player 1', Value).



value_part_2(_, [], []).
value_part_2(GameState, [X-Y|Rest], ReturnList):-
  size_of_board(GameState, Size),
  floodFill(GameState, Size, X, Y, 0, 9, NewGS),
  values_in_all_columns(NewGS, 9, ListResult),
  write(ListResult),nl,
  sequence(ListResult, TempValue),
  value_part_2(GameState, Rest, TempReturnList),
  append(TempReturnList, [TempValue], ReturnList).

value_part_1(GameState, List):-
  value_part_1(GameState, 0, 0, List).
% if it's last cell and its empty, neither the top pr left cell are empty, meaning list is has a value.
% No need to do floodfill cause there's only 1 cell to fill
value_part_1(GameState, X, Y, [Size1-Size1]):-
  size_of_board(GameState, Size), check_end(X, Y, Size),
  value_in_board(GameState, X, Y, 0),
  Size1 is Size-1.
% if it's last cell and not empty, return list is empty
value_part_1(GameState, X, Y, []):-
  size_of_board(GameState, Size), check_end(X, Y, Size).
% not at end and value of cell is 0
value_part_1(GameState, X, Y, List):-
  value_in_board(GameState, X, Y, 0), 
  size_of_board(GameState, Size),
  floodFill(GameState, Size, X, Y, 0, 9, NewGS),
  next_index(X, Y, Size, X2, Y2),
  value_part_1(NewGS, X2, Y2, Result),
  append(Result, [X-Y], List).
% not at end and value is != 0
value_part_1(GameState, X, Y, List):-
  size_of_board(GameState, Size),
  next_index(X, Y, Size, X2, Y2),
  value_part_1(GameState, X2, Y2, List).

% with a Board and a value returns a list [4,3,4,3,0,0] with amount of characters Value in all Columns
values_in_all_columns(GameState, Value, ListResult):-
  size_of_board(GameState, Size), Size1 is Size-1,
  values_in_all_columns(GameState, Value, Size1, ListResult).
values_in_all_columns(_, _, -1, []).
values_in_all_columns(GameState, Value, Index, Result):-
  values_in_column(GameState, Index, Value, ValueResult),
  Index1 is Index-1,
  values_in_all_columns(GameState, Value, Index1, TempResult),
  append(TempResult, [ValueResult], Result).
% returns the Amount of cells with Value in column X
values_in_column(GameState, X, Value, Amount):-
  get_column(GameState, X, Column),
  count(Value, Column, Amount).

% Receives [4,3,4,3,0,0] and returs 4
% [0,1,0,0,1,4,2]
% Returns in Result the longest sequence not formed by 0
sequence(List, Result):-
  sequence(List, 0, 0, Result).
sequence([], Counter, MaxLength, Counter):-
  Counter > MaxLength.
sequence([], _, MaxLength, MaxLength).
sequence([ToTest|Rest], Counter, MaxLength, Result):-
  ToTest == 0, Counter > MaxLength, 
  sequence(Rest, 0, Counter, Result).
sequence([ToTest|Rest], _, MaxLength, Result):-
  ToTest == 0, 
  sequence(Rest, 0, MaxLength, Result).
sequence([_|Rest], Counter, MaxLength, Result):-
  Counter1 is Counter+1,
  sequence(Rest, Counter1, MaxLength, Result).




valid_removes(GameState, PlayerS, List):-
  check_spot_remove(GameState, 0, 0, PlayerS, List).
check_spot_remove(GameState, X, Y, Player, ReturnList):-
  player_in_board(GameState, X, Y, Player),
  size_of_board(GameState, Size),
  \+ check_end(X, Y, Size), 
  next_index(X, Y, Size, X1, Y1),
  check_spot_remove(GameState, X1, Y1, Player, TempReturnList),
  append(TempReturnList, [[X, Y]], ReturnList).
check_spot_remove(GameState, X, Y, _, ReturnList):-
  size_of_board(GameState, Size),
  check_end(X, Y, Size),
  ReturnList = [].
% if not the end of the board, checks next spot
check_spot_remove(GameState, X, Y, Player, ReturnList):-
  size_of_board(GameState, Size),
  next_index(X, Y, Size, X1, Y1),
  check_spot_remove(GameState, X1, Y1, Player, ReturnList).


valid_moves(GameState, PlayerS, List):-
  check_spot(GameState, 0, 0, PlayerS, List).
  
% if spot belongs to player, checks directions and if list is empty -> next spot

% Base Case: Last Spot and Spot Belongs to Player, There're available plays
check_spot(GameState, X, Y, Player, ReturnList):-
  size_of_board(GameState, Size), check_end(X, Y, Size),
  player_in_board(GameState, X, Y, Player),
  available_dirs(GameState, X, Y, Player, TempList), TempList \= [],
  create_sublist(X, Y, TempList, ReturnList).
% Base Case: Last Spot and Spot Belongs to Player, There're no available plays
check_spot(GameState, X, Y, Player, []):-
  size_of_board(GameState, Size), check_end(X, Y, Size),
  player_in_board(GameState, X, Y, Player),
  available_dirs(GameState, X, Y, Player, []).
% Base Case: Last Spot and Spot Doesn't Belong to Player
check_spot(GameState, X, Y, _, []):-
  size_of_board(GameState, Size), check_end(X, Y, Size).
check_spot(GameState, X, Y, Player, ReturnList):-
  player_in_board(GameState, X, Y, Player),
  available_dirs(GameState, X, Y, Player, TempList), TempList \= [],
  create_sublist(X, Y, TempList, Result),
  size_of_board(GameState, Size),
  next_index(X, Y, Size, X1, Y1),
  check_spot(GameState, X1, Y1, Player, TempReturnList),
  append(TempReturnList, Result, ReturnList).
% if the spot does not belong to player checks if can go to next, if end of board returns
check_spot(GameState, X, Y, _, ReturnList):-
  size_of_board(GameState, Size),
  check_end(X, Y, Size),
  ReturnList = [].
% if not the end of the board, checks next spot
check_spot(GameState, X, Y, Player, ReturnList):-
  size_of_board(GameState, Size),
  next_index(X, Y, Size, X1, Y1),
  check_spot(GameState, X1, Y1, Player, ReturnList).

% from a position and a list of directions, creates options in the format [[X, Y, 'dir1'], [X, Y, 'dir2']]
create_sublist(X, Y, [Dir|Rest], Result):-
  NewList = [[X, Y, Dir]],
  create_sublist(X, Y, Rest, PreviousResult),
  append(PreviousResult, NewList, Result).
create_sublist(_, _, [], []).