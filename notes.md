# A testar

Quando fôr para implementar o server plog em js temos de ver se como se manda listas como argumentos.
Mandar um request tipo `length(List, Size)` e ver se ao mandar a lista como string se fica bem.

```prolog
Request: len([1,2])
Reply: 2

parse_input(len(List), Res) :- length(List, Res).
```

Listas funcionam ao passar como string, good to know.

## Menu Id e menu correspondente:
- 0 - Exit? (not sure se vai haver essa opção)
- 1 - main menu
- 2 - board size chooser
- 3 - choose bot 1 difficulty
- 4 - choose bot 2 difficulty
- 5 - choose player
- 6 - intruções
- 10 - pp
- 11 - pc - player as 1
- 12 - pc - player as 2
- 13 - cc - easy vs easy
- 14 - cc - easy vs normal
- 15 - cc - normal vs easy
- 16 - cc - normal vs normal

Menus e opções de cada menu são guardados internamente em JS. são mandados `choices(+MenuId, +Option, -Menu)` para prolog e este responde com o próximo menu a apresentar ou então um jogo


```prolog
choices(1, 1, 2). % do main menu, escolhendo 1 vai para board chooser
choices(1, 2, 2).
```


## Transições a implementar em prolog:
- main_menu, 1 (pp), board_size
  - board_size, 1 (6x6), start_game
  - board_size, 2 (8x8), start_game
  - board_size, 3 (10x10), start_game
  - board_size, 0 (exit), main_menu
- main_menu, 2 (pc), board_size
  - board_size, 1 (6x6), choose_dif
    - choose_dif, 1 (easy), choose_player
      - choose_player, 1 (Player 1), start_game
      - choose_player, 2 (Player 2), start_game
      - choose_player, 0 (exit), main_menu
    - choose_dif, 2 (normal), choose_player
      - ...
    - choose_dif, 0 (exit), main_menu
  - board_size, 2 (8x8), choose_dif
    - choose_dif, 1 (easy), choose_player
      - ...
    - choose_dif, 2 (normal), choose_player
      - ...
    - choose_dif, 0 (exit), main_menu
  - board_size, 3 (10x10), choose_dif
    - choose_dif, 1 (easy), choose_player
      - ...
    - choose_dif, 2 (normal), choose_player
      - c...
    - choose_dif, 0 (exit), main_menu
  - board_size, 0 (exit), main_menu
- main_menu, 3 (cc), board_size
  - board_size, 1 (6x6), start_game
    - choose_dif, 1 (easy), choose_player
      - choose_dif, 1 (easy), choose_player
      - choose_dif, 2 (normal), choose_player
      - choose_dif, 0 (exit), main_menu
    - choose_dif, 2 (normal), choose_player
      - ...
    - choose_dif, 0 (exit), main_menu
  - board_size, 2 (8x8), start_game
    - choose_dif, 1 (easy), choose_player
      - ...
    - choose_dif, 2 (normal), choose_player
      - ...
    - choose_dif, 0 (exit), main_menu
  - board_size, 3 (10x10), start_game
    - choose_dif, 1 (easy), choose_player
      - ...
    - choose_dif, 2 (normal), choose_player
      - ...
    - choose_dif, 0 (exit), main_menu
  - board_size, 0 (exit), main_menu


## Durante o jogo
### Player
O Player seleciona uma casa e precisa de verificar se é uma casa válida, não há verificação de inputs porque o pick já seleciona uma casa dentro do board, só é necessário que a casa seja do jogador.

JS chamará um predicado novo `spot(+GameState, +Player, +X-Y, -Return)` que returnará 0 se:
- for peça do jogador
- tiver peças inimigas adjacentes

ou 1 se posição for má

Este predicado fará uso dos predicados `validate_choice` **alterado**, `available_dirs` e `check_list` **alterado**.

---

Assim que tiver uma posição, precisa da posição inimiga:
- Xf-Yf têm de ser adjacentes
- Xf-Yf têm de ser inimigo

JS pode usar o predicado `moveto(+GameState, +Player, +X-Y-Xf-Yf, -Return)`, retornando 0 se posição for boa e 1 se for má

`moveto` fará uso de `player_in_board(+Board, +X, +Y, -PlayerS)` para verificar que a peça é do inimigo e `direction(+X, +Y, +Direction, -Xr, -Yr)` para verificar se a direção é adjacente

---

Para efetuar o move podemos chamar um predicado `move` com alterações. O move de agora é `move(+GameState, +X-Y-Direction, -NewGameState)` Mas nós não temos uma direção. Então cria-se um `move(+GameState, +X-Y-Xf-Yf, -NewGameState)` que faça o mesmo de cima, usando o predicado `direction(+X, +Y, +Direction, -Xr, -Yr)` para saber a direção.

---

### Bots

`make_move(+Difficulty, +GameState, +Player, -NewGameState)` does the Job. Ao mandar a difficuldade, o tabuleiro e o jogador o bot consegue decidir a jogada a fazer.


### TO DO

- final_state(GameState, Player, Return) - Checa se tens movimentos possiveis e retorna 0 se não tiver movimentos. 1 se tiver movimentos aka não está no estado final

- check_winner(GameState, Player, WinnerReturn) - Manda-se Board e Players, retorna 'Player 1', 'Player 2' ou 'none'



