% Maria Eduarda de Medeiros Simonassi _ 202365119A
% Patrick Canto de Carvalho _ 201935026

% --------------------------------------------------------- Montagem inicial do tabuleiro e impressão na tela --------------------------------------------------------- %

% Permite que o tabuleiro seja modificado de forma dinâmica durante o jogo
:- dynamic tabuleiro/1. 

% Tabuleiro inicial 
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



% ------------------------------------------------------------------------------- Menus ------------------------------------------------------------------------------- %

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



% --------------------------------------------------------------------------  Início do jogo -------------------------------------------------------------------------- %

% Início do jogo para a modalidade: Jogador x Computador
iniciar_jogo(1) :-
    nl,
    write('--------------------------------------------------------------------------------------------------------------------------------------------------'), nl,nl,
    write('------------------------------------------------------ Voce escolheu jogar contra o programa -----------------------------------------------------'), nl,
    mostrar_tabuleiro,
    escolher_jogador_inicial_tradicional(Jogador, Jogador2),
    iniciar_turno_tradicional(Jogador, Jogador2).

% Início do jogo para a modalidade:  Computador x Computador
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

% Escolher qual jogador inicia o jogo no modo tradicional 
escolher_jogador_inicial_tradicional(Jogador, Jogador2) :-
    repeat,
    write('Qual jogador deve iniciar a partida?'), nl,
    write('Digite 1. para voce iniciar (Jogador X) ou 2. para o computador iniciar (Jogador O).'), nl,
    write('Digite sua escolha (1. ou 2.): '),
    read(Escolha),
    (Escolha = 1 -> Jogador = 'X', Jogador2 = jogador, ! ;
     Escolha = 2 -> Jogador = 'O', Jogador2 = computador, ! ;
     write('Opcao invalida. Por favor, escolha 1. ou 2.'), nl, fail).

% Escolher qual jogador inicia o jogo no modo automático
escolher_jogador_inicial_automatico(Jogador) :-
    write('Qual jogador deve iniciar a partida?'), nl,
    write('Digite 1. o Jogador X  ou 2. para o Jogador O'), nl,
    write('Digite sua escolha (1. ou 2.): '),
    read(Escolha),
    (Escolha = 1 -> Jogador = 'X'; Escolha = 2 -> Jogador = 'O'; nl,
    write('Opcao invalida. Por favor, escolha 1. ou 2.'), nl, nl, escolher_jogador_inicial_automatico(Jogador)).



% ------------------------------------------------------------------------- Lógica dos turnos ------------------------------------------------------------------------- %
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


% ----------------------------------------------------------------------  Validação dos comandos ---------------------------------------------------------------------- %
% Controle de validade dos comandos inseridos pelo usuario _ Repetir até que um comando válido seja digitado
repetir_ate_comando_valido(Jogador) :-
    % Verifica se há movimentos disponíveis antes de pedir um comando
    (verificar_movimentos_disponiveis(Jogador) ->
        true
    ;   write('--------------------------------------------------------------------------------------------------------------------------------------------------'), nl,
        format('Nenhuma jogada disponivel para o jogador ~w. Fim de jogo! O outro jogador venceu.', [Jogador]), nl,
        write('--------------------------------------------------------------------------------------------------------------------------------------------------'), nl,
        halt
    ),
    
    % Repete até que um comando válido seja fornecido
    repeat,
    read(Comando),
    (Comando == sair ->
        nl,
        write('--------------------------------------------------------------------------------------------------------------------------------------------------'), nl,
        write('Jogo encerrado. Obrigado por jogar!'), nl,
        write('--------------------------------------------------------------------------------------------------------------------------------------------------'), nl, !, halt
    ;
        (Comando =.. [mv, Coord1, Coord2] ->
            (mv(Coord1, Coord2) ->
                trocar_turno_tradicional(Jogador, jogador), !
            ;
                write('Comando de movimento invalido. Tente novamente.'), nl,
                fail
            )
        ;
        (Comando =.. [cap, Coord1, Coords] ->
            (cap(Coord1, Coords) ->
                trocar_turno_tradicional(Jogador, jogador), ! 
            ;
                write('Comando de captura invalido. Tente novamente.'), nl,
                fail
            )
        ;
            write('Comando invalido. Tente novamente.'), nl,
            fail
        ))
    ).

