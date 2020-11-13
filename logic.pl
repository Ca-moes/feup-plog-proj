% After the input is processed correctly, the game logic is made here
direction(1, 'up').
direction(2, 'right').
direction(3, 'down').
direction(4, 'left').

% Predicate to select a piece location
move(GameState, Player) :-
    size_of_board(GameState, Size),
    choose_piece(GameState, Size, Player, X, Y),
    format('selected spot: X : ~d -- Y : ~w \n', [X,Y]).
    %read_direction(X, Y, Direction).
    % make_choice(GameState, Column, Row, FinalGameState),
    % GameState is FinalGameState
    
choose_piece(Board, Size, Player, X, Y):-
    read_inputs(Size, Xread, Yread),
    validate_choice(Board, Xread, Yread, Player, X, Y).

% check if selected piece belongs to player
validate_choice(Board, Xread, Yread, Player, X, Y):-
    row(NumbY, Y),
    value_in_board(Board, Xread, NumbY, Value),
    player_piece(Player, Piece),
    Piece == Value,
    X = Xread, Y = Yread,
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
    value_in_board(Board, X, Y, Value).

% Code takes opposed player code
opposed_opponent_code(Player, Code):-
    player_piece(Player, Piece),
    Code = -Piece.

% Checks if there's a enemy piece in position
check_dir(Board, X, Y, Player, Direction):-
    size_of_board(Board, Size),
    % OU para aceder a uma direção
    (direction(1, Direction) , Y > 0);
    (direction(2, Direction) , X < Size);
    (direction(3, Direction) , Y < Size);
    (direction(4, Direction) , X > 0).

