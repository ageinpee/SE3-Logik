/* SE3LP-18W-A05
  Namen: Chung-Shan Kao, Harm Matthias Harms, Henrik Peters
*/
?- consult('medien2.pl').
?- consult('medienKHP.pl').
?- consult('hauser.pl').
?- consult('galaxy.pl').

/*====================*/
/*==== Aufgabe 1 =====*/
/*====================*/
/*-----Aufgabe 1.1----*/
%%Definietionen von Peano-Zahlen wie in der Vorlesung:
peano(0).
peano(s(X)) :- peano(X).

%%Definition der peano 2 int Funktion.
%%Erster Parameter entspricht einer Peano-Zahl. Zweiter Parameter
%%soll der zu suchende Integer sein.
%%Der Acc wird genutzt um mit jeder Peano-Ebene die Integer-Variable
%%hochzuzöhlen.
peano2int(0,0).
peano2int(s(Peano), Int):- peano2int(Peano,Acc),
                           Int is Acc +1.

%% Beispiel:
%% ?- peano2int(s(s(s(s(0)))), Int).
%% Int = 4.

/*-----Aufgabe 1.2----*/
%%Definition der Peano-Greater-Equals-Funktion
%%Die Funktion benutzt die Funktion aus Aufgabe 1.1 um die zwei
%%Peanozahlen in Integer zu verwandeln und vergleicht sie dann
%%normal mittels >=.
peanoGEQ(s(P1), s(P2)) :- peano2int(P1, N1),
                          peano2int(P2, N2),
                          N1>=N2.

%% Beispiel 4 >= 2:
%% peanoGEQ(s(s(s(s(0)))), s(s(0))).
%% true.

%% Beispiel 2 >= 4:
%% ?- peanoGEQ(s(s(0)), s(s(s(s(0))))).
%% false.

%% Beispiel 2 >= 2:
%% ?- peanoGEQ(s(s(0)), s(s(0))).
%% true.


/*-----Aufgabe 1.3----*/
%% Die Peanozahl Peano wird in einen Integer umgewandelt womit anschließend
%% mittels der Prolog-eigenen divmod-Funktion die Hälfte und der Rest berechnet
%% werden. Da die Form der Ausgabe nicht definiert wurde, ist die Ausgabe für
%% Half und Remainder bei uns ein Integer.
peanoDivMod(Peano, Half, Remainder) :- peano2int(Peano, Int),
                                       divmod(Int, 2, Half, Remainder).

%% Beispiel Peano = 3:
%% ?- peanoDivMod(s(s(s(0))), Half, Remainder).
%% Half = Remainder, Remainder = 1.

%% Beispiel Peano = 5:
%% ?- peanoDivMod(s(s(s(s(s(0))))), Half, Remainder).
%% Half = 2,
%% Remainder = 1.

%% Beispiel Peano = 2:
%% ?- peanoDivMod(s(s(0)), Half, Remainder).
%% Half = 1,
%% Remainder = 0.

%% Kann unser Prädikat auch zum Verdoppeln einer Peanozahl verwendet werden?
%% --> Jein. Mit einer Integer Eingabe beim Parameter Half ist es möglich das
%%     doppelte, oder das doppelte +1, dieser Zahl als Peano zu berechnen.
%%     Beispiel - 2 mit Rest 0:
%%     ?- peanoDivMod(X, 2, 0).
%%     X = s(s(s(s(0)))) .
%%     Beispiel - 2 mit Rest 1:
%%     ?- peanoDivMod(X, 2, 1).
%%     X = s(s(s(s(s(0))))) .

/*-----Aufgabe 1.4----*/
%% max iteriert rekursiv über die Peanozahlen, bis eine von beiden
%% 0 ergibt.
peanoMax(0, X, X).
peanoMax(X, 0, X).
peanoMax(s(X), s(Y), s(Z)) :- peanoMax(X, Y, Z).

%% Beispiel max(3, 1)
%% ?- peanoMax(s(s(s(0))), s(0), X).
%% X = s(s(s(0))) ;
%% false.

%% Beispiel max(1, 3)
%% ?- peanoMax(s(0), s(s(s(0))), X).
%% X = s(s(s(0))) ;
%% false.

/*-----Aufgabe 1.5----*/
%% Hilfsprädiakte aus dem Skript. Berechnet die Bauernmultiplikation für Integer.
rbm(F1, 1, F1).
rbm(F1, F2, R) :- F2>1,
                  odd(F2),
                  F21 is F2-1,
                  rbm(F1, F21, R1),
                  R is R1+F1.
rbm(F1, F2, R) :- F2>1,
                  even(F2),
                  F11 is F1*2,
                  F21 is F2/2,
                  rbm(F11, F21, R).

%% Hilfsprädikate für die Hilfsprädikate aus dem Skript
odd(X) :- 1 is X mod 2.
even(X) :- X>0, 0 is X mod 2.

