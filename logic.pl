% After the input is processed correctly, the game logic is made here

% check if selected piece belongs to player
validate_choice(Board, X, Y, Player):-
    row(NumbY, Y),
    value_in_board(Board, X, NumbY, Value),
    player_piece(Player, Piece),
    Piece == Value, write('Chose correct coordenates').
validate_choice(Board, _, _, Player):-
    write('Wrong Cell, try again\n'),
    size_of_board(Board, Size),
    read_inputs(Size, X, Y),
    validate_choice(Board, X, Y, Player).



% retorns in Value  the value [0,1,2] at (X,Y) from Board
value_in_board(Board, X, Y, Value):-
    nth0(Y, Board, Row),
    nth0(X, Row, Value).
        
    
