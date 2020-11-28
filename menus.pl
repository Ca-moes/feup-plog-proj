option_dif(1, 'Easy').
option_dif(2, 'Normal').
clear :- write('\33\[2J').

talpa_logo :-
    clear,
    write('TTTTTTTTTTTTTTTTTTTTTTT                lllllll                                      \n'),
    write('T:::::::::::::::::::::T                l:::::l                                      \n'),
    write('T:::::::::::::::::::::T                l:::::l                                      \n'),
    write('T:::::TT:::::::TT:::::T                l:::::l                                      \n'),
    write('TTTTTT  T:::::T  TTTTTTaaaaaaaaaaaaa    l::::lppppp   ppppppppp     aaaaaaaaaaaaa   \n'),
    write('        T:::::T        a::::::::::::a   l::::lp::::ppp:::::::::p    a::::::::::::a  \n'),
    write('        T:::::T        aaaaaaaaa:::::a  l::::lp:::::::::::::::::p   aaaaaaaaa:::::a \n'),
    write('        T:::::T                 a::::a  l::::lpp::::::ppppp::::::p           a::::a \n'),
    write('        T:::::T          aaaaaaa:::::a  l::::l p:::::p     p:::::p    aaaaaaa:::::a \n'),
    write('        T:::::T        aa::::::::::::a  l::::l p:::::p     p:::::p  aa::::::::::::a \n'),
    write('        T:::::T       a::::aaaa::::::a  l::::l p:::::p     p:::::p a::::aaaa::::::a \n'),
    write('        T:::::T      a::::a    a:::::a  l::::l p:::::p    p::::::pa::::a    a:::::a \n'),
    write('      TT:::::::TT    a::::a    a:::::a l::::::lp:::::ppppp:::::::pa::::a    a:::::a \n'),
    write('      T:::::::::T    a:::::aaaa::::::a l::::::lp::::::::::::::::p a:::::aaaa::::::a \n'),
    write('      T:::::::::T     a::::::::::aa:::al::::::lp::::::::::::::pp   a::::::::::aa:::a\n'),
    write('      TTTTTTTTTTT      aaaaaaaaaa  aaaallllllllp::::::pppppppp      aaaaaaaaaa  aaaa\n'),
    write('                                               p:::::p                              \n'),
    write('                                               p:::::p                              \n'),
    write('                                              p:::::::p                             \n'),
    write('                                              p:::::::p                             \n'),
    write('                                              p:::::::p                             \n'),
    write('                                              ppppppppp                             \n').


menu_header_format(Header):-
  format('~n~`*t ~p ~`*t~57|~n', [Header]).
menu_option_format(Option, Details):-
  format('*~t~d~t~15|~t~a~t~40+~t*~57|~n',
        [Option, Details]).
menu_empty_format :-
  format('*~t*~57|~n', []).
menu_sec_header_format(Label1, Label2):-
  format('*~t~a~t~15+~t~a~t~40+~t*~57|~n',
          [Label1, Label2]).
menu_bottom_format :-
  format('~`*t~57|~n', []).

%Main Menu
menu :-
/*   clear,*/
  menu_header_format('MAIN MENU'),
  menu_empty_format,
  menu_sec_header_format('Option', 'Details'),
  menu_empty_format,
  menu_option_format(1, 'Player vs Player'),
  menu_option_format(2, 'Player vs Computer'),
  menu_option_format(3, 'Computer vs Computer'),
  menu_option_format(4, 'Game Intructions'),
  menu_option_format(5, 'Information about project'),
  menu_option_format(6, 'TEST AREA'),
  menu_empty_format,
  menu_option_format(0, 'EXIT'),
  menu_empty_format,
  menu_bottom_format,

  read_number(0, 6, Number),
  menu_option(Number).

% menu with an extra option for a hidden feature
menu_board_size_hidden_feature(Size):-
  menu_header_format('Choose a Board Size'),
  menu_empty_format,
  menu_sec_header_format('Option', 'Details'),
  menu_empty_format,
  menu_option_format(1, '6x6'),
  menu_option_format(2, '8x8'),
  menu_option_format(3, '10x10'),
  menu_empty_format,
  menu_option_format(0, 'EXIT'),
  menu_empty_format,
  menu_bottom_format,
  read_number_hidden(0, 4, Size).
% menu to choose the board size
menu_board_size(Size):-
 menu_header_format('Choose a Board Size'),
  menu_empty_format,
  menu_sec_header_format('Option', 'Details'),
  menu_empty_format,
  menu_option_format(1, '6x6'),
  menu_option_format(2, '8x8'),
  menu_option_format(3, '10x10'),
  menu_empty_format,
  menu_option_format(0, 'EXIT'),
  menu_empty_format,
  menu_bottom_format,
  read_number(0, 3, Size).
% Exit Main Menu
menu_option(0):-
  write('\nThank You For Playing\nIgnore the "yes"').
% Player vs PLayer, need to choose Board Size
menu_option(1):-
  menu_board_size_hidden_feature(Size),
  pp_menu(Size).
% Player vs Computer, need to choose Board Size
menu_option(2):-
  write('\nPlayer vs Computer\n'),
  menu_board_size(Size),
  pc_menu_1(Size),
  menu.
