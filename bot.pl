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
move('Player', GameState, PlayerS, NewGameState) :-
  choose_piece(GameState, PlayerS, X, Y, Directions),
  format('- Selected spot: X : ~d -- Y : ~w \n', [X,Y]),
  read_direction(Directions, Direction),
  format('- Direction received in logic : ~s\n', Direction),
  make_choice(GameState, PlayerS, X, Y, Direction, NewGameState), skip_line.
move(Difficulty, GameState, Player, NewGameState):-
  valid_moves(GameState, Player, List),
  choose_move(GameState, Player, Difficulty, List, X, Y, Direction),
  row(Y, Letter), format("I'll move from X:~d Y:~s to the ~s Direction\n", [X, Letter, Direction]),
  make_choice(GameState, Player, X, Y, Direction, NewGameState).

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
  valid_removes(GameState, Player, List),
  choose_move(GameState, Player, Difficulty, List, X, Y),
  row(Y, Letter), format("I'll remove my piece from X:~d Y:~s\n", [X, Letter]),
  replace(GameState, X, Y, 0, NewGameState).

choose_move(_, _, 'Easy', List, X, Y, Direction):-
  random_member(Value, List),
  nth0(0, Value, X),
  nth0(1, Value, Y),
  nth0(2, Value, Direction).
choose_move(_, _, 'Easy', List, X, Y):-
  random_member(Value, List),
  nth0(0, Value, X),
  nth0(1, Value, Y).

choose_move(GameState, Player, 'Normal', List, X, Y, Direction):-  
  write('here with direction'),
  findall(
    Value1-X1-Y1-Direction1-Index,
    (
      nth0(Index, List, SubList), 
      nth0(0, SubList, X1),
      nth0(1, SubList, Y1),
      nth0(2, SubList, Direction1),
      make_choice(GameState, Player, X1, Y1, Direction1, NewGameState),
      value(NewGameState, Player, Value1)
    ),
    ListResults
    ),
  sort(ListResults, Sorted), 
  reverse(Sorted, [_-X-Y-Direction-_|_]).
choose_move(GameState, Player, 'Normal', List, X, Y):-
  write('here without direction'),
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
value(GameState, Player, Value):-
  random(0, 11, Value).
  
% faz flood fill se nos lados tiver um o
/* value(GameState, 'Player 1', Value):-
  check_value2(GameState, 'Player 1').

% vê numero de 0 em cada linha e retorna o maior
value(GameState, 'Player 1', Value).

% checks it there's at least a 0 in columns 0 and SizeofBoard-1
check_value2(GameState, Player):-
  size_of_board(GameState, Size),Size1 is Size-1,
  find_zero_in_column(GameState, 0),
  find_zero_in_column(GameState, Size1).

% checks if column X has a zero
find_zero_in_column(GameState, X):-
  get_column(GameState, X). */




valid_removes(GameState, PlayerS, List):-
  check_spot_remove(GameState, 0, 0, PlayerS, List).
check_spot_remove(GameState, X, Y, Player, ReturnList):-
  player_in_board(GameState, X, Y, Player),
  size_of_board(GameState, Size),
  \+ check_end(X, Y, Size), 
  next_index(X, Y, Size, X1, Y1),
  check_spot_remove(GameState, X1, Y1, Player, TempReturnList),
  append(TempReturnList, [[X, Y]], ReturnList).
check_spot_remove(GameState, X, Y, Player, ReturnList):-
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
check_spot(GameState, X, Y, Player, ReturnList):-
  player_in_board(GameState, X, Y, Player),
  \+ available_dirs(GameState, X, Y, Player, []).
check_spot(GameState, X, Y, Player, ReturnList):-
  player_in_board(GameState, X, Y, Player),
  available_dirs(GameState, X, Y, Player, TempList), TempList \= [],
  create_sublist(X, Y, TempList, Result),
  size_of_board(GameState, Size),
  \+ check_end(X, Y, Size), 
  next_index(X, Y, Size, X1, Y1),
  check_spot(GameState, X1, Y1, Player, TempReturnList),
  append(TempReturnList, Result, ReturnList).
% if the spot does not belong to player checks if can go to next, if end of board returns
check_spot(GameState, X, Y, Player, ReturnList):-
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
create_sublist(X, Y, [], []).