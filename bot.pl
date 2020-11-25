% make_move(+Difficulty, +GameState, +Player, -NewGameState)
% Player Predicate move belongs to logic.pl but needs to be together with the bot predicate
make_move('Player', GameState, PlayerS, NewGameState) :-
  choose_piece(GameState, PlayerS, X, Y, Directions),
  format('- Selected spot: X : ~d -- Y : ~w \n', [X,Y]),
  read_direction(Directions, Direction),
  format('- Direction received in logic : ~s\n', Direction),
  move(GameState, X-Y-Direction, NewGameState), skip_line.
% Given the bot Difficulty, chooses a move, performs the move and returns the NewGameState
make_move(Difficulty, GameState, Player, NewGameState):-
  choose_move(GameState, Player, Difficulty, X-Y-Direction),
  row(Y, Letter), format("I'll move from X:~d Y:~s to the ~s Direction\n", [X, Letter, Direction]),
  sleep(1),
  move(GameState, X-Y-Direction, NewGameState).

% remove(+Difficulty, +GameState, +Player, -NewGameState)
% Player Predicate remove belongs to logic.pl but need to be together with the bot predicate
% instead of moving a piece and captuing a enemy piece, a player piece is removed because there aren't any available plays
remove('Player', GameState, PlayerS, NewGameState) :-
  write('- There are no pieces to replace, select one piece to remove.\n'),
  size_of_board(GameState, Size),
  read_inputs(Size, Xread, Yread),
  validate_choice(GameState, Xread, Yread, PlayerS, Xtemp, Ytemp),
  format('- Selected spot: X : ~d -- Y : ~w \n', [Xread,Yread]),
  replace(GameState, Xtemp, Ytemp, 0, NewGameState), skip_line.
% The bot chooses a remove, performs the remove and returns the NewGameState
remove(Difficulty, GameState, Player, NewGameState):-
  choose_remove(GameState, Player, Difficulty, X-Y),
  row(Y, Letter), format("I'll remove my piece from X:~d Y:~s\n", [X, Letter]),
  sleep(1),
  replace(GameState, X, Y, 0, NewGameState).

% choose_move(+GameState, +Player, +Level, -Move)
% Returns a Move after evaluating all the GameStates possible caused by all the available moves
% For the Easy Difficulty the move is chosen randomly
choose_move(GameState, Player, 'Easy', X-Y-Direction):-
  valid_moves(GameState, Player, List),
  random_member(Value, List),
  nth0(0, Value, X),
  nth0(1, Value, Y),
  nth0(2, Value, Direction).
% For the Normal Difficulty the move is chosen according to the value predicate
choose_move(GameState, Player, 'Normal', X-Y-Direction):-  
  valid_moves(GameState, Player, List),
  findall(
    Value1-X1-Y1-Direction1-Index,
    (
      nth0(Index, List, SubList), 
      nth0(0, SubList, X1),
      nth0(1, SubList, Y1),
      nth0(2, SubList, Direction1),
      move(GameState, X1-Y1-Direction1, NewGameState),
      value(NewGameState, Player, Value1)
    ),
    ListResults
    ),
  sort(ListResults, Sorted), 
  reverse(Sorted, [_-X-Y-Direction-_|_]).
% choose_remove(+GameState, +Player, +Level, -Move)
% Returns a Remove after evaluating all the GameStates possible caused by all the available removes
% For the Easy Difficulty the remove is chosen randomly
choose_remove(GameState, Player, 'Easy', X-Y):-
  valid_removes(GameState, Player, List),
  random_member(Value, List),
  nth0(0, Value, X),
  nth0(1, Value, Y).
% For the Normal Difficulty the remove is chosen according to the value predicate
choose_remove(GameState, Player, 'Normal', X-Y):-
  valid_removes(GameState, Player, List),
  findall(
    Value1-X1-Y1-Index,
    (
      nth0(Index, List, SubList), 
      nth0(0, SubList, X1),
      nth0(1, SubList, Y1),
      replace(GameState, X1, Y1, 0, NewGameState),
      value(NewGameState, Player, Value1)
    ),
    ListResults
    ),
  sort(ListResults, Sorted), 
  reverse(Sorted, [_-X-Y-_|_]).

