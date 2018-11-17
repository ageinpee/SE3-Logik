/* SE3LP-18W-A03
  Namen:
*/
?- consult('medien2.pl').
?- consult('medienKHP.pl').

/*========= A1.1 */
% Berechnet die Anzahl der Produkte einer Kategorie.
anzahl_produkte(KatName, Anz) :- findall(_,
                                         (kategorie(KatID, KatName, _),
                                          produkt(_, KatID, _, _, _, _, _)),
                                         L),
                                 length(L, Anz).
/*
 ?- anzahl_produkte(krimi, Anz).
 Anz = 5.
*/

% Bisher verkaufte Exemplare einer Kategorie
verkaufte_exemplare(KatName, Insgesamt_Verkauft) :- findall(Verkauft,
                                             (kategorie(KatID, KatName, _),
                                              produkt(PID, KatID, _, _, _, _, _),
                                              verkauft(PID, _, _, Verkauft)),
                                             L),
                                   sumlist(L, Insgesamt_Verkauft).
/*
?- verkaufte_exemplare(krimi, Insgesamt_Verkauft).
Insgesamt_Verkauft = 2114.
*/
/*========= A1.3*/
% Berechnet für ein gegebenes Jahr wie stark die Verkaufserlöse durch die
% Preisnachlässe gegenüber dem vorgegangenem Jahr geschmälert wurden.
% schmaelerung(Jahr) :-


/*========= A2.1 */
%Abfrage, die für einen Kategorienamen/Teilnamen eine List von ID's zurückgibt, in denen dieser vorkommt.
search_by_substring(K, Liste) :- findall(KatID , 
                                          (kategorie(KatID, Name, _), 
                                            sub_string(Name, _, Length, _, K), Length \= 0), 
                                          Liste).
/*
?- verwandte_kategorien(buch, L).
L = [1, 2, 3, 13, 14, 15, 20, 21].
*/
 
/*========= A2.2 */
% Kategorie eines Produktes muss immer in dem Kategoriebaum vorhanden sein. => Prüfe für wo das nciht der Fall ist
% Bedingung: keine Doppelergebnisse
% Rückgabe liste der ProduktID's
produkte_kategorie_nicht_vorhanden(Liste) :- findall(PID, (produkt(PID, KID,_,_,_,_,_), 
                                                          not(kategorie(KID,_,_))), Liste).
/*
?- produkte_kategorie_nicht_vorhanden(Liste).
Liste = [99999].
*/

/*========= A2.3 
Schlüssel und Namen aller Kategorien, die keine gültigen Oberkategorie zugeordnet sind.
*/
kategorie_obere_kategorie_ungueltig(Liste) :- findall([KID, Name], (kategorie(KID, Name, OID), OID \= 0,
                                                                  not(kategorie(OID, _, _))), Liste).
/*
?- kategorie_obere_kategorie_ungueltig(Liste).
Liste = [[9000, nicht_gueltige_oberkategorie]].
*/

/*========= A2.4
In einer Hierarchie ist fur jeden Knoten der übergeordnete Knoten eindeutig ¨
bestimmt. Definieren Sie ein Prädikat, das diejenigen Kategorien ermittelt,
für die diese Bedingung verletzt ist.
=> Die ID der Oberkategorie gibt es mehrfach.
=> gibt Kategorien(ID) aus, für die dieses zutrifft.
*/

mehrere_oberkategorien(L) :- findall(KatID, (kategorie(KatID, _,OID), findall(OID, kategorie(OID,_,_), Sub_Liste), 
                                            length(Sub_Liste, Laenge), 
                                            Laenge > 1), 
                                    L).
/*
?- mehrere_oberkategorien(L).
L = [9000].
*/