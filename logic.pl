% After the input is processed correctly, the game logic is made here

% directiosn knowledge
direction(1, 'up').
direction(2, 'right').
direction(3, 'down').
direction(4, 'left').

% get position in direction, doesn't check range, can get out of board
% Not beeing used
direction(X, Y, 'up', Xr, Yr):-     Xr = X,     Yr is Y-1.
direction(X, Y, 'right', Xr, Yr):-  Xr is X+1,  Yr = Y.
direction(X, Y, 'down', Xr, Yr):-   Xr = X,     Yr is Y+1.
direction(X, Y, 'left', Xr, Yr):-   Xr is X-1,  Yr = Y.


% Predicate to select move a piece
move(GameState, PlayerS, NewGameState) :-
    choose_piece(GameState, PlayerS, X, Y, Directions),
    format('- Selected spot: X : ~d -- Y : ~w \n', [X,Y]),
    read_direction(Directions, Direction),
    format('- Direction received in logic : ~s\n', Direction),
    make_choice(GameState, PlayerS, X, Y, Direction, NewGameState).
    
choose_piece(Board, PlayerS, X, Y, Directions):-
    size_of_board(Board, Size),
    read_inputs(Size, Xread, Yread),
    validate_choice(Board, Xread, Yread, PlayerS, Xtemp, Ytemp),
    available_dirs(Board, Xtemp, Ytemp, PlayerS, List),
    (
        (
            List \== [],
            write('- There are plays available for that spot\n'),
            X is Xtemp, Y is Ytemp, Directions = List
        ) ;
        (
            write('# No plays available for that piece, choose another\n'),
            skip_line,
            choose_piece(Board, PlayerS, X1, Y1, Directions1),
            X is X1, Y is Y1, Directions = Directions1
        )
    ).

% check if selected piece belongs to player
validate_choice(Board, Xread, Yread, PlayerS, X, Y):-
    row(NumbY, Yread),
    value_in_board(Board, Xread, NumbY, Value),
    player_piece(PlayerS, Piece),
    Piece == Value,
    X = Xread, Y = NumbY,
    write('- Chose Spot belonging to player\n').
validate_choice(Board, _, _, PlayerS, X, Y):-
    write('--Unavailable piece, try again\n'),
    size_of_board(Board, Size),
    skip_line,
    read_inputs(Size, Xread, Yread),
    validate_choice(Board, Xread, Yread, PlayerS, X, Y).

% returns in Value  the value [0,1,-1] at (X,Y) from Board
value_in_board(Board, X, Y, Value):-
    nth0(Y, Board, Row),
    nth0(X, Row, Value).

% returns in Player a string representing the player or fails if space is empty.
player_in_board(Board, X, Y, PlayerS):-
    value_in_board(Board, X, Y, Value),
    player_piece(PlayerS, Value).
        
% returns in Lists the numbers of the directions available to go
available_dirs(Board, X, Y, PlayerS, List):-
    %vai ter de verificar todas as direções
    check_dir(Board, X, Y, PlayerS, 'up', ListItem1), append([], ListItem1, PreList1),
    check_dir(Board, X, Y, PlayerS, 'right', ListItem2), append(PreList1, ListItem2, PreList2),
    check_dir(Board, X, Y, PlayerS, 'down', ListItem3), append(PreList2, ListItem3, PreList3),
    check_dir(Board, X, Y, PlayerS, 'left', ListItem4), append(PreList3, ListItem4, List).
    

% Checks if there's a enemy piece Direction of position
check_dir(Board, X, Y, PlayerS, Direction, Result):-
    size_of_board(Board, Size),
    opposed_opponent_code(PlayerS, OpponentCode),
    % OU para aceder a uma direção
    ((direction(1, Direction) , Y > 0, Y1 is Y-1, value_in_board(Board, X, Y1, Value), Value==OpponentCode, Result = [Direction]);
    (direction(2, Direction) , X < Size, X1 is X+1, value_in_board(Board, X1, Y, Value), Value==OpponentCode, Result = [Direction]);
    (direction(3, Direction) , Y < Size, Y2 is Y+1, value_in_board(Board, X, Y2, Value), Value==OpponentCode, Result = [Direction]);
    (direction(4, Direction) , X > 0, X2 is X-1, value_in_board(Board, X2, Y, Value), Value==OpponentCode, Result = [Direction]);
    Result = []).


replace_index(I, L, E, K) :-
    nth0(I, L, _, R),
    nth0(I, K, E, R).

replace(Board, X, Y, Value, BoardResult):-
    %usar substitute(+X, +Xlist, +Y, ?Ylist)
    nth0(Y, Board, Row),
    replace_index(X, Row, Value, NewRow),
    replace_index(Y, Board, NewRow, BoardResult).
    
make_choice(Board, PlayerS, X, Y, Direction, FinalBoard):-
    % X Y fica a branco
    replace(Board, X, Y, 0, Board1),
    % Direção fica com peça de player
    direction(X, Y, Direction, X1, Y1),
    player_piece(PlayerS, Code),
    replace(Board1, X1, Y1, Code, FinalBoard).


/* predicate to check if game as reached its final state */    
check_final_state(GameState, PlayerS, X, Y):-
    size_of_board(GameState, Length),
    value_in_board(GameState, X, Y, Value),
    ((
        Value \== 0,
        check_no_neighbors(GameState, PlayerS, X, Y),
        next_index(X, Y, Length, X2, Y2)
    ) ; 
    (
        next_index(X, Y, Length, X2, Y2)
    )),
    check_end(X, Y, Length, End),
    (
        (End is 1) ; (End \== 1, check_final_state(GameState, PlayerS, X2, Y2))
    ).


next_index(X, Y, Length, X2, Y2):-
    X1 is X + 1,
    ((
        X1 \== Length,
        X2 is X1, 
        Y2 is Y
    ) ;
    (
        X1 == Length, 
        X2 is 0, 
        Y2 is Y + 1
    )).

check_end(X, Y, Length, End):-
    ((
        X is (Length - 1),
        Y is (Length - 1),
        End is 1
    ) ;
    (
        X \== (Length - 1),
        Y \== (Length - 1),
        End is 0
    )).
    

check_no_neighbors(Board, PlayerS, X, Y):-
    available_dirs(Board, X, Y, PlayerS, Moves),
    Moves == [].


remove(GameState, PlayerS, NewGameState) :-
    write('- There are no pieces to replace, select one piece to remove.\n'),
    size_of_board(GameState, Size),
    read_inputs(Size, Xread, Yread),
    validate_choice(GameState, Xread, Yread, PlayerS, Xtemp, Ytemp),
    format('- Selected spot: X : ~d -- Y : ~w \n', [Xread,Yread]),
    replace(GameState, Xtemp, Ytemp, 0, NewGameState).