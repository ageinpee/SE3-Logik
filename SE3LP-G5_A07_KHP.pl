/* SE3LP-18W-A06
  Namen: Chung-Shan Kao, Harm Matthias Harms, Henrik Peters
*/
?- consult('texte_latin1.pl').

/*====================*/
/*==== Aufgabe 1 =====*/

%% del_stop startet und checkt mittels member ob ein Wort in der Stopliste ist.
%% Wenn ja wird dann mittels ! das Backtracing abgebrochen und es geht mit dem
%% nächsten Wort weiter. Wenn nicht wird rekursiv weiter gerechnet. Die Rekursion
%% wird abgebrochen wenn beide Listen leer sind.
del_stop(_,[],[]).
del_stop(Stops,[Word|Words],R):- member(Word, Stops),
                                 !,
                                 del_stop(Stops, Words, R).
del_stop(Stops,[Word|Words],[R|Rs]):- del_stop(Stops, Words, Rs).

%% Beispiel:
%% ?- stop(S), text(1, T), del_stop(S, T, R).
%% S = [der, die, das, den, dem, des, diese, dieser, diesem|...],
%% T = [nachdem, er, eine, feuerwerksrakete, von, seinem, hintern, aus, gezündet|...],
%% R = [_5390, _5396, _5402, _5408, _5414, _5420, _5426, _5432, _5438|...]

/*====================*/
/*==== Aufgabe 2 =====*/
/*====================*/
/*-----Aufgabe 2.1----*/
