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
[[X,Y,'up'],[X,Y,'left']]
*/

easy_bot_move(GameState, 'Player 2', NewGameState):-
  valid_moves(GameState, 'Player 2', List),
  choose_move_easy(List, X, Y, Direction),
  make_choice(GameState, 'Player 2', X, Y, Direction, NewGameState).

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

valid_moves(GameState, PlayerS, List):-
  check_spot(GameState, 0, 0, PlayerS, List).
  
% if spot belongs to player, checks directions and if list is empty -> next spot
check_spot(GameState, X, Y, Player, ReturnList):-
  player_in_board(GameState, X, Y, Player),
  available_dirs(GameState, X, Y, Player, TempList),
  (
    (
      TempList == [],
      fail
    )
  ;
    (
      TempList \= [],
      create_sublist(X, Y, TempList, Result),
      size_of_board(GameState, Size),
      \+ check_end(X, Y, Size), 
      next_index(X, Y, Size, X1, Y1),
      check_spot(GameState, X1, Y1, Player, TempReturnList),
      append(TempReturnList, Result, ReturnList)
    )
  ).
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

create_sublist(X, Y, [Dir|Rest], Result):-
  NewList = [[X, Y, Dir]],
  create_list(X, Y, Rest, PreviousResult),
  append(PreviousResult, NewList, Result).
create_sublist(X, Y, [], []).