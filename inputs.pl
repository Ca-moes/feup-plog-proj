code_number(48, 0).
code_number(49, 1).
code_number(50, 2).
code_number(51, 3).
code_number(52, 4).
code_number(53, 5).
code_number(54, 6).
code_number(55, 7).
code_number(56, 8).
code_number(57, 9).

% Predicate to select a piece location
select_spot(GameState, Player) :-
  size_of_board(GameState, Size),
  read_column(Column, Size),
  check_column(Column, CheckedColumn, Size),
  format('Column read :~d\n', CheckedColumn),
  read_row(Row, Size),
  check_row(Row, CheckedRow, Size),
  format('Row read :~w\n', CheckedRow)
  % validate_choice(Column, Row),
  % make_choice(GameState, Column, Row, FinalGameState),
  % GameState is FinalGameState
  .

% predicate to read column from user
read_column(Column, Size) :-
  write('Column (0-'), format('~d', Size-1), write(') - '),
  get_code(Column).
  %read(Column).

% predicate to read row from user
read_row(Row, Size) :-
  Size1 is Size-1,
  row(Size1, Letter),
  write('Row (A-'),write(Letter),write(') - '),
/*   skip_line,
 */  get_char(Row).

% checking columns
check_column(Testing, CheckedColumn, Size) :-
  peek_char(Char),
  Char == '\n',
  code_number(Testing, Number),
  Number < Size, Number >= 0, CheckedColumn = Number, skip_line.

% if not between 0-7 then try again
check_column(_, CheckedColumn, Size) :-
  write('Invalid column\nSelect again\n'),
  skip_line,
  read_column(Column, Size),
  check_column(Column, CheckedColumn, Size).

% checking rows
check_row(Rowread, CheckedRow, Size) :-
  (row(RowNumb, Rowread) ; row_lower(RowNumb, Rowread)), RowNumb < Size, RowNumb >= 0, 
  row(RowNumb, RowreadUpper), % caso lê minuscula, vai buscar maiuscula
  CheckedRow = RowreadUpper.

% if not between A-H then try again
check_row(_, CheckedRow, Size) :-
  write('Invalid row\nSelect again\n'),
  skip_line,
  read_row(Row, Size),
  check_row(Row, CheckedRow, Size).
