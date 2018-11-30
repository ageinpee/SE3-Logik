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

/*-----Aufgabe 1.2----*/
%%Definition der Peano-Greater-Equals-Funktion
%%Die Funktion benutzt die Funktion aus Aufgabe 1.1 um die zwei
%%Peanozahlen in Integer zu verwandeln und vergleicht sie dann
%%normal mittels >=.
peanoGEQ(s(P1), s(P2)) :- peano2int(P1, N1),
                          peano2int(P2, N2),
                          N1>=N1.

/*-----Aufgabe 1.3----*/
%%Hilfsfunktion für halbieren. Wandelt einen Integer in eine
%%Peanozahl um.
int2peano(0, 0).
int2peano(Number, s(Peano)) :- Number > 0,
                               Acc is Number-1,
                               int2peano(Acc, Peano).

%
% divide M (the dividend) by N (the divisor),
%yielding the quotient (Q) and remainder (R).
integer_division( M , N , Q , R ) :- M > 0 ,
                                     N > 0 ,
                                     div_rem( M , N , 0 , Q , R ).

 %
 % internal worker predicate for integer division
 % requires dividend and divisor both to be unsigned (positive).
 %
 div_rem( M , N , Q , Q , M ) :-  % dividend M < divisor N? We're done.
   M < N ,                        % - unify the accumulator with the quotient
   .                              % - and unify the divisor with the remainder
 div_rem( M , N ,T , Q , R ) :-   % dividend M >= divisor N?
   M >= N ,                       % - increment the accumulator T
   T is T+1 ,                     % - decrement the divisor by N
   M1 is M-N ,                    % - recurse down
   div_rem( M1 , N , T1 , Q , R ) % - That's all.
   .                              % Easy!


%%Die halbieren Funktion.
halbieren(s(Peano), Halbes, Rest) :- peano2int(Int, Peano),
                                     integer_division(Int, 2, Halbes, Rest).


/*====================*/
/*==== Aufgabe 2 =====*/
/*====================*/

/*====================*/
/*==== Aufgabe 3 =====*/
/*====================*/

/*====================*/
/*==== Aufgabe 4 =====*/
/*====================*/
