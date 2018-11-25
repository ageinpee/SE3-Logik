/* SE3LP-18W-A04
  Namen: Chung-Shan Kao, Harm Matthias Harms, Henrik Peters
*/
?- consult('medien2.pl').
?- consult('medienKHP.pl').
?- consult('hauser.pl').
?- consult('galaxy.pl').

produkt(43456,15,sonnenuntergang,hoffmann_susanne,meister,2014,1).
produkt(43457,20,spuren_im_schnee,wolf_michael,meister,2014,1).
produkt(43458,16,blutrache,wolf_michael,meister,2015,1).

produkt(44567,17,hoffnung,sand_molly,audio,2016,51).
produkt(44568,21,winterzeit,wolf_michael,audio,2017,16).


/*******************************************/
/*******************************************/
/* Aufgabe 1: Eigenschaften von Relationen */
/*******************************************/
/*******************************************/

%%______________________________________________________________________
%%| Relation        | symmetrisch | refelexiv | transitiv | funktional |
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
%%| Rolle im        |      X      |     X     |     X     |            |
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
%%      Funktionalität scheint sinnvoll, da jede Person B bloß ein
%%      Geburtsdatum A haben kann.
%% zu 2) Wenn A im Turnier gegen B antriit, tritt B auch gegen A an,
%%      Das besagt schon die interne Logik eines solchen Wettkampfes,
%%      woraus folgt, dass Symmetrie gegeben ist. Reflexivität und
%%      Transitivität machen auch keinen Sinn. Man kann nicht gegen sich
%%      selbst antreten. Und Transitivität würde nur in einem Wettkampf
%%      gelten, in dem Jeder gegen Jeden einmal antriit, wie z.B. in der
%%      Bundesliga. Bei einem Wettkampf wie dem DFB-Pokal ist die Trans-
%%      itivität schon wieder verletzt. So lässt sich nicht pauschal
%%      sagen, dass die Transitivität gilt. Auch die Funnktionalität ist
%%      hier nicht erfüllt. Sowohl A als auch B können gegen viele
%%      gleiche und verschiedene Gegner antreten.
%% zu 3) Die Symmetrie gilt hier nur wenn A eine unechte Teilmege von B
%%      ist. Denn nur dann ist auch B eine unechte Teilmenge von A,
%%      sprich A=B. A ist ebenfalls eine unechte Teilmenge von sich
%%      selbst, also gilt die Reflexivität. Auch die Transitivität gilt,
%%      denn wenn A Teilmenge von B und B Teilmenge von C ist, dann muss
%%      A auch Teilmenge von C sein. Funktionalität ist nicht erfüllt,
%%      denn A kann Teilmenge von mehreren Übermengen sein.
%% zu 4) Wenn A eine Rolle im gleichen Film wie B spielt, dann spielt
%%      auch B eine Rolle im gleichen Film wie A. Daraus folgt die
%%      Symmetrie. A spielt auch immer eine Rolle im gleichen Film wie
%%      A, woraus die Reflexivität folgt. Transitivität gilt auch. Die
%%      Argumentation ist dabei die gleiche wie bei 3). Funktionalität
%%      gilt allerdings nicht. Sowohl denn A kann mit mehreren Personen
%%      zusammen eine Rolle im gleichen Film spielen.
%% zu 5) Kongruent bedeutet Deckungsgleich. Das bedeutet, wenn A
%%      kongruent zu B ist, ist auch B kongruent zu A. Auch ist A immer
%%      kongruent zu sich selbst. Wenn nun A kongruent zu B und B
%%      kongruent zu C, dann ist auch A kongruent zu C. Damit sind
%%      Symmetrie, Reflexivität und Transitivität schonmal erfüllt. Die
%%      Funktionalität ist nicht erfüllt, das A zu mehr als einem B
%%      kongruent sein kann.

/******************************************************************/
/******************************************************************/
/* Aufgabe 2: Deduktive Datenbanken (3): Hierarchische Strukturen */
/******************************************************************/
/******************************************************************/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* 2.1 Prädikat: Übergeordnete Kategorien */
%% oberkategorie(?KId, ?Name, ?OId)

