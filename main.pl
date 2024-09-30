% Maria Eduarda de Medeiros Simonassi _ 202365119A
% Patrick Canto de Carvalho _ 201935026

% Montagem inicial do tabuleiro e impressão na tela
:- dynamic tabuleiro/1.

tabuleiro([
    [' ', 'O', ' ', 'O', ' ', 'O', ' ', 'O'],  
    ['O', ' ', 'O', ' ', 'O', ' ', 'O', ' '], 
    [' ', 'O', ' ', 'O', ' ', 'O', ' ', 'O'],  
    [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],  
    [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '], 
    ['X', ' ', 'X', ' ', 'X', ' ', 'X', ' '], 
    [' ', 'X', ' ', 'X', ' ', 'X', ' ', 'X'],  
    ['X', ' ', 'X', ' ', 'X', ' ', 'X', ' ']   
]).

% Função para exibir a grade do tabuleiro
mostrar_tabuleiro :-
    nl,
    write('---------------------------------------------------------------- Tabuleiro atual -----------------------------------------------------------------'), nl,nl,
    write('    A   B   C   D   E   F   G   H'), nl,
    write('  +---+---+---+---+---+---+---+---+'), nl, 
    tabuleiro(Tab), 
    mostrar_linhas(Tab, 8),
    nl.

% Função que exibe as linhas do tabuleiro 
mostrar_linhas([], _).
mostrar_linhas([Linha|Resto], Num) :-
    format('~d |', [Num]),  
    mostrar_linha(Linha, Num, 1),
    nl, write('  +---+---+---+---+---+---+---+---+'), nl,
    NovoNum is Num - 1,
    mostrar_linhas(Resto, NovoNum).

% Função que exibe uma linha do tabuleiro com cores alternadas
mostrar_linha([], _, _).
mostrar_linha([Casa|Resto], Linha, Coluna) :-
    cor_casa(Linha, Coluna, CorFundo),
    cor_peca(Casa, CorPeca),
    format('~w ~w ~w|', [CorFundo, CorPeca, '\033[0m']),
    ProximaColuna is Coluna + 1,
    mostrar_linha(Resto, Linha, ProximaColuna).

% Define as cores de fundo alternadas corretamente
cor_casa(Linha, Coluna, Cor) :-
    Soma is Linha + Coluna,
    (Soma mod 2 =:= 0 -> Cor = '\033[47m'; Cor = '\033[40m'). 

% Define as cores das peças usando caracteres ASCII
cor_peca('O', '\033[31mO').  
cor_peca('X', '\033[33mX'). 
cor_peca(' ', ' ').          



% Menus
% Menu inicial 
menuInicial :-
    nl, 
    write('----------------------------------------------------------- BEM VINDO AO JOGO DE DAMAS -----------------------------------------------------------'), nl, nl,
    write('Atencao! Para poder interagir durante o jogo e necessario que apos qualquer resposta adicionada ao terminal voce adicione no fim um ponto final'), nl,
    write('Exemplo: Para escolher o modo de jogo que voce deseja, voce devera adicionar no terminal o numero escolhido mais o ponto final'), nl,
    write('Exemplo: 1.'), nl,
    write('Bom jogo!'), nl, nl,
    write('--------------------------------------------------------------------------------------------------------------------------------------------------'), nl, nl,
    menu.

% Menu para escolher o modo de jogo
menu :-
    write('Escolha o modo de jogo:'), nl,
    write('1. Jogar contra o programa.'), nl,
    write('2. Assistir ao programa jogando contra si mesmo.'), nl,
    write('Digite sua escolha (1. ou 2.): '), 
    read(Opcao),
    iniciar_jogo(Opcao).




% Início do jogo
% Jogador x Computador
iniciar_jogo(1) :-
    nl,
    write('--------------------------------------------------------------------------------------------------------------------------------------------------'), nl,nl,
    write('------------------------------------------------------ Voce escolheu jogar contra o programa -----------------------------------------------------'), nl,
    mostrar_tabuleiro,
    escolher_jogador_inicial_tradicional(Jogador, Jogador2),
    iniciar_turno_tradicional(Jogador, Jogador2).
% Computador x Computador
iniciar_jogo(2) :-
    nl,
    write('--------------------------------------------------------------------------------------------------------------------------------------------------'), nl,nl,
    write('------------------------------------------- Voce escolheu assistir ao programa jogando contra si mesmo -------------------------------------------'), nl,
    mostrar_tabuleiro,
    escolher_jogador_inicial_automatico(Jogador),
    iniciar_turno_automatico(Jogador, computador).
% Opção inválida
iniciar_jogo(_) :-
    nl,
    write('Atencao! Opcao invalida. Por favor, escolha 1. ou 2.'), nl,
    nl,
    menu.
% Escolher qual jogador inicia o jogo (modo tradicional)
escolher_jogador_inicial_tradicional(Jogador, Jogador2) :-
    repeat,
    write('Qual jogador deve iniciar a partida?'), nl,
    write('Digite 1. para voce iniciar (Jogador X) ou 2. para o computador iniciar (Jogador O).'), nl,
    write('Digite sua escolha (1. ou 2.): '),
    read(Escolha),
    (Escolha = 1 -> Jogador = 'X', Jogador2 = jogador, ! ;
     Escolha = 2 -> Jogador = 'O', Jogador2 = computador, ! ;
     write('Opcao invalida. Por favor, escolha 1. ou 2.'), nl, fail).

% Escolher qual jogador inicia o jogo (modo automático)
escolher_jogador_inicial_automatico(Jogador) :-
    write('Qual jogador deve iniciar a partida?'), nl,
    write('Digite 1. o Jogador X  ou 2. para o Jogador O'), nl,
    write('Digite sua escolha (1. ou 2.): '),
    read(Escolha),
    (Escolha = 1 -> Jogador = 'X'; Escolha = 2 -> Jogador = 'O'; nl,
    write('Opcao invalida. Por favor, escolha 1. ou 2.'), nl, nl, escolher_jogador_inicial_automatico(Jogador)).




% Dando inicio aos turnos
% Turno com o usuario controlando as peças X _ jogo tradicional 
iniciar_turno_tradicional('X', jogador) :-
    nl,
    write('Sua vez de jogar (Jogador X)'),nl,
    write('Menu de comandos validos: '),nl,
    write('Para um movimento simples digite mv(Coord1, Coord2). onde Coord1 e a posicao inicial da peca e Coord2 a posicao final'),nl,
    write('Para um movimento de captura digite cap(Coord1, [Coord2, Coord3,...,Coordn]) onde Coord1 e a posicao inicial da peca e Coordn a posicao final da peca'),nl,
    write('ou digite sair. para encerrar o jogo.'), nl,
    repetir_ate_comando_valido('X').
% Turno do computador controlando as peças O _ jogo tradicional 
iniciar_turno_tradicional('O', computador) :-
    nl,
    write('Vez do computador (Jogador O).'), nl,
    realizar_jogada_computador('O'),
    trocar_turno_tradicional('O', computador).

% Turno do computador controlando as peças X _ jogo automático
iniciar_turno_automatico('X', computador) :-
    nl,
    write('Vez do computador (Jogador X).'), nl,
    realizar_jogada_computador_automatico('X').

% Turno do computador controlando as peças O _ jogo automático
iniciar_turno_automatico('O', computador) :-
    nl,
    write('Vez do computador (Jogador O).'), nl,
    realizar_jogada_computador_automatico('O').


% Controle de validade dos comandos inseridos pelo usuario _ Repetir até que um comando válido seja digitado
repetir_ate_comando_valido(Jogador) :-
    repeat,
    read(Comando),
    (Comando == sair ->
        nl,
        write('Jogo encerrado. Obrigado por jogar!'), nl, !, halt
    ;
        (Comando =.. [mv, Coord1, Coord2] ->
            (mv(Coord1, Coord2) ->
                trocar_turno_tradicional(Jogador, jogador), !
            ;
                write('Comando de movimento inválido. Tente novamente.'), nl,
                fail
            )
        ;
        (Comando =.. [cap, Coord1, Coords] ->
            (cap(Coord1, Coords) ->
                trocar_turno_tradicional(Jogador, jogador), ! 
            ;
                write('Comando de captura inválido. Tente novamente.'), nl,
                fail
            )
        ;
            verificar_movimentos_disponiveis(Jogador) -> 
                format('Nenhuma jogada disponível para o jogador ~w. Fim de jogo! O outro jogador venceu.', [Jogador]), nl,
                halt
            ;
            write('Comando inválido. Tente novamente.'), nl,
            fail
        ))).


% Lógica do movimento simples
mv(Coord1, Coord2) :-
    % Validação do movimento selecionado
    posicao_valida(Coord1, X1, Y1),
    posicao_valida(Coord2, X2, Y2),
    tabuleiro(Tab),
    peca_na_posicao(Tab, X1, Y1, Peca),
    Peca \= ' ', 
    movimento_valido(Peca, X1, Y1, X2, Y2),
    % Caso o movimento seja válido, o movimento é realizado
    mover(Tab, X1, Y1, X2, Y2, NovoTab),
    atualizar_tabuleiro(NovoTab),
    mostrar_tabuleiro.

% Função que valida a posição no tabuleiro para validar o movimento
posicao_valida(Coord, X, Y) :-
    (atom(Coord) ->
        atom_chars(Coord, [ColChar, RowChar]),
        coluna_para_indice(ColChar, X),
        linha_para_indice(RowChar, Y)
    ; 
        Coord = [ColChar, RowChar],
        coluna_para_indice(ColChar, X),
        linha_para_indice(RowChar, Y)
    ).


% Verifica se há uma peça em uma posição específica
peca_na_posicao(Tab, X, Y, Peca) :-
    nth1(Y, Tab, Linha),
    nth1(X, Linha, Peca).


% Regras de Movimento Simples _ Usado na lógica de validação do movimento solicitado
% Regras para as peças O
movimento_valido('O', X1, Y1, X2, Y2) :-
    nonvar(X1), nonvar(Y1), nonvar(X2), nonvar(Y2), 
    DX is abs(X2 - X1),
    DY is Y2 - Y1,
    DX =:= 1,
    DY =:= 1.

% Regras para as peças X
movimento_valido('X', X1, Y1, X2, Y2) :-
    nonvar(X1), nonvar(Y1), nonvar(X2), nonvar(Y2),
    DX is abs(X2 - X1),
    DY is Y1 - Y2,
    DX =:= 1,
    DY =:= 1.

% Atualiza o tabuleiro após um movimento
mover(Tab, X1, Y1, X2, Y2, NovoTab) :-
    peca_na_posicao(Tab, X1, Y1, Peca),
    set_peca(Tab, X1, Y1, ' ', TempTab),
    set_peca(TempTab, X2, Y2, Peca, NovoTab).

% Funções auxiliares para modificação do tabuleiro após uma jogada
set_peca(Tab, X, Y, Peca, NovoTab) :-
    nth1(Y, Tab, Linha),
    set_peca_linha(Linha, X, Peca, NovaLinha),
    set_linha(Tab, Y, NovaLinha, NovoTab).

set_peca_linha([_|T], 1, Peca, [Peca|T]).
set_peca_linha([H|T], X, Peca, [H|R]) :-
    X > 1,
    X1 is X - 1,
    set_peca_linha(T, X1, Peca, R).

set_linha([_|T], 1, NovaLinha, [NovaLinha|T]).
set_linha([H|T], Y, NovaLinha, [H|R]) :-
    Y > 1,
    Y1 is Y - 1,
    set_linha(T, Y1, NovaLinha, R).

% Atualiza o tabuleiro em memória
atualizar_tabuleiro(NovoTab) :-
    retract(tabuleiro(_)),
    assert(tabuleiro(NovoTab)).

realizar_jogada_computador(Peca) :-
    write('Pensando...'), nl,
    sleep(3), 
    tabuleiro(Tab),
    % Primeiramente, tenta encontrar uma captura válida
    (   encontrar_captura_valida(Tab, Peca, X1, Y1, X2, Y2, XCap, YCap) ->
        write('Debug: Encontrou uma captura válida.'), nl,
        % Realiza a captura
        indice_para_coluna(X1, Col1), indice_para_linha(Y1, Row1),
        indice_para_coluna(X2, Col2), indice_para_linha(Y2, Row2),
        format('Capturando com a peca ~w da posicao ~w~w para ~w~w.~n', [Peca, Col1, Row1, Col2, Row2]),
        set_peca(Tab, XCap, YCap, ' ', TempTab),
        mover(TempTab, X1, Y1, X2, Y2, NovoTab),
        atualizar_tabuleiro(NovoTab),
        mostrar_tabuleiro,
        trocar_turno_tradicional(Peca, computador)
    ;   % Se não houver captura válida, tenta um movimento simples
        write('Debug: Não encontrou captura válida, tentando movimento simples.'), nl,
        (encontrar_jogada_valida(Tab, Peca, X1, Y1, X2, Y2) ->
            write('Debug: Encontrou um movimento simples válido.'), nl,
            indice_para_coluna(X1, Col1), indice_para_linha(Y1, Row1),
            indice_para_coluna(X2, Col2), indice_para_linha(Y2, Row2),
            format('Movendo a peca ~w da posicao ~w~w para ~w~w.~n', [Peca, Col1, Row1, Col2, Row2]),
            mover(Tab, X1, Y1, X2, Y2, NovoTab),
            atualizar_tabuleiro(NovoTab),
            mostrar_tabuleiro,
            trocar_turno_tradicional(Peca, computador)
        ;   % Se não houver jogadas disponíveis, o jogo termina
            write('Debug: Nenhuma jogada disponível para o computador.'), nl,
            format('Nenhuma jogada disponível para o jogador ~w. Fim de jogo! O outro jogador venceu.', [Peca]), nl,
            halt
        )
    ).


% Realizar jogada do computador de forma aleatória, priorizando capturas _ jogo automático
realizar_jogada_computador_automatico(Peca) :-
    write('Pensando...'), nl,
    sleep(3), 
    tabuleiro(Tab),
    % Primeiramente, tenta encontrar uma captura válida
    (   encontrar_captura_valida(Tab, Peca, X1, Y1, X2, Y2, XCap, YCap) ->
        write('Debug: Encontrou uma captura válida.'), nl,
        % Realiza a captura
        indice_para_coluna(X1, Col1), indice_para_linha(Y1, Row1),
        indice_para_coluna(X2, Col2), indice_para_linha(Y2, Row2),
        format('Capturando com a peca ~w da posicao ~w~w para ~w~w.~n', [Peca, Col1, Row1, Col2, Row2]),
        set_peca(Tab, XCap, YCap, ' ', TempTab),
        mover(TempTab, X1, Y1, X2, Y2, NovoTab),
        atualizar_tabuleiro(NovoTab),
        mostrar_tabuleiro,
        trocar_turno_automatico(Peca, computador)
    ;   % Se não houver captura válida, tenta um movimento simples
        write('Debug: Não encontrou captura válida, tentando movimento simples.'), nl,
        (encontrar_jogada_valida(Tab, Peca, X1, Y1, X2, Y2) ->
            write('Debug: Encontrou um movimento simples válido.'), nl,
            indice_para_coluna(X1, Col1), indice_para_linha(Y1, Row1),
            indice_para_coluna(X2, Col2), indice_para_linha(Y2, Row2),
            format('Movendo a peca ~w da posicao ~w~w para ~w~w.~n', [Peca, Col1, Row1, Col2, Row2]),
            mover(Tab, X1, Y1, X2, Y2, NovoTab),
            atualizar_tabuleiro(NovoTab),
            mostrar_tabuleiro,
            trocar_turno_automatico(Peca, computador)
        ;   % Se não houver jogadas disponíveis, o jogo termina
            write('Debug: Nenhuma jogada disponível para o computador.'), nl,
            format('Nenhuma jogada disponível para o jogador ~w. Fim de jogo! O outro jogador venceu.', [Peca]), nl,
            halt
        )
    ).








% Função para encontrar uma captura válida para o computador
encontrar_captura_valida(Tab, Peca, X1, Y1, X2, Y2, XCap, YCap) :-
    write('Debug: Tentando encontrar captura válida para a peça '), write(Peca), nl,
    between(1, 8, X1),
    between(1, 8, Y1),
    peca_na_posicao(Tab, X1, Y1, Peca),
    between(1, 8, X2),
    between(1, 8, Y2),
    captura_valida(Tab, X1, Y1, X2, Y2, XCap, YCap),
    !, % Encontra a primeira captura válida e para
    format('Debug: Captura válida encontrada de (~w, ~w) para (~w, ~w) capturando (~w, ~w).', [X1, Y1, X2, Y2, XCap, YCap]), nl.


% Função para encontrar uma jogada válida para o computador
encontrar_jogada_valida(Tab, Peca, X1, Y1, X2, Y2) :-
    write('Debug: Tentando encontrar movimento simples para a peça '), write(Peca), nl,
    % Tente encontrar uma peça da posição (X1, Y1)
    between(1, 8, X1),
    between(1, 8, Y1),
    peca_na_posicao(Tab, X1, Y1, Peca),
    Peca \= ' ', % Certifique-se de que a posição contém uma peça
    % Encontre uma posição de destino (X2, Y2)
    between(1, 8, X2),
    between(1, 8, Y2),
    movimento_valido(Peca, X1, Y1, X2, Y2),
    peca_livre(Tab, X2, Y2),
    !, % Para na primeira jogada válida
    format('Debug: Movimento simples encontrado de (~w, ~w) para (~w, ~w).', [X1, Y1, X2, Y2]), nl.



% Comando de captura múltipla
cap(Coord1, [Coord2 | Rest]) :-
    posicao_valida(Coord1, X1, Y1),
    posicao_valida(Coord2, X2, Y2),
    tabuleiro(Tab),
    
    % Verifica a captura válida
    captura_valida(Tab, X1, Y1, X2, Y2, XCap, YCap),
    
    % Atualiza o tabuleiro removendo a peça capturada
    set_peca(Tab, XCap, YCap, ' ', TempTab),
    mover(TempTab, X1, Y1, X2, Y2, NovoTab),
    atualizar_tabuleiro(NovoTab),
    mostrar_tabuleiro,

    % Verifica se há mais capturas para fazer
    (Rest = [] -> true ; cap(Coord2, Rest)).

% Ajustar a função para verificar captura válida com 7 argumentos
% Ajustar a função para verificar captura válida com 7 argumentos
captura_valida(Tab, X1, Y1, X2, Y2, XCap, YCap) :-
    % Posição inicial (X1, Y1) contém a peça do jogador
    peca_na_posicao(Tab, X1, Y1, Peca),
    Peca \= ' ', % Certifica-se de que há uma peça para capturar
    
    % Verificar que o movimento é uma captura válida em uma das diagonais
    DX is abs(X2 - X1),
    DY is abs(Y2 - Y1),
    DX =:= 2,
    DY =:= 2, % Movimento deve ser de duas casas na diagonal
    
    % Cálculo da posição intermediária (XCap, YCap)
    XCap is (X1 + X2) // 2,
    YCap is (Y1 + Y2) // 2,
    
    % Verificar se a posição intermediária é válida e contém uma peça adversária
    between(1, 8, XCap),
    between(1, 8, YCap),
    peca_na_posicao(Tab, XCap, YCap, PecaCapturada),
    PecaCapturada \= ' ', % Certifica-se de que há uma peça na posição intermediária
    PecaCapturada \= Peca, % Certifica-se de que a peça a ser capturada é do adversário

    % A posição final (X2, Y2) deve estar livre
    between(1, 8, X2),
    between(1, 8, Y2),
    peca_livre(Tab, X2, Y2).




% Verifica se uma posição está livre
peca_livre(Tab, X, Y) :-
    peca_na_posicao(Tab, X, Y, ' ').

% Trocar o turno entre jogadores _ jogo tradicional
% Trocar o turno entre jogadores _ jogo tradicional
trocar_turno_tradicional('X', jogador) :-
    write('Debug: Trocando turno para Jogador O (computador).'), nl,
    iniciar_turno_tradicional('O', computador).
trocar_turno_tradicional('O', computador) :-
    write('Debug: Trocando turno para Jogador X (jogador).'), nl,
    iniciar_turno_tradicional('X', jogador).
% Trocar turno entre jogadores _ jogo automatico
% Trocar turno entre jogadores _ jogo automático
trocar_turno_automatico('X', computador) :-
    write('Debug: Trocando turno para Jogador O (computador).'), nl,
    iniciar_turno_automatico('O', computador).

trocar_turno_automatico('O', computador) :-
    write('Debug: Trocando turno para Jogador X (computador).'), nl,
    iniciar_turno_automatico('X', computador).



% Conversões
% Converte coluna para índice
coluna_para_indice('a', 1). coluna_para_indice('b', 2). coluna_para_indice('c', 3). coluna_para_indice('d', 4).
coluna_para_indice('e', 5). coluna_para_indice('f', 6). coluna_para_indice('g', 7). coluna_para_indice('h', 8).

% Converte índice para coluna
indice_para_coluna(1, 'a'). indice_para_coluna(2, 'b'). indice_para_coluna(3, 'c'). indice_para_coluna(4, 'd').
indice_para_coluna(5, 'e'). indice_para_coluna(6, 'f'). indice_para_coluna(7, 'g'). indice_para_coluna(8, 'h').

% Converte linha para índice
linha_para_indice('1', 8). linha_para_indice('2', 7). linha_para_indice('3', 6). linha_para_indice('4', 5).
linha_para_indice('5', 4). linha_para_indice('6', 3). linha_para_indice('7', 2). linha_para_indice('8', 1).

% Converte índice para linha
indice_para_linha(8, '1'). indice_para_linha(7, '2'). indice_para_linha(6, '3'). indice_para_linha(5, '4').
indice_para_linha(4, '5'). indice_para_linha(3, '6'). indice_para_linha(2, '7'). indice_para_linha(1, '8').


% Para iniciar o menu e escolher as opções de jogo
:- menuInicial.
