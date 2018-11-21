:- dynamic(player/2).
:- dynamic(healthpoint/1).
:- dynamic(armorpoint/1).
:- dynamic(inventory/1).
:- dynamic(armor/1).
:- dynamic(senjata/1).
:- dynamic(gameMain/1).

init_player :-
	asserta(gameMain(1)),
	asserta(player(6,5)),
	asserta(healthpoint(100)),
	asserta(armorpoint(0)),
	asserta(inventory([])),
	asserta(senjata(ak47)),
	asserta(armor(none)).

kalah :- 
	retract(gameMain(_)),
	asserta(gameMain(0)),!.