% Função para verificar se existem movimentos disponíveis para o jogador
verificar_movimentos_disponiveis(Jogador) :-
    tabuleiro(Tab),
    (   Jogador = 'X' -> Peca = 'X'; Peca = 'O'),
    (   between(1, 8, X1),
        between(1, 8, Y1),
        peca_na_posicao(Tab, X1, Y1, Peca),
        between(1, 8, X2),
        between(1, 8, Y2),
        captura_valida_disponivel(Tab, X1, Y1, X2, Y2)
    ->  true
    ;  
        between(1, 8, X1),
        between(1, 8, Y1),
        peca_na_posicao(Tab, X1, Y1, Peca),
        Peca \= ' ',
        between(1, 8, X2),
        between(1, 8, Y2),
        movimento_valido(Peca, X1, Y1, X2, Y2),
        peca_livre(Tab, X2, Y2)
    ->  true
    ;   false
    ).

% Função para verificar se uma captura é possível 
captura_valida_disponivel(Tab, X1, Y1, X2, Y2) :-
    peca_na_posicao(Tab, X1, Y1, Peca),
    Peca \= ' ',
    
    DX is abs(X2 - X1),
    DY is abs(Y2 - Y1),
    DX =:= 2,
    DY =:= 2, 
    
    XCap is (X1 + X2) // 2,
    YCap is (Y1 + Y2) // 2,
    
    between(1, 8, XCap),
    between(1, 8, YCap),
    peca_na_posicao(Tab, XCap, YCap, PecaCapturada),
    PecaCapturada \= ' ', 
    PecaCapturada \= Peca, 

    between(1, 8, X2),
    between(1, 8, Y2),
    peca_livre(Tab, X2, Y2).

% Lógica de captura para considerar a captura múltipla pela dama
cap_aux(Tab, X1, Y1, [Coord2 | Rest]) :-
    posicao_valida(Coord2, X2, Y2),
    captura_valida(Tab, X1, Y1, X2, Y2, XCap, YCap),
    set_peca(Tab, XCap, YCap, ' ', TempTab),
    mover(TempTab, X1, Y1, X2, Y2, NovoTab),
    atualizar_tabuleiro(NovoTab),
    mostrar_tabuleiro,
    (Rest = [] ->
        continuar_captura_jogador(NovoTab, 'D', X2, Y2)
    ;   
        cap_aux(NovoTab, X2, Y2, Rest)
    ).

% Função para continuar captura pela dama ou peça se houver capturas disponíveis
continuar_captura_jogador(Tab, Peca, X, Y) :-
    (encontrar_captura_valida(Tab, Peca, X, Y, NX, NY, NXCap, NYCap) ->
        indice_para_coluna(X, Col1), indice_para_linha(Y, Row1),
        indice_para_coluna(NX, Col2), indice_para_linha(NY, Row2),
        format('Capturando com a peca ~w da posicao ~w~w para ~w~w.\n', [Peca, Col1, Row1, Col2, Row2]),
        set_peca(Tab, NXCap, NYCap, ' ', TempTab),  
        mover(TempTab, X, Y, NX, NY, NovoTab),    
        atualizar_tabuleiro(NovoTab),              
        mostrar_tabuleiro,
        continuar_captura_jogador(NovoTab, Peca, NX, NY)
    ; 
        true % Não há mais capturas possíveis, fim da jogada
    ).

