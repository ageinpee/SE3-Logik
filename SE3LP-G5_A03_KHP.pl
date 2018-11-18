/* SE3LP-18W-A03
  Namen:
*/
?- consult('medien2.pl').
?- consult('medienKHP.pl').
?- consult('hauser.pl').


/*========= A1.1 */
%% Berechnet die Anzahl der Produkte einer Kategorie.
%% anzahl_produkte(+KatName, ?Anz)

anzahl_produkte(KatName, Anz) :- 
    findall(_,
            (kategorie(KatID, KatName, _),
             produkt(_, KatID, _, _, _, _, _)),
            L),
    length(L, Anz).
/*
%% anzahl_produkte(+KatName, -Anz)
?- anzahl_produkte(krimi, Anz).
Anz = 5.

%% anzahl_produkte(+KatName, +Anz)
?- anzahl_produkte(krimi, 5).
true.

%% anzahl_produkte(+KatName, +Anz)
?- anzahl_produkte(krimi, 3).
false.
*/

/*========= A1.2 */
%% Bisher verkaufte Exemplare einer Kategorie
%% verkaufte_exemplare(+KatName, ?Insgesamt_Verkauft)

verkaufte_exemplare(KatName, Insgesamt_Verkauft) :- 
    findall(Verkauft,
            (kategorie(KatID, KatName, _),
             produkt(PID, KatID, _, _, _, _, _),
             verkauft(PID, _, _, Verkauft)),
            L),
    sumlist(L, Insgesamt_Verkauft).
/*
%% verkaufte_exemplare(+KatName, -Insgesamt_Verkauft)
?- verkaufte_exemplare(krimi, Insgesamt_Verkauft).
Insgesamt_Verkauft = 2114.

%% verkaufte_exemplare(+KatName, +Insgesamt_Verkauft)
?- verkaufte_exemplare(krimi, 2114).
true.

%% verkaufte_exemplare(+KatName, +Insgesamt_Verkauft)
?- verkaufte_exemplare(krimi, 2115).
false.
*/

/*========= A1.3*/
%% Berechnet für ein gegebenes Jahr wie stark die Verkaufserlöse durch die
%% Preisnachlässe gegenüber dem vorgegangenem Jahr geschmälert wurden.
%% schmaelerung(+Jahr1, ?Insgesamt_Erloesdiff)

schmaelerung(Jahr1, Insgesamt_Erloesdiff) :- 
    findall(Erloesdiff,
            (Jahr2 is Jahr1-1,
             verkauft(PID, Jahr1, Preis1, Anz1),
             verkauft(PID, Jahr2, Preis2, Anz2),
             Preis1 < Preis2,
             Erloesdiff is Anz1*Preis1 - Anz2*Preis2),
            L),
    sumlist(L, Insgesamt_Erloesdiff).
/*
%% schmaelerung(+Jahr1, -Insgesamt_Erloesdiff)
?- schmaelerung(2018, Insgesamt_Erloesdiff).
Insgesamt_Erloesdiff = 3489.
--> Bedeutet: Durch den Preisnachlass im Vergleich zum Vorjahr wurden 
    insgesamt 3489 Euro mehr eingenommen.

%% schmaelerung(+Jahr1, +Insgesamt_Erloesdiff)
?- schmaelerung(2018, 3489).
true.

%% schmaelerung(+Jahr1, +Insgesamt_Erloesdiff)
?- schmaelerung(2018, 3490).
false.
*/

/*========= A2.1 */
%% Abfrage, die für einen Kategorienamen/Teilnamen eine List von IDs 
%% zurückgibt, in denen dieser vorkommt.
%% search_by_substring(+K,?Liste)

search_by_substring(K, Liste) :- 
    findall(KatID ,
            (kategorie(KatID, Name, _),
             sub_string(Name, _, Length, _, K), 
             Length \= 0),
            Liste).
