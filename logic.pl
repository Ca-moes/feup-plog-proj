% After the input is processed correctly, the game logic is made here

% Predicate to select a piece location
select_spot(GameState, Player) :-
    size_of_board(GameState, Size),
    read_inputs(Size, Xread, Yread),
    validate_choice(GameState, Xread, Yread, Player, X, Y),
    format('select spot: X : ~d -- Y : ~w \n', [X,Y]).
    %read_direction(X, Y, Direction).
    % make_choice(GameState, Column, Row, FinalGameState),
    % GameState is FinalGameState
    
% check if selected piece belongs to player
validate_choice(Board, Xread, Yread, Player, X, Y):-
    row(NumbY, Y),
    value_in_board(Board, Xread, NumbY, Value),
    player_piece(Player, Piece),
    Piece == Value,
    X = Xread, Y = Yread,
    write('Chose correct coordenates\n').
validate_choice(Board, Xread, Yread, Player, X, Y):-
    write('--Wrong Cell, try again\n'),
    size_of_board(Board, Size),
    skip_line,
    read_inputs(Size, X1, Y1),
    format('validate choice: X : ~d -- Y : ~w \n', [X1,Y1]),
    validate_choice(Board, X1, Y1, Player, X, Y).



% retorns in Value  the value [0,1,2] at (X,Y) from Board
value_in_board(Board, X, Y, Value):-
    nth0(Y, Board, Row),
    nth0(X, Row, Value).
        

