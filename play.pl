% play/0
% main predicate for game start, presents the main menu
play :-
  menu.

% start_game(+GameState, +Player1Type, +Player2Type)
% starts a game with Player1Type vs Player2Type
start_game(GameState, Player1Type, Player2Type):-
  clear, 
  display_game(GameState),
  turn(GameState, Player1Type, 'Player 1', Player2Type ).

% turn(+GameState, +Player, +PlayerS, +NextPlayer)
% Turn predicate for final game state where player removes a piece instead of moving it
turn(GameState, Player, PlayerS, NextPlayer):-
  ( Player = 'Player', format('\n ~a turn.\n', PlayerS) ; 
    Player \= 'Player', format('\n Computer turn as ~s.\n', PlayerS) ),
  check_final_state(GameState, PlayerS, 0, 0),
  remove(Player, GameState, PlayerS, NewGameState),
  game_over(NewGameState, PlayerS, TempResult),
  process_result(NewGameState, TempResult, Player, NextPlayer, PlayerS).
% Turn predicate for moving a piece
turn(GameState, Player, PlayerS, NextPlayer):-
  make_move(Player, GameState, PlayerS, NewGameState),
  game_over(NewGameState, PlayerS, TempResult),
  process_result(NewGameState, TempResult, Player, NextPlayer, PlayerS).

% process_result(+NewGameState, +Winner, +TypePlayer, +TypeToPlay, +PlayerS)
% Processes the Winner argument, if there are no winners then it's the opponent's turn
process_result(NewGameState, 'none', TypePlayer, TypeToPlay, PlayerS):-
  clear, display_game(NewGameState),
  opposed_opponent_string(PlayerS, EnemyS),
  turn(NewGameState, TypeToPlay, EnemyS, TypePlayer).
% If there's a winner, the game ends
process_result(NewGameState, Winner, _, _, _):-
  clear, display_game(NewGameState),
  format('Result -> ~s', Winner),
  sleep(2).

% game_over(+GameState, +Player , -Winner)
% checks first if enemy is winner
game_over(GameState, CurrentPlayer, EnemyS):-
  size_of_board(GameState, Size), Size1 is Size-1,
  opposed_opponent_string(CurrentPlayer, EnemyS),
  check_win(EnemyS, GameState, Size1).
% then checks if player is the winner
game_over(GameState, CurrentPlayer, CurrentPlayer):-
  size_of_board(GameState, Size), Size1 is Size-1,
  check_win(CurrentPlayer, GameState, Size1).
% in case there is no winner, 'none' is returned
game_over(_, _, 'none').

% check_win(+PlayerS, +GameState, +K, -Result)
% to check the win for Player 1, we can check the win for Player 1 with the transposed matrix
check_win('Player 2', GameState, X):-
  transpose(GameState, Transpose),
  check_win('Player 1', Transpose, X).
% verifies if player 1 won, and if the helper function finds a solution, returns 'Player 1', if it fails, goes to next predicate
check_win('Player 1', Board, Y):-
  value_in_board(Board, 0, Y, 0), 
  attemp_flood_fill(Board, 0, Y, NewBoard),
  size_of_board(Board, Size), Size1 is Size-1,
  check_win_helper(NewBoard, Size1, Size1).
% if the value in board is not 0 or previous fails, goes to next spot
check_win('Player 1', Board, Y):-
  Y @> 0, Y1 is Y-1, 
  check_win('Player 1', Board, Y1).
% once it reaches the end of the board, fails
check_win('Player 1', _, _):- fail.

% if the value in board in 9, a solution was found
check_win_helper(Board, Y, MaxX):-
  Y >= 0, value_in_board(Board, MaxX, Y, 9).
% else goes to the next spot and checks
check_win_helper(Board, Y, MaxX):-
  Y > 0, Y1 is Y-1, 
  check_win_helper(Board, Y1, MaxX).

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
