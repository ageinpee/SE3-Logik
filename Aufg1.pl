% Prolog Text mit Fakten
mann(adam).
mann(tobias).
mann(frank).
frau(eva).
frau(daniela).
frau(ulrike).
vater(adam,tobias).
vater(tobias,frank).
vater(tobias,ulrike).
mutter(eva,tobias).
mutter(daniela,frank).
mutter(daniela,ulrike).

?- mann(tobias).
?- mann(heinrich).

?- frau(X).

% Prolog Text mit Regel
grossvater(X,Y) :-
    vater(X,Z),
    vater(Z,Y).

grossvater(X,Y) :-
    vater(X,Z),
    mutter(Z,Y).

?- grossvater(adam,ulrike).
?- grossvater(X,frank).