% Função para verificar se uma peça deve ser promovida a dama
verificar_promocao(Tab, X, Y, Peca, NovoTab) :-
    ( Peca = 'X', Y =:= 1 ->
        set_peca(Tab, X, Y, 'D', NovoTab)
    ; Peca = 'O', Y =:= 8 ->
        set_peca(Tab, X, Y, 'DO', NovoTab)
    ; NovoTab = Tab ).
    
% Lógica do movimento simples, incluindo promoção a dama
mv(Coord1, Coord2) :-
    % Validação do movimento selecionado
    posicao_valida(Coord1, X1, Y1),
    posicao_valida(Coord2, X2, Y2),
    tabuleiro(Tab),
    peca_na_posicao(Tab, X1, Y1, Peca),
    Peca \= ' ',
    movimento_valido(Peca, X1, Y1, X2, Y2),
    % Caso o movimento seja válido, realiza o movimento e verifica promoção
    mover(Tab, X1, Y1, X2, Y2, NovoTab1),
    verificar_promocao(NovoTab1, X2, Y2, Peca, NovoTab2),
    atualizar_tabuleiro(NovoTab2),
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

% Verifica se o caminho está livre para a dama (diagonal)
caminho_livre(X1, Y1, X2, Y2) :-
    DX is sign(X2 - X1),
    DY is sign(Y2 - Y1),
    X is X1 + DX,
    Y is Y1 + DY,
    caminho_vazio(X, Y, X2, Y2).

caminho_vazio(X, Y, X, Y) :- !. % Se chegou ao destino, está livre
caminho_vazio(X, Y, X2, Y2) :-
    tabuleiro(Tab),
    peca_na_posicao(Tab, X, Y, ' '), % Verifica se a casa está vazia
    X1 is X + sign(X2 - X),
    Y1 is Y + sign(Y2 - Y),
    caminho_vazio(X1, Y1, X2, Y2).

% Lógica de movimento para damas 'D' (peça 'X' promovida) e 'DO' (peça 'O' promovida)
movimento_valido('D', X1, Y1, X2, Y2) :-
    nonvar(X1), nonvar(Y1), nonvar(X2), nonvar(Y2),
    abs(X2 - X1) =:= abs(Y2 - Y1), % Movimento na diagonal
    caminho_livre(X1, Y1, X2, Y2). % Verifica se o caminho está livre

movimento_valido('DO', X1, Y1, X2, Y2) :-
    nonvar(X1), nonvar(Y1), nonvar(X2), nonvar(Y2),
    abs(X2 - X1) =:= abs(Y2 - Y1), % Movimento na diagonal
    caminho_livre(X1, Y1, X2, Y2). % Verifica se o caminho está livre

movimento_valido('X', X1, Y1, X2, Y2) :- % Movimentos normais das peças 'X'
    nonvar(X1), nonvar(Y1), nonvar(X2), nonvar(Y2),
    DX is abs(X2 - X1),
    DY is Y1 - Y2,
    DX =:= 1,
    DY =:= 1.

movimento_valido('O', X1, Y1, X2, Y2) :- % Movimentos normais das peças 'O'
    nonvar(X1), nonvar(Y1), nonvar(X2), nonvar(Y2),
    DX is abs(X2 - X1),
    DY is Y2 - Y1,
    DX =:= 1,
    DY =:= 1.


% Função que realiza capturas, permitindo múltiplas capturas em um mesmo movimento
cap(Coord1, CoordList) :-
    posicao_valida(Coord1, X1, Y1),
    tabuleiro(Tab),
    cap_aux(Tab, X1, Y1, CoordList).

