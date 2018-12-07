/* SE3LP-18W-A06
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
%% Berechnet den goldenen Schnitt induktiv.
%% Rekursionsanfang: ruft bloß das Rekursionsprädikat auf.
goldener_schritt(Steps, Result) :-
    goldener_schritt_rec(Steps, 0, Result).
%% Rekusionsprädikat 1: Wenn die gewünschte Anzahl an Schritten erreicht ist,
%%                      wird 2 als Result eingesetzt.
goldener_schritt_rec(Steps, Step, Result) :-
    Step==Steps,
    Result=2.
%% Rekusionsprädikat 2: Wird für den Aufbau des Rekusionssatpels genutzt.
%%                      Solange der aktuelle Step kleiner ist, als die gewünschte
%%                      Anzahl, werden die Steps hochgezählt und das Rekusions-
%%                      prädikat wird mit erneut aufgerufen. Wenn der Rekursions-
%%                      stapel dann wieder abgebaut wird, wird das Result
%%                      zusammen gerechnet.
goldener_schritt_rec(Steps, Step, Result) :-
    Step @< Steps,
    NextStep is Step+1,
    goldener_schritt_rec(Steps, NextStep, Result2),
    Result is 1+1/Result2.
%% Beispiel:
%% ?- goldener_schritt(10, X).
%% X = 1.6180555555555556 ;
%% false.

%% Berechnet den goldenen Schnitt endrekursiv.
%% Rekursionsanfang: ruft das Rekursionsprädikat auf.
goldener_schritt_endrek(Steps, Result) :-
    goldener_schritt_endrek_rec(Steps, 0, 2, Result).
%% Rekursionsende: Wenn die gewünschte ANzhal an Steps erreicht ist, wird der
%%                 Akkumulator als Result ausgegeben.
goldener_schritt_endrek_rec(LastStep, Step, Acc, Result) :-
    LastStep == Step,
    Result is Acc.
%% Rekursionsschritt: Sowohl der Step-Counter als auch der Akkumulator werden
%%                    hochgezählt bzw. weiterberechnet. Dann wird das Prädikat
%%                    erneut aufgerufen. Durch den Akkumulator erzeugen wir hier
%%                    Endrekursion.
goldener_schritt_endrek_rec(LastStep, Step, Acc, Result) :-
    Step @< LastStep,
    Acc2 is 1+1/Acc,
    NextStep is Step+1,
    goldener_schritt_endrek_rec(LastStep, NextStep, Acc2, Result).
%% Beispiel:
%% ?- goldener_schritt_endrek(10, X).
%% X = 1.6180555555555556 ;
%% false.

/*====================*/
/*-----Aufgabe 1.2----*/
%% Die endrekursive Variante ist deutlich schneller als die induktive Variante:
%%
%% ?- time(goldener_schritt_endrek(1000000, X)).
%% % 3,000,002 inferences, 0.407 CPU in 0.410 seconds (99% CPU, 7373168 Lips)
%% X = 1.618033988749895 ;
%% % 5 inferences, 0.000 CPU in 0.000 seconds (64% CPU, 172414 Lips)
%% false.
%%
%% ?- time(goldener_schritt(100000, X)).
%% % 300,002 inferences, 0.789 CPU in 0.795 seconds (99% CPU, 380404 Lips)
%% X = 1.618033988749895 ;
%% % 7 inferences, 0.002 CPU in 0.002 seconds (97% CPU, 3121 Lips)
%% false.
%%
%% Zu sehen ist, dass die induktive Variante mit einem Zehntel der Schritte
%% schon beinahe doppelt so lange braucht, wie die endrekursive Variante.
%% Die Verständlichkeit ist für beide Varianten ziemlich ähnlich, wenn man sich
%% eh schon mit Rekursion auskennt.
%% Anmerkung: Die Frage nach Verständlichkeit ist nicht besonders sinnvoll, da
%%            das hoch subjektiv ist.

/*====================*/
/*-----Aufgabe 1.3----*/


%%
%% 
