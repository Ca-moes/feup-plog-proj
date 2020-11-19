% ASCII code and respective decimal number
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

% Read a Column and Row according to Size (of Board)
read_inputs(Size, X, Y):-
  read_column(Column, Size),
  check_column(Column, X, Size),
  format(': Column read :  ~d\n', X),
  read_row(Row, Size),
  check_row(Row, Y, Size),
  format(': Row read :     ~w\n', Y).


% predicate to read column from user
read_column(Column, Size) :-
  write('| Column (0-'), format('~d', Size-1), write(') - '),
  get_code(Column).

% Checks if input is a valid column
check_column(Testing, CheckedColumn, Size) :-
  peek_char(Char),
  Char == '\n',
  code_number(Testing, Number),
  Number < Size, Number >= 0, CheckedColumn = Number, skip_line.
% if not between 0-x then try again
check_column(_, CheckedColumn, Size) :-
  write('~ Invalid column\n| Select again\n'),
  skip_line,
  read_column(Column, Size),
  check_column(Column, CheckedColumn, Size).

% predicate to read row from user
read_row(Row, Size) :-
  Size1 is Size-1,
  row(Size1, Letter),
  write('| Row (A-'),write(Letter),write(') -    '),
  get_char(Row).

% checking rows
check_row(Rowread, CheckedRow, Size) :-
  (row(RowNumb, Rowread) ; row_lower(RowNumb, Rowread)), RowNumb < Size, RowNumb >= 0, 
  row(RowNumb, RowreadUpper), % caso lê minuscula, vai buscar maiuscula
  CheckedRow = RowreadUpper.
% if not between A-y then try again
check_row(_, CheckedRow, Size) :-
  write('~ Invalid row\n| Select again\n'),
  skip_line,
  read_row(Row, Size),
  check_row(Row, CheckedRow, Size).

% newline after printing directions
print_directions([]):-
  nl.
% prints the available directions
print_directions([Dir|Rest]):-
  direction(Number, Dir),
  format(" ~d - ~w |", [Number, Dir]),
  print_directions(Rest).
  
% prints avaialble directions, reads input and processes it
read_direction(List, DirSelected):-
  write('| Select Direction (number) to move to\n|'),
  print_directions(List), skip_line,
  get_code(CodeRead),
  check_direction_input(List, CodeRead, NumberRead),
  write('- Read valid direction (1-4)\n'), 
  check_direction(List, NumberRead, DirSelected),
  DirSelected \== ''.
  
%checks if input is between 1 and 4
check_direction_input(_, CharRead, Number):-
  peek_char(Char),
  Char == '\n',
  code_number(CharRead, Number),
  Number < 5, Number > 0.
% if there's bad input, a message is printed and asks again for input
check_direction_input(List, _, Number):-
  write('~ Invalid Number. Select again\n'),
  write('| Select Direction (number) to move to\n|'),
  print_directions(List), skip_line,
  get_code(CodeRead),
  check_direction_input(List, CodeRead, NumberRead),
  Number = NumberRead.

% check if number read is equal to one of the directions available
check_direction([Dir|_], NumberRead, Dir):-
  direction(NumberRead, Dir).
% checks next direction available
check_direction([_|Rest], NumberRead, Direction):-
  check_direction(Rest, NumberRead, Direction).
% if there are no more available directions, then returns ''
check_direction([], _, ''):-
  write('~ Not an available direction, choose correctly!\n').

