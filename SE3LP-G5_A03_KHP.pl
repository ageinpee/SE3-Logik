/* SE3LP-18W-A03
  Namen:
*/

/*========= A1.1 */
% Berechnet die Anzahl der Produkte einer Kategorie.
anzahl_produkte(KatName, Anz) :- findall(Produkt,
                                         (kategorie(KatID, KatName, _),
                                          produkt(_, KatID, _, _, _, _, _)),
                                         L),
                                 length(L, Anz).

/*========= A1.2 */
% Bisher verkaufte Exemplare einer Kategorie.
verkaufte_exemplare(KatName, Insgesamt_Verkauft) :- findall(Verkauft,
                                             (kategorie(KatID, KatName, _),
                                              produkt(PID, KatID, _, _, _, _, _),
                                              verkauft(PID, _, _, Verkauft)),
                                             L),
                                   sumlist(L, Insgesamt_Verkauft).

/*========= A1.3*/
% Berechnet für ein gegebenes Jahr wie stark die Verkaufserlöse durch die
% Preisnachlässe gegenüber dem vorgegangenem Jahr geschmälert wurden.
schmaelerung(Jahr) :-


/*========= A2.1 */
