/* Nama Kelompok : Anti_Wibu_Wibu_Club
	Anggota  :
		Aditya Putra Santosa / 13517013
		Ariel Ansa Razumardi / 13517040
		Ahmad Rizqee Nurhani / 13517058
		Elvina		     / 13517079
*/

/* Include */
:- include('file_eksternal.pl').
:- include('utility.pl').
:- include('barang.pl').
:- include('musuh.pl').
:- include('player.pl').
/*-----------------------------*/
:- dynamic(peta/1).

init_map :-
	baca_file('peta.txt',P),
	retract(peta(_)),
	asserta(peta(P)),
	player(X,Y),
	setPixel(X,Y,'P').
/*-----------------------------*/
/* Command Biasa */
start :-
	write('PUBG.'),nl,
	write('Game Mulai'),nl,
	init_player,
	init_map,!. 

help :-
	write('Daftar Command : '),nl,
	write('1. start : memulai permainan.'),nl,!.

quit :-
	retract(player(_,_)),
	retract(healthpoint(_)),
	retract(armorpoint(_)),
	retract(inventory(_)),
	retract(senjata(_)),
	retract(armor(_)),
	retract(peta(_)),
	write('Game selesai.'),nl,!.

look :-
	!.


map :-
	peta(X), printList(X),!.

/* Grafika */
setPixel(X,Y,C) :-
	retract(peta(L)),
	Pos is (X*2 + Y*24),
	change(L,LBaru,C,Pos),
	asserta(peta(LBaru)).
getPixel(X,Y,C) :-
	peta(L),
	Pos is (X*2 + Y*24),
	ambil(L,Pos,C).
getObjek(X,Y,'Musuh') :- !.
	/*musuh(Id,XPos,YPos,Damage,Health,ItemDrop),!.*/
/* Movement */
n :- 
	player(_,Y),
	Y =:= 1,
	write('Gabisa Cok!'),nl, !.
n :-
	retract(player(X,Y)),
	Y > 1,
	setPixel(X,Y,'-'),
	YBaru is Y-1,
	setPixel(X,YBaru,'P'),
	asserta(player(X,YBaru)),!.
e  :- 
	player(X,_),
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
	player(X,_),
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
	player(_,Y),
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
