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
	sudahMenang(Menang),Menang == true,
	write('Selamat, kamu menang'),nl,
	write('Terimakasih sudah bermain'), nl,
	write('Arigatou! UwU'), nl,
	quit,!.
update :-
	(
		(tick(T), T mod 10 =:= 0,random(1,3,Banyak),
			generateBarang(Banyak),
			write('Supply drop sudah datang, '),write('ada '),write(Banyak),
			write(' barang di peta jatuh secara acak.'),nl,
			write('Carilah! jika kau pikir kau mampu.'), nl
		);
		(tick(T), \+(T mod 10 =:= 0))
	),
	(	
		(tick(T), \+(T mod 15 =:= 14));
		(
			tick(T), T mod 15 =:= 14, 
			deadzone(DZ),
			lebarPeta(L),
			tinggiPeta(Ti),
			LTmin is min(L,Ti),
			MaxDZ is (LTmin div 2) - 1,
			DZ < MaxDZ->(
				incDeadzone,
				write('Kamu mendengar suara yang sangat menyakitkan.'), nl,
				write('Sepertinya dunia telah mengecil lagi.'), nl,
				write('Memandangnya fenomena tersebut dengan sebelah mata, kamu melanjutkan perjalananmu.'),nl
			);
			(
				write('Sepertinya dunia tidak akan lebih mengecil lagi.'), nl	
			)
		)
	),
	retract(tick(T)),
	TBaru is T+1,
	asserta(tick(TBaru)),
	updateMusuh,
	deadzoneDamage,
	deadzoneDamageEnemy,
	narrate, !.


start :-
	gameMain(_),
	write('Kamu tidak bisa memulai game ketika game sudah dimulai.'), nl, !.
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
	help,
	randomize,
	init_map,
	init_player,
	generateBarang(15),
	initMusuh(10),
	!.

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
	write('14. save(filename) : Menyimpan permainan pemain.'),nl,
	write('15. loads(filename) : Membuka save-an pemain.'),nl,
	write('16. help : Menampilkan ini lagi.'),nl,
	write('Catatan : Semua command di atas diakhiri titik (Misal : "help.")'), nl, !.

loads(FileName):-
	\+file_exists(FileName),
	write('File tersebut tidak ada.'), nl, !.
	
loads(FileName):-
	open(FileName, read, Str),
    read_file_lines(Str,Lines),
    close(Str),
    assertaList(Lines), !.

