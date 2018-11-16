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

% Bisher verkaufte Exemplare einer Kategorie.
verkaufte_exemplare(KatName, Anz) :- findall(Verkauft,
                                             (kategorie(KatID, KatName, _),
                                              produkt(PID, KatID, _, _, _, _, _),
                                              verkauft(PID, _, _, Verkauft)),
                                             L).
                                             % --> not working yet

% Berechnet für ein gegebenes Jahr wie stark die Verkaufserlöse durch die
% Preisnachlässe gegenüber dem vorgegangenem Jahr geschmälert wurden.
schmaelerung(Jahr) :-
