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
    
menu_option(0):-
  write('\nThank You For Playing\nIgnore the "yes"').
menu_option(1):-
  initial(GameState),
  display_game(GameState),
  start_game(GameState),
  menu.
menu_option(2):-
  write('\nPlayer vs Computer\nChoose a Difficulty:\n'),
  write('1 - Easy (Random)\n'),
  write('2 - Normal (Greedy)\n'),
  write('0 - Exit\n'),
  read_number(0,2,Number),
  pc_menu(Number),
  menu.
menu_option(3):-
  write('\nComputer vs Computer\nChoose a Difficulty for Computer 1:\n'),
  write('1 - Easy (Random)\n'),
  write('2 - Normal (Greedy)\n'),
  write('0 - Exit\n'),
  read_number(0,2,Number),
  cc_menu(Number),
  menu.
menu_option(4):-
  write('\nMissing instructions\n'),
  menu.
menu_option(5):-
  write('\nMade By Andre Gomes and Goncalo Teixeira\n'),
  menu.
  
% player vs computer menu
pc_menu(0).
pc_menu(1):-
  write('\nPlayer vs Computer (Easy)\nWhich Player do you want to be:\n'),
  write('1 - Player 1\n'),
  write('2 - Player 2\n'),
  write('0 - Exit\n'),
  read_number(0,2,Number),
  pc_menu_easy(Number).
pc_menu(2):-
  write('\nPlayer vs Computer (Normal)\nWhich Player do you want to be:\n'),
  write('1 - Player 1\n'),
  write('2 - Player 2\n'),
  write('0 - Exit\n'),
  read_number(0,2,Number),
  pc_menu_normal(Number).

pc_menu_easy(0).
pc_menu_easy(1):-
  write('TO IMPLEMENT\nPlayer vs Computer (Easy), Player is Player 1\n').
pc_menu_easy(2):-
  write('TO IMPLEMENT\nPlayer vs Computer (Easy), Player is Player 2\n').

pc_menu_normal(0).
pc_menu_normal(1):-
  write('TO IMPLEMENT\nPlayer vs Computer (Normal), Player is Player 1\n').
pc_menu_normal(2):-
  write('TO IMPLEMENT\nPlayer vs Computer (Normal), Player is Player 2\n').

cc_menu(0).
cc_menu(1):-
  write('\nComputer (Easy) vs Computer \nChoose a Difficulty for Computer 2:\n'),
  write('1 - Easy (Random)\n'),
  write('2 - Normal (Greedy)\n'),
  write('0 - Exit\n'),
  read_number(0,2,Number),
  cc_menu_easy(Number).
cc_menu(2):-
  write('\nComputer (Normal) vs Computer \nChoose a Difficulty for Computer 2:\n'),
  write('1 - Easy (Random)\n'),
  write('2 - Normal (Greedy)\n'),
  write('0 - Exit\n'),
  read_number(0,2,Number),
  cc_menu_normal(Number).

cc_menu_easy(0).
cc_menu_easy(1):-
  write('TO IMPLEMENT\nComputer (Easy) vs Computer (Easy)\n').
cc_menu_easy(2):-
  write('TO IMPLEMENT\nComputer (Easy) vs Computer (Normal)\n').

cc_menu_normal(0).
cc_menu_normal(1):-
  write('TO IMPLEMENT\nComputer (Normal) vs Computer (Easy)\n').
cc_menu_normal(2):-
  write('TO IMPLEMENT\nComputer (Normal) vs Computer (Normal)\n').