oberkategorie(KId, Name, OId) :-
    kategorie(KId, Name, OId).

oberkategorie(KId, Name, OId) :-
    kategorie(KId, _, OId1),
    oberkategorie(OId1, Name, OId).

/*
%%%% Acht Instanziierungsvarianten

%% oberkategorie(+KId, -Name, -OId)
?- oberkategorie(13, Name, OId).
Name = sachbuch,
OId = 1;
Name = buch,
OId = 0.

%% oberkategorie(-KId, +Name, -OId)
?- oberkategorie(KId, sachbuch, OId).
KId = 13,
OId = 1;
KId = 14,
OId = 2;
KId = 16,
OId = 1;
KId = 17,
OId = 1;
KId = 21,
OId = 1.

%% oberkategorie(-KId, -Name, +OId)
?- oberkategorie(KId, Name, 1).
KId = 4,
Name = kinder;
KId = 7,
Name = krimi;
KId = 10,
Name = roman;
KId = 13,
Name = sachbuch;
KId = 18,
Name = lyrik;
KId = 15,
Name = kinder;
KId = 16,
Name = sachbuch;
KId = 17,
Name = sachbuch;
KId = 20,
Name = kinder;
KId = 21,
Name = sachbuch.

%% oberkategorie(+KId, +Name, -OId)
?- oberkategorie(4, kinder, OId).
OId = 1.

%% oberkategorie(+KId, -Name, +OId)
?- oberkategorie(4, Name, 1).
Name = kinder.

%% oberkategorie(-KId, +Name, +OId)
?- oberkategorie(KId, kinder, 1).
KId = 4;
KId = 15;
KId = 20.

%% oberkategorie(+KId, +Name, +OId)
?- oberkategorie(4, kinder, 1).
true.

?- oberkategorie(5, kinder, 1).
false.

?- oberkategorie(4, krimi, 1).
false.

?- oberkategorie(4, kinder, 2).
false.

%% oberkategorie(+KId, +Name, +OId)
?- oberkategorie(KId, Name, OId)
KId = 1,
Name = buch,
OId = 0;
KId = 2,
Name = ebuch,
OId = 0;
KId = 3,
Name = hoerbuch,
OId = 0;
KId = 4,
Name = kinder,
OId = 1;
KId = 5,
Name = kinder,
OId = 2;
KId = 6,
Name = kinder,
OId = 3;
KId = 7,
Name = krimi,
OId = 1;
KId = 8,
Name = krimi,
OId = 2;
KId = 9,
Name = krimi,
OId = 3;
KId = 10,
Name = roman,
OId = 1;
KId = 11,
Name = roman,
OId = 2;
KId = 12,
Name = roman,
OId = 3;
KId = 13,
Name = sachbuch,
OId = 1;
KId = 14,
Name = sachbuch,
OId = 2;
KId = 15,
Name = bilderbuch,
OId = 4;
KId = 16,
Name = reisefuehrer,
OId = 13;
KId = 17,
Name = lexikon,
OId = 13;
KId = 18,
Name = lyrik,
OId = 1;
KId = 19,
Name = lyrik,
OId = 3;
KId = 20,
Name = bastelbuch,
OId = 4;
KId = 21,
Name = woerterbuch,
OId = 13;
KId = 4,
Name = buch,
OId = 0;
KId = 5,
Name = ebuch,
OId = 0;
KId = 6,
Name = hoerbuch,
OId = 0;
KId = 7,
Name = buch,
OId = 0;
KId = 8,
Name = ebuch,
OId = 0;
KId = 9,
Name = hoerbuch,
OId = 0;
KId = 10,
Name = buch,
OId = 0;
KId = 11,
Name = ebuch,
OId = 0;
KId = 12,
Name = hoerbuch,
OId = 0;
KId = 13,
Name = buch,
OId = 0;
KId = 14,
Name = ebuch,
OId = 0;
KId = 15,
Name = kinder,
OId = 1;
KId = 15,
Name = buch,
OId = 0;
KId = 16,
Name = sachbuch,
OId = 1;
KId = 16,
Name = buch,
OId = 0;
KId = 17,
Name = sachbuch,
OId = 1;
KId = 17,
Name = buch,
OId = 0;
KId = 18,
Name = buch,
OId = 0;
KId = 19,
Name = hoerbuch,
OId = 0;
KId = 20,
Name = kinder,
OId = 1;
KId = 20,
Name = buch,
OId = 0;
KId = 21,
Name = sachbuch,
OId = 1;
KId = 21,
Name = buch,
OId = 0.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* 2.2 Prädikat: Untergeordnete Kategorien */
%% unterkategorie(?Liste, ?OId)

