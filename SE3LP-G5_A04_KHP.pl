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
