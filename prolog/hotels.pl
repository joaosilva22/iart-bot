:- dynamic erro_sem/1.
:- dynamic contexto/1.

:- [terminals, knowledge, input, answers].

% Ponto de entrada
q(S, R) :-
	parse_input(S, L),
	inicio(R, L, []).

% Inicio da gramatica
inicio(R) --> 
	afirmativa(L),
	{ responde_afi(L, R) }.

inicio(R) -->
	interrogativa(L),
	{ responde_int(L, T), retractall(contexto(_)), assert(contexto(L)), escreve_resposta_int(T, R) }.

inicio(M) -->
	{ contexto(_) ; assert(erro_sem(2)), fail },
	aditiva_sem_contexto(M).

inicio('Erro semântico.', _, _) :- 
	erro_sem(1),
	retractall(erro_sem(_)).

inicio('Erro semântico (Falta de contexto).', _, _) :-
	erro_sem(2),
	retractall(erro_sem(_)).

inicio('Erro sintático.', _, _) :-
	retractall(erro_sem(_)).

% Processa frases afirmativas
afirmativa([ser-S-S-Ms-Mo|Os]) -->
	sintagma_nominal(_-N, S, Ms),
	verbo(N, ser, S),
	modificador(S, Mo, _-N),
	aditiva(N, ser, S, Os).

afirmativa([A-O-S-Ms-Mo|Os]) -->
	sintagma_nominal(_-N, S, Ms),
	sintagma_verbal(N, A, O, S, Mo),
	aditiva(N, A, S, Os).


 % Processa frases interrogativas
interrogativa([I-A-O-M|Os]) -->
	pronome_int(_-N, I),
	sintagma_verbal(N, A, O, _, M),
	aditiva_int(N, I, A, O, Os).

interrogativa([I-ser-O-M|Os]) -->
	pronome_int(G-N, I),
	sintagma_nominal(G-N, O, M),
	aditiva_int(N, I, ser, O, Os).

interrogativa([I-ser-servico-[A-[M]]|Os]) -->
	pronome_int(G-N, I),
	nome(G-N, servico),
	sintagma_verbal(N1, A, M, _, _),
	aditiva_int(N1, I, A, servico, Os).

interrogativa([I-ser-O-M|Os]) -->
	pronome_int(G-N, I),
	sintagma_nominal(G-N, O, M1),
	sintagma_verbal(N1, A, M2, _, M3), 
	{ append([A-[M2]], M3, M4), append(M1, M4, M) },
	aditiva_int(N1, I, A, O, Os).

% Processa frases aditivas sem contexto
aditiva_sem_contexto(R) -->
	[e],
	modificador(_, M, _),
	{ obtem_contexto(M, L), responde_int(L, T), escreve_resposta_int(T, R), retractall(contexto(_)), assert(contexto(L)) }.

% Processa frases aditivas interrogativas
aditiva_int(_, _, _, _, [I-A-O-M|Os]) -->
	[e],
	pronome_int(_-N, I),
	sintagma_verbal(N, A, O, _, M),
	aditiva_int(N, I, A, O, Os).

aditiva_int(_, _, _, _, [I-ser-O-M|Os]) -->
	[e],
	pronome_int(G-N, I),
	sintagma_nominal(G-N, O, M),
	aditiva_int(N, I, ser, O, Os).

aditiva_int(_, I, A, _, [I-A-O-M|Os]) -->
	[e],
	nome(G-N, O),
	comparacao(O, M, G-N),
	aditiva_int(_, I, A, O, Os).

aditiva_int(_, I, A, O, [I-A-O-M|Os]) -->
	[e],
	modificador(_, M, _),
	aditiva_int(_, I, A, O, Os).

aditiva_int(N, I, _, _, [I-A-O-M|Os]) -->
	[e],
	sintagma_verbal(N, A, O, _, M),
	aditiva_int(N, I, A, O, Os).

aditiva_int(_, I, A, O, [I-A-O-[ter-[O1]|M]|Os]) -->
	[e],
	sintagma_nominal(_, O1, M),
	{ servico(O1) ; amenidade(O1) },
	aditiva_int(_, I, A, O, Os).