unterkategorie([Name|L], OId) :-
    kategorie(OId, Name, _),
    unterkat(L, OId).
    
unterkat([Name], OId) :-
    kategorie(UId, Name, OId),
    not(kategorie(_, _, UId)).

unterkat([Name | L], OId) :-
    kategorie(UId, Name, OId),
    unterkat(L, UId).
    
/*
%%%% Vier Instanziierungsvarianten

%% unterkategorie(-Liste, +OId)
?- unterkategorie(Liste, 1).
Liste = [buch, krimi];
Liste = [buch, roman];
Liste = [buch, lyrik];
Liste = [buch, kinder, bilderbuch];
Liste = [buch, kinder, bastelbuch];
Liste = [buch, sachbuch, reisefuehrer];
Liste = [buch, sachbuch, lexikon];
Liste = [buch, sachbuch, woerterbuch].

%% unterkategorie(+Liste, -OId)
?- unterkategorie([buch, sachbuch, lexikon], OId).
OId = 1.

%% unterkategorie(+Liste, +OId)
?- unterkategorie([buch, sachbuch, lexikon], 1).
true.

?- unterkategorie([buch, sachbuch, lexikon], 2).
false.

?- unterkategorie([buch, ebuch, lexikon], 1).
false.

?- unterkategorie([buch, sachbuch], 1).
false.

%% unterkategorie(-Liste, -OId)
?- unterkategorie(Liste, KId).
KId = 1,
Liste = [buch, krimi];
KId = 1,
Liste = [buch, roman];
KId = 1,
Liste = [buch, lyrik];
KId = 1,
Liste = [buch, kinder, bilderbuch];
KId = 1,
Liste = [buch, kinder, bastelbuch];
KId = 1,
Liste = [buch, sachbuch, reisefuehrer];
KId = 1,
Liste = [buch, sachbuch, lexikon];
KId = 1,
Liste = [buch, sachbuch, woerterbuch];
KId = 2,
Liste = [ebuch, kinder];
KId = 2,
Liste = [ebuch, krimi];
KId = 2,
Liste = [ebuch, roman];
KId = 2,
Liste = [ebuch, sachbuch];
KId = 3,
Liste = [hoerbuch, kinder];
KId = 3,
Liste = [hoerbuch, krimi];
KId = 3,
Liste = [hoerbuch, roman];
KId = 3,
Liste = [hoerbuch, lyrik];
KId = 4,
Liste = [kinder, bilderbuch];
KId = 4,
Liste = [kinder, bastelbuch];
KId = 13,
Liste = [sachbuch, reisefuehrer];
KId = 13,
Liste = [sachbuch, lexikon];
KId = 13,
Liste = [sachbuch, woerterbuch].
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* 2.3 Prädikat: Alle Produkte einer Kategorie und Unterkategorien */
%% katProdukte(?KId, ?PId)

katProdukte(KId, PId) :-
    produkt(PId, KId, _, _, _, _, _).

katProdukte(KId, PId) :-
    kategorie(UId, _, KId),
    katProdukte(UId, PId).

