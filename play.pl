% main predicate for game start
play :-
  initial(GameState),
  display_game(GameState),
  start_game(GameState). 

% initializes the board with pieces organized
initial(GameState) :-
  initial_board(GameState).

% Starts the game with player 1
start_game(GameState) :-
  turn(GameState, 'Player 1', Result).

% Makes a turn and calls the predicate to chose a spot
turn(GameState, PlayerS, Result) :-
  format('\n ~a turn.\n', PlayerS),
   % verificar se está em fase final, AKA tirar peças em vez de comer
  check_final_state(GameState, PlayerS, 0, 0),
  remove(GameState, PlayerS, NewGameState),
  %check_winnner(NewGameState, PlayerS, TempResult), 
  process_result('none', NewGameState, PlayerS, Result).  
turn(GameState, PlayerS, Result) :-
  move(GameState, PlayerS, NewGameState),
  %check_winnner(NewGameState, PlayerS, TempResult), 
  process_result('none', NewGameState, PlayerS, Result).


process_result('none', NewGameState, PlayerS, Result):-
  display_game(NewGameState),
  opposed_opponent_string(PlayerS, EnemyS),
  skip_line,
  turn(NewGameState, EnemyS, Result).
process_result(Winner, _, _, Result):-
  format('Result -> ~s', Winner),
  Result = Winner.

%% Ripzão na simplificação, ele volta para tras e tenta com Size1 diferentes
check_winnner(Board, CurrentPlayer, Player):-
  size_of_board(Board, Size),
  Size1 is Size-1,
  opposed_opponent_string(CurrentPlayer, EnemyS),
  check_win(EnemyS, Board, Size1, Result), 
  (
    (Result == EnemyS, Player=EnemyS)
    ;
    (
      check_win(CurrentPlayer, Board, Size1, Result1), 
      (
        (Result1 == CurrentPlayer, Player=CurrentPlayer);
        (Player = 'none')
      )
    )
  ).

%% Ripzão na simplificação, ele volta para tras e tenta com Size1 diferentes
check_win('Player 1', Board, Y, Result):-
  value_in_board(Board, 0, Y, 0), 
  size_of_board(Board, Size),
  floodFill(Board, Size, 0, Y, 0, 9, NewBoard),
  Size1 is Size-1,
  check_1_win_helper(NewBoard, Size1, Size1, Return),
  (
    (
      Return == 'not', 
      Y1 is Y-1, 
      ((Y1 >= 0, check_win('Player 1', Board, Y1, Result)) ; (Result = 'none'))
    );
    (
      Return == 'found',
      Result = 'Player 1'
    )
  ).
% if the value in board is not 0
check_win('Player 1', Board, Y, Result):-
  Y1 is Y-1, Y1 >= 0, 
  check_win('Player 1', Board, Y1, Result).
check_win('Player 1', _, _, 'none').

%% Ripzão na simplificação, ele volta para tras e tenta com Size1 diferentes
check_win('Player 2', Board, X, Result):-
  value_in_board(Board, X, 0, 0), 
  size_of_board(Board, Size),
  floodFill(Board, Size, X, 0, 0, 9, NewBoard),
  Size1 is Size-1,
  check_2_win_helper(NewBoard, Size1, Size1, Return),
  (
    (
      Return == 'not', 
      X1 is X-1, 
      ((X1 >= 0, check_win('Player 2', Board, X1, Result)) ; (Result = 'none'))
    );
    (
      Return == 'found',
      Result = 'Player 2'
    )
  ).
% if the value in board is not 0
check_win('Player 2', Board, X, Result):-
  X1 is X-1, X1 >= 0, 
  check_win('Player 2', Board, X1, Result).
check_win('Player 2', _, _, 'none').



check_1_win_helper(Board, Y, MaxX, 'found'):-
  value_in_board(Board, MaxX, Y, 9).
check_1_win_helper(Board, Y, MaxX, Return):-
  Y1 is Y-1,
  Y1 >= 0,
  check_1_win_helper(Board, Y1, MaxX, Return).
check_1_win_helper(_, _, _, 'not').

check_2_win_helper(Board, X, MaxY, 'found'):-
  value_in_board(Board, X, MaxY, 9).
check_2_win_helper(Board, X, MaxY, Return):-
  X1 is X-1,
  X1 >= 0,
  check_2_win_helper(Board, X1, MaxY, Return).
check_2_win_helper(_, _, _, 'not').


floodFill(Board, BoardSize, X, Y, PrevCode, NewCode, FinalBoard):-
  X >= 0, X < BoardSize, Y >= 0, Y < BoardSize,
  value_in_board(Board, X, Y, PrevCode),
  replace(Board, X, Y, NewCode, BoardResult), % substitui 0 pelo novo valor,
  X1 is X+1, X2 is X-1, Y1 is Y+1, Y2 is Y-1,
  floodFill(BoardResult, BoardSize, X1, Y, PrevCode, NewCode, T1) ,
  floodFill(T1, BoardSize, X2, Y, PrevCode, NewCode, T2) ,
  floodFill(T2, BoardSize, X, Y1, PrevCode, NewCode, T3) ,  
  floodFill(T3, BoardSize, X, Y2, PrevCode, NewCode, FinalBoard).
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
