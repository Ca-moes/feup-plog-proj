% Predicate to select a piece location
select_spot(GameState, Player) :-
  size_of_board(GameState, Size),
  read_column(Column, Size),
  check_column(Column, CheckedColumn, Size),
  read_row(Row, Size),
  check_row(Row, CheckedRow, Size)
  % validate_choice(Column, Row),
  % make_choice(GameState, Column, Row, FinalGameState),
  % GameState is FinalGameState
  .

% predicate to read column from user
read_column(Column, Size) :-
  write('Column (0-'), format('~d', Size-1), write(') - '),
  read(Column).

% predicate to read row from user
read_row(Row, Size) :-
  Size1 is Size-1,
  row(Size1, Letter),
  write('Row (A-'),write(Letter),write(') - '),
  read(Row).

% checking columns
check_column(Testing, CheckedColumn, Size) :-
  Testing < Size, Testing >= 0, !, CheckedColumn = Testing. % acho que não precisa de !, deixa estar

% if not between 0-7 then try again
check_column(_, CheckedColumn, Size) :-
  write('Invalid column\nSelect again\n'),
  read_column(Column, Size),
  check_column(Column, CheckedColumn, Size).

% checking rows
check_row(Rowread, CheckedRow, Size) :-
  row(RowNumb, Rowread), RowNumb < Size, RowNumb >= 0, !, CheckedRow = Rowread.

% if not between A-H then try again
check_row(_, CheckedRow, Size) :-
  write('Invalid row\nSelect again\n'),
  read_row(Row),
  check_row(Row, CheckedRow, Size).