/*
%%%% Vier Instanziierungsvarianten

%% katProdukte(+KId, -PId)
?- KatProdukte(1, PId).
PId = 43456;
PId = 43457;
PId = 12347;
PId = 12348;
PId = 12349;
PId = 12345;
PId = 43458;
PId = 44567;
PId = 44568;
PId = 12346.

%% katProdukte(-KId, +PId)
?- KatProdukte(KId, 12345).
KId = 10;
KId = 0;
KId = 1.

%% katProdukte(-KId, -PId)
?- KatProdukte(1, 12345).
true.

?- KatProdukte(1, 12344).
false.

?- KatProdukte(2, 12345).
false.

%% katProdukte(-KId, -PId)
?- KatProdukte(KId, PId).
KId = 10,
PId = 12345;
KId = 18,
PId = 12346;
KId = 7,
PId = 12347;
KId = 7,
PId = 12348;
KId = 7,
PId = 12349;
KId = 11,
PId = 23456;
KId = 11,
PId = 23457;
KId = 8,
PId = 23458;
KId = 19,
PId = 34567;
KId = 9,
PId = 34568;
KId = 15,
PId = 43456;
KId = 20,
PId = 43457;
KId = 16,
PId = 43458;
KId = 17,
PId = 44567;
KId = 21,
PId = 44568;
KId = 0,
PId = 43456;
KId = 0,
PId = 43457;
KId = 0,
PId = 12347;
KId = 0,
PId = 12348;
KId = 0,
PId = 12349;
KId = 0,
PId = 12345;
KId = 0,
PId = 43458;
KId = 0,
PId = 44567;
KId = 0,
PId = 44568;
KId = 0,
PId = 12346;
KId = 0,
PId = 23458;
KId = 0,
PId = 23456;
KId = 0,
PId = 23457;
KId = 0,
PId = 34568;
KId = 0,
PId = 34567;
KId = 1,
PId = 43456;
KId = 1,
PId = 43457;
KId = 1,
PId = 12347;
KId = 1,
PId = 12348;
KId = 1,
PId = 12349;
KId = 2,
PId = 23458;
KId = 3,
PId = 34568;
KId = 1,
PId = 12345;
KId = 2,
PId = 23456;
KId = 2,
PId = 23457;
KId = 1,
PId = 43458;
KId = 1,
PId = 44567;
KId = 1,
PId = 44568;
KId = 4,
PId = 43456;
KId = 13,
PId = 43458;
KId = 13,
PId = 44567;
KId = 1,
PId = 12346;
KId = 3,
PId = 34567;
KId = 4,
PId = 43457;
KId = 13,
PId = 44568.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* 2.4 Prädikat: Anzahl verkaufter Produkte einer Kategorie */
%% katVerkauf(?KId, ?Jahr, ?Verkauf)

katVerkauf(KId, Jahr, Verkauf) :-
    findall(V,
            katVK(KId, Jahr, V),
            L),
    sumlist(L, Verkauf).

katVK(KId, Jahr, Verkauf) :-
    findall(Anz,
            (produkt(PId, KId, _, _, _, _, _),
             verkauft(PId, Jahr, _, Anz)),
            L),
    sumlist(L, Verkauf).

katVK(KId, Jahr, Verkauf) :-
    kategorie(KId1, _, KId),
    katVK(KId1, Jahr, Verkauf).

/*
%%%% Acht Instanziierungsvarianten: fünf nützlich, drei nutzlos

%%%% fünf Instanziierungsvarianten nützlich

%% katVerkauf(+KId, +Jahr, -Verkauf)
?- katVerkauf(1, 2016, Verkauf).
Verkauf = 433.

%% katVerkauf(+KId, +Jahr, +Verkauf)
?- katVerkauf(1, 2016, 433).
true.

?- katVerkauf(1, 2016, 444).
false.

?- katVerkauf(1, 2017, 433).
false.

?- katVerkauf(3, 2016, 433).
false.

%% katVerkauf(+KId, -Jahr, -Verkauf)
?- katVerkauf(1, Jahr, Verkauf).
Verkauf = 3837.

%% katVerkauf(-KId, +Jahr, -Verkauf)
?- katVerkauf(KId, 2016, Verkauf).
Verkauf = 1530.

%% katVerkauf(-KId, -Jahr, -Verkauf)
?- katVerkauf(KId, Jahr, Verkauf).
Verkauf = 12444.

%%%% drei Instanziierungsvarianten nutzlos

%% katVerkauf(-KId, -Jahr, +Verkauf)
?- katVerkauf(KId, Jahr, 433).
false.

%% katVerkauf(-KId, +Jahr, +Verkauf)
?- katVerkauf(KId, 2016, 433).
false.

%% katVerkauf(+KId, -Jahr, +Verkauf)
?- katVerkauf(1, Jahr, 433).
false.

%% katVerkauf(+KId, -Jahr, +Verkauf)
?- katVerkauf(1, Jahr, 433).
false.
*/

