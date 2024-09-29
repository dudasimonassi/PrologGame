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
    write(' --------------------------------------------------------------- Tabuleiro atual -----------------------------------------------------------------'), nl,
    write('    A   B   C   D   E   F   G   H'), nl,
    write('  +---+---+---+---+---+---+---+---+'), nl, 
    tabuleiro(Tab), 
    mostrar_linhas(Tab, 8).

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
    write('Bom jogo!'), nl,
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
    write('--------------------------------------------------------------------------------------------------------------------------------------------------'), nl,
    write('------------------------------------------------------ Voce escolheu jogar contra o programa -----------------------------------------------------'), nl, nl,
    mostrar_tabuleiro,
    escolher_jogador_inicial_tradicional(Jogador),
    iniciar_turno(Jogador, jogador).

% Computador x Computador
iniciar_jogo(2) :-
    write('--------------------------------------------------------------------------------------------------------------------------------------------------'), nl,
    write('------------------------------------------- Voce escolheu assistir ao programa jogando contra si mesmo -------------------------------------------'), nl, nl,
    mostrar_tabuleiro,
    escolher_jogador_inicial_automatico(Jogador),
    iniciar_turno(Jogador, computador).

% Opção inválida
iniciar_jogo(_) :-
    nl,
    write('Atencao! Opcao invalida. Por favor, escolha 1. ou 2.'), nl,
    nl,
    menu.

% Escolher qual jogador inicia o jogo (modo tradicional)
escolher_jogador_inicial_tradicional(Jogador) :-
    write('Qual jogador deve iniciar a partida?'), nl,
    write('Digite 1. para voce iniciar (Jogador X) ou 2. para o computador iniciar (Jogador O).'), nl,
    write('Digite sua escolha (1. ou 2.): '),
    read(Escolha),
    (Escolha = 1 -> Jogador = 'X'; Escolha = 2 -> Jogador = 'O'; nl,
    write('Opcao invalida. Por favor, escolha 1. ou 2.'), nl, nl, escolher_jogador_inicial_tradicional(Jogador)).

% Escolher qual jogador inicia o jogo (modo automático)
escolher_jogador_inicial_automatico(Jogador) :-
    % Escolha automática para o modo automático
    random_member(Jogador, ['X', 'O']),
    write('O jogador '), write(Jogador), write(' ira comecar a partida.'), nl.

% Verifica se uma posição está livre
peca_livre(Tab, X, Y) :-
    peca_na_posicao(Tab, X, Y, ' ').

% Converte índices para colunas (de números para letras)
coluna_inv(1, 'a'). 
coluna_inv(2, 'b'). 
coluna_inv(3, 'c'). 
coluna_inv(4, 'd').
coluna_inv(5, 'e'). 
coluna_inv(6, 'f'). 
coluna_inv(7, 'g'). 
coluna_inv(8, 'h').

% Converte índices para linhas (de números para caracteres)
linha_inv(8, '1'). 
linha_inv(7, '2'). 
linha_inv(6, '3'). 
linha_inv(5, '4').
linha_inv(4, '5'). 
linha_inv(3, '6'). 
linha_inv(2, '7'). 
linha_inv(1, '8').


% Repetir até que um comando válido seja digitado
repetir_ate_comando_valido(Jogador) :-
    repeat,
    read(Comando),
    (Comando == sair ->
        write('Jogo encerrado. Obrigado por jogar!'), nl, !, halt
    ;
        (Comando =.. [mv, Coord1, Coord2] ->
            (mv(Coord1, Coord2) ->
                trocar_turno(Jogador, jogador), ! % Trocar turno apenas após um movimento válido
            ;
                write('Comando de movimento inválido. Tente novamente.'), nl,
                fail
            )
        ;
        (Comando =.. [cap, Coord1, Coords] ->
            (cap(Coord1, Coords) ->
                trocar_turno(Jogador, jogador), ! % Trocar turno apenas após uma captura válida
            ;
                write('Comando de captura inválido. Tente novamente.'), nl,
                fail
            )
        ;
            write('Comando inválido. Tente novamente.'), nl,
            fail
        ))).

% Movimento simples
mv(Coord1, Coord2) :-
    posicao_valida(Coord1, X1, Y1),
    posicao_valida(Coord2, X2, Y2),
    tabuleiro(Tab),
    peca_na_posicao(Tab, X1, Y1, Peca),
    Peca \= ' ',  % Certificar-se de que há uma peça na posição inicial
    movimento_valido(Peca, X1, Y1, X2, Y2),
    mover(Tab, X1, Y1, X2, Y2, NovoTab),
    atualizar_tabuleiro(NovoTab),
    mostrar_tabuleiro.

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