/*
%% search_by_substring(+K, -Liste)
?- search_by_substring(buch, L).
L = [1, 2, 3, 13, 14, 15, 20, 21].

%% search_by_substring(+K, +Liste)
?- search_by_substring(buch, [1, 2, 3, 13, 14, 15, 20, 21]).
true.
*/

/*========= A2.2 */
% Kategorie eines Produktes muss immer in dem Kategoriebaum vorhanden sein.
% => Prüfe für wo das nciht der Fall ist
% Bedingung: keine Doppelergebnisse
% Rückgabe liste der ProduktIDs

% produkte_kategorie_nicht_vorhanden(-Liste)

produkte_kategorie_nicht_vorhanden(Liste) :- 
    findall(PID, 
            (produkt(PID, KID,_,_,_,_,_),
             not(kategorie(KID,_,_))), 
            Liste).
/*
%% produkte_kategorie_nicht_vorhanden(-Liste)
?- produkte_kategorie_nicht_vorhanden(Liste).
Liste = [99999].
*/

/*========= A2.3
Schlüssel und Namen aller Kategorien, die keine gültigen Oberkategorie 
zugeordnet sind.
*/

%% kategorie_obere_kategorie_ungueltig(-Liste)

kategorie_obere_kategorie_ungueltig(Liste) :- 
    findall([KID, Name], 
            (kategorie(KID, Name, OID), 
             OID \= 0,
             not(kategorie(OID, _, _))), 
            Liste).
            
/*
%% kategorie_obere_kategorie_ungueltig(-Liste)
?- kategorie_obere_kategorie_ungueltig(Liste).
Liste = [[9000, nicht_gueltige_oberkategorie]].
*/

/*========= A2.4
In einer Hierarchie ist fur jeden Knoten der übergeordnete Knoten eindeutig
bestimmt. Definieren Sie ein Prädikat, das diejenigen Kategorien ermittelt,
für die diese Bedingung verletzt ist.
=> Die ID der Oberkategorie gibt es mehrfach.
=> gibt Kategorien(ID) aus, für die dieses zutrifft.
*/

%% mehrere_oberkategorien(-L)

mehrere_oberkategorien(L) :- 
    findall(KatID, 
            (kategorie(KatID, _,OID), 
             findall(OID, 
                     kategorie(OID,_,_), 
                     Sub_Liste),
             length(Sub_Liste, Laenge),
             Laenge > 1),
            L).
/*
%% mehrere_oberkategorien(-L)
?- mehrere_oberkategorien(L).
L = [9000].
*/

/*========= A3.1
neueigentuemer(?Eigentumer, ?Strasse, ?Hausnummer)
*/
neueigentuemer(Eigentuemer, Strasse, Hausnummer) :-
    bew(_, ONr, _, Eigentuemer, _, Verkaufsdatum),
    not((bew(_, ONr, Eigentuemer, _, _, Verkaufsdatum2),
         Verkaufsdatum2 > Verkaufsdatum)),
    obj(ONr, _, Strasse, Hausnummer, _).
/*
%% neueigentuemer(-Eigentümer,-Strasse,-Hausnummer)
?- neueigentuemer( Eigentümer, Strasse, Hausnummer).
Eigentümer = meier,
Strasse = gaertnerstr,
Hausnummer = 15;
Eigentümer = mueller,
Strasse = bahnhofsstr,
Hausnummer = 29;
Eigentümer = piepenbrink,
Strasse = bahnhofsstr,
Hausnummer = 30.

%% neueigentuemer(+Eigentümer,-Strasse,-Hausnummer)
?- neueigentuemer(mueller,Strasse,Hausnummer).
Strasse = bahnhofsstr,
Hausnummer = 29.

%% neueigentuemer(+Eigentümer,-Strasse,-Hausnummer)
?- neueigentuemer(schneider,Strasse,Hausnummer).
false.

%% neueigentuemer(-Eigentümer,+Strasse,-Hausnummer)
?- neueigentuemer(Eigentümer,bahnhofsstr,Hausnummer).
Eigentümer = mueller,
Hausnummer = 29;
Eigentümer = piepenbrink,
Hausnummer = 30.

%% neueigentuemer(-Eigentümer,+Strasse,-Hausnummer)
?- neueigentuemer(Eigentümer,bahnhofsstr,29).
Eigentümer = mueller;
false.

/*========= A3.2
vorbesitzer(?ObjektID,?Besitzer,?Vorbesitzer)
1. mit findall
2. Reihenfolge -> Rekursion
*/
vorbesitzer1(ObjektID, Besitzer, Vorbesitzer) :- 
    bew(_,ObjektID,_,Besitzer,_,Datum),
    findall(Verkaufer, 
            (bew(_,ObjektID,Verkaufer,_,_,Datum2), 
             Datum >= Datum2),
            Vorbesitzer).
