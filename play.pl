% main predicate for game start
play :-
  initial(GameState),
  display_game(GameState, Player),
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
  move(GameState, PlayerS, NewGameState),
  display_game(NewGameState, Player),
  opposed_opponent_string(PlayerS, EnemyS),
  skip_line,
  turn(NewGameState, EnemyS)
  .  
