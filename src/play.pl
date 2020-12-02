% play/0
% main predicate for game start, presents the main menu
play :-
  clear,
  talpa_logo,
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
  ( Player = 'Player', format('~n~`*t ~a turn ~`*t~57|~n', [PlayerS]) ;
    Player \= 'Player', format('~n~`*t Computer turn as ~s ~`*t~57|~n', [PlayerS]) ),
  check_final(GameState, PlayerS),
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
  clear, 
  display_game(NewGameState),
  opposed_opponent_string(PlayerS, EnemyS),
  turn(NewGameState, TypeToPlay, EnemyS, TypePlayer).
% If there's a winner, the game ends
process_result(NewGameState, Winner, _, _, _):-
  clear, 
  display_game(NewGameState),
  format('~n~`*t Winner - ~a ~`*t~57|~n', [Winner]),
  sleep(5), clear.

% game_over(+GameState, +Player , -Winner)
% checks first if enemy is winner
game_over(GameState, CurrentPlayer, EnemyS):-
  size_of_board(GameState, Size), 
  opposed_opponent_string(CurrentPlayer, EnemyS),
  check_win(EnemyS, GameState, Size).
% then checks if player is the winner
game_over(GameState, CurrentPlayer, CurrentPlayer):-
  size_of_board(GameState, Size),
  check_win(CurrentPlayer, GameState, Size).
% in case there is no winner, 'none' is returned
game_over(_, _, 'none').

% check_win(+PlayerS, +GameState, +K, -Result)
% to check the win for Player 1, we can check the win for Player 1 with the transposed matrix
check_win('Player 2', GameState, X):-
  transpose(GameState, Transpose),
  check_win('Player 1', Transpose, X).

check_win('Player 1', GameState, Size):-
  value(GameState, 'Player 1', Value),
  Value == Size.

% does one floodfill and doesn't repeat on redo
attemp_flood_fill(Board, X, Y, NewBoard):-
  size_of_board(Board, Size),
  floodFill(Board, Size, X, Y, 0, 9, NewBoard), !.
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
