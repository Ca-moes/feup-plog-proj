/*
Avaliação do Tabuleiro: Forma(s) de avaliação do estado do jogo. O predicado
deve chamar-se 
value(+GameState, +Player, -Value).

Jogada do Computador: Escolha da jogada a efetuar pelo computador,
dependendo do nível de dificuldade. O predicado deve chamar-se
choose_move(+GameState, +Player, +Level, -Move).

Lista de Jogadas Válidas: Obtenção de lista com jogadas possíveis (com melhor á cabeça). O predicado
deve chamar-se 
valid_moves(+GameState, +Player, -ListOfMoves).
[[X,Y,'up'],[X,Y,'left']]
*/