:- dynamic(player/2). 				/* player(XPos,YPos) */
:- dynamic(healthpoint/1).			/* healthpoint(Darah) */
:- dynamic(inventory/2).			/* inventory(NamaBarang,Atribut) */
:- dynamic(armor/1).				/* armor(Defense) */
:- dynamic(senjata/3).				/* senjata(Nama,Damage,Ammo) */
:- dynamic(gameMain/1).				/* gameMain(LagiMain) */
:- dynamic(maxInventory/1).			/* maxInventory(Maks) */
:- dynamic(maxHealth/1).			/* maxHealth(Maks) */
:- dynamic(maxArmor/1).				/* maxArmor(Maks) */
:- include('utility.pl').
:- include('barang.pl').

init_player :-
	asserta(gameMain(1)),
	lebarPeta(L),
	tinggiPeta(T),
	random(1,L,X),
	random(1,T,Y),
	asserta(player(X,Y)),
	asserta(healthpoint(100)),
	asserta(senjata(ak47,20,100)),
	asserta(armor(0)),
	asserta(maxInventory(10)),
	asserta(maxHealth(100)),
	asserta(maxArmor(100)).

quit :-
	\+gameMain(_),
	write('Command ini hanya bisa dipakai setelah game dimulai.'), nl,
	write('Gunakan command "start." untuk memulai game.'), nl, !.
quit :-
	retract(player(_,_)),
	retract(healthpoint(_)),
	retract(senjata(_,_,_)),
	retract(armor(_)),
	retract(maxHealth(_)),
	retract(maxArmor(_)),
	retract(maxInventory(_)),
	write('Game selesai.'),nl,
	retract(gameMain(_)),
    retract(deadzone(_)),
    retract(tick(_)),
	retract(lebarPeta(_)),retract(tinggiPeta(_)),
	retractMusuh, retractBarang, retractInventory,retractTerrain,
	!.

retractBarang:-
	\+barang(_,_,_,_,_),
	!.
retractBarang:-
	retract(barang(_,_,_,_,_)),
	retractBarang, !.

retractMusuh:-
	\+musuh(_,_,_,_,_,_),
	!.
retractMusuh:-
	retract(musuh(_,_,_,_,_,_)),
	retractMusuh, !.

retractInventory:-
	\+inventory(_,_),
	!.
retractInventory:-
	retract(inventory(_,_)),
	retractInventory, !.
retractTerrain:-
	\+terrain(_,_,_),
	!.
retractTerrain:-
	retract(terrain(_,_,_)),
	retractTerrain, !.

cekPanjangInv(Panjang) :-
	findall(B,inventory(B,_),ListBanyak),
	length(ListBanyak,Panjang).

addToInventory(_,_) :-
	cekPanjangInv(Panjang),
	maxInventory(Maks),
	(Panjang+1) > Maks,!,fail.
addToInventory(Object,Atribut) :-
	/*Inventory muat*/
	asserta(inventory(Object,Atribut)),!.

delFromInventory(Object,Atribut) :-
	\+inventory(Object,Atribut),!,fail.
delFromInventory(Object,Atribut) :-
	inventory(Object,Atribut),
	retract(inventory(Object,Atribut)),
	!.

equipSenjata(NewSenjata,NewDamage):-
	delFromInventory(NewSenjata,NewDamage),
	retract(senjata(OldSenjata,OldDamage,OldAmmo)),
	asserta(senjata(NewSenjata,NewDamage,0)),
	addToInventory(OldSenjata,OldDamage),
	write('Kamu meletakkan '),write(OldSenjata),
	write(' yang kamu pakai sebelumnya di inventory'),
	masukkanAmmo(OldSenjata, OldAmmo), !.

masukkanAmmo(_, OldAmmo):-
	OldAmmo < 1,write('.'), nl, !.
masukkanAmmo(OldSenjata, OldAmmo):-
	write(' setelah mengeluarkan ammo di dalamnya.'), nl,
	isAmmo(NamaAmmo,_,OldSenjata),
	cekPanjangInv(Panjang),
	maxInventory(Max),
	Panjang < Max ->
	(
		addToInventory(NamaAmmo, OldAmmo),
		write('Kamu meletakkan '),write(NamaAmmo),write(' sebanyak '),
		write(OldAmmo),write(' dari senjata '),write(OldSenjata),
		write(' di inventory.'),nl
	);(
		isAmmo(NamaAmmo,_,OldSenjata),
		write('Kamu mencoba meletakkan '),write(NamaAmmo),write(' sebanyak '),write(OldAmmo),
		write(' dari senjata '),write(OldSenjata),
		write(' di inventory.'),nl,
		write('Tetapi gagal, karena inventory sudah penuh.'), nl,
		write('Setelah memikirkannya kembali, akhirnya kamu menjatuhkannya ke tanah.'), nl,
		between(1,500,Id),\+barang(Id,_,_,_,_),
		player(X,Y),
		asserta(barang(Id,NamaAmmo,X,Y,OldAmmo))
	), !.