% Lógica de captura para damas
captura_valida(Tab, X1, Y1, X2, Y2, XCap, YCap) :-
    peca_na_posicao(Tab, X1, Y1, Peca),
    member(Peca, ['D', 'DO']), % Verifica se é uma dama
    abs(X2 - X1) =:= abs(Y2 - Y1), % Movimento na diagonal
    XCap is (X1 + X2) // 2,
    YCap is (Y1 + Y2) // 2,
    between(1, 8, XCap),
    between(1, 8, YCap),
    peca_na_posicao(Tab, XCap, YCap, PecaCapturada),
    PecaCapturada \= ' ', 
    PecaCapturada \= Peca, 
    between(1, 8, X2),
    between(1, 8, Y2),
    peca_livre(Tab, X2, Y2).

% Função auxiliar para verificar se uma posição está livre
peca_livre(Tab, X, Y) :-
    peca_na_posicao(Tab, X, Y, ' ').


% ---------------------------------------------------------------------- Atualização do tabuleiro --------------------------------------------------------------------- %
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


% --------------------------------------------------------------- Lógica de movimentação do computador --------------------------------------------------------------- %
% Realizar jogada do computador de forma aleatória, priorizando capturas _ jogo tradicional
realizar_jogada_computador(Peca) :-
    write('Pensando...'), nl,
    sleep(3),
    tabuleiro(Tab),
    % Primeiro, obtém todas as capturas possíveis
    encontrar_captura_valida(Tab, Peca, Capturas),
    (   Capturas \= [] ->
        % Realiza a primeira captura da lista
        Capturas = [(X1, Y1, X2, Y2, XCap, YCap)|_],
        indice_para_coluna(X1, Col1), indice_para_linha(Y1, Row1),
        indice_para_coluna(X2, Col2), indice_para_linha(Y2, Row2),
        format('Capturando com a peca ~w da posicao ~w~w para ~w~w.~n', [Peca, Col1, Row1, Col2, Row2]),
        set_peca(Tab, XCap, YCap, ' ', TempTab),
        mover(TempTab, X1, Y1, X2, Y2, NovoTab),
        atualizar_tabuleiro(NovoTab),
        mostrar_tabuleiro,
        trocar_turno_tradicional(Peca, computador)
    ;   % Se não houver captura válida, tenta um movimento simples
        (encontrar_jogada_valida(Tab, Peca, X1, Y1, X2, Y2) ->
            % Realiza o movimento
            indice_para_coluna(X1, Col1), indice_para_linha(Y1, Row1),
            indice_para_coluna(X2, Col2), indice_para_linha(Y2, Row2),
            format('Movendo a peca ~w da posicao ~w~w para ~w~w.~n', [Peca, Col1, Row1, Col2, Row2]),
            mover(Tab, X1, Y1, X2, Y2, NovoTab),
            atualizar_tabuleiro(NovoTab),
            mostrar_tabuleiro,
            trocar_turno_tradicional(Peca, computador)
        ;   % Se não houver jogadas disponíveis, o jogo termina
            write('--------------------------------------------------------------------------------------------------------------------------------------------------'), nl,
            format('Nenhuma jogada disponivel para o jogador ~w. Fim de jogo! O outro jogador venceu.', [Peca]), nl,
            write('--------------------------------------------------------------------------------------------------------------------------------------------------'),
            halt
        )
    ).

