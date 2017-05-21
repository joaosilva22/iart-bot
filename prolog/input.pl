parse_input(Str, Atoms) :-
	string_to_list(Str, Asciis),
	trim_punctuation(Asciis, Trim),
	split_string(Trim, " ", " ", Split),
	parse_atoms(Split, Atoms).

parse_atoms([],[]).
parse_atoms([S|Ss],[A|As]):-
	downcase_atom(S,A),
	parse_atoms(Ss, As).

trim_punctuation([],[]).
trim_punctuation([33|As], T) :- trim_punctuation(As, T).
trim_punctuation([34|As], T) :- trim_punctuation(As, T).
trim_punctuation([35|As], T) :- trim_punctuation(As, T).
trim_punctuation([36|As], T) :- trim_punctuation(As, T).
trim_punctuation([37|As], T) :- trim_punctuation(As, T).
trim_punctuation([38|As], T) :- trim_punctuation(As, T).
trim_punctuation([39|As], T) :- trim_punctuation(As, T).
trim_punctuation([40|As], T) :- trim_punctuation(As, T).
trim_punctuation([41|As], T) :- trim_punctuation(As, T).
trim_punctuation([42|As], T) :- trim_punctuation(As, T).
trim_punctuation([43|As], T) :- trim_punctuation(As, T).
trim_punctuation([44|As], T) :- trim_punctuation(As, T).
trim_punctuation([45|As], T) :- trim_punctuation(As, T).
trim_punctuation([46|As], T) :- trim_punctuation(As, T).
trim_punctuation([47|As], T) :- trim_punctuation(As, T).
trim_punctuation([58|As], T) :- trim_punctuation(As, T).
trim_punctuation([59|As], T) :- trim_punctuation(As, T).
trim_punctuation([60|As], T) :- trim_punctuation(As, T).
trim_punctuation([61|As], T) :- trim_punctuation(As, T).
trim_punctuation([62|As], T) :- trim_punctuation(As, T).
trim_punctuation([62|As], T) :- trim_punctuation(As, T).
trim_punctuation([63|As], T) :- trim_punctuation(As, T).
trim_punctuation([64|As], T) :- trim_punctuation(As, T).
trim_punctuation([91|As], T) :- trim_punctuation(As, T).
trim_punctuation([92|As], T) :- trim_punctuation(As, T).
trim_punctuation([93|As], T) :- trim_punctuation(As, T).
trim_punctuation([94|As], T) :- trim_punctuation(As, T).
trim_punctuation([95|As], T) :- trim_punctuation(As, T).
trim_punctuation([96|As], T) :- trim_punctuation(As, T).
trim_punctuation([123|As], T) :- trim_punctuation(As, T).
trim_punctuation([124|As], T) :- trim_punctuation(As, T).
trim_punctuation([125|As], T) :- trim_punctuation(As, T).
trim_punctuation([126|As], T) :- trim_punctuation(As, T).
trim_punctuation([A|As], [A|T]) :- trim_punctuation(As, T).