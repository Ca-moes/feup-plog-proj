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
  turn(GameState, 'Player 1').

% Makes a turn and calls the predicate to chose a spot
turn(GameState, PlayerS) :-
  format('\n ~a turn.\n', PlayerS),
  % move(GameState, PlayerS, NewGameState),

  check_win(GameState, Result), 
  format('Result -> ~s', Result)
  %opposed_opponent_string(PlayerS, EnemyS),
  %skip_line,
  %turn(NewGameState, EnemyS)
  .  

check_win(Board, Player):-
  size_of_board(Board, Size),
  Size1 is Size-1,
  check_1_win(Board, Size1, Result),
  (
    (Result == 'Player 1', Player='Player 1') ;
    (
      check_2_win(Board, Size1, Result1),
      (
        (Result1 == 'Player 2', Player='Player 2') ;
        (Player = 'none')
      )
    )
  ).
  
check_1_win(Board, Y, Result):-
  value_in_board(Board, 0, Y, Value), % se valor não for 0 falha
  ( % se valor for 0 entra aqui
    Value == 0,
    size_of_board(Board, Size),
    floodFill(Board, Size, 0, Y, 0, 9, NewBoard),
    Size1 is Size-1,
    check_1_win_helper(NewBoard, Size1, Size1, Return),
    (
      (
        Return == 'not', 
        Y1 is Y-1, 
        ((Y1 >= 0, check_1_win(Board, Y1, Result)) ; (Result = 'none'))
      );
      (
        Return == 'found',
        Result = 'Player 1'
      )
    )
  );
  ( % se valor não for 0 entra aqui
    Y1 is Y-1, 
    ((Y1 >= 0, check_1_win(Board, Y1, Result)) ; (Result = 'none'))
  ).
    

check_1_win_helper(Board, Y, MaxX, Return):-
  (
    (
      value_in_board(Board, MaxX, Y, 9),
      Return = 'found'
    )
    ;
    (
      Y1 is Y-1,
      ((Y1 >= 0, check_1_win_helper(Board, Y1, MaxX, Return)) ; (Return = 'not'))
    )
  ).

check_2_win(Board, X, Result):-
  value_in_board(Board, X, 0, Value), % se valor não for 0 falha
  ( % se valor for 0 entra aqui
    Value == 0,
    size_of_board(Board, Size),
    floodFill(Board, Size, X, 0, 0, 9, NewBoard),
    Size1 is Size-1,
    check_2_win_helper(NewBoard, Size1, Size1, Return),
    (
      (
        Return == 'not', 
        X1 is X-1, 
        ((X1 >= 0, check_2_win(Board, X1, Result)) ; (Result = 'none'))
      );
      (
        Return == 'found',
        Result = 'Player 2'
      )
    )
  );
  ( % se valor não for 0 entra aqui
    X1 is X-1, 
    ((X1 >= 0, check_2_win(Board, X1, Result)) ; (Result = 'none'))
  ).
    

check_2_win_helper(Board, X, MaxY, Return):-
  (
    (
      value_in_board(Board, X, MaxY, 9),
      Return = 'found'
    )
    ;
    (
      X1 is X-1,
      ((X1 >= 0, check_2_win_helper(Board, X1, MaxY, Return)) ; (Return = 'not'))
    )
  ).

floodFill(Board, BoardSize, X, Y, PrevCode, NewCode, FinalBoard):-
  (
    ( 
      X >= 0, X < BoardSize, Y >= 0, Y < BoardSize,
      value_in_board(Board, X, Y, Value),
      Value == PrevCode,
      Value \== NewCode,
      replace(Board, X, Y, NewCode, BoardResult), % substitui 0 pelo novo valor,
      X1 is X+1, X2 is X-1, Y1 is Y+1, Y2 is Y-1,
      floodFill(BoardResult, BoardSize, X1, Y, PrevCode, NewCode, T1) ,
      floodFill(T1, BoardSize, X2, Y, PrevCode, NewCode, T2) ,
      floodFill(T2, BoardSize, X, Y1, PrevCode, NewCode, T3) , 
      floodFill(T3, BoardSize, X, Y2, PrevCode, NewCode, FinalBoard) 
    ) 
  ; 
    (FinalBoard = Board) 
  ).



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

/*
attempt 1

floodFill(Board, BoardSize, X, Y, PrevCode, NewCode, FinalBoard):-
 format('X:~d Y:~d     ', [X,Y]),
 X >= 0, X < BoardSize, Y > 0, Y < BoardSize,
 value_in_board(Board, X, Y, Value),
 Value == PrevCode,  % valor no board é 0, vai ter de ser mudado para NewCode
 replace(Board, X, Y, NewCode, BoardResult), % substitui 0 pelo novo valor,
 X1 is X+1, X2 is X-1, Y1 is Y+1, Y2 is Y-1,
 (floodFill(BoardResult, BoardSize, X1, Y, PrevCode, NewCode, FinalBoard) ;
 floodFill(BoardResult, BoardSize, X2, Y, PrevCode, NewCode, FinalBoard)  ;
 floodFill(BoardResult, BoardSize, X, Y1, PrevCode, NewCode, FinalBoard)  ; 
 floodFill(BoardResult, BoardSize, X, Y2, PrevCode, NewCode, FinalBoard) ; FinalBoard=Board )
floodFill(Board, BoardSize, X, Y, PrevCode, NewCode, FinalBoard).

*/