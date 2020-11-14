% After the input is processed correctly, the game logic is made here
direction(1, 'up').
direction(2, 'right').
direction(3, 'down').
direction(4, 'left').

% Predicate to select a piece location
move(GameState, Player) :-
    size_of_board(GameState, Size),
    choose_piece(GameState, Size, Player, X, Y),
    format('selected spot: X : ~d -- Y : ~w \n', [X,Y]),
    available_dirs(GameState, X, Y, Player, List),
    write(List).
    %read_direction(X, Y, Direction).
    % make_choice(GameState, Column, Row, FinalGameState),
    % GameState is FinalGameState
    
choose_piece(Board, Size, Player, X, Y):-
    read_inputs(Size, Xread, Yread),
    validate_choice(Board, Xread, Yread, Player, X, Y).

% check if selected piece belongs to player
validate_choice(Board, Xread, Yread, Player, X, Y):-
    row(NumbY, Yread),
    value_in_board(Board, Xread, NumbY, Value),
    player_piece(Player, Piece),
    Piece == Value,
    X = Xread, Y = NumbY,
    write('Chose correct coordenates\n').
validate_choice(Board, _, _, Player, X, Y):-
    write('--Wrong Cell, try again\n'),
    size_of_board(Board, Size),
    skip_line,
    read_inputs(Size, Xread, Yread),
    validate_choice(Board, Xread, Yread, Player, X, Y).

% returns in Value  the value [0,1,2] at (X,Y) from Board
value_in_board(Board, X, Y, Value):-
    nth0(Y, Board, Row),
    nth0(X, Row, Value).

% returns in Player a string representing the player or fails if space is empty.
player_in_board(Board, X, Y, Player):-
    value_in_board(Board, X, Y, Value),
    player_piece(Player, Value).
        
% returns in Lists the numbers of the directions available to go
available_dirs(Board, X, Y, Player, List):-
    %vai ter de verificar todas as direções
    check_dir(Board, X, Y, Player, 'up', ListItem1), append([], ListItem1, PreList1),
    check_dir(Board, X, Y, Player, 'right', ListItem2), append(PreList1, ListItem2, PreList2),
    check_dir(Board, X, Y, Player, 'down', ListItem3), append(PreList2, ListItem3, PreList3),
    check_dir(Board, X, Y, Player, 'left', ListItem4), append(PreList3, ListItem4, List).
    

% Checks if there's a enemy piece Direction of position
check_dir(Board, X, Y, Player, Direction, Result):-
    size_of_board(Board, Size),
    opposed_opponent_code(Player, Code),
    % OU para aceder a uma direção
    ((direction(1, Direction) , Y > 0, Y1 is Y-1, value_in_board(Board, X, Y1, Value), Value==Code, Result = [Direction]);
    (direction(2, Direction) , X < Size, X1 is X+1, value_in_board(Board, X1, Y, Value), Value==Code, Result = [Direction]);
    (direction(3, Direction) , Y < Size, Y2 is Y+1, value_in_board(Board, X, Y2, Value), Value==Code, Result = [Direction]);
    (direction(4, Direction) , X > 0, X2 is X-1, value_in_board(Board, X2, Y, Value), Value==Code, Result = [Direction]);
    Result = []).