useMedicine(Nama,HPRecov):-
	healthpoint(CurHP),
	maxHealth(Max),
	CurHP=:=Max,
	write('HP kamu sudah full.'), nl,
	write('Tapi kamu sudah terlanjur memakai medicinenya.'), nl,
	write('Medicine tesebut akhirnya terbuang sia-sia.'), nl,
	write('Be careful next time hehehe.'), nl,
	delFromInventory(Nama, HPRecov),
	!.

useMedicine(Nama,HPRecov):-
	delFromInventory(Nama, HPRecov),
	healthpoint(CurHP),
	maxHealth(Max),
	NewHP is CurHP + HPRecov,
	BedaHP is Max - CurHP,
	write('HP Awal :(Luar Loop) '), write(CurHP), nl,
	NewHP > Max ->(
		write('Kamu mencoba mengobati dirimu agar lebih fit dari biasanya, tapi gagal.'), nl,
		write('Karena Max HP kamu cuma '), write(Max), write(','), nl,
		write('HP kamu cuma bertambah '),write(BedaHP), write(' dengan menggunakan '),write(Nama), write('.'), nl, 	
		retract(healthpoint(_)),asserta(healthpoint(Max))
	);
	(
		healthpoint(CurHP),
		NewHP is CurHP + HPRecov,
		write('HP Awal :'), write(CurHP), nl,
		write('HP kamu bertambah '),write(HPRecov), write(' dengan menggunakan '),write(Nama), write('.'), nl,
		write('HP kamu sekarang '), write(NewHP), write('.'), nl,
		retract(healthpoint(_)),asserta(healthpoint(NewHP))
	), !.

useAmmo(Nama, Jumlah) :-
	senjata(NamaSenjata,Damage,OldAmmoCount),
	isAmmo(Nama,_,NamaSenjata)->(
		delFromInventory(Nama,Jumlah)->
		NewAmmoCount is OldAmmoCount+Jumlah,
		retract(senjata(_,_,_)),
		asserta(senjata(NamaSenjata,Damage,NewAmmoCount)),
		write('Senjata '),write(NamaSenjata),write(' milikmu telah terisi sebanyak '),
		write(Jumlah),write(' dengan '),write(Nama),write('.'), nl,
		write('Sekarang senjata milikmu berisi ammo sebanyak '),write(NewAmmoCount),write('.'), nl
	);
	(
		senjata(NamaSenjata,Damage,OldAmmoCount),
		write('Kamu mencoba memasukkan '),write(Nama),write(' ke dalam '), write(NamaSenjata), write('.'), nl,
		write('Setelah beberapa saat, barulah kamu tersadar...'), nl,
		write('"Ammo ini hanya bisa dipakai untuk '), write(NamaSenjata), write('"'), nl,
		write('Kamu akhirnya mengembalikan '),write(Nama),write(' ke dalam inventory.'), nl,
		write('Tapi, waktu yang kamu habiskan tidak akan pernah kembali.'), nl
	), !.

equipArmor(Nama,_):-
	armor(CurArmor),
	maxArmor(Max),
	CurArmor=:=Max,
	write('Seluruh armor yang kamu pakai sudah sangat tebal dan menghalangi gerakan.'), nl,
	write('Kamu tidak bisa memakai armor tambahan lagi.'), nl,
	write('Kamu mengembalikan '),write(Nama),write(' ke dalam inventory.'), nl,
	!.
	
equipArmor(Nama, ArmorPoint):-
	armor(CurArmor),
	maxArmor(Max),
	NewArmor is CurArmor+ArmorPoint,
	BedaArmor is Max-CurArmor,
	delFromInventory(Nama, ArmorPoint),
	NewArmor>Max ->(
		write('Kamu mencoba memakai '),write(Nama),write('...'), nl,
		write('Tetapi kamu tidak bisa bergerak ketika memakainya.'), nl,
		write('Akhirnya kamu menghancurkan sebagian dari '),write(Nama),write(' agar bisa bergerak ketika memakainya.'), nl,
		write('Armor kamu hanya bertambah '),write(BedaArmor), write(' dengan menggunakan '),write(Nama), write('.'), nl, 	
		retract(armor(_)),asserta(armor(Max))
	);
	(
		armor(CurArmor),
		NewArmor is CurArmor+ArmorPoint,
		write('Setelah memakai '),write(Nama),write(', kamu merasa lebih kebal serangan.'), nl,
		write('Tepatnya sebanyak '),write(ArmorPoint),write(' armor point.'), nl,
		write('Armor kamu menjadi '),write(NewArmor), write(' armor point.'),nl,
		retract(armor(_)),asserta(armor(NewArmor))
	), !.

kalah :- 
	write('Kamu kalah'),
	quit,
	fail, !.

narrate :-
	narratePlayer,
	write('Kamu melihat sekeliling kamu.'), nl,
	narrateNorth,
	narrateWest,
	narrateEast,
	narrateSouth, !.

