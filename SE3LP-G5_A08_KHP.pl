/* SE3LP-18W-A07
  Namen: Chung-Shan Kao, Harm Matthias Harms, Henrik Peters
*/
consult('texte.pl').
consult('chatbot_db.pl').

                        /*====================*/
                        /*==== Aufgabe 1 =====*/
                        /*====================*/
%% Chatbot Asiliza

/*****************************************************************************/
/*------ Hilfsfakten ------*/
y_char_type(46,period) :- !.
my_char_type(X,alphanumeric) :- X >= 65, X =< 90, !.
my_char_type(X,alphanumeric) :- X >= 97, X =< 123, !.
my_char_type(X,alphanumeric) :- X >= 48, X =< 57, !.
my_char_type(X,whitespace) :- X =< 32, !.
my_char_type(X,punctuation) :- X >= 33, X =< 47, !.
my_char_type(X,punctuation) :- X >= 58, X =< 64, !.
my_char_type(X,punctuation) :- X >= 91, X =< 96, !.
my_char_type(X,punctuation) :- X >= 123, X =< 126, !.
my_char_type(_,special).

/*****************************************************************************/
/*---- Hilfs-Prädikate ----*/

% lower_case(+C,?L)
% Setzt einen ASCII Buchstaben ins lower_case

lower_case(X,Y) :-
	X >= 65,
	X =< 90,
	Y is X + 32, !.

lower_case(X,X).

% read_lc_string(-String)
%  Liest einen String aus der Eingabe als Liste aus lowercase Strings ein
read_lc_string(String) :-
	get0(FirstChar),
	lower_case(FirstChar,LChar),
	read_lc_string_aux(LChar,String).

read_lc_string_aux(10,[]) :- !.  % end of line

read_lc_string_aux(-1,[]) :- !.  % end of file

read_lc_string_aux(LChar,[LChar|Rest]) :- read_lc_string(Rest).
