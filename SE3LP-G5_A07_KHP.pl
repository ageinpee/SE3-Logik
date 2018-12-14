/* SE3LP-18W-A06
  Namen: Chung-Shan Kao, Harm Matthias Harms, Henrik Peters
*/
?- consult('texte_latin1.pl').

/*====================*/
/*==== Aufgabe 1 =====*/

%% 
remove_stops(_,[],[]).
remove_stops(L2,[Element|Tail],R):- member(Element, L2)
                                   ,!
                                   ,remove_stops(L2,Tail,R).
remove_stops(L2,[Element|Tail],[Element|R]):- remove_stops(L2,Tail,R).


/*====================*/
/*==== Aufgabe 2 =====*/
/*====================*/
/*-----Aufgabe 2.1----*/