%% Prädikat für die Peano-Bauernmultiplikation. Die Peanozahlen werden in
%% Integer umgewandelt und anschließend mittels der aus dem Skript stammenden
%% Hilfsprädikate verrechnet. Da die Form der Ausgabe hier nicht definier ist,
%% wird diese als Integer ausgegeben.
peanoRBM(Peano1, Peano2, Result) :- peano2int(Peano1, Int1),
                                    peano2int(Peano2, Int2),
                                    rbm(Int1, Int2, Result).
%% Beispiel 2*3:
%% peanoRBM(s(s(0)), s(s(s(0))), Result).
%% Result = 6 .

%% Können wir unser Prädikat auch für die Division verwenden?
%% --> Ja. Das Beispiel zeigt eine Rechnung von 6/2. Die Ausgabe ist allerdings
%%     kein Integer sondern eine Peanozahl.
%% Beispiel 6/2:
%% ?- peanoRBM(X, s(s(0)), 6).
%% X = s(s(s(0))) .

/*====================*/
/*==== Aufgabe 2 =====*/
/*====================*/

:- consult('systematik.pl').

%% kategorien(?Art, ?Liste)
kategorien(Art, [['reich',Art]]) :-
    reich(Art).

kategorien(Art, [[Kat,Art]|L]) :-
    sub(Art,Kat,Oberkategorie),
    kategorien(Oberkategorie, L).

/*
%%%% Vier Instanziierungsvarianten

%% kategorien(+Art, -Liste)
?- kategorien(menschenfloh, Liste).
Liste = [[art, menschenfloh],
         [gattung, pulex],
         [familie, pulicidae],
         [ordnung, floehe],
         [klasse, insekten],
         [stamm, gliederfuesser],
         [reich, vielzeller]].

%% kategorien(+Art, +Liste)
?- kategorien(menschenfloh, [[art, menschenfloh],
                             [gattung, pulex],
                             [familie, pulicidae],
                             [ordnung, floehe],
                             [klasse, insekten],
                             [stamm, gliederfuesser],
                             [reich, vielzeller]]).
true.

?- kategorien(menschenfloh, [[art, menschenfloh],
                             [gattung, pulex],
                             [familie, pulicidae],
                             [ordnung, floehe],
                             [klasse, insekten],
                             [stamm, gliederfuesser],
                             [reich, viren]]). % kein Virus
false.

%% kategorien(-Art, +Liste)
?- kategorien(Art, [[art, menschenfloh],
                    [gattung, pulex],
                    [familie, pulicidae],
                    [ordnung, floehe],
                    [klasse, insekten],
                    [stamm, gliederfuesser],
                    [reich, vielzeller]]).
Art = menschenfloh.

%% kategorien(-Art, -Liste)
?- kategorien(Art, Liste).
Art = vielzeller,
Liste = [[reich, vielzeller]];
Art = bakterien,
Liste = [[reich, bakterien]];
Art = viren,
Liste = [[reich, viren]];
Art = pflanzen,
Liste = [[reich, pflanzen]];
Art = pilze,
Liste = [[reich, pilze]];
Art = schwaemme,
Liste = [[stamm, schwaemme], [reich, vielzeller]];
Art = kalkschwaemme,
Liste = [[klasse, kalkschwaemme], [stamm, schwaemme],
         [reich, vielzeller]];
Art = gliederfuesser,
Liste = [[stamm, gliederfuesser], [reich, vielzeller]];
Art = insekten,
Liste = [[klasse, insekten], [stamm, gliederfuesser],
         [reich, vielzeller]];
Art = kaefer,
Liste = [[ordnung, kaefer], [klasse, insekten],
         [stamm, gliederfuesser], [reich, vielzeller]];
Art = schmetterlinge,
Liste = [[ordnung, schmetterlinge], [klasse, insekten],
         [stamm, gliederfuesser], [reich, vielzeller]].
*/

/*====================*/
/*==== Aufgabe 3 =====*/
/*====================*/

/*===== Aufgabe 3.1
ein dreistelliges
Pr¨adikat, das fur ein gegebenes Zulieferteil und ein gegebenes End- ¨
produkt die Fertigungstiefe auf einem Produktionsfad vom Zulieferteil zum
Endprodukt ermittelt.
*/
fertigungstiefe(Produkt1,Produkt2,1) :- arbeitsschritt(Produkt1,_,_,Produkt2).
fertigungstiefe(Produkt1,Produkt2,Tiefe) :- arbeitsschritt(Produkt1,_,_,Zwischenprodukt),
                                          fertigungstiefe(Zwischenprodukt,Produkt2,Deep),
                                          Tiefe is Deep+1.
/*
?- fertigungstiefe(box0815, box0817, T).
T = 2.
*/

/*===== Aufgabe 3.2
Definieren Sie ein dreistelliges Pr¨adikat, das fur ein gegebenes Endprodukt ¨
die Anzahl der dafur ben ¨ ¨otigten Zulieferteile einer bestimmten Art berechnet.
Ob ein Teil ein Zulieferteil ist, wird im Pr¨adikat zulieferung/1 spezifiziert.
*/
anzahl_zulieferteil(Endprodukt, Zulieferteil, Anzahl) :- zulieferung(Zulieferteil), endprodukt(Endprodukt),
                                                          anzahl_zulieferteil_rek(Endprodukt, Zulieferteil, Anzahl).
