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
    asserta(peta(PBaru)),
    asserta(lebarPeta(26)),asserta(tinggiPeta(10)),
    retract(lebarPeta(_)),retract(tinggiPeta(_)),
    asserta(lebarPeta(26)),asserta(tinggiPeta(10)),!.

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

gambarPlayer :-
    player(X,Y),
    setPixel(X,Y,'P'),!.
gambarObjek([]) :- !.
gambarObjek([Id|Tail]) :-
    barang(Id,Nama,X,Y),
    (isSenjata(Nama,_),setPixel(X,Y,'S');
     isArmor(Nama,_),setPixel(X,Y,'A');
     isMedicine(Nama,_),setPixel(X,Y,'O');
     isAmmo(Nama,_),setPixel(X,Y,'M')),
    gambarObjek(Tail), !.
gambarMusuh([]) :- !.
gambarMusuh([Id|Tail]) :-
    musuh(Id,X,Y,_,_,_),
    setPixel(X,Y,'E'),
    gambarMusuh(Tail), !.

updatePeta :-
    init_map,
    findall(M, musuh(M,_,_,_,_,_), ListIdMusuh),
    findall(B, barang(B,_,_,_), ListIdBarang),
    gambarPlayer,
    gambarObjek(ListIdBarang),
    gambarMusuh(ListIdMusuh),!.

/* terrain(Tipe,XAtasKiri,YAtasKiri,XBawahKanan,YBawahKanan) */
terrain(open_field,1,1,5,5).
terrain(desert,2,2,3,3).