:- include('barang.pl').
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
    updatePosisiMusuh(ListId),!.

updatePosisiMusuh([]) :- !.
updatePosisiMusuh([Id|Tail]) :-
    random(1,100,Acak),
    tentukanAksi(Id,Acak),
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

serangPlayer(Damage) :-
    armor(Armor),
    Armor > 0,Armor >= Damage,
    ArmorBaru is Armor-Damage,
    retract(armor(_)),
    asserta(armor(ArmorBaru)),
    (
        (ArmorBaru =:= 0,retract(armor(_)),asserta(armor(0)),
            write('Armormu hancur melindungimu'),nl);
        (ArmorBaru > 0,write('Armormu melindungimu, sisa armormu : '),write(ArmorBaru),nl)
    ),!.
serangPlayer(Damage) :- 
    healthpoint(Darah),
    armor(Armor),
    Armor > 0, Armor =< Damage,
    retract(armor(_)),asserta(armor(0)),
    write('Armormu hancur melindungimu'),nl,
    DarahBaru is Darah+Armor-Damage,
    retract(healthpoint(_)),asserta(healthpoint(DarahBaru)),
    write('Kamu baru saja diserang musuh, sisa darahmu : '),write(DarahBaru),nl,!.
serangPlayer(Damage) :-
    healthpoint(Darah),
    (
        (   Darah > Damage, 
            DarahBaru is Darah-Damage,
            retract(healthpoint(_)),asserta(healthpoint(DarahBaru)),
            write('Kamu baru saja diserang musuh, sisa darahmu : '),write(DarahBaru),nl
        );
        (   Darah =< Damage,
            write('Darahmu habis terkena serangan musuh, kamu mati'),nl,
            kalah   
        )
    ),!. 

serangMusuh([]) :- !.
serangMusuh(_) :-
    senjata(_,_,BanyakAm),
    BanyakAm =:= 0,
    write('Ammo-mu tidak cukup untuk menyerang musuh'),nl,!.
serangMusuh([Id|Tail]) :- 
    musuh(Id,_,_,_,DarahM,SenjataMusuh),
    senjata(Senjata,Damage,BanyakAm),
    BanyakAm > 0,
        BanyakAmBaru is BanyakAm-1,
        retract(senjata(Senjata,Damage,BanyakAm)),
        asserta(senjata(Senjata,Damage,BanyakAmBaru)),
    isSenjata(SenjataMusuh,DamageMusuh),
    DarahM > Damage,
    DarahMBaru is DarahM-Damage,
    retract(musuh(Id,Xm,Ym,DamM,_,SenjataMusuh)),
    asserta(musuh(Id,Xm,Ym,DamM,DarahMBaru,SenjataMusuh)),
    write('Anda menyerang musuh sebesar '),write(Damage),
    write(' damage'),nl,
    serangPlayer(DamageMusuh),
    serangMusuh(Tail),!.
serangMusuh([Id|Tail]) :-
    musuh(Id,_,_,_,DarahM,SenjataMusuh),
    senjata(Senjata,Damage,BanyakAm),
    BanyakAm > 0,
        BanyakAmBaru is BanyakAm-1,
        retract(senjata(Senjata,Damage,BanyakAm)),
        asserta(senjata(Senjata,Damage,BanyakAmBaru)),
    isSenjata(SenjataMusuh,_),
    DarahM =< Damage,write('Anda menyerang musuh sebesar '),write(Damage),nl,
    write('Musuh mati.'),nl,
    retract(musuh(Id,Xm,Ym,_,_,_)),
    between(1,100,IdB),\+barang(IdB,_,_,_,_),
    isSenjata(SenjataMusuh,DA),
    Per2 is (DA div 2),
    random(Per2,DA,DropAmmo),
    asserta(barang(Id,SenjataMusuh,Xm,Ym,DropAmmo)),
    serangMusuh(Tail),!.
