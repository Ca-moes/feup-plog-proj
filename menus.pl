option_dif(1, 'Easy').
option_dif(2, 'Normal').

menu :-
  write('\nMenu\n'),
  write('1 - Player vs Player\n'),
  write('2 - Player vs Computer\n'),
  write('3 - Computer vs Computer\n'),
  write('4 - Game Intructions\n'),
  write('5 - Information about project\n'),
  write('0 - Exit\n'),
  read_number(0, 5, Number),
  menu_option(Number).

% menu with an extra option for a hidden feature
menu_board_size_hidden_feature(Size):-
  write('\nChoose a Board Size\n'),
  write('1 - 6x6\n'),
  write('2 - 8x8\n'),
  write('3 - 10x10\n'),
  write('0 - Exit\n'),
  read_number_hidden(0, 4, Size).
% menu to choose the board size
menu_board_size(Size):-
  write('\nChoose a Board Size\n'),
  write('1 - 6x6\n'),
  write('2 - 8x8\n'),
  write('3 - 10x10\n'),
  write('0 - Exit\n'),
  read_number(0, 3, Size).

menu_option(0):-
  write('\nThank You For Playing\nIgnore the "yes"').
menu_option(1):-
  menu_board_size_hidden_feature(Size),
  pp_menu(Size).
menu_option(2):-
  write('\nPlayer vs Computer\n'),
  menu_board_size(Size),
  pc_menu_1(Size),
  menu.
menu_option(3):-
  write('\nComputer vs Computer\n'),
  menu_board_size(Size),
  cc_menu_board(Size),
  menu.
menu_option(4):-
  write('\nMissing instructions\n'),
  menu.
menu_option(5):-
  write('\nMade By Andre Gomes and Goncalo Teixeira\n'),
  menu.

pp_menu(0):-
  menu.
pp_menu(4):-
  write('You found a Hidden Feature, Have Fun!\n'),
  initial(4, GameState),
  display_game(GameState),
  start_game(GameState),
  menu.
pp_menu(Size):-
  initial(Size, GameState),
  display_game(GameState),
  start_game(GameState),
  menu.

% process board input
pc_menu_1(0).
pc_menu_1(Size):-
  index_to_board_size(Size,Actual),
  format('\nPlayer vs Computer - ~dx~d Board\nChoose a Difficulty:\n', [Actual, Actual]),
  write('1 - Easy (Random)\n'),
  write('2 - Normal (Greedy)\n'),
  write('0 - Exit\n'),
  read_number(0,2,Number),
  pc_menu_2(Size, Number).

pc_menu_2(_, 0).
pc_menu_2(Size, Difficulty):-
  index_to_board_size(Size,Actual), option_dif(Difficulty, Diff),
  format('\nPlayer vs Computer (~s) - ~dx~d Board\nWhich Player do you want to be:\n', [Diff, Actual, Actual]),
  write('1 - Player 1\n'),
  write('2 - Player 2\n'),
  write('0 - Exit\n'),
  read_number(0,2,Number),
  pc_menu_3(Size, Difficulty, Number).

pc_menu_3(_,_,0).
pc_menu_3(Size, Difficulty, Player):-
  index_to_board_size(Size,Actual), option_dif(Difficulty, Diff), 
  format('\nTO IMPLEMENT\nPlayer vs Computer (~s), Player is Player ~d, Board Size ~dx~d\n', [Diff, Player, Actual, Actual]).


cc_menu_board(0).
cc_menu_board(Size):-
  index_to_board_size(Size,Actual),
  format('\nComputer vs Computer - ~dx~d Board\nChoose a Difficulty for Computer 1:\n', [Actual, Actual]),
  write('1 - Easy (Random)\n'),
  write('2 - Normal (Greedy)\n'),
  write('0 - Exit\n'),
  read_number(0,2,Number),
  cc_menu(Size, Number).

cc_menu(_, 0).
cc_menu(Size, 1):-
  index_to_board_size(Size,Actual),
  format('\nComputer (Easy) vs Computer - ~dx~d Board\nChoose a Difficulty for Computer 2:\n', [Actual, Actual]),
  write('1 - Easy (Random)\n'),
  write('2 - Normal (Greedy)\n'),
  write('0 - Exit\n'),
  read_number(0,2,Number),
  cc_menu_easy(Number).
cc_menu(Size, 2):-
  index_to_board_size(Size,Actual),
  format('\nComputer (Normal) vs Computer - ~dx~d Board\nChoose a Difficulty for Computer 2:\n', [Actual, Actual]),
  write('1 - Easy (Random)\n'),
  write('2 - Normal (Greedy)\n'),
  write('0 - Exit\n'),
  read_number(0,2,Number),
  cc_menu_normal(Number).

cc_menu_easy(_,0).
cc_menu_easy(Size, 1):-
  index_to_board_size(Size,Actual),
  format('\nComputer (Easy) vs Computer (Easy) - ~dx~d Board\nChoose a Difficulty for Computer 2:\n', [Actual, Actual]).
cc_menu_easy(Size, 2):-
  index_to_board_size(Size,Actual),
  format('\nComputer (Easy) vs Computer (Normal) - ~dx~d Board\nChoose a Difficulty for Computer 2:\n', [Actual, Actual]).

cc_menu_normal(_,0).
cc_menu_normal(Size, 1):-
  index_to_board_size(Size,Actual),
  format('\nComputer (Normal) vs Computer (Easy) - ~dx~d Board\nChoose a Difficulty for Computer 2:\n', [Actual, Actual]).
cc_menu_normal(Size, 2):-
  index_to_board_size(Size,Actual),
  format('\nComputer (Normal) vs Computer (Normal) - ~dx~d Board\nChoose a Difficulty for Computer 2:\n', [Actual, Actual]).
