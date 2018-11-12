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

/* Change(LLama,LBaru,C,Indeks). */
change([_|Tail],[C|Tail],C,0) :- !. 
change([A|Tail],[A|LBaru],C,Indeks) :- IndeksBaru is Indeks-1, change(Tail,LBaru,C,IndeksBaru).

/* Print Map */
printList([]) :- !.
printList([A|Tail]) :-
	write(A), printList(Tail).

map :-
	retract(peta(X)), printList(X),!.
/*-----------------------------*/

start :-
	write('PUBG.'),nl,nl,nl,
	asserta(player(5,5)),
	asserta(darah(100)),
	asserta(inventory([])),
	asserta(senjata(none)),
	asserta(armor(none)),
	asserta(peta([])),
	baca_map,setPixel(5,5,'P'),
	write('yes'),nl.
/* Player */
setPixel(X,Y,C) :-
	retract(peta(L)),
	Pos is (Y*20+X),
	change(L,LBaru,C,Pos),
	asserta(peta(LBaru)).

/* Movement */
n :- 
	retract(player(X,Y)),
	X =:= 0,
	asserta(player(X,Y)),
	write('Gabisa Cok!'),nl, !.
n :-
	retract(player(X,Y)),
	write([X,Y]),nl,
	X > 0,
	setPixel(X,Y,'-'),
	XBaru is X-1,
	setPixel(XBaru,Y,'P'),
	asserta(player(XBaru,Y)),!.
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
