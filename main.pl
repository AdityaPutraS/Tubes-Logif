/* Nama Kelompok : Anti_Wibu_Wibu_Club
	Anggota  :
		Aditya Putra Santosa / 13517013
		Ariel Ansa Razumardi / 13517040
		Ahmad Rizqee Nurhani / 13517058
		Elvina		     / 13517079
*/

/* Include */
:- include('peta.pl').
/*-----------------------------*/
/* Command Biasa */
start :-
	write('PUBG.'),nl,
	write('Game Mulai'),nl,
	init_player,
	updatePeta,!. 

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
	peta(X), printList2D(X),!.

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
	lebarPeta(Le),
	X =:= Le,
	write('Gabisa Cok!'),nl, !.
e :-
	retract(player(X,Y)),
	write([X,Y]),nl,
	lebarPeta(Le),
	X < Le,
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
	tinggiPeta(Ti),
	Y =:= Ti,
	write('Gabisa Cok!'),nl, !.
s :-
	retract(player(X,Y)),
	write([X,Y]),nl,
	tinggiPeta(Ti),
	Y < Ti,
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