anzahl_zulieferteil_rek(Endprodukt, Zulieferteil, Anzahl) :- arbeitsschritt(Zulieferteil, Stueckzahl, _, Endprodukt),
                                                        Anzahl = Stueckzahl.
anzahl_zulieferteil_rek(Endprodukt, Zulieferteil, Anzahl) :- arbeitsschritt(Zulieferteil, Stueckzahl2, _, Zwischenprodukt),
                                                              anzahl_zulieferteil_rek(Endprodukt, Zwischenprodukt, Stueckzahl),
                                                              Anzahl is Stueckzahl2 + Stueckzahl.
/* anzahl_zulieferteil
?- anzahl_zulieferteil(galaxy2004, box0815, Anzahl).
Anzahl = 7 ;
*/

/*===== Aufgabe 3.3
Definieren Sie ein Pr¨adikat, das fur eine gegebene Anzahl von Zulieferteilen ¨
die Anzahl der maximal daraus noch zu fertigenden Endprodukte ermittelt.
*/
anzahl_endprodukte(Endprodukt, AnzahlE, Zulieferteil, AnzahlZ) :- anzahl_zulieferteil(Endprodukt, Zulieferteil,
                                                                                      Anzahl),
                                                                  AnzahlE is AnzahlZ / Anzahl.
/*
?- anzahl_endprodukte(galaxy2004, AnzhalE, box0815, 14).
AnzhalE = 2.
*/

/*====================*/
/*==== Aufgabe 4 =====*/
/*====================*/

/*
%%%% Gemeinsamkeiten und Unterschiede

Bei den Prädikatsdefinitionen für die genannten Datenbasen weisen die
intensional definierten Relationen Hierarchie und Transitivität auf.
Die Relationen lassen sich also durch gerichtete Graphen darstellen.
Ein Knoten steht in Relation zu allen Knoten, die sich im gleichen 
Kantenzug befinden und hierarchisch tiefer sind.

Andererseits unterscheiden sich die Relationen in den Besonderheiten
der jeweiligen Datenbasen: Beim Besitzerwechsel im Immobilienhandel
besteht der Graph aus Wegen, die nicht miteinander zusammenhängen; 
jeder Weg zeigt den Besitzerwechsel eines Immobilienobjektes. Bei den
Kategorien in der Mediendatenbank enthält der Graph kurze Bäume und 
einzelne alleinstehende Knoten; es gibt nämlich Kategorien, die zwar
mit aufgelistet sind, in denen jedoch kein Produkt vorhanden ist. Die
Systematisch biologischer Arten ist ein zusammenhänender großer Baum.
Bei der Familiendatenbank stellt die Vor-/Nachfahren-Beziehung auch 
einen zusammenhängenden Baum dar. Bei der Produktionsplanung ähnelt
die Relation einem Netzwerk mit Quell- und Zielknoten, wobei sich die
Wege an Zwischenknoten kreuzen. Bei der Wegplanung ist die Relation
auch ähnlich einem Netzwerk, jedoch nicht notwendigerweise mit 
deutlichen Quell- und Zielknoten.



%%%% Bedingungen für terminierungssichere Prädikatsaufrufe

Da die Relationen hierarchisch und trasitiv sind, lassen sie durch 
rekursive Prädikatsaufrufe ermitteln. Allerdings kann die Rekursion
Terminierungsprobleme hervorrufen, wenn die transitive Relation 
zugleich symmetrisch ist. (Um Redundanz zu vermeiden, sind extensional
definierte zweistellige Relationen im Grund unsymmetrisch. Die
Symmetrie wird durch intensionale Spezifikation hergestellt.)

Ein Beispiel aus der Wegplanung: 
con(Stadt1,Stadt2) :- con(Stadt1,Stadt2).

Ein weiteres Beispiel aus der familiären Beziehung:
geschwister_von(Person1,Person2) :- geschwister_von(Person2,Person1).

Ein rekursive Prädikatsaufruf wird in endlose zyklische Schleife 
geraten, weil die folgenden Bedingungen einer Rekursion nicht alle zu 
erfüllen sind:

% Jeder Rekusionsschritt sollte die Argumente an die Bedingung zum
  Rekursionsabbruch näher bringen (z.B. ein Listenargument verkürzt).
  
% Die Abbruchbedingung muss so formuliert werden, dass die Iterationen
  nicht über das Ziel hinaus weiter laufen.

Bei den oben genannten Beispielen kommt ein rekursiver 
Prädikatsaufruf zwar im Rekursionsschritt dem Ziel näher, schießt aber 
wieder übers Ziel hinaus und läuft weiter. Somit geht die zyklische 
Schleife nie zu Ende.
*/