% Definindo a captura válida com 7 argumentos
captura_valida(Tab, X1, Y1, X2, Y2, XCap, YCap) :-
    % Posição inicial (X1, Y1) contém a peça do jogador
    peca_na_posicao(Tab, X1, Y1, Peca),
    Peca \= ' ', % Certifica-se de que há uma peça para capturar
    
    % Posição da peça a ser capturada (XCap, YCap)
    XCap is (X1 + X2) // 2,
    YCap is (Y1 + Y2) // 2,
    peca_na_posicao(Tab, XCap, YCap, PecaCapturada),
    PecaCapturada \= ' ', % Certifica-se de que há uma peça adversária
    
    % A posição final (X2, Y2) deve estar livre
    peca_livre(Tab, X2, Y2).


% Função que valida a posição no tabuleiro
posicao_valida(Coord, X, Y) :-
    (atom(Coord) -> % Se for um átomo, converte para uma lista de caracteres
        atom_chars(Coord, [Col, Row])
    ;   % Se já for uma lista de caracteres, extrai diretamente
        Coord = [Col, Row]
    ),
    coluna(Col, X),
    linha(Row, Y).


% Converte colunas e linhas para índices
coluna('a', 1). coluna('b', 2). coluna('c', 3). coluna('d', 4).
coluna('e', 5). coluna('f', 6). coluna('g', 7). coluna('h', 8).

linha('1', 8). linha('2', 7). linha('3', 6). linha('4', 5).
linha('5', 4). linha('6', 3). linha('7', 2). linha('8', 1).

% Verifica se há uma peça em uma posição específica
peca_na_posicao(Tab, X, Y, Peca) :-
    nth1(Y, Tab, Linha),
    nth1(X, Linha, Peca).

% Regras de Movimento Simples
movimento_valido('O', X1, Y1, X2, Y2) :-
    nonvar(X1), nonvar(Y1), nonvar(X2), nonvar(Y2), % Certifica-se de que todas as variáveis estão instanciadas
    DX is abs(X2 - X1),
    DY is Y2 - Y1,
    DX =:= 1,
    DY =:= 1.

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

% Atualiza o tabuleiro em memória
atualizar_tabuleiro(NovoTab) :-
    retract(tabuleiro(_)),
    assert(tabuleiro(NovoTab)).

% Altera uma peça no tabuleiro
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

% Iniciar o turno do jogador ou do computador
iniciar_turno('X', jogador) :-
    write('Sua vez de jogar (Jogador X). Digite um movimento na forma mv(Coord1, Coord2) ou digite sair. para encerrar o jogo.'), nl,
    repetir_ate_comando_valido('X').

iniciar_turno('O', jogador) :-
    write('Sua vez de jogar (Jogador O). Digite um movimento na forma mv(Coord1, Coord2) ou digite sair. para encerrar o jogo.'), nl,
    repetir_ate_comando_valido('O').

iniciar_turno('X', computador) :-
    write('Vez do computador (Jogador X).'), nl,
    realizar_jogada_computador('X'),
    trocar_turno('X', computador).

iniciar_turno('O', computador) :-
    write('Vez do computador (Jogador O).'), nl,
    realizar_jogada_computador('O'),
    trocar_turno('O', computador).

% Realizar jogada do computador
realizar_jogada_computador(Peca) :-
    tabuleiro(Tab),
    encontrar_jogada_valida(Tab, Peca, X1, Y1, X2, Y2),
    (   nonvar(X1), nonvar(Y1), nonvar(X2), nonvar(Y2) ->
        coluna_inv(X1, Col1), linha_inv(Y1, Row1),
        coluna_inv(X2, Col2), linha_inv(Y2, Row2),
        format('Movendo a peca ~w da posicao ~w~w para ~w~w.~n', [Peca, Col1, Row1, Col2, Row2]),
        mover(Tab, X1, Y1, X2, Y2, NovoTab),
        atualizar_tabuleiro(NovoTab),
        mostrar_tabuleiro
    ;   write('Nenhuma jogada disponível para o computador.'), nl
    ).

% Função para encontrar uma jogada válida para o computador
encontrar_jogada_valida(Tab, Peca, X1, Y1, X2, Y2) :-
    between(1, 8, X1),
    between(1, 8, Y1),
    peca_na_posicao(Tab, X1, Y1, Peca),
    between(1, 8, X2),
    between(1, 8, Y2),
    movimento_valido(Peca, X1, Y1, X2, Y2),
    peca_livre(Tab, X2, Y2),
    !. % Encontra a primeira jogada válida e para


% Trocar o turno entre jogadores
trocar_turno('X', jogador) :- iniciar_turno('O', computador).
trocar_turno('O', jogador) :- iniciar_turno('X', computador).
trocar_turno('X', computador) :- iniciar_turno('O', jogador).
trocar_turno('O', computador) :- iniciar_turno('X', jogador).


% Para iniciar o menu e escolher as opções de jogo
:- menuInicial.
