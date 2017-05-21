% Simbolos terminais - vocabulario
pronome_int(_-p, ql) --> [quais].
pronome_int(_-s, ql) --> [qual].
pronome_int(_-p, qt) --> [quantos].
pronome_int(_, ql) --> [que].

grau_adj(mais) --> [mais].
grau_adj(menos) --> [menos].

grau_comp(mais) --> [superior, a].
grau_comp(menos) --> [inferior, a].

adjetivo(m-s, caro) --> [caro].
adjetivo(m-p, caro) --> [caros].
adjetivo(f-s, caro) --> [cara].
adjetivo(f-p, caro) --> [caras].
adjetivo(m-s, barato) --> [barato].
adjetivo(m-p, barato) --> [baratos].
adjetivo(f-s, barato) --> [barata].
adjetivo(f-p, barato) --> [baratas].
adjetivo(_-s, paris) --> [parisiense].
adjetivo(_-p, paris) --> [parisienses].

prep(m-s) --> [no].
prep(m-s) --> [do].
prep(f-s) --> [na].
prep(n-s) --> [em].
prep(_) --> [de].
prep(_) --> [com].
prep(m-s) --> [pelo].

det(m-s) --> [o].
det(m-p) --> [os].

verbo(s, ficar, Suj) --> [fica], { hotel(Suj), ! ; assert(erro_sem(1)), fail, ! }.
verbo(p, ficar, Suj) --> [ficam], { hotel(Suj), ! ; assert(erro_sem(1)), fail, ! }.
verbo(s, ter, Suj) --> ([possui] ; [tem]), { hotel(Suj), ! ; assert(erro_sem(1)), fail, ! }.
verbo(p, ter, _) --> [possuem].
verbo(p, ser, _) --> [sao].
verbo(s, ser, _) --> [é].
verbo(s, disponibilizar, _) --> [disponibiliza].
verbo(p, disponibilizar, _) --> [disponibilizados].

nome(m-s, [hotel, x]) --> [hotel, x].
nome(m-s, [hotel, y]) --> [hotel, y].
nome(m-s, porto) --> [porto].
nome(n-s, faro) --> [faro].
nome(n-s, paris) --> [paris].
nome(_, [5, estrelas]) --> ['5', estrelas] ; ['5'].
nome(_, [4, estrelas]) --> ['4', estrelas] ; ['4'].
nome(_, [3, estrelas]) --> ['3', estrelas] ; ['3'].
nome(_, [2, estrelas]) --> ['2', estrelas] ; ['2'].
nome(_, [1, estrela]) --> ['1', estrela] ; ['1'].
nome(m-p, hotel) --> [hoteis].
nome(m-s, hotel) --> [hotel].
nome(f-s, categoria) --> [categoria].
nome(m-p, servico) --> [servicos].
nome(m-s, servico) --> [servico].
nome(m-s, [servico, de, babysitting]) --> [servico, de, babysitting]. 
nome(m-p, [servico, de, babysitting]) --> [servicos, de, babysitting]. 
nome(m-s, [servico, de, quarto]) --> [servico, de, quarto].
nome(m-p, [servico, de, quarto]) --> [servico, de, quartos].
nome(m-s, [quarto, com, vista, mar]) --> [quarto, com, vista, mar].
nome(m-p, [quarto, com, vista, mar]) --> [quartos, com, vista, mar].