aditiva_int(_, I, A, _, [I-A-O-M|Os]) -->
	[e],
	sintagma_nominal(_, O, M),
	aditiva_int(_, I, A, O, Os).

aditiva_int(_, _, _, _, []) -->
	{ true }.

% Processa frases aditivas afirmativas
aditiva(N, _, S, [A-O-S-Ms-[]|Os]) -->
	[e],
	sintagma_verbal(N, A, O, S, Ms),
	aditiva(N, A, S, Os).

aditiva(_, _, _, [A-O-S-Ms-Mo|Os]) -->
	[e],
	sintagma_nominal(_-N, S, Ms),
	sintagma_verbal(N, A, O, S, Mo),
	aditiva(N, A, S, Os).

aditiva(N, A, S, [A-O-S-[]-Mo|Os]) -->
	[e],
	(prep(G1-N1) ; { true }),
	sintagma_nominal(G1-N1, O, Mo),
	aditiva(N, A, S, Os).

aditiva(_, _, _, []) --> 
	{ true }.

% Processa sintagmas nominais
sintagma_nominal(G-N, S, M) --> 
	det(G-N),
	nome(G-N, S),
	modificador(S, M, G-N).

sintagma_nominal(G-N, S, M) --> 
	nome(G-N, S),
	modificador(S, M, G-N).

% Processa sintagmas verbais
sintagma_verbal(N, A, O, S, M) --> 
	verbo(N, A, S),
	sintagma_nominal(_, O, M).

sintagma_verbal(N, A, O, S, M) -->
	verbo(N, A, S),
	comparacao_de(O, M, _).

sintagma_verbal(N, A, O, S, M) --> 
	verbo(N, A, S),
	prep(G1-N1),
	sintagma_nominal(G1-N1, O, M).

% Processa comparacoes
comparacao(_, [Comp-[P-M]|Ms], G-N) -->
	grau_adj(Comp),
	adjetivo(G-N, P),
	[que],
	(det(G1-N1), {true}),
	nome(G1-N1, M),
	modificador(P, Ms, G1-N1).

comparacao(P, [Comp-[P-M], Comp1-[P-M1]|Ms], _) -->
	grau_comp(Comp),
	nome(_, M),
	[e],
	grau_comp(Comp1),
	nome(G2-N2, M1),
	modificador(M1, Ms, G2-N2).

comparacao(P, [Comp-[P-M]|Ms], _) -->
	grau_comp(Comp),
	nome(G1-N1, M),
	modificador(M, Ms, G1-N1).

% Processa modificadores
modificador(P, Os, G-N) -->
	comparacao(P, Os, G-N).

modificador(_, Os, _) -->
	prep(_),
	comparacao_de(_, Os, _).

modificador(_, [A-[M]|Ms], G-N) --> 
	[que],
	verbo(_, A, _), 
	(prep(G1-N1) ; { true }),
	nome(G1-N1, M),
	modificador(M, Ms, G-N).

modificador(_, [ter-[M]|Ms], G-N) -->
	[com],
	nome(_, M),
	modificador(M, Ms, G-N).

modificador(_, [ser-[M]|Ms], G-N) --> 
	prep(G1-N1),
	nome(G1-N1, M), 
	modificador(M, Ms, G-N).

modificador(_, [ser-[M]|Ms], G-N) -->
	adjetivo(G-N, M),
	modificador(M, Ms, G-N). 

modificador(_, [], _) --> 
	{ true }.

comparacao_de(categoria, [Comp-[categoria-M]|Ms], _) -->
	grau_adj(Comp),
	[de],
	( [que] ; {true} ),
	nome(_, M),
	{ categoria(M, _) },
	[e],
	comparacao_de(_, Ms, _).

comparacao_de(categoria, [Comp-[categoria-M]|Ms], _) -->
	grau_adj(Comp),
	[de],
	( [que] ; {true} ),
	nome(G-N, M),
	{ categoria(M, _) },
	modificador(M, Ms, G-N).