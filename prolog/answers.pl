
% Responde a frases afirmativas
responde_afi([A-O-S-Ms-Mo|Os], R) :-
	Pred =.. [A, S, O], Pred,
	testa_mod(S, Ms),
	testa_mod(O, Mo),
	responde_afi(Os, R).

responde_afi([], ['Sim.']).

responde_afi(_, ['Nao.']).

% Responde a frases interrogativas
responde_int([ql-A-O-M|Os], [ql-R-A-O-M|Rs]) :-
	findall(
		S,
		(Pred =.. [A, S, O], Pred, testa_mod(S, M)),
		R
	),
	responde_int(Os, Rs).

responde_int([qt-A-O-M|Os], [qt-R-A-O-M|Rs]) :-
	findall(
		S,
		(Pred =.. [A, S, O], Pred, testa_mod(S, M)),
		L
	),
	length(L, R),
	responde_int(Os, Rs).

responde_int([], []).

% Escreve a resposta a frases interrogativas qualitativas
escreve_resposta_int([ql-R-A-O-M,ql-R1-A-O-M1|Os], L) :-
	intersection(R, R1, R2),
	append(M, M1, M2),
	escreve_resposta_int([ql-R2-A-O-M2|Os], L).

escreve_resposta_int([ql-R-A-O-[disponibilizar-M]|Os], [L|Ls]) :-
	length(R, N), N > 1,
	escreve_sujeitos_resposta(R, I1),
	escreve_acao_resposta(p, A, O, I2),
	escreve_modificadores_resposta(_, [disponibilizar-M], I3),
	atomic_list_concat([I1,'',I2,' ',I3,'.'], L),
	escreve_resposta_int(Os, Ls).

escreve_resposta_int([ql-R-A-O-M|Os], [L|Ls]) :-
	length(R, N), N > 1,
	escreve_sujeitos_resposta(R, I1),
	escreve_acao_resposta(p, A, O, I2),
	escreve_modificadores_resposta(p, M, I3),
	atomic_list_concat([I1,'',I2,' ',I3,'.'], L),
	escreve_resposta_int(Os, Ls).

escreve_resposta_int([ql-R-A-O-M|Os], [L|Ls]) :-
	escreve_sujeitos_resposta(R, I1),
	escreve_acao_resposta(s, A, O, I2),
	escreve_modificadores_resposta(s, M, I3),
	atomic_list_concat([I1,'',I2,' ',I3,'.'], L),
	escreve_resposta_int(Os, Ls).

% Escreve a resposta quando nao existe qualquer sujeito que corresponda a pergunta
escreve_resposta_int([_-[]-_-O-M|Os], [L|Ls]) :-
	nome(_-s, O, O1, []), format(atom(I2), '~w', O1),
	escreve_modificadores_resposta(s, M, I3),
	atomic_list_concat(['não há nenhum ',I2,' ',I3,'.'], L),
	escreve_resposta_int(Os, Ls).

escreve_resposta_int([_-0-_-O-M|Os], [L|Ls]) :-
	nome(_-s, O, O1, []), format(atom(I2), '~w', O1),
	escreve_modificadores_resposta(s, M, I3),
	atomic_list_concat(['não há nenhum ',I2,' ',I3,'.'], L),
	escreve_resposta_int(Os, Ls).

% Escreve a resposta a frases interrogativas quantitativas
escreve_resposta_int([qt-R-A-O-M,qt-R1-A-O-M1|Os], L) :-
	R2 is min(R, R1),
	append(M, M1, M2),
	escreve_resposta_int([qt-R2-A-O-M2|Os], L).

escreve_resposta_int([qt-R-_-O-M|Os], [L|Ls]) :-
	R > 1, 
	format(atom(I1), '~w ~w', ['há', R]),
	nome(_-p, O, O1, []), format(atom(I2), '~w', O1),
	escreve_modificadores_resposta(p, M, I3),
	atomic_list_concat([I1,' ',I2,' ',I3,'.'], L),
	escreve_resposta_int(Os, Ls).

escreve_resposta_int([qt-R-_-O-M|Os], [L|Ls]) :-
	format(atom(I1), '~w ~w', ['há', R]),
	nome(_-s, O, O1, []), format(atom(I2), '~w', O1),
	escreve_modificadores_resposta(s, M, I3),
	atomic_list_concat([I1,' ',I2,' ',I3,'.'], L),
	escreve_resposta_int(Os, Ls).

