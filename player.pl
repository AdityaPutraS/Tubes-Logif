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

init_player :-
	asserta(gameMain(1)),
	asserta(player(6,5)),
	asserta(healthpoint(100)),
	asserta(senjata(ak47,20,100)),
	asserta(armor(0)),
	asserta(maxInventory(10)),
	asserta(maxHealth(100)),
	asserta(maxArmor(100)).

quit :-
	gameMain(GM), GM =:= 1,
	retract(player(_,_)),
	retract(healthpoint(_)),
	inventory(_,_)->retract(inventory(_,_));!,
	retract(senjata(_,_,_)),
	retract(armor(_)),
	retract(maxHealth(_)),
	retract(maxArmor(_)),
	retract(maxInventory(_)),
	peta(_)->retract(peta(_));!,
	write('Game selesai.'),nl,
	retract(gameMain(_)),
	asserta(gameMain(0)),!.

cekPanjangInv(Panjang) :-
	findall(B,inventory(B,_),ListBanyak),
	length(ListBanyak,Panjang).

addToInventory(_,_) :-
	cekPanjangInv(Panjang),
	maxInventory(Maks),
	(Panjang+1) >= Maks,!,fail.
addToInventory(Object,Atribut) :-
	/*Inventory muat*/
	asserta(inventory(Object,Atribut)),!.

delFromInventory(Object,Atribut) :-
	\+inventory(Object,Atribut),!,fail.
delFromInventory(Object,Atribut) :-
	inventory(Object,Atribut),
	retract(inventory(Object,Atribut)),
	!.

kalah :- 
	write('Kamu kalah cok'),
	quit,!.