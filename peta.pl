:- include('file_eksternal.pl').
:- include('musuh.pl').
/* Deadzone, terrain dll */
:- dynamic(deadzone/1).
:- dynamic(lebarPeta/1).
:- dynamic(tinggiPeta/1).
:- dynamic(peta/1).

init_map :-
    baca_file('peta.txt',P),
    splitList(P,'\n',PBaru),
    asserta(peta(P)),
	retract(peta(_)),
    asserta(peta(PBaru)),!.

setPixel(X,Y,C) :-
    peta(P),
    ambil(P,Y,PBaris),
    change(PBaris,PBarisBaru,C,X),
    change(P,PBaru,PBarisBaru,Y),
    retract(peta(_)),
    asserta(peta(PBaru)),
    !.
getPixel(X,Y,C) :-
    peta(P),
    ambil(P,Y,PBaris),
    ambil(PBaris,X,C),!.

/* terrain(Tipe,XAtasKiri,YAtasKiri,XBawahKanan,YBawahKanan) */
terrain(open_field,1,1,5,5).
terrain(desert,2,2,3,3).