escreve_resposta_int([], []).

% Escreve a acao a partir da acao e do objeto
escreve_acao_resposta(N, A, O, L) :-
	local(O),
	verbo(N, A, _, [V|_], _),
	prep(G1-N1, [P|_], _),
	nome(G1-N1, O, C, []),
	formata_sujeito(C, C1),
	format(atom(L), ' ~w ~w ~w', [V, P, C1]).

escreve_acao_resposta(N, A, O, L) :-
	categoria(O, _),
	verbo(N, A, _, [V|_], _),
	nome(_, O, C, []),
	formata_sujeito(C, C1),
	format(atom(L), ' ~w ~w', [V, C1]).

escreve_acao_resposta(N, A, O, L) :-
	verbo(N, A, _, [V|_], _),
	det(G-N, [D|_], _),
	nome(G-N, O, C, []),
	formata_sujeito(C, C1),
	format(atom(L), ' ~w ~w ~w', [V, D, C1]).

% Escreve os modificadores 
escreve_modificadores_resposta(N, [_-[categoria]|Ms], L) :-
	escreve_modificadores_resposta(N, Ms, L).

escreve_modificadores_resposta(N, [A-Args|Ms], L) :-
	( grau_adj(A, _, _) ; grau_comp(A, _, _) ),
	escreve_comparacao_resposta(N, A, Args, I),
	length(Ms, S),
	escreve_modificadores_resposta(S, N, Ms, Is),
	atomic_list_concat([que,I|Is], L).

escreve_modificadores_resposta(N, [A-[Args]|Ms], L) :-
	escreve_acao_resposta(N, A, Args, I),
	length(Ms, S),
	escreve_modificadores_resposta(S, N, Ms, Is),
	atomic_list_concat([que,I|Is], L).

escreve_modificadores_resposta(_, [], '').

escreve_modificadores_resposta(S, N, [_-[categoria]|Ms], L) :-
	S1 is S-1,
	escreve_modificadores_resposta(S1, N, Ms, L).

escreve_modificadores_resposta(1, N, [A-Args|Ms], [L|Ls]) :-
	( grau_adj(A, _, _) ; grau_comp(A, _, _) ),
	escreve_comparacao_resposta(N, A, Args, I),
	atomic_list_concat([' ',e,I], L),
	escreve_modificadores_resposta(0, N, Ms, Ls).

escreve_modificadores_resposta(1, N, [A-[Args]|Ms], [L|Ls]) :-
	escreve_acao_resposta(N, A, Args, I),
	atomic_list_concat([' ',e,I], L),
	escreve_modificadores_resposta(0, N, Ms, Ls).

escreve_modificadores_resposta(S, N, [A-Args|Ms], [L|Ls]) :-
	( grau_adj(A, _, _) ; grau_comp(A, _, _) ),
	escreve_comparacao_resposta(N, A, Args, I),
	atomic_list_concat([',',I], L),
	S1 is S-1,
	escreve_modificadores_resposta(S1, N, Ms, Ls).

escreve_modificadores_resposta(S, N, [A-[Args]|Ms], [L|Ls]) :-
	escreve_acao_resposta(N, A, Args, I),
	atomic_list_concat([',',I], L),
	S1 is S-1,
	escreve_modificadores_resposta(S1, N, Ms, Ls).

escreve_modificadores_resposta(_, _, [], []).

% Escreve comparacao
escreve_comparacao_resposta(N, A, [T-O], L) :-
	verbo(N, ter, _, [V|_], _),
	grau_comp(A, [G|_], _),
	formata_sujeito(O, O1),
	format(atom(L), ' ~w ~w ~w a ~w', [V, T, G, O1]).

% Escreve uma lista de sujeitos para uma frase
% i.e. [[hotel, x], [hotel, y], [hotel, z]] --> hotel x, hotel y e hotel z
escreve_sujeitos_resposta([R|Rs], L) :-
	formata_sujeito(R, R1),
	format(atom(I), '~w', R1),
	length(Rs, S),
	escreve_sujeitos_resposta(S, Rs, Is),
	atomic_list_concat([I|Is], L).

escreve_sujeitos_resposta([R|Rs], L) :-
	format(atom(I), '~w', R),
	length(Rs, S),
	escreve_sujeitos_resposta(S, Rs, Is),
	atomic_list_concat([I|Is], L).

