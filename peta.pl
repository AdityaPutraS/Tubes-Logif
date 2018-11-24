:- include('file_eksternal.pl').
:- include('musuh.pl').
/* Deadzone, terrain dll */
:- dynamic(deadzone/1).
:- dynamic(lebarPeta/1).
:- dynamic(tinggiPeta/1).
:- dynamic(tick/1).
:- dynamic(terrain/3).

init_map :-
    asserta(deadzone(0)),
    asserta(tick(0)),
    random(5,20,X),
    random(5,20,Y),
    asserta(lebarPeta(X)),asserta(tinggiPeta(Y)),
    generateTerrain,!.

isBorderAtas(_,Y) :-
    Y=:=0
    ,!.
isBorderKiri(X,_) :-
    X=:=0,
    !.
isBorderBawah(_,Y) :-
    tinggiPeta(T),
    YMax is T+1,
    Y=:=YMax,
    !.
isBorderKanan(X,_) :-
    lebarPeta(L),
    XMax is L+1,
    X=:=XMax,
    !.
isDeadzone(X,Y) :-
    deadzone(DZ),
    lebarPeta(L),
    tinggiPeta(T),
    NotDZXMin is DZ+1,
    NotDZYMin is DZ+1,
    NotDZXMax is L-DZ,
    NotDZYMax is T-DZ,
    (   
        Y < NotDZYMin;
        Y > NotDZYMax;   
        X < NotDZXMin;
        X > NotDZXMax
    ),
    !.

incDeadzone :-
    retract(deadzone(DZ)),
    DZBaru is DZ+1,
    asserta(deadzone(DZBaru)),!.
deadzoneDeadCheck  :-
    healthpoint(HP),
    HP=<0->(
        write('Di saat-saat terakhirmu,'), nl,
        write('Hal yang paling kau sesali adalah...'), nl,
        write('"Kenapa aku tidak mendengarkan suara-suara itu..."'), nl,
        kalah
    );
    (
        write('Kamu merasa mendengar suara dari bawah, "Cepat kabur dari sini!"'), nl,
        write('Haruskah kamu menaati suara tersebut?'), nl,
        write('Semua tergantung kepadamu.'), nl
    ),!.
deadzoneDamage :-
    player(X,Y),
    isDeadzone(X,Y), !,
    write('Kamu merasa daerah sekitarmu mengurangi kehidupanmu sedikit demi sedikit.'), nl,
    healthpoint(HP),
    NewHP is HP-3,
    retract(healthpoint(_)), asserta(healthpoint(NewHP)),
    write('HP kamu berkurang menjadi '),write(NewHP),write('.'),nl,
    deadzoneDeadCheck,
    !.
deadzoneDamage :-
    !.
deadzoneDamageEnemy :-
    forall(musuh(Id,X,Y,Dam,HP,Drop),(
        isDeadzone(X,Y),
        NewHP is HP-1,
        retract(musuh(Id,X,Y,Dam,_,Drop)),
        NewHP>0->(
            asserta(musuh(Id,X,Y,Dam,NewHP,Drop))
        );
        (
            write('Kamu merasakan seperti ada orang yang mati tidak jauh.'), nl   
        )
    )), !.
    
printPrio(X,Y) :-
    isBorderKanan(X,Y), !, write('+').
printPrio(X,Y) :-
    isBorderKiri(X,Y), !, write('+').
printPrio(X,Y) :-
    isBorderAtas(X,Y), !, write('+').
printPrio(X,Y) :-
    isBorderBawah(X,Y), !, write('+').
printPrio(X,Y) :-
	musuh(_,X,Y,_,_,_),!, write('E').
printPrio(X,Y) :-
	isMedicine(Nama,_), barang(_,Nama,X,Y,_), !, write('O').
printPrio(X,Y) :-
	isSenjata(Nama,_), barang(_,Nama,X,Y,_), !, write('S').
printPrio(X,Y) :-
	isArmor(Nama,_), barang(_,Nama,X,Y,_), !, write('A').
printPrio(X,Y) :-
	isAmmo(Nama,_,_), barang(_,Nama,X,Y,_), !, write('M').
printPrio(X,Y) :-
	player(X,Y), !, write('P').
printPrio(X,Y) :-
	isDeadzone(X,Y), !, write('X').
printPrio(_,_) :-
	write('-').

printMap(X,Y) :-
    isBorderKanan(X,Y), !, write('+').
printMap(X,Y) :-
    isBorderKiri(X,Y), !, write('+').
printMap(X,Y) :-
    isBorderAtas(X,Y), !, write('+').
printMap(X,Y) :-
    isBorderBawah(X,Y), !, write('+').
printMap(X,Y) :-
    player(X,Y), !, write('P').
printMap(X,Y) :-
	isDeadzone(X,Y), !, write('X').
printMap(_,_) :-
	write('-').

/* terrain(X,Y,nama) */
isTerrain(bukit).
isTerrain(hutan).
isTerrain(gunung).
isTerrain(padang_rumput).
isTerrain(padang_pasir).
isTerrain(kota).
isTerrain(desa).


generateTerrain:-
    lebarPeta(L),
    tinggiPeta(T),
	XMin is 1,
	XMax is L,
	YMin is 1,
	YMax is T,
	forall(between(YMin,YMax,J), (
		forall(between(XMin,XMax,I), (
            findall(Ter,isTerrain(Ter),ListTerrain),
            length(ListTerrain, Panjang),
            random(0,Panjang,NoTerrain),
            ambil(ListTerrain, NoTerrain, Terrain),
            asserta(terrain(I,J,Terrain))
		))
	)),
	!.