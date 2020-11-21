% main predicate for game start
play :-
  menu.

% Starts the game with player 1
start_game(GameState) :-
  turn(GameState, 'Player 1', Result).

% Checks if game is in final state (remove pieces intead of relocating them) and in that case, removes piece, checks if there's a winner and processes
turn(GameState, PlayerS, Result) :-
  format('\n ~a turn.\n', PlayerS),
  check_final_state(GameState, PlayerS, 0, 0),
  remove(GameState, PlayerS, NewGameState),
  check_winnner(NewGameState, PlayerS, TempResult), 
  process_result(TempResult, NewGameState, PlayerS, Result).  
% Move a piece instead of removing one, checks if there's a winner and processes
turn(GameState, PlayerS, Result) :-
  move(GameState, PlayerS, NewGameState),
  check_winnner(NewGameState, PlayerS, TempResult), 
  process_result(TempResult, NewGameState, PlayerS, Result).



start_game_p1ceasy(GameState):-
  turn_p1ceasy(GameState, 'Player 1', Result).

turn_p1ceasy(GameState, 'Player 2', Result):-
  write('\n Computer turn as Player 2.\n'),
  check_final_state(GameState, 'Player 2', 0, 0),
  easy_bot_remove(GameState, 'Player 2', NewGameState),
  check_winnner(NewGameState, 'Player 2', TempResult),
  process_result_p1ceasy(TempResult, NewGameState, 'Player 2', Result).
turn_p1ceasy(GameState, 'Player 2', Result):-
  easy_bot_move(GameState, 'Player 2', NewGameState),
  check_winnner(NewGameState, 'Player 2', TempResult),
  process_result_p1ceasy(TempResult, NewGameState, 'Player 2', Result).
turn_p1ceasy(GameState, 'Player 1', Result):-
  write('\n Player 1 Turn.\n'),
  check_final_state(GameState, 'Player 1', 0, 0),
  remove(GameState, 'Player 1', NewGameState), skip_line,
  check_winnner(NewGameState, 'Player 1', TempResult),
  process_result_p1ceasy(TempResult, NewGameState, 'Player 1', Result).
turn_p1ceasy(GameState, 'Player 1', Result):-
  move(GameState, 'Player 1', NewGameState), skip_line,
  check_winnner(NewGameState, 'Player 1', TempResult),
  process_result_p1ceasy(TempResult, NewGameState, 'Player 1', Result).

% if there's no winner the next turn is played by the enemy
process_result_p1ceasy('none', NewGameState, PlayerS, Result):-
  display_game(NewGameState),
  opposed_opponent_string(PlayerS, EnemyS),
  turn_p1ceasy(NewGameState, EnemyS, Result).
% if there's a winner, the game ends
process_result_p1ceasy(Winner, NewGameState, _, Winner):-
  display_game(NewGameState),
  format('Result -> ~s', Winner),
  sleep(2).

start_game_p2ceasy(GameState):-
  turn_p2ceasy(GameState, 'Player 1', Result).

turn_p2ceasy(GameState, 'Player 1', Result):-
  write('\n Computer turn as Player 1.\n'),
  check_final_state(GameState, 'Player 1', 0, 0),
  easy_bot_remove(GameState, 'Player 1', NewGameState),
  check_winnner(NewGameState, 'Player 1', TempResult),
  process_result_p2ceasy(TempResult, NewGameState, 'Player 1', Result).
turn_p2ceasy(GameState, 'Player 1', Result):-
  easy_bot_move(GameState, 'Player 1', NewGameState),
  check_winnner(NewGameState, 'Player 1', TempResult),
  process_result_p2ceasy(TempResult, NewGameState, 'Player 1', Result).
turn_p2ceasy(GameState, 'Player 2', Result):-
  write('\n Player 2 Turn.\n'),
  check_final_state(GameState, 'Player 2', 0, 0),
  remove(GameState, 'Player 2', NewGameState), skip_line,
  check_winnner(NewGameState, 'Player 2', TempResult),
  process_result_p2ceasy(TempResult, NewGameState, 'Player 2', Result).
turn_p2ceasy(GameState, 'Player 2', Result):-
  move(GameState, 'Player 2', NewGameState),   skip_line,
  check_winnner(NewGameState, 'Player 2', TempResult),
  process_result_p2ceasy(TempResult, NewGameState, 'Player 2', Result).

process_result_p2ceasy('none', NewGameState, PlayerS, Result):-
  display_game(NewGameState),
  opposed_opponent_string(PlayerS, EnemyS),
  turn_p2ceasy(NewGameState, EnemyS, Result).
% if there's a winner, the game ends
process_result_p2ceasy(Winner, NewGameState, _, Winner):-
  display_game(NewGameState),
  format('Result -> ~s', Winner),
  sleep(2).


% if there's no winner the next turn is played by the enemy
process_result('none', NewGameState, PlayerS, Result):-
  display_game(NewGameState),
  opposed_opponent_string(PlayerS, EnemyS),
  skip_line,
  turn(NewGameState, EnemyS, Result).
% if there's a winner, the game ends
process_result(Winner, _, _, Winner):-
  format('Result -> ~s', Winner),
  sleep(2), skip_line.

% checks first if enemy is winner
check_winnner(Board, CurrentPlayer, EnemyS):-
  size_of_board(Board, Size),
  Size1 is Size-1,
  opposed_opponent_string(CurrentPlayer, EnemyS),
  check_win(EnemyS, Board, Size1, EnemyS).
