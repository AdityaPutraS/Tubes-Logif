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
update :-
	updateMusuh, updatePeta, !.

start :-
	write('PUBG.'),nl,
	write('Game Mulai'),nl,
	init_player,
	init_map,
	init_barang,
	initMusuh(10),
	updatePeta,!. 

help :-
	write('Daftar Command : '),nl,
	write('1. start : memulai permainan.'),nl,
	write('2. map : Menampilkan peta.'),nl,
	write('3. look : Menampilkan peta 3x3 yang lebih detil.'),nl,
	write('4. n : Bergerak kearah Utara(atas).'),nl,
	write('5. e : Bergerak kearah Timur(kanan).'),nl,
	write('6. w : Bergerak kearah Barat(kiri).'),nl,
	write('7. s : Bergerak kearah Selatan(bawah).'),nl,
	write('8. quit : Keluar dari permainan.'),nl,
	write('9. take(object) : Mengambil object pada petak.'),nl,
	write('10. drop(object) : Membuang sebuah object dari inventory.'),nl,
	write('11. use(object) : Menggunakan sebuah object yang dalam inventori.'),nl,
	write('12. attack : Menyerang enemy dalam petak sama.'),nl,
	write('13. status : Melihat status diri.'),nl,
	write('13. save : Menyimpan permainan pemain.'),nl,
	write('14. load : Membuka save-an pemain.'),nl,!.

quit :-
	retractall(_),
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
	write('Gabisa Cok!'),nl,update,!.
n :-
	retract(player(X,Y)),
	Y > 1,
	setPixel(X,Y,'-'),
	YBaru is Y-1,
	setPixel(X,YBaru,'P'),
	asserta(player(X,YBaru)),update,!.
e  :- 
	player(X,_),
	lebarPeta(Le),
	X =:= Le,
	write('Gabisa Cok!'),nl,update,!.
e :-
	retract(player(X,Y)),
	write([X,Y]),nl,
	lebarPeta(Le),
	X < Le,
	setPixel(X,Y,'-'),
	XBaru is X+1,
	setPixel(XBaru,Y,'P'),
	asserta(player(XBaru,Y)),update,!.
w :- 
	player(X,_),
	X =:= 1,
	write('Gabisa Cok!'),nl,update,!.
w :-
	retract(player(X,Y)),
	write([X,Y]),nl,
	X > 1,
	setPixel(X,Y,'-'),
	XBaru is X-1,
	setPixel(XBaru,Y,'P'),
	asserta(player(XBaru,Y)),update,!.
s :- 
	player(_,Y),
	tinggiPeta(Ti),
	Y =:= Ti,
	write('Gabisa Cok!'),nl,update,!.
s :-
	retract(player(X,Y)),
	write([X,Y]),nl,
	tinggiPeta(Ti),
	Y < Ti,
	setPixel(X,Y,'-'),
	YBaru is Y+1,
	setPixel(X,YBaru,'P'),
	asserta(player(X,YBaru)),update,!.
/*-----------------------------*/