:- include('barang.pl').
:- include('utility.pl').
:- include('player.pl').
:- dynamic(musuh/6).

/* musuh(Id,XPos,YPos,Damage,Health,ItemDrop) */

initMusuh(0) :- !.
initMusuh(Banyak) :-
    lebarPeta(Le),tinggiPeta(Ti),
    random(1, Le, X),
    random(1, Ti, Y),
    findall(S,isSenjata(S,_),ListSenjata),
    length(ListSenjata, Panjang),
    random(0,Panjang,NoSenjata),
    ambil(ListSenjata,NoSenjata,Senjata),
    isSenjata(Senjata,Damage),
    asserta(musuh(Banyak,X,Y,Damage,100,Senjata)),
    BanyakBaru is Banyak-1,
    initMusuh(BanyakBaru),!.

updateMusuh :-
    findall(M, musuh(M,_,_,_,_,_), ListId),
    updatePosisiMusuh(ListId),
    updateAksiMusuh(ListId),!.

updatePosisiMusuh([]) :- !.
updatePosisiMusuh([Id|Tail]) :-
    random(1,100,MovAcak),
    tentukanAksi(Id,MovAcak),
    updatePosisiMusuh(Tail),!.

tentukanAksi(_,Mov) :-
    Mov > 75, !.
tentukanAksi(Id,_) :-
    musuh(Id,Xm,Ym,_,_,_),player(Xp,Yp),
    Xm =:= Xp,Ym =:= Yp, !.
tentukanAksi(Id,_) :-
    musuh(Id,Xm,Ym,_,_,_),player(Xp,Yp),
    Xm =:= Xp,Ym > Yp,
    random(1,100,Gerak), G is (Gerak mod 2),
    (
        (G =:= 0, nMusuh(Id));
        (G =:= 1)    
    ),!.
tentukanAksi(Id,_) :-
    musuh(Id,Xm,Ym,_,_,_),player(Xp,Yp),
    Xm =:= Xp,Ym < Yp,
    random(1,100,Gerak), G is (Gerak mod 2),
    (
        (G =:= 0, sMusuh(Id));
        (G =:= 1)    
    ),!.
tentukanAksi(Id,_) :-
    musuh(Id,Xm,Ym,_,_,_),player(Xp,Yp),
    Xm < Xp,Ym =:= Yp,
    random(1,100,Gerak), G is (Gerak mod 2),
    (
        (G =:= 0, eMusuh(Id));
        (G =:= 1)    
    ),!.
tentukanAksi(Id,_) :-
    musuh(Id,Xm,Ym,_,_,_),player(Xp,Yp),
    Xm > Xp,Ym =:= Yp,
    random(1,100,Gerak), G is (Gerak mod 2),
    (
        (G =:= 0, wMusuh(Id));
        (G =:= 1)    
    ),!.
tentukanAksi(Id,_) :-
    musuh(Id,Xm,Ym,_,_,_),player(Xp,Yp),
    Xm < Xp,Ym < Yp,
    random(1,100,Gerak), G is (Gerak mod 3),
    (
        (G =:= 0,sMusuh(Id));
        (G =:= 1,eMusuh(Id));
        (G =:= 2)
    ),!.
tentukanAksi(Id,_) :-
    musuh(Id,Xm,Ym,_,_,_),player(Xp,Yp),
    Xm < Xp,Ym > Yp,
    random(1,100,Gerak), G is (Gerak mod 3),
    (
        (G =:= 0,nMusuh(Id));
        (G =:= 1,eMusuh(Id));
        (G =:= 2)
    ),!.
tentukanAksi(Id,_) :-
    musuh(Id,Xm,Ym,_,_,_),player(Xp,Yp),
    Xm > Xp,Ym < Yp,
    random(1,100,Gerak), G is (Gerak mod 3),
    (
        (G =:= 0,sMusuh(Id));
        (G =:= 1,wMusuh(Id));
        (G =:= 2)
    ),!.
tentukanAksi(Id,_) :-
    musuh(Id,Xm,Ym,_,_,_),player(Xp,Yp),
    Xm > Xp,Ym > Yp,
    random(1,100,Gerak), G is (Gerak mod 3),
    (
        (G =:= 0,nMusuh(Id));
        (G =:= 1,wMusuh(Id));
        (G =:= 2)
    ),!.

nMusuh(Id) :- 
    musuh(Id,Xm,Ym,Damage,Health,ItemDrop),
    Ym > 1,
    YmBaru is Ym-1,
    retract(musuh(Id,_,_,_,_,_)),
    assertz(musuh(Id,Xm,YmBaru,Damage,Health,ItemDrop)),!.
nMusuh(Id) :-
    sMusuh(Id),!.
eMusuh(Id) :- 
    musuh(Id,Xm,Ym,Damage,Health,ItemDrop),
    lebarPeta(Le),
    Xm < Le,
    XmBaru is Xm+1,
    retract(musuh(Id,_,_,_,_,_)),
    assertz(musuh(Id,XmBaru,Ym,Damage,Health,ItemDrop)),!.
eMusuh(Id) :-
    wMusuh(Id),!.
wMusuh(Id) :- 
    musuh(Id,Xm,Ym,Damage,Health,ItemDrop),
    Xm > 1,
    XmBaru is Xm-1,
    retract(musuh(Id,_,_,_,_,_)),
    assertz(musuh(Id,XmBaru,Ym,Damage,Health,ItemDrop)),!.
wMusuh(Id) :-
    eMusuh(Id),!.
sMusuh(Id) :- 
    musuh(Id,Xm,Ym,Damage,Health,ItemDrop),
    tinggiPeta(Ti),
    Ym < Ti,
    YmBaru is Ym+1,
    retract(musuh(Id,_,_,_,_,_)),
    assertz(musuh(Id,Xm,YmBaru,Damage,Health,ItemDrop)),!.
sMusuh(Id) :-
    nMusuh(Id),!.

updateAksiMusuh([]) :- !.
updateAksiMusuh([Id|Tail]) :-
    musuh(Id,Xm,Ym,Damage,Health,ItemDrop),
    player(Xp,Yp),
    Xm =:= Xp, Ym =:= Yp,
    serangPlayer(Damage),
    updateAksiMusuh(Tail),!.
updateAksiMusuh([_|Tail]) :-
    updateAksiMusuh(Tail),!.

serangPlayer(Damage) :- 
    healthpoint(Darah),
    Darah > Damage,
    DarahBaru is Darah-Damage,
    retract(healthpoint(_)),
    asserta(healthpoint(DarahBaru)),
    write('Kamu baru saja diserang oleh musuh.'),nl,
    write('Sisa darahmu : '),write(DarahBaru),nl,!.
serangPlayer(Damage) :-
    healthpoint(Darah),
    Darah =< Damage,
    kalah, !. 
