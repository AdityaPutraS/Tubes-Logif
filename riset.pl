readData(S,[]) :-
	at_end_of_stream(S), !.

readData(S,[X1|Tail]) :-
	get_char(S,X1),
	readData(S,Tail).

baca_map :-
	open('peta.txt',read,S),
	repeat,
	readData(S,X),
	close(S),
	asserta(peta(X)).
/*
writeData(S,[]) :- !.
writeData(S,[X1|Tail]) :-
	write(S,X1),
	writeData(S,Tail).

write_map(L) :-
	open('peta.txt',write,S),
	repeat,
	writeData(S,L),
	close(S).
*/
printList([]) :- !.
printList([A|Tail]) :-
	write(A), printList(Tail).

map :-
	baca_map,retract(peta(X)), printList(X),!.

main :-
	asserta(player(0,0)),
	asserta(darah(100)),
	asserta(inventory([])),
	asserta(senjata(none)),
	asserta(armor(none)).

n :-
	retract(player(X,Y)), XBaru is X-1, asserta(player(XBaru,Y)).
e :-
	retract(player(X,Y)), YBaru is Y+1, asserta(player(X,YBaru)).


setDarah(Darah) :-
	asserta(darah(Darah)).

kenaSerang(Damage) :-
	retract(darah(X)), XBaru is X-Damage, asserta(darah(XBaru)).