escreve_sujeitos_resposta(1, [R|Rs], [L|Ls]) :-
	formata_sujeito(R, R1),
	format(atom(L), ' e ~w', R1),
	escreve_sujeitos_resposta(0, Rs, Ls).

escreve_sujeitos_resposta(1, [R|Rs], [L|Ls]) :-
	format(atom(L), ' e ~w', R),
	escreve_sujeitos_resposta(0, Rs, Ls).

escreve_sujeitos_resposta(S, [R|Rs], [L|Ls]) :-
	formata_sujeito(R, R1),
	format(atom(L), ', ~w', R1),
	S1 is S-1,
	escreve_sujeitos_resposta(S1, Rs, Ls).

escreve_sujeitos_resposta(S, [R|Rs], [L|Ls]) :-
	format(atom(L), ', ~w', R),
	S1 is S-1,
	escreve_sujeitos_resposta(S1, Rs, Ls).

escreve_sujeitos_resposta(_, [], []).

% Transforma uma lista de nomes que representa um sujeito
% no atmomo correspondente, formatado com espacos
% i.e. [hotel, x] --> hotel x
formata_sujeito([S|Ss], L) :-
	format(atom(I), '~w', S),
	formata_sujeito_aux(Ss, Is),
	atomic_list_concat([I|Is], L).

formata_sujeito_aux([S|Ss], [L|Ls]) :-
	format(atom(L), ' ~w', S),
	formata_sujeito_aux(Ss, Ls).

formata_sujeito_aux([], []).

% Verifica se os modificadores se aplicam ao sujeito Suj
testa_mod(_, []).
testa_mod(S, [A-As|Ms]) :-
	append([A], [S], T), append(T, As, F),
	Pred =.. F,
	Pred,
	testa_mod(S, Ms).

% Obtem o contexto dados os novos modificadores
obtem_contexto(M1, [I-A-O-M]) :-
	contexto([I-A-O1-M2]),
	obtem_novo_objeto(O1, M1, O),
	obtem_novos_modificadores(M1, M2, M).

obtem_contexto(_, _) :-
	assert(erro_sem(2)), fail.

% Obtem o novo objeto dado o antigo e os novos modificadores
obtem_novo_objeto(O1, [_-[O2]|_], O2) :-
	local(O1), local(O2).

obtem_novo_objeto(O1, [_-[O2]|_], O2) :-
	servico(O1), servico(O2).

obtem_novo_objeto(O1, [_|Ms], O2) :-
	obtem_novo_objeto(O1, Ms, O2).

obtem_novo_objeto(O, [], O).

% Obtem os novos modificadores dados os antigos e os novos
obtem_novos_modificadores(M1, M2, M) :-
	descarta_modificadores_repetidos(M1, M2, T),
	append(M1, T, M).

% Remove todos os modificadores antigos que entram em conflito com os novos
descarta_modificadores_repetidos(M, [M1|Ms], L) :-
	testa_conflito_modificador(M1, M),
	descarta_modificadores_repetidos(M, Ms, L).

descarta_modificadores_repetidos(M, [M1|Ms], [M1|Ls]) :-
	descarta_modificadores_repetidos(M, Ms, Ls).

descarta_modificadores_repetidos(_, [], []).

% Se ambos os modificadores forem um local, estao em conflito
testa_conflito_modificador(_-[Args1], [_-[Args2]|_]) :-
	local(Args1), local(Args2).

% Se ambos os modificadores forem um servico, estao em conflito
testa_conflito_modificador(_-[Args1], [_-[Args2]|_]) :-
	servico(Args1), servico(Args2).

testa_conflito_modificador(_-[servico], [_-[servico]|_]).

testa_conflito_modificador(_-[Args1], [_-[servico]|_]) :-
	servico(Args1).

testa_conflito_modificador(_-[servico], [_-[Args2]|_]) :-
	servico(Args2).

% Se ambos os modificadores forem uma comparacao, estao em conflito
testa_conflito_modificador(_-[categoria-_], [_-[categoria-_]|_]).

% Caso contrario, manter o antigo
testa_conflito_modificador(M, [_|Ms]) :-
	testa_conflito_modificador(M, Ms).

testa_conflito_modificador(_, []) :- false.