/*
%% vorbesitzer(+ObjektID,+Besitzer,-Vorbesitzer)
?- vorbesitzer1(3, mueller, Vorbesitzer).
Vorbesitzer = [schulze, schneider].

%% vorbesitzer(+ObjektID,-Besitzer,-Vorbesitzer)
?- vorbesitzer1(3, Besitzer, Vorbesitzer).
Besitzer = schneider,
Vorbesitzer = [schulze];
Besitzer = mueller,
Vorbesitzer = [schulze, schneider].

%% vorbesitzer(-ObjektID,+Besitzer,-Vorbesitzer)
?- vorbesitzer1(ObjektID, mueller, Vorbesitzer).
ObjektID = 3,
Vorbesitzer = [schulze, schneider].

%% vorbesitzer(-ObjektID,-Besitzer,+Vorbesitzer)
?- vorbesitzer1(ObjektID, Besitzer, [schulze, schneider]).
ObjektID = 3,
Besitzer = mueller.
*/
vorbesitzer2(ObjektID, Besitzer, Vorbesitzer) :- 
    bew(_, ObjektID, Vorbesitzer, Besitzer, _, _).
    
vorbesitzer2(ObjektID, Besitzer, Vorbesitzer) :- 
    bew(_, ObjektID, Verkaufer, Besitzer, _, _),
    vorbesitzer2(ObjektID, Verkaufer, Vorbesitzer).
/*
%% vorbesitzer(+ObjektID,+Besitzer,-Vorbesitzer)
?- vorbesitzer2(3, mueller, Vorbesitzer).
Vorbesitzer = schneider;
Vorbesitzer = schulze.

%% vorbesitzer(+ObjektID,-Besitzer,-Vorbesitzer)
?- vorbesitzer2(3, Besitzer, Vorbesitzer).
Besitzer = schneider,
Vorbesitzer = schulze;
Besitzer = mueller,
Vorbesitzer = schneider;
Besitzer = mueller,
Vorbesitzer = schulze.

%% vorbesitzer(-ObjektID,+Besitzer,-Vorbesitzer)
?- vorbesitzer2(ObjektID, mueller, Vorbesitzer).
ObjektID = 3,
Vorbesitzer = schneider;
ObjektID = 3,
Vorbesitzer = schulze.

%% vorbesitzer(-ObjektID,-Besitzer,+Vorbesitzer)
?- vorbesitzer2(ObjektID, Besitzer, schulze).
ObjektID = 3,
Besitzer = schneider.
ObjektID = 3,
Besitzer = mueller.
*/
/*
Bei der ersten werden direkt im ersten Atemzug alle Vorbesitzer 
zurückgegeben. Wie man aber gut erkennen kann ist die Reihenfolge 
falsch. 

Die zweite Funktion hat einen Rekursiven Ansatz. Hier ist die 
Reihenfolge richtig, man bekommt aber nicht sofort alle Vorbesitzer 
geliefert. Je nach Anwendungsfall kann man sich somit eine Variante
aussuchen.
*/
