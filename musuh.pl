:- include('barang.pl').
:- include('utility.pl').
:- include('player.pl').
:- dynamic(musuh/6).

/* musuh(Id,XPos,YPos,Damage,Health,ItemDrop) */

initMusuh(0) :- !.
initMusuh(Banyak) :-
    random(1, 10, X),
    random(1, 10, Y),
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
    Movement is (MovAcak mod 4)+1,
    gerakMusuh(Id,Movement),
    updatePosisiMusuh(Tail),!.

gerakMusuh(Id,1) :-
    nMusuh(Id),!.
gerakMusuh(Id,2) :-
    eMusuh(Id),!.
gerakMusuh(Id,3) :-
    wMusuh(Id),!.
gerakMusuh(Id,4) :-
    sMusuh(Id),!.

nMusuh(Id) :- 
    musuh(Id,Xm,Ym,Damage,Health,ItemDrop),
    Ym > 1,
    YmBaru is Ym-1,
    retract(musuh(Id,_,_,_,_,_)),
    assertz(musuh(Id,Xm,YmBaru,Damage,Health,ItemDrop)),!.
nMusuh(Id) :-
    eMusuh(Id),!.
eMusuh(Id) :- 
    musuh(Id,Xm,Ym,Damage,Health,ItemDrop),
    Xm < 10,
    XmBaru is Xm+1,
    retract(musuh(Id,_,_,_,_,_)),
    assertz(musuh(Id,XmBaru,Ym,Damage,Health,ItemDrop)),!.
eMusuh(Id) :-
    wMusuh(Id),!.
wMusuh(Id) :- 
    musuh(Id,Xm,Ym,Damage,Health,ItemDrop),
    Ym < 10,
    YmBaru is Ym+1,
    retract(musuh(Id,_,_,_,_,_)),
    assertz(musuh(Id,Xm,YmBaru,Damage,Health,ItemDrop)),!.
wMusuh(Id) :-
    sMusuh(Id),!.
sMusuh(Id) :- 
    musuh(Id,Xm,Ym,Damage,Health,ItemDrop),
    Xm > 1,
    XmBaru is Xm-1,
    retract(musuh(Id,_,_,_,_,_)),
    assertz(musuh(Id,XmBaru,Ym,Damage,Health,ItemDrop)),!.
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