narratePlayer :-
	player(X,Y),
	terrain(X,Y,NamaTerrain),
	write('Kamu berada di sebuah '), write(NamaTerrain), write('.'), nl,
	forall(barang(_,NamaBarang,X,Y,_), (
		write('    Di tempat ini, kamu melihat ada sebuah '), write(NamaBarang), write('.'), nl	
	)),
	findall(Id, musuh(Id,X,Y,_,_,_), ListMusuh),
	length(ListMusuh, BanyakMusuh),
	BanyakMusuh>0->(
		write('    Di tempat ini, kamu melihat ada '), write(BanyakMusuh), write(' orang musuh.'), nl	
	);
	(
		write('    Di tempat ini sepertinya tidak ada musuh.'), nl	
	),
	!.

narrateNorth :-
	player(X,Y),
	YNorth is Y-1,
	YNorth>0->(
		terrain(X,YNorth,NamaTerrain),
		write('Di arah utara ada sebuah '), write(NamaTerrain), write('.'), nl,
		forall(barang(_,NamaBarang,X,YNorth,_), (
			write('    Di arah sana, kamu melihat ada sebuah '), write(NamaBarang), write('.'), nl	
		)),
		narrateDeadzone(X,YNorth),
		findall(Id, musuh(Id,X,YNorth,_,_,_), ListMusuh),
		length(ListMusuh, BanyakMusuh),
		BanyakMusuh>0->(
			write('    Di arah sana, kamu melihat ada '), write(BanyakMusuh), write(' orang musuh.'), nl	
		);
		(
			write('')	
		)
	);
	(
		write('Somehow, kamu tidak bisa melihat apapun di arah utara.'), nl,
		write('Apakah ini yang dimaksud dengan ujung dunia ?'), nl
	),
	!.

narrateSouth :-
	player(X,Y),
	tinggiPeta(T),
	YSouth is Y+1,
	YSouth=<T->(
		terrain(X,YSouth,NamaTerrain),
		write('Di arah selatan ada sebuah '), write(NamaTerrain), write('.'), nl,
		forall(barang(_,NamaBarang,X,YSouth,_), (
			write('    Di arah sana, kamu melihat ada sebuah '), write(NamaBarang), write('.'), nl	
		)),
		narrateDeadzone(X,YSouth),
		findall(Id, musuh(Id,X,YSouth,_,_,_), ListMusuh),
		length(ListMusuh, BanyakMusuh),
		BanyakMusuh>0->(
			write('    Di arah sana, kamu melihat ada '), write(BanyakMusuh), write(' orang musuh.'), nl	
		);
		(
			write('')	
		)
	);
	(
		write('Somehow, kamu tidak bisa melihat apapun di arah selatan.'), nl,
		write('Apakah ini yang dimaksud dengan ujung dunia ?'), nl
	),
	!.

narrateWest :-
	player(X,Y),
	XWest is X-1,
	XWest>0->(
		terrain(XWest,Y,NamaTerrain),
		write('Di arah barat ada sebuah '), write(NamaTerrain), write('.'), nl,
		forall(barang(_,NamaBarang,XWest,Y,_), (
			write('    Di arah sana, kamu melihat ada sebuah '), write(NamaBarang), write('.'), nl	
		)),
		narrateDeadzone(XWest,Y),
		findall(Id, musuh(Id,XWest,Y,_,_,_), ListMusuh),
		length(ListMusuh, BanyakMusuh),
		BanyakMusuh>0->(
			write('    Di arah sana, kamu melihat ada '), write(BanyakMusuh), write(' orang musuh.'), nl
		);
		(
			write('')	
		)
	);
	(
		write('Somehow, kamu tidak bisa melihat apapun di arah barat.'), nl,
		write('Apakah ini yang dimaksud dengan ujung dunia ?'), nl
	),
	!.

narrateEast :-
	player(X,Y),
	lebarPeta(L),
	XEast is X+1,
	XEast=<L->(
		terrain(XEast,Y,NamaTerrain),
		write('Di arah timur ada sebuah '), write(NamaTerrain), write('.'), nl,
		forall(barang(_,NamaBarang,XEast,Y,_), (
			write('    Di arah sana, kamu melihat ada sebuah '), write(NamaBarang), write('.'), nl	
		)),
		narrateDeadzone(XEast,Y),
		findall(Id, musuh(Id,XEast,Y,_,_,_), ListMusuh),
		length(ListMusuh, BanyakMusuh),
		BanyakMusuh>0->(
			write('    Di arah sana, kamu melihat ada '), write(BanyakMusuh), write(' orang musuh.'), nl	
		);
		(
			write('')	
		)
	);
	(
		write('Somehow, kamu tidak bisa melihat apapun di arah timur.'), nl,
		write('Apakah ini yang dimaksud dengan ujung dunia ?'), nl
	),
	!.


narrateDeadzone(X,Y) :-
	\+isDeadzone(X,Y), !.
narrateDeadzone(_,_) :-
	write('    Kamu merasakan aura kematian di arah sana.'), nl,
	write('    Sebaiknya tidak pergi kesana....'), nl, !.