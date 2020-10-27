% main predicate for game start
play :-
  initial(GameState),
  print_board(GameState),
  start_game(GameState).

% initializes the board with no pieces on it
initial(GameState) :-
  initial_board(GameState).

% Starts the game with player 1 and black board
start_game(GameState) :-
  turn(GameState, 'Player 1').

% Makes a turn and calls the predicate to chose a spot
turn(GameState, Player) :-
  format('\n ~a turn.\n', Player),
  select_spot(GameState, Player),
  print_board(GameState).
