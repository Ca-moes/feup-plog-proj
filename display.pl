% Initial board with pieces in chess formation
initial_board([
  [1,2,1,2,1,2,1,2],
  [2,1,2,1,2,1,2,1],
  [1,2,1,2,1,2,1,2],
  [2,1,2,1,2,1,2,1],
  [1,2,1,2,1,2,1,2],
  [2,1,2,1,2,1,2,1],
  [1,2,1,2,1,2,1,2],
  [2,1,2,1,2,1,2,1]
]).

% Pieces codes for board representation
code(0, ' ').
code(1, 'X').
code(2, '+').

% Codes for board rows
row(0, R) :- R='A'.
row(1, R) :- R='B'.
row(2, R) :- R='C'.
row(3, R) :- R='D'.
row(4, R) :- R='E'.
row(5, R) :- R='F'.
row(6, R) :- R='G'.
row(7, R) :- R='H'.

% When the counter reaches 0, it ends
print_matrix([], 8).
print_matrix([L|T], N) :-
  row(N, R), write(' '), write(R), write(' | '),
  N1 is N + 1,
  print_line(L), nl,
  write('---|---|---|---|---|---|---|---|---|\n'),
  print_matrix(T, N1).

% Prints a line of the board
print_line([]).
print_line([C|L]) :-
  code(C, P), write(P), write(' | '),
  print_line(L).

% Prints the board according to its state
display_game(Board, Player) :-
  % Header of the board
  nl,
  write('   | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |\n'),
  write('---|---|---|---|---|---|---|---|---|\n'),
  print_matrix(Board, 0).

% test display:
% ?- initial_board(_B), print_board(_B).
