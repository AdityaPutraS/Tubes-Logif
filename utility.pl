/* LIST */
/* search(List,CharDicari,Indexnya) */
search([],_,-1) :- !.
search([C|_],C,0) :- !.
search([_|Tail],C,IndexBaru) :-  search(Tail,C,Index),IndexBaru is Index+1.

/* change(LLama,LBaru,C,Indeks). */
change([_|Tail],[C|Tail],C,0) :- !. 
change([A|Tail],[A|LBaru],C,Indeks) :- IndeksBaru is Indeks-1, change(Tail,LBaru,C,IndeksBaru).

/* ambil(L,Pos,C) */
ambil([],0,'') :- !.
ambil([C|_],0,C) :- !.
ambil([_|LTail],Pos,C) :- PosBaru is (Pos-1),ambil(LTail,PosBaru,C), !.

/* hapus(LLama, LBaru, Indeks). */
hapus([],[],_) :- !.
hapus([_|Tail],Tail,0) :- !.
hapus([Head|Tail],[Head|Hasil],Indeks) :- IndeksBaru is Indeks-1, hapus(Tail,Hasil,IndeksBaru), !.

/* printList(List). */
printList([]) :- !.
printList([A|Tail]) :-
	write(A), printList(Tail).