% Computer vs Computer, need to choose Board Size
menu_option(3):-
  write('\nComputer vs Computer\n'),
  menu_board_size(Size),
  cc_menu_1(Size),
  menu.
% Game Instructions
menu_option(4):-
  write('\nMissing instructions\n'),
  menu.
% Info about the Project
menu_option(5):-
  write('\nMade By Andre Gomes and Goncalo Teixeira\n'),
  menu.
menu_option(6):-
  write('\33\[2J'),
  write('\nOption for Testing things\n'),

  initial(1, GameState),
  display_game(GameState),
  attemp_flood_fill(GameState, 0, 0, NewBoard),
  display_game(NewBoard),


  /* transpose(GameState, Transpose),
  display_game(Transpose),

  Player = 'Player 2',
  valid_moves(GameState, Player, List),

  write(List), nl, 
  findall(
    Value1-X1-Y1-Direction1-Index,
    (
      nth0(Index, List, SubList), 
      nth0(0, SubList, X1),
      nth0(1, SubList, Y1),
      nth0(2, SubList, Direction1),
      move(GameState, X1-Y1-Direction1, NewGameState),
      value(NewGameState, Player, Value1),
      write(Value1-X1-Y1-Direction1-Index), nl
    ),
    ListResults
  ),
  write(ListResults),  */

  menu.

% Choose to exit game on size screen
pp_menu(0):-
  menu.
% Hidden Feature
pp_menu(4):-
  write('You found a Hidden Feature, Have Fun!\n'),
  initial(4, GameState),
  start_game(GameState, 'Player', 'Player'),
  menu.
% Choose Size, Starting Game
pp_menu(Size):-
  initial(Size, GameState),
  start_game(GameState, 'Player', 'Player'),
  menu.

% Choose to exit game on size screen
pc_menu_1(0).
% Choose a board, needs to choose a difficulty for the bot
pc_menu_1(Size):-
  index_to_board_size(Size,Actual),
  format('\nPlayer vs Computer - ~dx~d Board\nChoose a Difficulty:\n', [Actual, Actual]),
  write('1 - Easy (Random)\n'),
  write('2 - Normal (Greedy)\n'),
  write('0 - Exit\n'),
  read_number(0,2,Number),
  pc_menu_2(Size, Number).

% Returning to Main Menu
pc_menu_2(_, 0).
% Choose a board and bot difficulty, needs to choose who plays first
pc_menu_2(Size, Difficulty):-
  index_to_board_size(Size,Actual), option_dif(Difficulty, Diff),
  format('\nPlayer vs Computer (~s) - ~dx~d Board\nWhich Player do you want to be:\n', [Diff, Actual, Actual]),
  write('1 - Player 1 (Plays First)\n'),
  write('2 - Player 2\n'),
  write('0 - Exit\n'),
  read_number(0,2,Number),
  pc_option(Size, Difficulty, Number).

pc_option(_,_,0).
pc_option(Size, 1, 1):-
  initial(Size, GameState),
  start_game(GameState, 'Player', 'Easy').
pc_option(Size, 1, 2):-
  initial(Size, GameState),
  start_game(GameState, 'Easy', 'Player').
pc_option(Size, 2, 1):-
  initial(Size, GameState),
  start_game(GameState, 'Player', 'Normal').
pc_option(Size, 2, 2):-
  initial(Size, GameState),
  start_game(GameState, 'Normal', 'Player').

% Returning to Main Menu
cc_menu_1(0).
% Choose a board, needs to choose bot 1 difficulty
cc_menu_1(Size):-
  index_to_board_size(Size,Actual),
  format('\nComputer vs Computer - ~dx~d Board\nChoose a Difficulty for Computer 1:\n', [Actual, Actual]),
  write('1 - Easy (Random)\n'),
  write('2 - Normal (Greedy)\n'),
  write('0 - Exit\n'),
  read_number(0,2,Number),
  cc_menu_2(Size, Number).

% Returning to Main Menu
cc_menu_2(_, 0).
% Choose a board and bot 1 difficulty, needs to choose bot 2 difficulty
cc_menu_2(Size, Diff1):-
  index_to_board_size(Size,Actual), option_dif(Diff1, Diff1S),
  format('\nComputer (~s) vs Computer - ~dx~d Board\nChoose a Difficulty for Computer 2:\n', [Diff1S, Actual, Actual]),
  write('1 - Easy (Random)\n'),
  write('2 - Normal (Greedy)\n'),
  write('0 - Exit\n'),
  read_number(0,2,Number),
  cc_option(Size, Diff1, Number).
  
cc_option(_,_,0).
cc_option(Size, 1, 1):-
  initial(Size, GameState),
  start_game(GameState, 'Easy', 'Easy').
cc_option(Size, 1, 2):-
  initial(Size, GameState),
  start_game(GameState, 'Easy', 'Normal').
cc_option(Size, 2, 1):-
  initial(Size, GameState),
  start_game(GameState, 'Normal', 'Easy').
cc_option(Size, 2, 2):-
  initial(Size, GameState),
  start_game(GameState, 'Normal', 'Normal').