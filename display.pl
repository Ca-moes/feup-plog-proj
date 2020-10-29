/*

*/
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

% códigos das peças na list
code(0, ' ').
code(1, 'X').
code(2, '+').

% rows do tabuleiro codificadas
row(0, R) :- R='A'.
row(1, R) :- R='B'.
row(2, R) :- R='C'.
row(3, R) :- R='D'.
row(4, R) :- R='E'.
row(5, R) :- R='F'.
row(6, R) :- R='G'.
row(7, R) :- R='H'.

% quando o contador chegar a 8 significa que acabou
print_matrix([], 8).
print_matrix([L|T], N) :-
  row(N, R), write(' '), write(R), write(' | '),
  N1 is N + 1,
  print_line(L), nl,
  write('---|---|---|---|---|---|---|---|---|\n'),
  print_matrix(T, N1).

print_line([]).
print_line([C|L]) :-
  code(C, P), write(P), write(' | '),
  print_line(L).

display_game(Board, Player) :-
  % cabeçalho do tabuleiro
  nl,
  write('   | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |\n'),
  write('---|---|---|---|---|---|---|---|---|\n'),
  print_matrix(Board, 0).

% testar display:
% ?- initial_board(_B), print_board(_B).
