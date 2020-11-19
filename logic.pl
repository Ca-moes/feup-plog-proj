% After the input is processed correctly, the game logic is made here

% directions knowledge
direction(1, 'up').
direction(2, 'right').
direction(3, 'down').
direction(4, 'left').

% get position in direction, doesn't check range, can get out of board
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
    
% predicate to read input, check if piece belongs to player, gwt available directions and return
choose_piece(Board, PlayerS, X, Y, Directions):-
    size_of_board(Board, Size),
    read_inputs(Size, Xread, Yread),
    validate_choice(Board, Xread, Yread, PlayerS, Xtemp, Ytemp),
    available_dirs(Board, Xtemp, Ytemp, PlayerS, List),
    List \== [],
    write('- There are plays available for that spot\n'),
    X is Xtemp, Y is Ytemp, Directions = List.
% in case there are no available directions, choose_piece again
% doesn't enter here, instead goes back to validate_choice when there aro no directions
choose_piece(Board, PlayerS, X, Y, Directions):-
    write('# No plays available for that piece, choose another\n'),
    skip_line,
    choose_piece(Board, PlayerS, X, Y, Directions).

     
% check if selected piece belongs to player
validate_choice(Board, Xread, Yread, PlayerS, X, Y):-
    row(NumbY, Yread),
    value_in_board(Board, Xread, NumbY, Value),
    player_piece(PlayerS, Piece),
    Piece == Value,
    X = Xread, Y = NumbY,
    write('- Chose Spot belonging to player\n').
% if the selected piece doesnt belong to the player, asks again
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
    %needs to check all 4 directions
    check_dir(Board, X, Y, PlayerS, 'up', ListItem1), append([], ListItem1, PreList1),
    check_dir(Board, X, Y, PlayerS, 'right', ListItem2), append(PreList1, ListItem2, PreList2),
    check_dir(Board, X, Y, PlayerS, 'down', ListItem3), append(PreList2, ListItem3, PreList3),
    check_dir(Board, X, Y, PlayerS, 'left', ListItem4), append(PreList3, ListItem4, List), !.

% Checks if there is an enemy piece on the 'up' direction
check_dir(Board, X, Y, PlayerS, 'up', ['up']):-
    opposed_opponent_code(PlayerS, ExpectedCode),
    Y > 0, Y1 is Y-1, value_in_board(Board, X, Y1, Value), Value==ExpectedCode.
% Checks if there is an enemy piece on the 'right' direction
check_dir(Board, X, Y, PlayerS, 'right', ['right']):-
    size_of_board(Board, Size),
    opposed_opponent_code(PlayerS, ExpectedCode),
    X < Size, X1 is X+1, value_in_board(Board, X1, Y, Value), Value==ExpectedCode.
% Checks if there is an enemy piece on the 'down' direction
check_dir(Board, X, Y, PlayerS, 'down', ['down']):-
    size_of_board(Board, Size),
    opposed_opponent_code(PlayerS, ExpectedCode),
    Y < Size, Y2 is Y+1, value_in_board(Board, X, Y2, Value), Value==ExpectedCode.
% Checks if there is an enemy piece on the 'left' direction
check_dir(Board, X, Y, PlayerS, 'left', ['left']):-
    opposed_opponent_code(PlayerS, ExpectedCode),
    X > 0, X2 is X-1, value_in_board(Board, X2, Y, Value), Value==ExpectedCode.
% returns a empty list in case of a wrong direction
check_dir(_, _, _, _, _, []).

% replaces Element E in List L at Index I, Resulting in List K
replace_index(I, L, E, K) :-
    nth0(I, L, _, R),
    nth0(I, K, E, R).

% replaces a value in the board
replace(Board, X, Y, Value, BoardResult):-
    %usar substitute(+X, +Xlist, +Y, ?Ylist)
    nth0(Y, Board, Row),
    replace_index(X, Row, Value, NewRow),
    replace_index(Y, Board, NewRow, BoardResult).

%  performs the change in the board, replaces current piece with 0 and enemy piece with player code
make_choice(Board, PlayerS, X, Y, Direction, FinalBoard):-
    replace(Board, X, Y, 0, Board1),
    direction(X, Y, Direction, X1, Y1),
    player_piece(PlayerS, Code),
    replace(Board1, X1, Y1, Code, FinalBoard).

/* predicate to check if game as reached its final state */ 
% if check_no_neightbors returs 0, ends predicate   
check_final_state(GameState, PlayerS, X, Y):-
    value_in_board(GameState, X, Y, Value),
    check_no_neighbors(GameState, PlayerS, X, Y, Value, 0), !, fail.
% check_no_neighbors returned 1, there are not directions available, checking if reached end of board
% if reached end of board, then returns, else fails and continues to next predicate
check_final_state(GameState, _, X, Y):-
    size_of_board(GameState, Length),
    check_end(X, Y, Length, 1).
% checks if next position has directions available
check_final_state(GameState, PlayerS, X, Y):-
    size_of_board(GameState, Length),
    next_index(X, Y, Length, X2, Y2),
    check_final_state(GameState, PlayerS, X2, Y2).

% gets next index and verifies if reached end of Row, in that case switched to next row
next_index(X, Y, Length, X2, Y2):-
    X1 is X + 1,
    X1 \== Length,
    X2 is X1, 
    Y2 is Y.
next_index(X, Y, Length, X2, Y2):-
    X1 is X + 1,
    X1 == Length, 
    X2 is 0,
    Y2 is Y + 1.

% used before calling next_index to check if current position is the last in the board
check_end(X, Y, Length, 1):-
    X is (Length - 1),
    Y is (Length - 1).
check_end(X, Y, Length, 0):-
    X \== (Length - 1),
    Y \== (Length - 1).

% checks if there are directions available, if the list is empty goes to next predicate, else return is 0
check_no_neighbors(Board, PlayerS, X, Y, Value, 0):-
    player_piece(PlayerS, Value),
    available_dirs(Board, X, Y, PlayerS, [_]).
% if list of directions is empty, returns 1
check_no_neighbors(Board, PlayerS, X, Y, Value, 1):-
    player_piece(PlayerS, Value),
    available_dirs(Board, X, Y, PlayerS, []).
% if the player piece is different from the value on the board, no need to check for directions
check_no_neighbors(_, _, _, _, _, 1).

% instead of moving a pice and captuing a enemy piece, a player piece is removed because there aren't any available plays
remove(GameState, PlayerS, NewGameState) :-
    write('- There are no pieces to replace, select one piece to remove.\n'),
    size_of_board(GameState, Size),
    read_inputs(Size, Xread, Yread),
    validate_choice(GameState, Xread, Yread, PlayerS, Xtemp, Ytemp),
    format('- Selected spot: X : ~d -- Y : ~w \n', [Xread,Yread]),
    replace(GameState, Xtemp, Ytemp, 0, NewGameState).