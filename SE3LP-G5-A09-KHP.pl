/* SE3LP-18W-A08
  Namen: Chung-Shan Kao, Harm Matthias Harms, Henrik Peters
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                              %%%%
%%%% Aufgabe 1: Vektorenalgebra                                   %%%%
%%%%                                                              %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

skalar([H1], [H2], E) :- E is H1 * H2.
skalar([H1 | R1], [H2 | R2], E) :- skalar(R1, R2, E2), E is H1 * H2 + E2.
% ?- once(skalar([1], [1], E)).
% E = 1.
% ?- once(skalar([1, 2], [1, 2], E)).
% E = 5.

laenge(V, E) :- sum_under_sqrt(V, S), E is sqrt(S).
% ?-laenge([1], E).
% E = 1.0.
% ?- laenge([7, 4, 4], S).
% S = 9.0.

sum_under_sqrt([H], S) :- S is H**2.
sum_under_sqrt([H|R], S) :- sum_under_sqrt(R, S2), S is H**2 + S2.
% ?- sum_under_sqrt([1, 2], S).
% S = 5.

cos(V1, V2, C) :- skalar(V1, V2, S), laenge(V1, L1), laenge(V2, L2), C is S / (L1 * L2).
% ?- cos([1], [1], C).
% C = 1.0.
% ?- cos([3, 4], [4, 3], C).
% C = 0.96.