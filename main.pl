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
	write(' _____    _    _   ____     _____ '),nl,
	write('|  __ \\  | |  | | |  _ \\   / ____|'),nl,
	write('| |__) | | |  | | | |_) | | |  __'),nl,
	write('|  ___/  | |  | | |  _ <  | | |_ |'),nl,
	write('| |      | |__| | | |_) | | |__| |'),nl,
	write('|_|       \\____/  |____/   \\_____|'),nl,
	write('Game Mulai'),nl,
	write('  _   _          _   _ '),nl,
	write(' | | | |__ __ __| | | |'),nl,
 	write(' | |_| |\\ V  V /| |_| |'),nl,
  write('  \\___/  \\_/\\_/  \\___/ '),nl,
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
	gameMain(GM), GM =:= 1,
	retract(player(_,_)),
	retract(healthpoint(_)),
	retract(armorpoint(_)),
	retract(inventory(_)),
	retract(senjata(_)),
	retract(armor(_)),
	retract(peta(_)),
	write('Game selesai.'),nl,
	retract(gameMain(_)),
	asserta(gameMain(0)),!.

look :-
	gameMain(GM), GM =:= 1,
	player(X,Y),
	XMin is X-1,
	XMax is X+1,
	YMin is Y-1,
	YMax is Y+1,
	forall(between(YMin,YMax,J), (
		forall(between(XMin,XMax,I), (
			printPrio(I,J)
		)),
		nl
	)),
	!.

map :-
	gameMain(GM), GM =:= 1,
	peta(X), printList2D(X),!.

status :-
	gameMain(GM), GM =:= 1,
	write('Health        : '),healthpoint(Darah),write(Darah),nl,
	write('Armor         : '),armorpoint(ArmorP),write(ArmorP),nl,
	write('Senjata Equip : '),senjata(Sen),write(Sen),nl,
	write('Armor Equip   : '),armor(Armor),write(Armor),nl,
	!.

attack :-
	gameMain(GM), GM =:= 1,
	\+senjata(none),
	player(X,Y),
	findall(M,musuh(M,X,Y,_,_,_),ListId),
	\+kosong(ListId),
	length(ListId,BanyakM),
	write('Ada '),write(BanyakM),write(' musuh di petak ini'),nl,
	serangMusuh(ListId),update,!.
attack :-
	gameMain(GM), GM =:= 1,
	player(X,Y),
	findall(M,musuh(M,X,Y,_,_,_),ListId),
	kosong(ListId),
	write('Ga ada musuh buat diserang cok!'),nl,update,!.
attack :-
	gameMain(GM), GM =:= 1,
	senjata(none),
	write('Butuh senjata untuk menyerang musuh kawanku'),nl,update,!.
/* Movement */
n :-
	gameMain(GM), GM =:= 1,
	player(_,Y),
	Y =:= 1,
	write('Gabisa Cok!'),nl,update,!.
n :-
	gameMain(GM), GM =:= 1,
	retract(player(X,Y)),
	Y > 1,
	setPixel(X,Y,'-'),
	YBaru is Y-1,
	setPixel(X,YBaru,'P'),
	asserta(player(X,YBaru)),update,!.
e  :-
	gameMain(GM), GM =:= 1,
	player(X,_),
	lebarPeta(Le),
	X =:= Le,
	write('Gabisa Cok!'),nl,update,!.
e :-
	gameMain(GM), GM =:= 1,
	retract(player(X,Y)),
	write([X,Y]),nl,
	lebarPeta(Le),
	X < Le,
	setPixel(X,Y,'-'),
	XBaru is X+1,
	setPixel(XBaru,Y,'P'),
	asserta(player(XBaru,Y)),update,!.
w :-
	gameMain(GM), GM =:= 1,
	player(X,_),
	X =:= 1,
	write('Gabisa Cok!'),nl,update,!.
w :-
	gameMain(GM), GM =:= 1,
	retract(player(X,Y)),
	write([X,Y]),nl,
	X > 1,
	setPixel(X,Y,'-'),
	XBaru is X-1,
	setPixel(XBaru,Y,'P'),
	asserta(player(XBaru,Y)),update,!.
s :-
	gameMain(GM), GM =:= 1,
	player(_,Y),
	tinggiPeta(Ti),
	Y =:= Ti,
	write('Gabisa Cok!'),nl,update,!.
s :-
	gameMain(GM), GM =:= 1,
	retract(player(X,Y)),
	write([X,Y]),nl,
	tinggiPeta(Ti),
	Y < Ti,
	setPixel(X,Y,'-'),
	YBaru is Y+1,
	setPixel(X,YBaru,'P'),
	asserta(player(X,YBaru)),update,!.
/*-----------------------------*/
