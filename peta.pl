:- include('file_eksternal.pl').
:- include('musuh.pl').
/* Deadzone, terrain dll */
:- dynamic(deadzone/1).
:- dynamic(lebarPeta/1).
:- dynamic(tinggiPeta/1).
:- dynamic(peta/1).
:- dynamic(petaBackup/1).

init_map :-
    baca_file('peta.txt',P),
    splitList(P,'\n',PBaru),
    asserta(peta(PBaru)),
    asserta(petaBackup(PBaru)),
    asserta(deadzone(0)),
    asserta(lebarPeta(26)),asserta(tinggiPeta(10)),!.

reset_map :-
    petaBackup(PBaru),
	retract(peta(_)),
    asserta(peta(PBaru)),!.

setPixel(X,Y,C) :-
    lebarPeta(Le),tinggiPeta(Ti),
    X>=0,X=<Le,Y>=0,Y=<Ti,!,
    peta(P),
    ambil(P,Y,PBaris),
    change(PBaris,PBarisBaru,C,X),
    change(P,PBaru,PBarisBaru,Y),
    retract(peta(_)),
    asserta(peta(PBaru)),!.
getPixel(X,Y,C) :-
    lebarPeta(Le),tinggiPeta(Ti),
    X>=0,X=<Le,Y>=0,Y=<Ti,!,
    peta(P),
    ambil(P,Y,PBaris),
    ambil(PBaris,X,C),!.

incDeadzone :-
    retract(deadzone(DZ)),
    DZBaru is DZ+1,
    asserta(deadzone(DZBaru)),!.

gambarDeadzone(0) :- !.
gambarDeadzone(DZ) :-
    lebarPeta(Le),tinggiPeta(Ti),
    XMin is DZ, XMax is Le-DZ+1,
    YMin is DZ, YMax is Ti-DZ+1,
    forall(between(XMin,XMax,X),(setPixel(X,YMin,'X'),setPixel(X,YMax,'X'))),
    forall(between(YMin,YMax,Y),(setPixel(XMin,Y,'X'),setPixel(XMax,Y,'X'))),
    DZBaru is DZ-1, gambarDeadzone(DZBaru),!.

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
    reset_map,
    findall(M, musuh(M,_,_,_,_,_), ListIdMusuh),
    findall(B, barang(B,_,_,_), ListIdBarang),
    deadzone(DZ),
    gambarDeadzone(DZ),
    gambarPlayer,
    gambarObjek(ListIdBarang),
    gambarMusuh(ListIdMusuh),!.

/* terrain(Tipe,XAtasKiri,YAtasKiri,XBawahKanan,YBawahKanan) */
terrain(open_field,1,1,5,5).
terrain(desert,2,2,3,3).