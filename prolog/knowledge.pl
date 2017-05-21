% Verifica se X tem a propriedade Y
ser(_, categoria).
ser(X, hotel) :- hotel(X).
ser(X, servico) :- servico(X).
ser(X, Y) :- local(Y), ficar(X, Y).

categoria([1, estrela], 1).
categoria([2, estrelas], 2).
categoria([3, estrelas], 3).
categoria([4, estrelas], 4).
categoria([5, estrelas], 5).

ficar([hotel, x], porto).
ficar([hotel, y], porto).
ficar([hotel, x], faro).
ficar([hotel, x], paris).

local(porto).
local(faro).
local(paris).

disponibilizar([servico, de, babysitting], [hotel, x]).
disponibilizar([servico, de, quarto], [hotel, x]).

ter(_, categoria).
ter(X, Y) :- servico(Y), disponibilizar(Y, X).

ter([hotel, x], [4, estrelas]).
ter([hotel, y], [2, estrelas]).
ter([hotel, x], [quarto, com, vista, mar]).

servico([servico, de, babysitting]).
servico([servico, de, quarto]).

amenidade([quarto, com, vista, mar]).

hotel([hotel, x]).
hotel([hotel, y]).

% Compara categoria quando Y e uma categoria, i.e [2, estrelas]
% Compara as categorias quando Y e um hotel, i.e [hotel, y]
mais(X, categoria-Y) :-
	categoria(Y, V1),
	hotel(X), ter(X, C), categoria(C, V2),
	V2 > V1.

mais(X, categoria-Y) :-
	hotel(Y), ter(Y, C1), categoria(C1, V1),
	hotel(X), ter(X, C2), categoria(C2, V2),
	V2 > V1.

menos(X, categoria-Y) :-
	categoria(Y, V1),
	hotel(X), ter(X, C), categoria(C, V2),
	V2 < V1.

menos(X, categoria-Y) :-
	hotel(Y), ter(Y, C1), categoria(C1, V1),
	hotel(X), ter(X, C2), categoria(C2, V2),
	V2 < V1.
