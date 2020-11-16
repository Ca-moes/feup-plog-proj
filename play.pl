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
  % verificar se está em fase final, AKA tirar peças em vez de comer
  (
    (
      check_final_state(GameState, PlayerS, 0, 0),
      remove(GameState, PlayerS, NewGameState)
    ) 
    ; 
    (move(GameState, PlayerS, NewGameState))
  ),
  
  
  % verificar se jogo acabou
  display_game(NewGameState),
  opposed_opponent_string(PlayerS, EnemyS),
  skip_line,
  turn(NewGameState, EnemyS)
  .  


/*
Board

Peça a peça
Code, código oponente

available_dirs
= []

passa próxima

    ultima peça
    available dirs []
    fase final
*/