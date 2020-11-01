% Predicate to select a piece location
select_spot(GameState, Player) :-
  read_column(Column),
  check_column(Column, CheckedColumn),
  read_row(Row),
  check_row(Row, CheckedRow)
  % validate_choice(Column, Row),
  % make_choice(GameState, Column, Row, FinalGameState),
  % GameState is FinalGameState
  .

% predicate to read column from user
read_column(Column) :-
  write('Column (0-7) - '),
  read(Column).

% predicate to read row from user
read_row(Row) :-
  write('Row (A-H) - '),
  read(Row).

% checking columns
check_column(0, CheckedColumn) :-
  CheckedColumn = 0.
check_column(1, CheckedColumn) :-
  CheckedColumn = 1.
check_column(2, CheckedColumn) :-
  CheckedColumn = 2.
check_column(3, CheckedColumn) :-
  CheckedColumn = 3.
check_column(4, CheckedColumn) :-
  CheckedColumn = 4.
check_column(5, CheckedColumn) :-
  CheckedColumn = 5.
check_column(6, CheckedColumn) :-
  CheckedColumn = 6.
check_column(7, CheckedColumn) :-
  CheckedColumn = 7.
% if not between 0-7 then try again
check_column(_, CheckedColumn) :-
  write('Invalid column\nSelect again\n'),
  read_column(Column),
  check_column(Column, CheckedColumn).

% checking rows
check_row('A', CheckedRow) :-
  CheckedColumn = 'A'.
check_row('B', CheckedRow) :-
  CheckedColumn = 'B'.
check_row('C', CheckedRow) :-
  CheckedColumn = 'C'.
check_row('D', CheckedRow) :-
  CheckedColumn = 'D'.
check_row('E', CheckedRow) :-
  CheckedColumn = 'E'.
check_row('F', CheckedRow) :-
  CheckedColumn = 'F'.
check_row('G', CheckedRow) :-
  CheckedColumn = 'G'.
check_row('H', CheckedRow) :-
  CheckedColumn = 'H'.
% if not between A-H then try again
check_row(_, CheckedRow) :-
  write('Invalid row\nSelect again\n'),
  read_row(Row),
  check_row(Row, CheckedRow).