% then checks if player is the winner
check_winnner(Board, CurrentPlayer, CurrentPlayer):-
  size_of_board(Board, Size),
  Size1 is Size-1,
  check_win(CurrentPlayer, Board, Size1, CurrentPlayer).
% in case there is no winner
check_winnner(_, _, 'none').

% verifies if player 1 won, and if the helper function finds a solution, returns 'Player 1'
check_win('Player 1', Board, Y, 'Player 1'):-
  value_in_board(Board, 0, Y, 0), 
  attemp_flood_fill(Board, 0, Y, NewBoard),
  size_of_board(Board, Size),
  Size1 is Size-1,
  check_1_win_helper(NewBoard, Size1, Size1).
% if the helper functions doesn't find a solution, goes to next predicate
check_win('Player 1', Board, Y, _):-
  value_in_board(Board, 0, Y, 0), 
  attemp_flood_fill(Board, 0, Y, NewBoard),
  size_of_board(Board, Size),
  Size1 is Size-1,
  check_1_win_helper(NewBoard, Size1, Size1).
% if the value in board is not 0, goes to next spot
check_win('Player 1', Board, Y, Result):-
  Y1 is Y-1, Y1 >= 0, 
  check_win('Player 1', Board, Y1, Result).
% once it reaches the end of the board, returns 'none'
check_win('Player 1', _, _, 'none').

% verifies if player 2 won, and if the helper function finds a solution, returns 'Player 2'
check_win('Player 2', Board, X, 'Player 2'):-
  value_in_board(Board, X, 0, 0), 
  size_of_board(Board, Size),
  floodFill(Board, Size, X, 0, 0, 9, NewBoard),
  Size1 is Size-1,
  check_2_win_helper(NewBoard, Size1, Size1).
% if the helper functions doesn't find a solution, goes to next predicate
check_win('Player 2', Board, X, 'Player 2'):-
  value_in_board(Board, X, 0, 0), 
  size_of_board(Board, Size),
  floodFill(Board, Size, X, 0, 0, 9, NewBoard),
  Size1 is Size-1,
  check_2_win_helper(NewBoard, Size1, Size1).
% if the value in board is not 0, goes to next spot
check_win('Player 2', Board, X, Result):-
  X1 is X-1, X1 >= 0, 
  check_win('Player 2', Board, X1, Result).
% once it reaches the end of the board, returns 'none'
check_win('Player 2', _, _, 'none').

% if the value in board in 9, a solution was found
check_1_win_helper(Board, Y, MaxX):-
  value_in_board(Board, MaxX, Y, 9).
% else goes to the next spot and checks
check_1_win_helper(Board, Y, MaxX):-
  Y1 is Y-1,
  Y1 >= 0,
  check_1_win_helper(Board, Y1, MaxX).

% if the value in board in 9, a solution was found
check_2_win_helper(Board, X, MaxY):-
  value_in_board(Board, X, MaxY, 9).
% else goes to the next spot and checks
check_2_win_helper(Board, X, MaxY):-
  X1 is X-1,
  X1 >= 0,
  check_2_win_helper(Board, X1, MaxY).

% does one floodfill and doesn't repeat on redo
attemp_flood_fill(Board, X, Y, NewBoard):-
  size_of_board(Board, Size),
  floodFill(Board, Size, X, Y, 0, 9, NewBoard), !.

% prolog implementation of the floodFill algorithm
floodFill(Board, BoardSize, X, Y, PrevCode, NewCode, FinalBoard):-
  X >= 0, X < BoardSize, Y >= 0, Y < BoardSize,
  value_in_board(Board, X, Y, PrevCode),
  replace(Board, X, Y, NewCode, BoardResult), % substitui 0 pelo novo valor,
  X1 is X+1, X2 is X-1, Y1 is Y+1, Y2 is Y-1,
  floodFill(BoardResult, BoardSize, X1, Y, PrevCode, NewCode, T1) ,
  floodFill(T1, BoardSize, X2, Y, PrevCode, NewCode, T2) ,
  floodFill(T2, BoardSize, X, Y1, PrevCode, NewCode, T3) ,  
  floodFill(T3, BoardSize, X, Y2, PrevCode, NewCode, FinalBoard).
% if initial floodfill returns from every direction, returns the initial board
floodFill(Board, _, _, _, _, _, Board).


/*
  [
  [-1,-1,-1,-1, 1, 0,-1, 0],
  [ 0, 0, 0, 0, 0, 0, 0,-1],
  [-1, 1, 0, 1, 0, 0, 1, 0],
  [ 0, 0, 0,-1, 0,-1, 0,-1],
  [ 0, 1, 1, 0, 1, 0, 0, 0],
  [-1, 0, 0, 0, 0, 0, 1, 0],
  [ 0, 0, 0, 1, 1,-1, 0, 0],
  [-1, 1,-1, 0, 1, 1, 1, 0]
]

0,0  -> Size-1, 0 ; Size-1, 1; Size-1, 2
0,1
0,2
0,3
0,4

Para cada 0,x
  available_dirs
  Para cada dir
    X e Y atualizado
    X == Size-1?


modificar available_dirs para devolver direções com 0
['down', 'left']

para cada direção

direction(X, Y, 'up', Xr, Yr):-     Xr = X,     Yr is Y-1.
direction(X, Y, 'right', Xr, Yr):-  Xr is X+1,  Yr = Y.
direction(X, Y, 'down', Xr, Yr):-   Xr = X,     Yr is Y+1.
direction(X, Y, 'left', Xr, Yr):-   Xr is X-1,  Yr = Y.


*/
