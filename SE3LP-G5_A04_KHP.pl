/* SE3LP-18W-A04
  Namen: Kao Chung-Shan, Harm Matthias Harms, Henrik Peters
*/
?- consult('medien2.pl').
?- consult('medienKHP.pl').
?- consult('hauser.pl').
?- consult('galaxy.pl').


/*========= A1*/
%%______________________________________________________________________
%%| Eigenschaft     | symmetrisch | refelexiv | transitiv | funktional |
%%|=================|=============|===========|===========|============|
%%| 1) A ist das    |             |           |           |            |
%%| Geburtsdatum    |             |           |           |     X      |
%%| von B           |             |           |           |            |
%%|-----------------|-------------|-----------|-----------|------------|
%%| 2) A ist im     |             |           |           |            |
%%| Turnier gegen B |      X      |           |           |            |
%%| angetreten      |             |           |           |            |
%%|-----------------|-------------|-----------|-----------|------------|
%%|  3) A ist eine  |             |           |           |            |
%%| (echte oder un- |             |           |           |            |
%%| echte) Teilmenge|      X      |     X     |     X     |            |
%%| von B           |             |           |           |            |
%%|-----------------|-------------|-----------|-----------|------------|
%%| 4) A und B      |             |           |           |            |
%%| spielen eine    |             |           |           |            |
%%| Rolle im        |      X      |     X     |           |            |
%%| gleichen Film   |             |           |           |            |
%%|-----------------|-------------|-----------|-----------|------------|
%%| 5) A ist        |             |           |           |            |
%%| kongruent zu B  |      X      |     X     |     X     |            |
%%|_________________|_____________|___________|___________|____________|
%%
%% Begründungen:
%% zu 1) Wenn A ein Geburtsdatum ist, dann muss B eine Person sein
%%      (Kontext). Symmetrie würde bedeuten, dass dann eine Person
%%      das Geburtsdatum für ein Geburtsdatum sein kann. Das macht
%%      keinen Sinn und ist deshalb nicht möglich. aus dem selben Grund
%%      ist auch Reflexivität nich tmöglich. Dann würde A ein Geburts-
%%      datum von A sein, was auch keinen Sinn macht. Transitivität ist
%%      ebenfalls aus dem selben Grund nicht möglich.
%%      Funktionalität scheint sinnvoll



/*====== Aufgabe 3*/

/*====== Aufgabe 3.1
das fur beliebige Beispieldatenbanken berechnet, ob Produkt1 Voraussetzung
für die Fertigung von Produkt2 ist. Produkte seien beliebige Komponenten
bzw. fertige Produkte.
*/
voraussetzung(Produkt1,Produkt2) :- arbeitsschritt(Produkt1, _, _, Produkt2).
voraussetzung(Produkt1,Produkt2) :- arbeitsschritt(Produkt1, _, _, Zwischenprodukt),
                                    voraussetzung(Zwischenprodukt, Produkt2).
/*
?- voraussetzung(box0815, box0817).
true.
*/

/*===== Aufgabe 3.2
Definieren Sie ein zweistelliges Prädikat, das die betroffenen Endprodukte für
ein beliebiges nichtlieferbares Teil berechnet.
*/
betroffene_produkte(Produkt, L) :- findall(P2, voraussetzung(Produkt, P2), L).
/*
?- betroffene_produkte(box0815, L).
L = [box0816, box0817, galaxy2001, galaxy2002, galaxy2003, galaxy2004].
*/

/*==== Aufgabe 3.3
Definieren Sie ein zweistelliges Pr¨adikat, das eine Liste der von einem Maschinenausfall
betroffenen Endprodukte berechnet.

Erweitern Sie dazu zun¨achst das Pr¨adikat voraussetzung/2 aus Aufgabenteil
1 zu einem dreistelligen Pr¨adikat, das uberpr ¨ uft, ob ein Produktionspfad ¨
zwischen zwei Produkten auch dann noch existiert, wenn ein bestimmter Arbeitsplatz
nicht mehr zur Verfugung steht. 
*/
% Prüft, ob ein Pfad existiert, der Maschine nicht benutzt.
other_path(Produkt1, Maschine, Produkt2) :- arbeitsschritt(Produkt1, _, Maschine2, Produkt2), 
                                                Maschine2 \= Maschine.
other_path(Produkt1, Maschine, Produkt2) :- arbeitsschritt(Produkt1, _, Maschine2, Zwischenprodukt),
                                                Maschine \= Maschine2,
                                                other_path(Zwischenprodukt, Maschine, Produkt2).

%Hilfsfunktion
not_member(_, []) :- !.
not_member(X, [Head|Tail]) :- X \= Head,
                              not_member(X, Tail).

%gibt nur endprodukte zurück.
maschinen_ausfall(Maschine, Endprodukte) :- findall(Endprodukt2, 
                                            (findall(Endprodukt,other_path(_, Maschine, Endprodukt), L), 
                                              endprodukt(Endprodukt2), not_member(Endprodukt2, L)), 
                                            Endprodukte).
/*
?- maschinen_ausfall(montage2, L).
L = [galaxy2003].
*/