/****************************************/
/****************************************/
/* Aufgabe 3: Deduktive Datenbanken (2) */
/****************************************/
/****************************************/

/*====== Aufgabe 3.1
das fur beliebige Beispieldatenbanken berechnet, ob Produkt1 Voraussetzung
für die Fertigung von Produkt2 ist. Produkte seien beliebige Komponenten
bzw. fertige Produkte.
*/
voraussetzung(Produkt1,Produkt2) :- 
    arbeitsschritt(Produkt1, _, _, Produkt2).

voraussetzung(Produkt1,Produkt2) :- 
    arbeitsschritt(Produkt1, _, _, Zwischenprodukt),
    voraussetzung(Zwischenprodukt, Produkt2).

/*
?- voraussetzung(box0815, box0817).
true.
*/

/*===== Aufgabe 3.2
Definieren Sie ein zweistelliges Prädikat, das die betroffenen 
Endprodukte für ein beliebiges nichtlieferbares Teil berechnet.
*/
betroffene_produkte(Produkt, L) :- 
    findall(P2, 
            (endprodukt(P2), voraussetzung(Produkt, P2)), 
            L).
/*
?- betroffene_produkte(box0815, L).
L = [galaxy2001, galaxy2002, galaxy2003, galaxy2004].
*/

/*==== Aufgabe 3.3
Definieren Sie ein zweistelliges Prädikat, das eine Liste der von 
einem Maschinenausfall betroffenen Endprodukte berechnet.

Erweitern Sie dazu zunächst das Prädikat voraussetzung/2 aus Aufgabenteil
1 zu einem dreistelligen Prädikat, das uberprüft, ob ein Produktionspfad
zwischen zwei Produkten auch dann noch existiert, wenn ein bestimmter 
Arbeitsplatz nicht mehr zur Verfügung steht. 
*/
% Prüft, ob ein Pfad existiert, der Maschine nicht benutzt.
other_path(Produkt1, Maschine, Produkt2) :- 
    arbeitsschritt(Produkt1, _, Maschine2, Produkt2), 
    Maschine2 \= Maschine.
    
other_path(Produkt1, Maschine, Produkt2) :- 
    arbeitsschritt(Produkt1, _, Maschine2, Zwischenprodukt),
    Maschine \= Maschine2,
    other_path(Zwischenprodukt, Maschine, Produkt2).

%Hilfsfunktion
not_member(_, []) :- !.
not_member(X, [Head|Tail]) :- X \= Head,
                              not_member(X, Tail).

%gibt nur endprodukte zurück.
maschinen_ausfall(Maschine, Endprodukte) :- 
    findall(Endprodukt2, 
            (findall(Endprodukt,
                     other_path(_, Maschine, Endprodukt), 
                     L), 
             endprodukt(Endprodukt2), 
             not_member(Endprodukt2, L)), 
            Endprodukte).
/*
?- maschinen_ausfall(montage2, L).
L = [galaxy2003].
*/

/*===== Aufgabe 3.4
das fur jedes gegebene Paar aus Zulieferteil und Endprodukt 
die Fertigungstiefe berechnet.
*/
fertigungstiefe(Produkt1, Produkt2, Tiefe) :- 
    fertigungstiefe(Produkt1, Produkt2, 0, Tiefe).
    
fertigungstiefe(Produkt1, Produkt2, Acc, Tiefe) :- 
    arbeitsschritt(Produkt1, _, _, Produkt2), Tiefe is Acc + 1.

fertigungstiefe(Produkt1, Produkt2, Acc, Tiefe) :- 
    arbeitsschritt(Produkt1, _, _, Zwischenprodukt),
    Tiefe2 is Acc + 1,
    fertigungstiefe(Zwischenprodukt, Produkt2, Tiefe2, Tiefe).
                                              
/*
?- fertigungstiefe(box0815,galaxy2004 ,T).
T = 3.
*/
