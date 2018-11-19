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

/* ambil(L,Pos,C) */
ambil([],0,'') :- !.
ambil([C|_],0,C) :- !.
ambil([_|LTail],Pos,C) :- PosBaru is (Pos-1),ambil(LTail,PosBaru,C), !.

/* Print Map */
printList([]) :- !.
printList([A|Tail]) :-
	write(A), printList(Tail).

map :-
	retract(peta(X)), printList(X),asserta(peta(X)),!.
/*-----------------------------*/

start :-
	write('PUBG.'),nl,nl,nl,
	asserta(player(6,5)),
	asserta(darah(100)),
	asserta(inventory([])),
	asserta(senjata(none)),
	asserta(armor(none)),
	asserta(peta([])),
	baca_map,setPixel(6,5,'P'),
	write('yes'),nl.
/* Grafika */
setPixel(X,Y,C) :-
	retract(peta(L)),
	Pos is (X*2 + Y*24),
	change(L,LBaru,C,Pos),
	asserta(peta(LBaru)).
getPixel(X,Y,C) :-
	retract(peta(L)),
	Pos is (X*2 + Y*24),
	ambil(L,Pos,C),
	asserta(peta(L)).
/* Movement */
n :- 
	retract(player(X,Y)),
	asserta(player(X,Y)),
	Y =:= 1,
	write('Gabisa Cok!'),nl, !.
n :-
	retract(player(X,Y)),
	write([X,Y]),nl,
	Y > 1,
	setPixel(X,Y,'-'),
	YBaru is Y-1,
	setPixel(X,YBaru,'P'),
	asserta(player(X,YBaru)),!.
e  :- 
	retract(player(X,Y)),
	asserta(player(X,Y)),
	X =:= 10,
	write('Gabisa Cok!'),nl, !.
e :-
	retract(player(X,Y)),
	write([X,Y]),nl,
	X < 10,
	setPixel(X,Y,'-'),
	XBaru is X+1,
	setPixel(XBaru,Y,'P'),
	asserta(player(XBaru,Y)),!.
w :- 
	retract(player(X,Y)),
	asserta(player(X,Y)),
	X =:= 1,
	write('Gabisa Cok!'),nl, !.
w :-
	retract(player(X,Y)),
	write([X,Y]),nl,
	X > 1,
	setPixel(X,Y,'-'),
	XBaru is X-1,
	setPixel(XBaru,Y,'P'),
	asserta(player(XBaru,Y)),!.
s :- 
	retract(player(X,Y)),
	asserta(player(X,Y)),
	Y =:= 10,
	write('Gabisa Cok!'),nl, !.
s :-
	retract(player(X,Y)),
	write([X,Y]),nl,
	Y < 10,
	setPixel(X,Y,'-'),
	YBaru is Y+1,
	setPixel(X,YBaru,'P'),
	asserta(player(X,YBaru)),!.
/*-----------------------------*/

/* Test Fungsi Attack */
setDarah(Darah) :-
	asserta(darah(Darah)).

kenaSerang(Damage) :-
	retract(darah(X)), XBaru is X-Damage, asserta(darah(XBaru)).
/*-----------------------------*/
