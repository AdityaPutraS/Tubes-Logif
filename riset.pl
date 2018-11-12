/* Nama Kelompok : Anti_Wibu_Wibu_Club
	Anggota  :
		Aditya Putra Santosa / 13517013
		Ariel Ansa Razumardi / 13517040
		Ahmad Rizqee Nurhani / 13517058
		Elvina		     / 13517079
*/

/* Hasil Riset Asistensi 1 */

/* Buat baca data dari peta.txt */
readData(S,[]) :-
	at_end_of_stream(S), !.

readData(S,[X1|Tail]) :-
	get_char(S,X1),
	readData(S,Tail).

baca_map :-
	retract(peta(_)),
	open('peta.txt',read,S),
	repeat,
	readData(S,X),
	close(S),
	asserta(peta(X)).
/*-----------------------------*/

/* Buat nulis data ke peta.txt */
writeData(_,[]) :- !.
writeData(S,[X1|Tail]) :-
	write(S,X1),
	writeData(S,Tail).

write_map(L) :-
	open('peta.txt',write,S),
	repeat,
	writeData(S,L),
	close(S).
/*-----------------------------*/

search([],_,-1) :- !.
search([C|_],C,0) :- !.
search([_|Tail],C,IndexBaru) :-  search(Tail,C,Index),IndexBaru is Index+1.

change([],_,_) :- !.

/* Print Map */
printList([]) :- !.
printList([A|Tail]) :-
	write(A), printList(Tail).

map :-
	baca_map,retract(peta(X)), printList(X),!.
/*-----------------------------*/

start :-
	write('PUBG.'),nl,nl,nl,
	write('yes'),nl,
	asserta(player(0,0)),
	asserta(darah(100)),
	asserta(inventory([])),
	asserta(senjata(none)),
	asserta(armor(none)),
	asserta(peta([])).

/* Movement */
n :-
	retract(player(X,Y)), XBaru is X-1, asserta(player(XBaru,Y)).
e :-
	retract(player(X,Y)), YBaru is Y+1, asserta(player(X,YBaru)).
w :-
	retract(player(X,Y)), YBaru is Y-1, asserta(player(X,YBaru)).
s :-
	retract(player(X,Y)), XBaru is X+1, asserta(player(XBaru,Y)).
/*-----------------------------*/

/* Test Fungsi Attack */
setDarah(Darah) :-
	asserta(darah(Darah)).

kenaSerang(Damage) :-
	retract(darah(X)), XBaru is X-Damage, asserta(darah(XBaru)).
/*-----------------------------*/