% Realizar jogada do computador de forma aleatória, priorizando capturas _ jogo automático
% Realizar jogada do computador de forma obrigatória priorizando capturas _ jogo automático
realizar_jogada_computador_automatico(Peca) :-
    write('Pensando...'), nl,
    sleep(3),
    tabuleiro(Tab),
    % Primeiro, obtém todas as capturas possíveis
    encontrar_todas_capturas(Tab, Peca, Capturas),
    (   
        Capturas \= [] ->
        % Se houver capturas disponíveis, realiza a primeira captura da lista
        Capturas = [(X1, Y1, X2, Y2, XCap, YCap)|_],
        indice_para_coluna(X1, Col1), indice_para_linha(Y1, Row1),
        indice_para_coluna(X2, Col2), indice_para_linha(Y2, Row2),
        format('Capturando com a peca ~w da posicao ~w~w para ~w~w.~n', [Peca, Col1, Row1, Col2, Row2]),
        set_peca(Tab, XCap, YCap, ' ', TempTab),
        mover(TempTab, X1, Y1, X2, Y2, NovoTab),
        atualizar_tabuleiro(NovoTab),
        mostrar_tabuleiro,
        % Continua jogando se houver múltiplas capturas disponíveis
        continuar_captura_jogador(NovoTab, Peca, X2, Y2),
        trocar_turno_automatico(Peca, computador)
    ;
        % Se não houver capturas disponíveis, tenta um movimento simples
        (encontrar_jogada_valida(Tab, Peca, X1, Y1, X2, Y2) ->
            indice_para_coluna(X1, Col1), indice_para_linha(Y1, Row1),
            indice_para_coluna(X2, Col2), indice_para_linha(Y2, Row2),
            format('Movendo a peca ~w da posicao ~w~w para ~w~w.~n', [Peca, Col1, Row1, Col2, Row2]),
            mover(Tab, X1, Y1, X2, Y2, NovoTab),
            atualizar_tabuleiro(NovoTab),
            mostrar_tabuleiro,
            trocar_turno_automatico(Peca, computador)
        ;
            % Se não houver jogadas disponíveis, o jogo termina
            write('--------------------------------------------------------------------------------------------------------------------------------------------------'), nl,
            format('Nenhuma jogada disponivel para o jogador ~w. Fim de jogo! O outro jogador venceu.', [Peca]), nl,
            write('--------------------------------------------------------------------------------------------------------------------------------------------------'), nl,
            halt
        )
    ).


% Função para encontrar uma captura válida (utilizada em outras partes do código)
encontrar_captura_valida(Tab, Peca, X1, Y1, X2, Y2, XCap, YCap) :-
    between(1, 8, X1),
    between(1, 8, Y1),
    peca_na_posicao(Tab, X1, Y1, Peca),
    between(1, 8, X2),
    between(1, 8, Y2),
    captura_valida(Tab, X1, Y1, X2, Y2, XCap, YCap).

% Função para encontrar uma jogada válida para o computador
encontrar_jogada_valida(Tab, Peca, X1, Y1, X2, Y2) :-
    between(1, 8, X1),
    between(1, 8, Y1),
    peca_na_posicao(Tab, X1, Y1, Peca),
    Peca \= ' ',
    between(1, 8, X2),
    between(1, 8, Y2),
    movimento_valido(Peca, X1, Y1, X2, Y2),
    peca_livre(Tab, X2, Y2).

% Função para obter todas as capturas possíveis para uma peça específica
encontrar_todas_capturas(Tab, Peca, Capturas) :-
    findall((X1, Y1, X2, Y2, XCap, YCap),
            (between(1, 8, X1),
             between(1, 8, Y1),
             peca_na_posicao(Tab, X1, Y1, Peca),
             between(1, 8, X2),
             between(1, 8, Y2),
             captura_valida(Tab, X1, Y1, X2, Y2, XCap, YCap)),
            Capturas).

% --------------------------------------------------------------------- Lógica da troca de turnos --------------------------------------------------------------------- %
% Trocar o turno entre jogadores _ jogo tradicional
trocar_turno_tradicional('X', jogador) :-
    iniciar_turno_tradicional('O', computador).

trocar_turno_tradicional('O', computador) :-
    iniciar_turno_tradicional('X', jogador).

% Trocar turno entre jogadores _ jogo automático
trocar_turno_automatico('X', computador) :-
    iniciar_turno_automatico('O', computador).

trocar_turno_automatico('O', computador) :-
    iniciar_turno_automatico('X', computador).

% ---------------------------------------------------------------------------- Conversões ----------------------------------------------------------------------------- %
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

% --------------------------------------------------------------------------- Início do jogo -------------------------------------------------------------------------- %
:- menuInicial.