% value(+GameState, +Player, -Value)
% For the Player 2, we can use the value function for the Player 1, given as the argument the transposed matrix
value(GameState, 'Player 2', Value):-
  transpose(GameState, Transpose),
  value(Transpose, 'Player 1', Value).
% In-Depth explanation : https://github.com/Ca-moes/feup-plog-proj/issues/19
value(GameState, 'Player 1', Value):-
  value_part_1(GameState, List),
  value_part_2(GameState, List, ReturnList),
  max_member(Value, ReturnList), !.
  
% value_part_1(+GameState, -List)
% Returns a List containing Positions to FloodFill, starts to analyze at position (0,0)
value_part_1(GameState, List):-
  value_part_1(GameState, 0, 0, List).
% if it's the last cell and its empty, neither the top nor left cell are empty, meaning list has a value.
% No need to do floodfill cause there's only 1 cell to fill
value_part_1(GameState, X, Y, [Size1-Size1]):-
  size_of_board(GameState, Size), check_end(X, Y, Size),
  value_in_board(GameState, X, Y, 0),
  Size1 is Size-1.
% if it's the last cell and it's not empty, returns list as empty
value_part_1(GameState, X, Y, []):-
  size_of_board(GameState, Size), check_end(X, Y, Size).
% if searh is not at end and value of cell is 0, saves the position to append to the result and goes to next position
value_part_1(GameState, X, Y, List):-
  value_in_board(GameState, X, Y, 0), 
  size_of_board(GameState, Size),
  floodFill(GameState, Size, X, Y, 0, 9, NewGS),
  next_index(X, Y, Size, X2, Y2),
  value_part_1(NewGS, X2, Y2, Result),
  append(Result, [X-Y], List).
% if searh is not at end and value is != 0, goes to next position
value_part_1(GameState, X, Y, List):-
  size_of_board(GameState, Size),
  next_index(X, Y, Size, X2, Y2),
  value_part_1(GameState, X2, Y2, List).

% value_part_2(+GameState, +List, -ReturnList)
% Base Case: No more Positions to analyze
value_part_2(_, [], []).
% Gets a position to floodFill, the amount of fill characters per column in a list, the value of the patch and calls itself with the next position
value_part_2(GameState, [X-Y|Rest], ReturnList):-
  attemp_flood_fill(GameState, X, Y, NewGS),
  values_in_all_columns(NewGS, 9, ListResult),
  sequence(ListResult, TempValue),
  value_part_2(GameState, Rest, TempReturnList),
  append(TempReturnList, [TempValue], ReturnList).

% values_in_all_columns(+GameState, +Value, -ListResult)
% with a Board and a value returns a list (eg. [4,3,4,3,0,0]) with amount of characters Value in all Columns
% Starts at the end of the board with Index Size-1
values_in_all_columns(GameState, Value, ListResult):-
  size_of_board(GameState, Size), Size1 is Size-1,
  values_in_all_columns(GameState, Value, Size1, ListResult).
% values_in_all_columns(+GameState, +Value, +Index, -ListResult)
% Base Case: When Index reaches -1 returns a empty List to be appended with results.
values_in_all_columns(_, _, -1, []).
% Gets the amount of one columns ans goes to next column.
values_in_all_columns(GameState, Value, Index, Result):-
  values_in_column(GameState, Index, Value, ValueResult),
  Index1 is Index-1,
  values_in_all_columns(GameState, Value, Index1, TempResult),
  append(TempResult, [ValueResult], Result).

% values_in_column(+GameState, +X, +Value, -Amount)
% returns the Amount of cells with Value in column X
values_in_column(GameState, X, Value, Amount):-
  get_column(GameState, X, Column),
  count(Value, Column, Amount).

% sequence(+List, -Result)
% Given a List finds the biggest sequence formed by numbers diferent from 0, starts with Counter 0 and MaxLenght 0
sequence(List, Result):-
  sequence(List, 0, 0, Result).
% sequence(+List, +Counter, +MaxLength, -Result)
% Base Case: If there's no more numbers to process and Counter is bigger than MaxLenght, returns Counter
sequence([], Counter, MaxLength, Counter):-
  Counter > MaxLength.
