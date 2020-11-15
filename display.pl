% Initial board with pieces in chess formation

/* initial_board([
  [ 1,-1, 1,-1, 1,-1, 1,-1],
  [-1, 1,-1, 1,-1, 1,-1, 1],
  [ 1,-1, 1,-1, 1,-1, 1,-1],
  [-1, 1,-1, 1,-1, 1,-1, 1],
  [ 1,-1, 1,-1, 1,-1, 1,-1],
  [-1, 1,-1, 1,-1, 1,-1, 1],
  [ 1,-1, 1,-1, 1,-1, 1,-1],
  [-1, 1,-1, 1,-1, 1,-1, 1]
]).  */

/* initial_board([
  [ 1,-1, 1,-1, 1,-1],
  [-1, 1,-1, 1,-1, 1],
  [ 1,-1, 1,-1, 1,-1],
  [-1, 1,-1, 1,-1, 1],
  [ 1,-1, 1,-1, 1,-1],
  [-1, 1,-1, 1,-1, 1]
]). */

/* initial_board([
  [ 1,-1, 1],
  [-1, 1,-1],
  [ 1,-1, 1]
]). */

initial_board([
  [-1,-1,-1,-1, 1, 0,-1, 0],
  [ 0, 0, 0, 0, 0, 0, 0,-1],
  [-1, 1, 0, 1, 0, 0, 1, 0],
  [ 0, 0, 0,-1, 0,-1, 0,-1],
  [ 0, 1, 1, 0, 1, 0, 0, 0],
  [-1, 0, 0, 0, 0, 0, 1, 0],
  [ 0, 0, 0, 1, 1,-1, 0, 0],
  [-1, 1,-1, 0, 1, 1, 1, 0]
]).

size_of_board(Board, X):-
  nth0(0, Board, Header),
  length(Header, X),
  length(Board, Y),
  X == Y. % check if board is nxn and not nxm

% Code takes opposed player code
opposed_opponent_code(PlayerS, Code):-
  player_piece(PlayerS, Piece),
  Code is -Piece.

opposed_opponent_string(PlayerS, EnemyS):-
  opposed_opponent_code(PlayerS, Code),
  player_piece(EnemyS, Code).

% Pieces codes for board representation
code(0, 32). %ascii code for space
code(-1, 216). % Ø - Player 2
code(1, 215). % × - Player 1

player_piece('Player 1', 1).
player_piece('Player 2', -1).

% Codes for board rows
row(0, 'A').
row(1, 'B').
row(2, 'C').
row(3, 'D').
row(4, 'E').
row(5, 'F').
row(6, 'G').
row(7, 'H').

row_lower(0, 'a').
row_lower(1, 'b').
row_lower(2, 'c').
row_lower(3, 'd').
row_lower(4, 'e').
row_lower(5, 'f').
row_lower(6, 'g').
row_lower(7, 'h').

print_board_middle_separator(1):-
  write('|\n').
print_board_middle_separator(X):-
  write('+ - '), X1 is X-1, print_board_middle_separator(X1).

% When the counter reaches 0, it ends
print_matrix([], 8, _).
print_matrix([L|T], N, X) :-
  row(N, R), code(1,P), write(' '), write(R), write(' | '),put_code(P), write(' | '),
  N1 is N + 1,
  print_line(L), nl,
  N < X - 1, write('---+   | - '), print_board_middle_separator(X),
  print_matrix(T, N1, X).
print_matrix(_, _, X):-
  write('---+   *---'),
  print_board_separator(X).

% Prints a line of the board
print_line([]):-
  code(1,P), put_code(P).
print_line([C|L]) :-
  code(C, P),put_code(P), write(' | '),
  print_line(L).


print_header_numbers(Inicial, Final):-
  Inicial = Final,
  write('\n').
print_header_numbers(Inicial, Final):-
  write(' '), write(Inicial), write(' |'), N1 is Inicial + 1, print_header_numbers(N1, Final).

print_separator(0):-
  write('|\n').
print_separator(X):-
  write('+---'), X1 is X-1, print_separator(X1).
  
print_line_codes(0, _):-
  write('\n').
print_line_codes(X, P):-
  put_code(P), write('   '), X1 is X-1, print_line_codes(X1, P).

print_board_separator(1):-
  write('*\n').
print_board_separator(X):-
  write('+---'), X1 is X-1, print_board_separator(X1).

print_header(P, X):-
  write('       |'),
  print_header_numbers(0, X),
  write('       '),
  print_separator(X),
  write('         '), 
  print_line_codes(X, P),
  write('---+   *---'),
  print_board_separator(X).


% Prints the board according to its state
display_game(Board, _) :- % trocar _ por Player no futuro, está assim para não ser singleton
  % Header of the board
  nl, code(-1, P), size_of_board(Board, X),
  print_header(P, X),
  print_matrix(Board, 0, X),
  write('         '),
  print_line_codes(X, P).

% test display:
% ?- initial_board(_B), print_board(_B).
