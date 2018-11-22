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
	sudahMenang(Menang),Menang == false,
	(
		(tick(T), T mod 10 =:= 0,random(1,3,Banyak),
			generateBarang(Banyak),
			write('Supply drop sudah datang, '),write('ada '),write(Banyak),
			write(' barang di peta jatuh secara acak, cari ya'),nl
		);
		(tick(T), \+(T mod 10 =:= 0))
	),
	retract(tick(T)),
	TBaru is T+1,
	asserta(tick(TBaru)),
	updateMusuh, updatePeta, !.
update :-
	sudahMenang(Menang),Menang == true,
	write('Selamat, kamu menang'),nl,
	quit,!.

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
	generateBarang(5),
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
	retract(player(_,_)),
	retract(healthpoint(_)),
	retract(armorpoint(_)),
	retract(inventory(_)),
	retract(senjata(_)),
	retract(armor(_)),
	retract(peta(_)),
	write('Game selesai.'),nl,
	write('ArigaThanks :3'),!.

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

printPrio(X,Y) :-
	musuh(_,X,Y,_,_,_),!, write('E').
printPrio(X,Y) :-
	isMedicine(Nama,_), barang(_,Nama,X,Y), !, write('O').
printPrio(X,Y) :-
	isSenjata(Nama,_), barang(_,Nama,X,Y), !, write('S').
printPrio(X,Y) :-
	isArmor(Nama,_), barang(_,Nama,X,Y), !, write('A').
printPrio(X,Y) :-
	isAmmo(Nama,_), barang(_,Nama,X,Y), !, write('M').
printPrio(X,Y) :-
	player(X,Y), !, write('P').
printPrio(X,Y) :-
	isDeadzone(X,Y), !, write('X').
printPrio(X,Y) :-
	write('-').

map :-
	gameMain(GM), GM =:= 1,
	peta(X), printList2D(X),!.

status :-
	gameMain(GM), GM =:= 1,
	write('Health           : '),healthpoint(Darah),write(Darah),nl,
	write('Armor            : '),armor(ArmorP),write(ArmorP),nl,
	write('Tipe Senjata     : '),senjata(Sen,Dam,Ammo),write(Sen),nl,
	write('Damage Senjata   : '),write(Dam),nl,
	write('Banyak Ammo      : '),write(Ammo),write(' peluru'),nl,
	write('Inventory        : '),nl,
	inventory(_,_)->
	forall(inventory(Obj,Atribut),
		(
			write('  -'),write(Obj),write(' : '),write(Atribut),
			(
				(isAmmo(Obj,_,_),write(' peluru'));
				(isSenjata(Obj,_),write(' peluru'));
				(isArmor(Obj,_),write(' defense'));
				(isMedicine(Obj,_),write(' HP'))
			),nl
		)
	);(
		write(' Inventory kosong'),nl	
	),
	!.

attack :-
	gameMain(GM), GM =:= 1,
	\+senjata(none,_,_),
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
	senjata(none,_,_),
	write('Butuh senjata untuk menyerang musuh kawanku'),nl,update,!.
/* Inventory */
take(_) :-
	player(X,Y),
	\+barang(_,_,X,Y,_),
	write('Barang yang kamu cari tidak ditemukan'),
	update, !.
take(Object) :-
	player(X,Y),
	barang(Id,Object,X,Y,D),
	!,
	addToInventory(Object,D)->
	(
		retract(barang(Id,Object,X,Y,D)),write('Kamu mengambil 1 '),write(Object),
		write(' dan menaruhnya di inventory'),nl
	);(
		write('Gagal menambahkan karena inventory penuh'),nl
	),
	update, !.


drop(Object) :-
	findall(Atribut,inventory(Object,Atribut),ListObj),
	length(ListObj,Panjang),
	Panjang > 1 ->
	(
		/* Ada banyak, kasih pengguna milih */
		write('Nampaknya ada banyak item yang bernama '),write(Object),write(' di inventorimu'),nl,
		write('Pilih diantara item berikut yang mau kamu drop'),nl,
		forall(between(1,Panjang,I),(
			Idx is I-1,
			write('   '),write(I),write('. '),write(Object),write(' , Atribut : '),
			ambil(ListObj,Idx,C),write(C),nl
		)),
		write('Masukan kode item yang ingin kamu drop (akhiri dengan . ) : '),
		read(Kode),between(1,Panjang,Kode)->
		(
			IdxItem is Kode-1,ambil(ListObj,IdxItem,Atrib),
			delFromInventory(Object,Atrib)->
			between(1,100,Id),\+barang(Id,_,_,_,_),
			player(X,Y),
			asserta(barang(Id,Object,X,Y,Atrib)),
			write('Kamu menjatuhkan 1 '),write(Object),write(' ke tanah'),nl
		);(
			write('Kode tidak valid'),fail,!
		)
	);(
		/* Ada 1 aja atau ngga ada */
		inventory(Object,Atribut),
		delFromInventory(Object,Atribut)->
		(
			between(1,100,Id),\+barang(Id,_,_,_,_),
			player(X,Y),
			asserta(barang(Id,Object,X,Y,Atribut)),
			write('Kamu menjatuhkan 1 '),write(Object),write(' ke tanah'),nl
		);(
			write(Object),write(' harus ada di inventory agar bisa dijatuhkan'),nl
		)
	),
	update,!. 


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

sudahMenang(true) :-
	findall(M,musuh(M,_,_,_,_,_),ListId),
	length(ListId,0),!.
sudahMenang(false).

generateBarang(0) :- !.
generateBarang(Banyak) :-
    (between(1,100,Id),\+barang(Id,_,_,_,_)),
    findall(S,isSenjata(S,_),ListSenjata),
    findall(A,isArmor(A,_),ListArmor),
    findall(O,isMedicine(O,_),ListMedicine),
    findall(M,isAmmo(M,_,_),ListAmmo),
    concatList(ListSenjata,ListArmor,L),
    concatList(L,ListMedicine,L2),
    concatList(L2,ListAmmo,L3),
    length(L3,Panjang),
    random(1,Panjang,X),
    ambil(L3,X,Barang),
    lebarPeta(Le),tinggiPeta(Ti),
	random(1,Le,XPos),random(1,Ti,YPos),
	(
		/* TODO : Randomize D */
		(isSenjata(Barang,D);isArmor(Barang,D);isAmmo(Barang,D,_);isMedicine(Barang,D)),
		asserta(barang(Id,Barang,XPos,YPos,D))
	),
    BanyakBaru is Banyak-1,
    generateBarang(BanyakBaru),!.