% Base Case: If there's no more numbers to process and MaxLenght is bigger than Counter, returns MaxLength
sequence([], _, MaxLength, MaxLength).
% If the number is zero and the current sequence is bigger than the one so far, then MaxLength takes the Counter value
sequence([ToTest|Rest], Counter, MaxLength, Result):-
  ToTest == 0, Counter > MaxLength, 
  sequence(Rest, 0, Counter, Result).
% If the number is zero and the current sequence isn't bigger than the one so far, then MaxLength keeps the same value
sequence([ToTest|Rest], _, MaxLength, Result):-
  ToTest == 0, 
  sequence(Rest, 0, MaxLength, Result).
% if the number is not 0, increments Counter by 1
sequence([_|Rest], Counter, MaxLength, Result):-
  Counter1 is Counter+1,
  sequence(Rest, Counter1, MaxLength, Result).


% valid_removes(+GameState, +PlayerS, -List)
% will check the removes for every spot, starting ar 0,0
valid_removes(GameState, PlayerS, List):-
  check_spot_remove(GameState, 0, 0, PlayerS, List).

% check_spot_remove(+GameState, +X, +Y, +Player, -ReturnList)
% if check_end returns true, then Returns a empty List to be appended
check_spot_remove(GameState, X, Y, _, []):-
  size_of_board(GameState, Size),
  check_end(X, Y, Size).
% if not at the end, and the player in board is the current player, then saves spot and calls itself with next position
check_spot_remove(GameState, X, Y, Player, ReturnList):-
  player_in_board(GameState, X, Y, Player),
  size_of_board(GameState, Size),
  next_index(X, Y, Size, X1, Y1),
  check_spot_remove(GameState, X1, Y1, Player, TempReturnList),
  append(TempReturnList, [[X, Y]], ReturnList).
% if not the end of the board, checks next position
check_spot_remove(GameState, X, Y, Player, ReturnList):-
  size_of_board(GameState, Size),
  next_index(X, Y, Size, X1, Y1),
  check_spot_remove(GameState, X1, Y1, Player, ReturnList).

% valid_moves(+GameState, +PlayerS, -List)
% will check the moves for every spot, starting ar 0,0
valid_moves(GameState, PlayerS, List):-
  check_spot(GameState, 0, 0, PlayerS, List).
  
% check_spot(+GameState, +X, +Y, +Player, -ReturnList)
% if spot belongs to player, checks directions and if list is empty -> next spot
% Base Case: Last Spot and Spot Belongs to Player, There're available plays
check_spot(GameState, X, Y, Player, ReturnList):-
  size_of_board(GameState, Size), check_end(X, Y, Size),
  player_in_board(GameState, X, Y, Player),
  available_dirs(GameState, X, Y, Player, TempList), TempList \= [],
  create_sublist(X, Y, TempList, ReturnList).
% Base Case: Last Spot and Spot Belongs to Player, There're no available plays OR last spot and doesn't belong to player. Returns empty list 
check_spot(GameState, X, Y, _, []):-
  size_of_board(GameState, Size), check_end(X, Y, Size).
% if the spot belongs to player and there are directions available, saves the sublist created and calls itself with next position
check_spot(GameState, X, Y, Player, ReturnList):-
  player_in_board(GameState, X, Y, Player),
  available_dirs(GameState, X, Y, Player, TempList), TempList \= [],
  create_sublist(X, Y, TempList, Result),
  size_of_board(GameState, Size),
  next_index(X, Y, Size, X1, Y1),
  check_spot(GameState, X1, Y1, Player, TempReturnList),
  append(TempReturnList, Result, ReturnList).
% if not the end of the board, checks next spot
check_spot(GameState, X, Y, Player, ReturnList):-
  size_of_board(GameState, Size),
  next_index(X, Y, Size, X1, Y1),
  check_spot(GameState, X1, Y1, Player, ReturnList).

% create_sublist(+X, +Y, +ListDirs, -Result)
% from a position and a list of directions, creates options in the format [[X, Y, 'dir1'], [X, Y, 'dir2']]
create_sublist(X, Y, [Dir|Rest], Result):-
  NewList = [[X, Y, Dir]],
  create_sublist(X, Y, Rest, PreviousResult),
  append(PreviousResult, NewList, Result).
create_sublist(_, _, [], []).