save(_):-
	\+gameMain(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
save(FileName):-
	tell(FileName),
		player(X,Y),
		write(player(X,Y)),write('.'),nl,
		healthpoint(HP),
		write(healthpoint(HP)),write('.'), nl,
		writeSenjata,
		armor(Arm),
		write(armor(Arm)),write('.'), nl,
		maxHealth(Maxh),
		write(maxHealth(Maxh)),write('.'), nl,
		maxArmor(Maxa),
		write(maxArmor(Maxa)),write('.'), nl,
		gameMain(GM),
		write(gameMain(GM)),write('.'), nl,
		deadzone(DZ),
		write(deadzone(DZ)),write('.'), nl,
		tick(Det),
		write(tick(Det)),write('.'), nl,
		lebarPeta(Le),
		write(lebarPeta(Le)),write('.'), nl,
		tinggiPeta(Ti),
		write(tinggiPeta(Ti)),write('.'), nl,
		writeMusuh, writeBarang, writeInventory, writeTerrain,
	told, !.
writeSenjata:-
	\+senjata(_,_,_),
	!.
writeSenjata:-
	senjata(Na,Dam,Am),
	write(senjata(Na,Dam,Am)),write('.'), nl,
	!.
writeBarang:-
	\+barang(_,_,_,_,_),
	!.
writeBarang:-
	forall(barang(Id,Na,X,Y,Atrib),(
		write(barang(Id,Na,X,Y,Atrib)),write('.'), nl
	)), !.

writeMusuh:-
	\+musuh(_,_,_,_,_,_),
	!.
writeMusuh:-
	forall(musuh(Id,Na,X,Y,Atrib,D),(
		write(musuh(Id,Na,X,Y,Atrib,D)),write('.'), nl	
	)), !.

writeInventory:-
	\+inventory(_,_),
	!.
writeInventory:-
	forall(inventory(N,A),(
		write(inventory(N,A)),write('.'), nl	
	)), !.

writeTerrain:-
	\+terrain(_,_,_),
	!.
writeTerrain:-
	forall(terrain(X,Y,Na),(
		write(terrain(X,Y,Na)),write('.'), nl	
	)), !.

look :-
	\+gameMain(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
look :-
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
	write('Keterangan Simbol :'), nl,
	write('P    :    Player'), nl,
	write('E    :    Enemy'), nl,
	write('S    :    Senjata'), nl,
	write('M    :    Ammo'), nl,
	write('O    :    Medicine'), nl,
	write('B    :    Bag'), nl,
	write('A    :    Armor'), nl,
	write('+    :    Border'), nl,
	write('X    :    Deadzone'), nl,
	write('-    :    Nothing of interest'), nl,
	!.


map :-
	\+gameMain(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
map :-
	tinggiPeta(T),
	lebarPeta(L),
	XMin is 0,
	XMax is L+1,
	YMin is 0,
	YMax is T+1,
	forall(between(YMin,YMax,J), (
		forall(between(XMin,XMax,I), (
			printMap(I,J)
		)),
		nl
	)),
	write('Keterangan Simbol :'), nl,
	write('P    :    Player'), nl,
	write('+    :    Border'), nl,
	write('X    :    Deadzone'), nl,
	write('-    :    Nothing of interest'), nl,
	!.


status :-
	\+gameMain(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
status :-
	write('Health             : '),healthpoint(Darah),write(Darah),nl,
	write('Armor              : '),armor(ArmorP),write(ArmorP),nl,
	write('Tipe Senjata       : '),senjata(Sen,Dam,Ammo),write(Sen),nl,
	write('Damage Senjata     : '),write(Dam),nl,
	write('Banyak Ammo        : '),write(Ammo),write(' peluru'),nl,
	write('Kapasitas inventory: '),maxInventory(MaxInv),write(MaxInv),write(' barang'), nl,
	write('Isi inventory      : '),nl,
	inventory(_,_)->(
		forall(inventory(Obj,Atribut),
		(
			write('  -'),write(Obj),write(' : '),write(Atribut),
			(
				(isAmmo(Obj,_,_),write(' peluru'));
				(isSenjata(Obj,_),write(' damage'));
				(isArmor(Obj,_),write(' defense'));
				(isMedicine(Obj,_),write(' HP'));
				(isBag(Obj,_),write(' barang'))
			),nl
		))
	);(
		write(' Inventory kosong'),nl	
	),
	!.

attack :-
	\+gameMain(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
attack :-
	\+senjata(none,_,_),
	player(X,Y),
	findall(M,musuh(M,X,Y,_,_,_),ListId),
	\+kosong(ListId),
	length(ListId,BanyakM),
	terrain(X,Y,Ter),
	write('Kamu mencoba menembak '),write(BanyakM),write(' musuh yang berada di '),write(Ter),write(' tersebut.'),nl,
	serangMusuh(ListId),update,!.
attack :-
	player(X,Y),
	findall(M,musuh(M,X,Y,_,_,_),ListId),
	kosong(ListId),
	write('Kamu mencari musuh untuk diserang selama beberapa saat...'),nl,
	write('Kamu tidak menemukan musuh sama sekali dan hanya membuang waktu.'),nl,update,!.
attack :-
	senjata(none,_,_),
	write('Kamu mau mencoba melawan musuh bersenjata jarak jauh mematikan dengan tangan kosong?!'),nl,
	write('Tidak ada yang melarang, tapi, tapi....'),nl,update,!.
/* Inventory */
take(_) :-
	\+gameMain(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
take(Object) :-
	player(X,Y), 
	\+barang(_,Object,X,Y,_), !,
	terrain(X,Y,Ter),
	write('Kamu mencoba mencari '),write(Object),write(' di seluruh penjuru '),write(Ter),write(' tersebut.'), nl,
	write('Setelah pencarian yang lama.......'), nl,
	write('Kamu tidak menemukan apapun, melainkan kehilangan waktu yang berharga.'), nl,
	update, !.
take(Object) :-
	player(X,Y),
	barang(Id,Object,X,Y,D),
	!,
	addToInventory(Object,D)->
	(
		retract(barang(Id,Object,X,Y,D)),write('Kamu mengambil 1 '),write(Object),
		write(' dan menaruhnya di inventory'),nl, update, !
	);(
		write('Kamu mencoba memaksakan masuk '), write(Object), write(' ke dalam inventory dengan harapan,'), nl,
		write('"Satu barang lagi harusnya tidak masalah, iya kan?"'),nl,
		write('Tapi sayangnya, yang kamu dapatkan dari perjuangan tersebut hanyalah harapan yang lenyap.'),nl
	),
	update, !.

drop(_) :-
	\+gameMain(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
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
		write('Masukan kode item yang ingin kamu drop (akhiri dengan . misal : "1.") : '),
		read(Kode),between(1,Panjang,Kode)->
		(
			IdxItem is Kode-1,ambil(ListObj,IdxItem,Atrib),
			delFromInventory(Object,Atrib)->
			between(1,500,Id),\+barang(Id,_,_,_,_),
			player(X,Y),
			asserta(barang(Id,Object,X,Y,Atrib)),
			write('Kamu menjatuhkan 1 '),write(Object),write(' ke tanah.'),nl,
			update, !
		);(
			write('Kode tidak valid'),fail,!
		)
	);(
		/* Ada 1 aja atau ngga ada */
		inventory(Object,Atribut),
		delFromInventory(Object,Atribut)->
		(
			between(1,500,Id),\+barang(Id,_,_,_,_),
			player(X,Y),
			asserta(barang(Id,Object,X,Y,Atribut)),
			write('Kamu menjatuhkan 1 '),write(Object),write(' ke bawah, dengan harapan tidak akan disalahgunakan'),nl
		);(
			write('Kamu mencari-cari '),write(Object),write(' di dalam inventory.'), nl,
			write('Akhirnya kamu tersadar kalau sebenarnya kamu tidak memiliki barang tersebut.'),nl
		)
	),
	update,!. 

use(_) :-
	\+gameMain(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
use(Object) :-
	findall(Atribut,inventory(Object,Atribut),ListObj),
	length(ListObj,Panjang),
	Panjang > 1 ->
	(
		/* Ada banyak, kasih pengguna milih */
		write('Nampaknya ada banyak item yang bernama '),write(Object),write(' di inventorimu'),nl,
		write('Pilih diantara item berikut yang mau kamu use'),nl,
		forall(between(1,Panjang,I),(
			Idx is I-1,
			write('   '),write(I),write('. '),write(Object),write(' , Atribut : '),
			ambil(ListObj,Idx,C),write(C),nl
		)),
		write('Masukan kode item yang ingin kamu use (akhiri dengan . misal : "1.") : '),
		read(Kode),between(1,Panjang,Kode)->(
			IdxItem is Kode-1,ambil(ListObj,IdxItem,Atrib),
			(
				(isAmmo(Object,_,_),useAmmo(Object,Atrib));
				(isSenjata(Object,_),equipSenjata(Object,Atrib));
				(isArmor(Object,_),equipArmor(Object,Atrib));
				(isMedicine(Object,_),useMedicine(Object,Atrib));
				(isBag(Object,_),equipBag(Object,Atrib))
			),
			update, !
		);
		(
			write('Kode tidak valid'),fail,!
		)
	);
	(
		/* Ada 1 aja atau ngga ada */
		inventory(Object,Atribut)->(
			(isAmmo(Object,_,_),useAmmo(Object,Atribut));
			(isSenjata(Object,_),equipSenjata(Object,Atribut));
			(isArmor(Object,_),equipArmor(Object,Atribut));
			(isMedicine(Object,_),useMedicine(Object,Atribut));
			(isBag(Object,_),equipBag(Object,Atribut))
		);
		(
			write('Kamu tidak memiliki '),write(Object),write('.'),nl,
			write('Mungkin kamu bisa use sesuatu yang memang kamu miliki.'), nl,
			write('Seperti mungkin, ensephalon yang ada pada kepalamu itu.'), nl
		)
	),
	update,!.


/* Movement */
n :-
	\+gameMain(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
n :-
	player(_,Y),
	Y =:= 1,
	write('Kamu tidak bisa melihat apapun di utara, namun kamu tetap mencoba berjalan kesana.'),nl,
	write('Setelah sekian lama berjalan, kamu tersadar bahwa sekeliling kamu tidak pernah berubah sedikit pun.'),nl,
	write('Akhirnya kamu memutuskan untuk berhenti mencoba.'),nl,update,!.
n :-
	retract(player(X,Y)),
	Y > 1,
	YBaru is Y-1,
	write([X,YBaru]),nl,
	asserta(player(X,YBaru)),update,!.
e :-
	\+gameMain(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
e  :-
	player(X,_),
	lebarPeta(Le),
	X =:= Le,
	write('Kamu tidak bisa melihat apapun di timur, namun kamu tetap mencoba berjalan kesana.'),nl,
	write('Setelah sekian lama berjalan, kamu tersadar bahwa sekeliling kamu tidak pernah berubah sedikit pun.'),nl,
	write('Akhirnya kamu memutuskan untuk berhenti mencoba.'),nl,update,!.
e :-
	retract(player(X,Y)),
	lebarPeta(Le),
	X < Le,
	XBaru is X+1,
	write([XBaru,Y]),nl,
	asserta(player(XBaru,Y)),update,!.
w :-
	\+gameMain(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
w :-
	player(X,_),
	X =:= 1,
	write('Kamu tidak bisa melihat apapun di barat, namun kamu tetap mencoba berjalan kesana.'),nl,
	write('Setelah sekian lama berjalan, kamu tersadar bahwa sekeliling kamu tidak pernah berubah sedikit pun.'),nl,
	write('Akhirnya kamu memutuskan untuk berhenti mencoba.'),nl,update,!.
w :-
	retract(player(X,Y)),
	X > 1,
	XBaru is X-1,
	write([XBaru,Y]),nl,
	asserta(player(XBaru,Y)),update,!.
s :-
	\+gameMain(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
s :-
	player(_,Y),
	tinggiPeta(Ti),
	Y =:= Ti,
	write('Kamu tidak bisa melihat apapun di selatan, namun kamu tetap mencoba berjalan kesana.'),nl,
	write('Setelah sekian lama berjalan, kamu tersadar bahwa sekeliling kamu tidak pernah berubah sedikit pun.'),nl,
	write('Akhirnya kamu memutuskan untuk berhenti mencoba.'),nl,update,!.
s :-
	retract(player(X,Y)),
	tinggiPeta(Ti),
	Y < Ti,
	YBaru is Y+1,
	write([X,YBaru]),nl,
	asserta(player(X,YBaru)),update,!.
/*-----------------------------*/

sudahMenang(true) :-
	findall(M,musuh(M,_,_,_,_,_),ListId),
	length(ListId,0),!.
sudahMenang(false).

generateBarang(0) :- !.
generateBarang(Banyak) :-
    (between(1,500,Id),\+barang(Id,_,_,_,_)),
    findall(S,isSenjata(S,_),ListSenjata),
    findall(A,isArmor(A,_),ListArmor),
    findall(O,isMedicine(O,_),ListMedicine),
	findall(M,isAmmo(M,_,_),ListAmmo),
	findall(B,isBag(B,_),ListBag),
    concatList(ListSenjata,ListArmor,L),
    concatList(L,ListMedicine,L2),
	concatList(L2,ListAmmo,L3),
	concatList(L3,ListBag,L4),
    length(L4,Panjang),
    random(1,Panjang,X),
    ambil(L4,X,Barang),
    lebarPeta(Le),tinggiPeta(Ti),
	random(1,Le,XPos),random(1,Ti,YPos),
	(
		/* TODO : Randomize D */
		(isSenjata(Barang,D);isArmor(Barang,D);isAmmo(Barang,D,_);isMedicine(Barang,D);isBag(Barang,D)),
		asserta(barang(Id,Barang,XPos,YPos,D))
	),
    BanyakBaru is Banyak-1,
    generateBarang(BanyakBaru),!.