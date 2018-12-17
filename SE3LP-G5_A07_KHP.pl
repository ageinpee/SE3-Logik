/* SE3LP-18W-A07
  Namen: Chung-Shan Kao, Harm Matthias Harms, Henrik Peters
*/
consult('texte.pl').

/*====================*/
/*==== Aufgabe 1 =====*/
/*
del_stop/4 checkt mittels member/2 und number/1, ob ein Wort in der 
Stoppwortliste oder eine Zahl ist. Wenn ja, dann geht es mit dem 
nächsten Wort rekursiv weiter. Wenn nicht, wird das Wort zu dem neuen 
Text hinzugefügt und dann rekursiv weiter gerechnet. Die Rekursion 
wird abgebrochen, wenn der alte Text leer ist.
*/

%%%% Prädikat
%% del_stop(+Stops,+TextOld,?TextNew)
del_stop(Stops,TextOld,TextNew) :-
    del_stop(Stops,TextOld,[],TextNew). % Acc von [] an

del_stop(_,[],Acc,TextNew) :-
    reverse(Acc,TextNew). % Abbruchbedingung, TextNew == Acc umdrehen

del_stop(Stops,[Word|Words],Acc,TextNew) :-
    not(member(Word,Stops)),                  % Word kein Stoppwort
    not(number(Word)),                        % Word keine Zahl
    del_stop(Stops,Words,[Word|Acc],TextNew). % Word in Acc einfügen

del_stop(Stops,[Word|Words],Acc,TextNew) :-
    member(Word,Stops),                % Word ein Stoppwort
    del_stop(Stops,Words,Acc,TextNew). % Word nicht in Acc einfügen

del_stop(Stops,[Word|Words],Acc,TextNew) :-
    number(Word),                      % Word eine Zahl
    del_stop(Stops,Words,Acc,TextNew). % Word nicht in Acc einfügen

/*
%%%% Testfall
%% del_stop(+Stops,+TextOld,-TextNew)
?- stop(Stops),text(6,TextOld),del_stop(Stops,TextOld,TextNew).

Stops = [der, die, das, den, dem, des, diese, dieser, diesem, deren, 
ein, eine, eines, einer, einen, einem, eines, kein, keine, keinen, 
keinem, keines, keiner, ist, sind, sei, war, waren, haben, habe, hat, 
hatte, hatten, will, wollen, wollte, wollten, werden, wird, wurde, 
wurden, worden, machen, macht, mache, können, könnte, könnten, soll, 
sollen, sollte, müssten, müsste, müsse, und, oder, da, weil, er, sie, 
es, sich, sein, seine, seinen, seinem, seiner, ihr, ihre, ihrer, 
ihren, ihrem, ihres, weiter, weiteren, weitere, weiterer, weiteres, 
einige, einigen, mehreren, mehrere, andere, anderen, ob, dass, obwohl, 
am, an, auf, aus, bei, beim, bis, durch, für, gegen, im, in, ins, mit, 
nahe, nach, seit, trotz, über, ums, unter, vom, von, vor, wegen, zu, 
zum, zur, oft, auch, so, nur, noch, wieder, erst, sehr, dafür, zurück, 
einander, mehr, als, nicht, wie, wann, wo, dann, mal, vorbei, null, 
eins, zwei, drei, vier, fünf, sechs, sieben, acht, neun, zehn, elf, 
zwölf, ('.'), (',')],

TextNew = [terroranschlägen, bagdad, kurz, hintereinander, mindestens, 
menschen, leben, gekommen, iraker, verletzt, selbstmordattentäter, 
riss, rekrutierungsbüro, polizei, west, bagdad, iraker, tod, polizei, 
mitteilte, starben, attacke, polizeipatrouille, stadtzentrum, 
menschen, sprengsatz, detonierte, schnellrestaurant],

TextOld = [bei, drei, terroranschlägen, sind, in, bagdad, kurz, 
hintereinander, mindestens, 33, menschen, ums, leben, gekommen, ('.'), 
mehr, als, 50, iraker, wurden, verletzt, ('.'), ein, 
selbstmordattentäter, riss, vor, einem, rekrutierungsbüro, der, 
polizei, in, west, bagdad, 28, iraker, mit, in, den, tod, ('.'), wie, 
die, polizei, weiter, mitteilte, (','), starben, bei, einer, weiteren, 
attacke, auf, eine, polizeipatrouille, im, stadtzentrum, vier, 
menschen, ('.'), ein, weiterer, sprengsatz, detonierte, in, einem, 
schnellrestaurant, ('.')];
false.
*/

/*====================*/
/*==== Aufgabe 2 =====*/
/*====================*/

%%%% Prädikat
%% occurance(+Text,?FreqList)
occurance(Text,FreqList) :-
    occurance(Text,[],Text,[],FreqList). % SoFar und Acc von [] an

occurance([],_,_,Acc,FreqList) :- 
    reverse(Acc,FreqList). % Abbruchbedingung, Acc umkehren

occurance([Word|Words],SoFar,Text,Acc,FreqList) :-
    member(Word,SoFar),   % Word bereits im Text vorgekommen
    occurance(Words,SoFar,Text,Acc,FreqList). % Word ignorieren

occurance([Word|Words],SoFar,Text,Acc,FreqList) :-
    not(member(Word,SoFar)), % Word noch nicht im Text vorgekommen
    findall(Word,member(Word,Text),WordList),
    length(WordList,N),      % Häufigkeit von Word im Text
    occurance(Words,[Word|SoFar],Text,[[Word,N]|Acc],FreqList).

/*
%%%% Testfall
%% occurance(+Text,-FreqList)
?- text(6,T),occurance(T,F).

F = [[bei, 2], [drei, 1], [terroranschlägen, 1], [sind, 1], [in, 4], 
[bagdad, 2], [kurz, 1], [hintereinander, 1], [mindestens, 1], [33, 1], 
[menschen, 2], [ums, 1], [leben, 1], [gekommen, 1], [('.'), 5], 
[mehr, 1], [als, 1], [50, 1], [iraker, 2], [wurden, 1], [verletzt, 1], 
[ein, 2], [selbstmordattentäter, 1], [riss, 1], [vor, 1], [einem, 2], 
[rekrutierungsbüro, 1], [der, 1], [polizei, 2], [west, 1], [28, 1], 
[mit, 1], [den, 1], [tod, 1], [wie, 1], [die, 1], [weiter, 1], 
[mitteilte, 1], [(','), 1], [starben, 1], [einer, 1], [weiteren, 1], 
[attacke, 1], [auf, 1], [eine, 1], [polizeipatrouille, 1], [im, 1], 
[stadtzentrum, 1], [vier, 1], [weiterer, 1], [sprengsatz, 1], 
[detonierte, 1], [schnellrestaurant, 1]],

T = [bei, drei, terroranschlägen, sind, in, bagdad, kurz, 
hintereinander, mindestens, 33, menschen, ums, leben, gekommen, ('.'), 
mehr, als, 50, iraker, wurden, verletzt, ('.'), ein, 
selbstmordattentäter, riss, vor, einem, rekrutierungsbüro, der, 
polizei, in, west, bagdad, 28, iraker, mit, in, den, tod, ('.'), wie, 
die, polizei, weiter, mitteilte, (','), starben, bei, einer, weiteren, 
attacke, auf, eine, polizeipatrouille, im, stadtzentrum, vier, 
menschen, ('.'), ein, weiterer, sprengsatz, detonierte, in, einem, 
schnellrestaurant, ('.')];
false.
*/
    
/*====================*/
/*==== Aufgabe 3 =====*/
/*====================*/
/*-----Aufgabe 3.1----*/

%%%% Prädikat 
%% wort_index(+Text,?Index)
wort_index([E|R],Index) :-
    create_index(R,[E],0,[[E,0]],I), % Initialisierung mit Akkumulator
    reverse(I,Index).

% create_index(Text,ElemBisher,Schlüssel,Akkumulator,IndexInvers)
create_index([],_,_,Acc,Acc). % Abbruchbedingung: Text leer

create_index([E|R],L,N,Acc,I) :- 
    not(member(E,L)), % Wortform E bisher nicht vorgekommen
    N1 is N + 1,
    create_index(R,[E|L],N1,[[E,N1]|Acc],I).

create_index([E|R],L,N,Acc,I) :-
    member(E,L), % Wortform E bereits vorgekommen
    create_index(R,L,N,Acc,I).

/*
%%%% Testfälle
%% wort_index(+Text,-Index)
?- wort_index([eins,zwei,drei,eins,vier],Index).
Index = [[eins, 0], [zwei, 1], [drei, 2], [vier, 3]];
false.

%% wort_index(+Text,-Index)
?- text(6,Text),wort_index(T,I).

I = [[bei, 0], [drei, 1], [terroranschlägen, 2], [sind, 3], 
[in, 4], [bagdad, 5], [kurz, 6], [hintereinander, 7], [mindestens, 8], 
[33, 9], [menschen, 10], [ums, 11], [leben, 12], [gekommen, 13], 
[('.'), 14], [mehr, 15], [als, 16], [50, 17], [iraker, 18], 
[wurden, 19], [verletzt, 20], [ein, 21], [selbstmordattentäter, 22], 
[riss, 23], [vor, 24], [einem, 25], [rekrutierungsbüro, 26], 
[der, 27], [polizei, 28], [west, 29], [28, 30], [mit, 31], [den, 32], 
[tod, 33], [wie, 34], [die, 35], [weiter, 36], [mitteilte, 37], 
[(','), 38], [starben, 39], [einer, 40], [weiteren, 41], 
[attacke, 42], [auf, 43], [eine, 44], [polizeipatrouille, 45], 
[im, 46], [stadtzentrum, 47], [vier, 48], [weiterer, 49], 
[sprengsatz, 50], [detonierte, 51], [schnellrestaurant, 52]],

T = [bei, drei, terroranschlägen, sind, in, bagdad, kurz, 
hintereinander, mindestens, 33, menschen, ums, leben, gekommen, ('.'), 
mehr, als, 50, iraker, wurden, verletzt, ('.'), ein, 
selbstmordattentäter, riss, vor, einem, rekrutierungsbüro, der, 
polizei, in, west, bagdad, 28, iraker, mit, in, den, tod, ('.'), wie, 
die, polizei, weiter, mitteilte, (','), starben, bei, einer, weiteren, 
attacke, auf, eine, polizeipatrouille, im, stadtzentrum, vier, 
menschen, ('.'), ein, weiterer, sprengsatz, detonierte, in, einem, 
schnellrestaurant, ('.')];
false.
*/

/*-----Aufgabe 3.2----*/

%%%% Prädikat
%% word2key(?Word,?Key,+Index)
word2key(W,K,[[W,K]|_]). % Abbruchbedingung: Wortform gefunden
word2key(W,K,[_|R]) :- word2key(W,K,R). % Wortform nicht gefunden

/*
%%%% Testfälle
%% word2key(+Word,-Key,+Index)
?- text(6,T),wort_index(T,I),word2key(polizeipatrouille,K,I).
K = 45,

I = [[bei, 0], [drei, 1], [terroranschlägen, 2], [sind, 3], 
[in, 4], [bagdad, 5], [kurz, 6], [hintereinander, 7], [mindestens, 8], 
[33, 9], [menschen, 10], [ums, 11], [leben, 12], [gekommen, 13], 
[('.'), 14], [mehr, 15], [als, 16], [50, 17], [iraker, 18], 
[wurden, 19], [verletzt, 20], [ein, 21], [selbstmordattentäter, 22], 
[riss, 23], [vor, 24], [einem, 25], [rekrutierungsbüro, 26], 
[der, 27], [polizei, 28], [west, 29], [28, 30], [mit, 31], [den, 32], 
[tod, 33], [wie, 34], [die, 35], [weiter, 36], [mitteilte, 37], 
[(','), 38], [starben, 39], [einer, 40], [weiteren, 41], 
[attacke, 42], [auf, 43], [eine, 44], [polizeipatrouille, 45], 
[im, 46], [stadtzentrum, 47], [vier, 48], [weiterer, 49], 
[sprengsatz, 50], [detonierte, 51], [schnellrestaurant, 52]],

T = [bei, drei, terroranschlägen, sind, in, bagdad, kurz, 
hintereinander, mindestens, 33, menschen, ums, leben, gekommen, ('.'), 
mehr, als, 50, iraker, wurden, verletzt, ('.'), ein, 
selbstmordattentäter, riss, vor, einem, rekrutierungsbüro, der, 
polizei, in, west, bagdad, 28, iraker, mit, in, den, tod, ('.'), wie, 
die, polizei, weiter, mitteilte, (','), starben, bei, einer, weiteren, 
attacke, auf, eine, polizeipatrouille, im, stadtzentrum, vier, 
menschen, ('.'), ein, weiterer, sprengsatz, detonierte, in, einem, 
schnellrestaurant, ('.')];
false.

%% word2key(+Word,+Key,+Index)
?- text(6,T),wort_index(T,I),word2key(polizeipatrouille,44,I).
false.

%% word2key(+Word,+Key,+Index)
?- text(6,T),wort_index(T,I),word2key(patrouille,45,I).
false.

%% word2key(+Word,-Key,+Index)
?- text(6,T),wort_index(T,I),word2key(patrouille,K,I).
false.

%% word2key(+Word,+Key,+Index)
?- text(6,T),wort_index(T,I),word2key(polizei,45,I).
false.

%% word2key(-Word,+Key,+Index)
?- text(6,T),wort_index(T,I),word2key(W,28,I).
W = polizei,

I = [[bei, 0], [drei, 1], [terroranschlägen, 2], [sind, 3], 
[in, 4], [bagdad, 5], [kurz, 6], [hintereinander, 7], [mindestens, 8], 
[33, 9], [menschen, 10], [ums, 11], [leben, 12], [gekommen, 13], 
[('.'), 14], [mehr, 15], [als, 16], [50, 17], [iraker, 18], 
[wurden, 19], [verletzt, 20], [ein, 21], [selbstmordattentäter, 22], 
[riss, 23], [vor, 24], [einem, 25], [rekrutierungsbüro, 26], 
[der, 27], [polizei, 28], [west, 29], [28, 30], [mit, 31], [den, 32], 
[tod, 33], [wie, 34], [die, 35], [weiter, 36], [mitteilte, 37], 
[(','), 38], [starben, 39], [einer, 40], [weiteren, 41], 
[attacke, 42], [auf, 43], [eine, 44], [polizeipatrouille, 45], 
[im, 46], [stadtzentrum, 47], [vier, 48], [weiterer, 49], 
[sprengsatz, 50], [detonierte, 51], [schnellrestaurant, 52]],

T = [bei, drei, terroranschlägen, sind, in, bagdad, kurz, 
hintereinander, mindestens, 33, menschen, ums, leben, gekommen, ('.'), 
mehr, als, 50, iraker, wurden, verletzt, ('.'), ein, 
selbstmordattentäter, riss, vor, einem, rekrutierungsbüro, der, 
polizei, in, west, bagdad, 28, iraker, mit, in, den, tod, ('.'), wie, 
die, polizei, weiter, mitteilte, (','), starben, bei, einer, weiteren, 
attacke, auf, eine, polizeipatrouille, im, stadtzentrum, vier, 
menschen, ('.'), ein, weiterer, sprengsatz, detonierte, in, einem, 
schnellrestaurant, ('.')];
false.
*/

/*-----Aufgabe 3.3----*/

/*
Die folgende endrekursive Implementierung erfordert eine volle 
Instanziierung des ersten Arguments, was der Aufgabenstellung nicht
entspricht:

%%%% Prädikat (endrekursiv)
%% words2keys(+Text,?ListOfKeys,+Index)
words2keys(T,L,I) :- words2keys(T,[],L,I).

words2keys([],Acc,L,_) :- reverse(Acc,L).

words2keys([E|R],Acc,L,I) :-
    word2key(E,K,I),
    words2keys(R,[K|Acc],L,I).

words2keys([E|R],Acc,L,I) :-
    not(word2key(E,_,I)),
    words2keys(R,Acc,L,I).
*/

%%%% Prädikat (nicht endrekursiv)
%% words2keys(?Text,?ListOfKeys,+Index)
words2keys([],[],_).    % Abbruchbedingung, Text leer

words2keys([E|R],[K|L],I) :-
    word2key(E,K,I),    % Wortform im Index gefunden
    words2keys(R,L,I).  % Ersetzen mit dem Rest des Texts

words2keys([E|R],L,I) :-
    not(word2key(E,_,I)),   % Wortform im Index nicht gefunden
    words2keys(R,L,I).      % Ersetzen mit dem Rest des Texts
    
/*
%%%% Testfälle
%% words2keys(+Text,-ListOfKeys,+Index)
?- wort_index([null, eins, zwei, drei, eins],I),
   words2keys([zwei, eins, drei],L,I).
I = [[null, 0], [eins, 1], [zwei, 2], [drei, 3]],
L = [2, 1, 3];
false.

%% words2keys(+Text,+ListOfKeys,+Index)
?- wort_index([null, eins, zwei, drei, eins],I),
   words2keys([zwei, eins, drei],[2, 0, 3],I).
false.

%% words2keys(+Text,+ListOfKeys,+Index)
?- wort_index([null, eins, zwei, drei, eins],I),
   words2keys([zwei, null, drei],[2, 1, 3],I).
false.

%% words2keys(-Text,+ListOfKeys,+Index)
?- wort_index([null, eins, zwei, drei, eins],I),
   words2keys(T,[2, 1, 3],I).
I = [[null, 0], [eins, 1], [zwei, 2], [drei, 3]],
T = [zwei, eins, drei];
false.

%% words2keys(-Text,-ListOfKeys,+Index)
?-wort_index([null, eins, zwei, drei, eins],I),words2keys(T,L,I).
I = [[null, 0], [eins, 1], [zwei, 2], [drei, 3]],
L = T, T = [];
I = [[null, 0], [eins, 1], [zwei, 2], [drei, 3]],
L = [0],
T = [null];
I = [[null, 0], [eins, 1], [zwei, 2], [drei, 3]],
L = [0, 0],
T = [null, null];
I = [[null, 0], [eins, 1], [zwei, 2], [drei, 3]],
L = [0, 0, 0],
T = [null, null, null];
I = [[null, 0], [eins, 1], [zwei, 2], [drei, 3]],
L = [0, 0, 0, 0],
T = [null, null, null, null].

%% words2keys(+Text,-ListOfKeys,+Index)
?- text(6,T),wort_index(T,I),words2keys(T,L,I).

L = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 
19, 20, 14, 21, 22, 23, 24, 25, 26, 27, 28, 4, 29, 5, 30, 18, 31, 4, 
32, 33, 14, 34, 35, 28, 36, 37, 38, 39, 0, 40, 41, 42, 43, 44, 45, 46, 
47, 48, 10, 14, 21, 49, 50, 51, 4, 25, 52, 14],

I = [[bei, 0], [drei, 1], [terroranschlägen, 2], [sind, 3], 
[in, 4], [bagdad, 5], [kurz, 6], [hintereinander, 7], [mindestens, 8], 
[33, 9], [menschen, 10], [ums, 11], [leben, 12], [gekommen, 13], 
[('.'), 14], [mehr, 15], [als, 16], [50, 17], [iraker, 18], 
[wurden, 19], [verletzt, 20], [ein, 21], [selbstmordattentäter, 22], 
[riss, 23], [vor, 24], [einem, 25], [rekrutierungsbüro, 26], 
[der, 27], [polizei, 28], [west, 29], [28, 30], [mit, 31], [den, 32], 
[tod, 33], [wie, 34], [die, 35], [weiter, 36], [mitteilte, 37], 
[(','), 38], [starben, 39], [einer, 40], [weiteren, 41], 
[attacke, 42], [auf, 43], [eine, 44], [polizeipatrouille, 45], 
[im, 46], [stadtzentrum, 47], [vier, 48], [weiterer, 49], 
[sprengsatz, 50], [detonierte, 51], [schnellrestaurant, 52]],

T = [bei, drei, terroranschlägen, sind, in, bagdad, kurz, 
hintereinander, mindestens, 33, menschen, ums, leben, gekommen, ('.'), 
mehr, als, 50, iraker, wurden, verletzt, ('.'), ein, 
selbstmordattentäter, riss, vor, einem, rekrutierungsbüro, der, 
polizei, in, west, bagdad, 28, iraker, mit, in, den, tod, ('.'), wie, 
die, polizei, weiter, mitteilte, (','), starben, bei, einer, weiteren, 
attacke, auf, eine, polizeipatrouille, im, stadtzentrum, vier, 
menschen, ('.'), ein, weiterer, sprengsatz, detonierte, in, einem, 
schnellrestaurant, ('.')];
false.
*/

/*====================*/
/*==== Aufgabe 4 =====*/
/*====================*/
/*-----Aufgabe 4.1----*/

% [Vater, Sohn1, Sohn2]
%   Eine Liste mit drei Elementen stellt einen (Teil)Baum dar.

%   Vater repräsentiert die Wurzel des (Teil)Baums.
%   Sohn1 und Sohn2 sind jeweils ein Teilbaum oder ein Blatt.

%   Ein Teilbaum ist wiederum eine Liste der gleichen Struktur.
%   Ein Blatt ist eine leere Liste [].

%   Sohn1.Schlüssel < Vater.Schlüssel < Sohn2.Schlüssel
%   Alle Schlüssel im Teilbaum Sohn1 sind kleiner als Vater.Schlüssel.
%   Alle Schlüssel im Teilbaum Sohn2 sind größer  als Vater.Schlüssel.

/*-----Aufgabe 4.2----*/

%%%% Prädikat
%% intree(+Element,+BaumAlt,?BaumNeu)
intree([E,N],[],[[E,N],[],[]]). % Abbruchbedingung, BaumAlt leer
                                % Rückgabe: E mit zwei Blättern

intree([E,N],[[W,K],VB,HB],[[W,K],VBN,HB]) :-
	N=<K, intree([E,N],VB,VBN). % E.Schlüssel <= Wurzel.Schlüssel
	                            % Einfügen von E in VB (vorderen Baum)

intree([E,N],[[W,K],VB,HB],[[W,K],VB,HBN]) :-
	N>K, intree([E,N],HB,HBN).  % E.Schlüssel > Wurzel.Schlüssel
	                            % Einfügen von E in HB (hinteren Baum)

/*
%%%% Testfälle
%% intree(+Element,+BaumAlt,-BaumNeu)
?- index2tree([[z,0],[a,1],[b,2],[d,4]],B),intree([c,3],B,T).
B = [[b, 2], [[a, 1], [[z, 0], [], []], []], [[d, 4], [], []]],
T = [[b, 2], [[a, 1], [[z, 0], [], []], []], [[d, 4], [[c, 3], [], []], []]];
false.

%% intree(+Element,+BaumAlt,-BaumNeu)
?- index2tree([[z,0],[a,1],[b,2],[d,4]],B),intree([f,6],B,T).
B = [[b, 2], [[a, 1], [[z, 0], [], []], []], [[d, 4], [], []]],
T = [[b, 2], [[a, 1], [[z, 0], [], []], []], [[d, 4], [], [[f, 6], [], []]]]
false.

%% intree(+Element,+BaumAlt,-BaumNeu)
?- index2tree([[z,0],[a,1],[b,2],[d,4]],B),intree([f,6],B,T1),
                                           intree([c,3],T1,T2).
B = [[b, 2], [[a, 1], [[z, 0], [], []], []], [[d, 4], [], []]],
T1 = [[b, 2], [[a, 1], [[z, 0], [], []], []], 
              [[d, 4], [], [[f, 6], [], []]]],
T1 = [[b, 2], [[a, 1], [[z, 0], [], []], []], 
              [[d, 4], [[c, 3], [], []], [[f, 6], [], []]]];
false.

%% intree(+Element,+BaumAlt,+BaumNeu)
?- index2tree([[z,0],[a,1],[b,2],[d,4]],B),intree([c,3],B,[[b, 2], 
[[a, 1], [[z, 0], [], []], []], [[d, 4], [[c, 3], [], []], []]]).
B = [[b, 2], [[a, 1], [[z, 0], [], []], []], [[d, 4], [], []]];
false.

%% intree(+Element,+BaumAlt,+BaumNeu)
?- index2tree([[z,0],[a,1],[b,2],[d,4]],B),intree([c,3],B, 
[[b, 2], [[a, 1], [[z, 0], [], []], []], [[d, 4], [], [[c, 3], [], []]]]).
false.
*/

/*-----Aufgabe 4.3----*/

%%%% Prädikat
%% word2keyT(?Word,?Key,+Tree)
word2keyT(W,K,[[W,K],_,_]). % Abbruchbedingung, Wortform gefunden
word2keyT(W,K,[_,B,_]) :- word2keyT(W,K,B). % Suche im Teilbaum links
word2keyT(W,K,[_,_,B]) :- word2keyT(W,K,B). % Suche im Teilbaum rechts

/*
%%%% Testfälle
%% word2keyT(+Word,-Key,+Tree)
?- index2tree([[z,0],[a,1],[b,2],[c,3],[d,4]],B),word2keyT(z,K,B).
B = [[b, 2], [[a, 1], [[z, 0], [], []], []], [[d, 4], [[c, 3], [], []], []]],
K = 0;
false.

%% word2keyT(+Word,+Key,+Tree)
?- index2tree([[z,0],[a,1],[b,2],[c,3],[d,4]],B),word2keyT(d,4,B).
B = [[b, 2], [[a, 1], [[z, 0], [], []], []], [[d, 4], [[c, 3], [], []], []]];
false.

%% word2keyT(+Word,+Key,+Tree)
?- index2tree([[z,0],[a,1],[b,2],[c,3],[d,4]],B),word2keyT(d,3,B).
false.

%% word2keyT(-Word,+Key,+Tree)
?- index2tree([[z,0],[a,1],[b,2],[c,3],[d,4]],B),word2keyT(W,1,B).
B = [[b, 2], [[a, 1], [[z, 0], [], []], []], [[d, 4], [[c, 3], [], []], []]],
W = a;
false.

%% word2keyT(-Word,-Key,+Tree)
?- index2tree([[z,0],[a,1],[b,2],[c,3],[d,4]],B),word2keyT(W,K,B).
B = [[b, 2], [[a, 1], [[z, 0], [], []], []], [[d, 4], [[c, 3], [], []], []]],
K = 2,
W = b;
B = [[b, 2], [[a, 1], [[z, 0], [], []], []], [[d, 4], [[c, 3], [], []], []]],
K = 1,
W = a;
B = [[b, 2], [[a, 1], [[z, 0], [], []], []], [[d, 4], [[c, 3], [], []], []]],
K = 0,
W = z;
B = [[b, 2], [[a, 1], [[z, 0], [], []], []], [[d, 4], [[c, 3], [], []], []]],
K = 4,
W = d;
B = [[b, 2], [[a, 1], [[z, 0], [], []], []], [[d, 4], [[c, 3], [], []], []]],
K = 3,
W = c.
*/

/*-----Aufgabe 4.4----*/

%%%% Prädikat
%% words2keysT(?Text,?ListOfKeys,+Binärbaum)
words2keysT([],[],_).       % Abbruchbedingung, Text leer

words2keysT([W|R],[K|L],I) :-
    word2keyT(W,K,I),       % Wortform im Indexbaum gefunden
    words2keysT(R,L,I).     % Rekursion mit dem Rest des Texts

words2keysT([W|R],L,I) :-
    not(word2keyT(W,_,I)),  % Wortform im Indexbaum nicht gefunden
    words2keysT(R,L,I).     % Rekursion mit dem Rest des Texts

/*
%%%% Testfälle
%% words2keysT(+Text,-ListOfKeys,+Index)
?- wort_index([null, eins, zwei, drei, eins],I),
   index2tree(I,B),words2keysT([zwei, eins, drei],L,B).
B = [[zwei, 2], [[eins, 1], [[null, 0], [], []], []], [[drei, 3], [], []]],
I = [[null, 0], [eins, 1], [zwei, 2], [drei, 3]],
L = [2, 1, 3];
false.

%% words2keys(+Text,+ListOfKeys,+Index),
   index2tree(I,B),words2keysT([zwei, eins, drei],[2, 0, 3],B).
false.

%% words2keys(+Text,+ListOfKeys,+Index)
?- wort_index([null, eins, zwei, drei, eins],I),
   index2tree(I,B),words2keysT([zwei, null, drei],[2, 1, 3],B).
false.

%% words2keys(-Text,+ListOfKeys,+Index)
?- wort_index([null, eins, zwei, drei, eins],I),
   index2tree(I,B),words2keysT(T,[2, 1, 3],B).
B = [[zwei, 2], [[eins, 1], [[null, 0], [], []], []], [[drei, 3], [], []]],
I = [[null, 0], [eins, 1], [zwei, 2], [drei, 3]],
T = [zwei, eins, drei];
falsefalse.

%% words2keys(-Text,-ListOfKeys,+Index)
?-wort_index([null, eins, zwei, drei, eins],I),words2keys(T,L,I).
I = [[null, 0], [eins, 1], [zwei, 2], [drei, 3]],
L = T, T = [];
I = [[null, 0], [eins, 1], [zwei, 2], [drei, 3]],
L = [0],
T = [null];
I = [[null, 0], [eins, 1], [zwei, 2], [drei, 3]],
L = [0, 0],
T = [null, null];
I = [[null, 0], [eins, 1], [zwei, 2], [drei, 3]],
L = [0, 0, 0],
T = [null, null, null];
I = [[null, 0], [eins, 1], [zwei, 2], [drei, 3]],
L = [0, 0, 0, 0],
T = [null, null, null, null].

%% words2keys(+Text,-ListOfKeys,+Index)
?- text(6,T),wort_index(T,I),index2tree(I,B),words2keysT(T,L,B).

B = [[rekrutierungsbüro, 26], [[gekommen, 13], [[kurz, 6], [[sind, 3], 
[[drei, 1], [[bei, 0], [], []], [[terroranschlägen, 2], [], []]], 
[[bagdad, 5], [[in, 4], [], []], []]], [[menschen, 10], 
[[mindestens, 8], [[hintereinander, 7], [], []], [[33, 9], [], []]], 
[[leben, 12], [[ums, 11], [], []], []]]], [[verletzt, 20], [[50, 17], 
[[mehr, 15], [[('.'), 14], [], []], [[als, 16], [], []]], 
[[wurden, 19], [[iraker, 18], [], []], []]], [[riss, 23], 
[[selbstmordattentäter, 22], [[ein, 21], [], []], []], [[einem, 25], 
[[vor, 24], [], []], []]]]], [[einer, 40], [[tod, 33], [[28, 30], 
[[polizei, 28], [[der, 27], [], []], [[west, 29], [], []]], 
[[den, 32], [[mit, 31], [], []], []]], [[mitteilte, 37], [[die, 35], 
[[wie, 34], [], []], [[weiter, 36], [], []]], [[starben, 39], 
[[(','), 38], [], []], []]]], [[stadtzentrum, 47], [[eine, 44], 
[[attacke, 42], [[weiteren, 41], [], []], [[auf, 43], [], []]], 
[[im, 46], [[polizeipatrouille, 45], [], []], []]], [[sprengsatz, 50], 
[[weiterer, 49], [[vier, 48], [], []], []], [[schnellrestaurant, 52], 
[[detonierte, 51], [], []], []]]]]],

I = [[bei, 0], [drei, 1], [terroranschlägen, 2], [sind, 3], [in, 4], 
[bagdad, 5], [kurz, 6], [hintereinander, 7], [mindestens, 8], [33, 9], 
[menschen, 10], [ums, 11], [leben, 12], [gekommen, 13], [('.'), 14], 
[mehr, 15], [als, 16], [50, 17], [iraker, 18], [wurden, 19], 
[verletzt, 20], [ein, 21], [selbstmordattentäter, 22], [riss, 23], 
[vor, 24], [einem, 25], [rekrutierungsbüro, 26], [der, 27], 
[polizei, 28], [west, 29], [28, 30], [mit, 31], [den, 32], [tod, 33], 
[wie, 34], [die, 35], [weiter, 36], [mitteilte, 37], [(','), 38], 
[starben, 39], [einer, 40], [weiteren, 41], [attacke, 42], [auf, 43], 
[eine, 44], [polizeipatrouille, 45], [im, 46], [stadtzentrum, 47], 
[vier, 48], [weiterer, 49], [sprengsatz, 50], [detonierte, 51], 
[schnellrestaurant, 52]],

L = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 
19, 20, 14, 21, 22, 23, 24, 25, 26, 27, 28, 4, 29, 5, 30, 18, 31, 4, 
32, 33, 14, 34, 35, 28, 36, 37, 38, 39, 0, 40, 41, 42, 43, 44, 45, 46, 
47, 48, 10, 14, 21, 49, 50, 51, 4, 25, 52, 14],

T = [bei, drei, terroranschlägen, sind, in, bagdad, kurz, 
hintereinander, mindestens, 33, menschen, ums, leben, gekommen, ('.'), 
mehr, als, 50, iraker, wurden, verletzt, ('.'), ein, 
selbstmordattentäter, riss, vor, einem, rekrutierungsbüro, der, 
polizei, in, west, bagdad, 28, iraker, mit, in, den, tod, ('.'), wie, 
die, polizei, weiter, mitteilte, (','), starben, bei, einer, weiteren, 
attacke, auf, eine, polizeipatrouille, im, stadtzentrum, vier, 
menschen, ('.'), ein, weiterer, sprengsatz, detonierte, in, einem, 
schnellrestaurant, ('.')];
false.
*/

/*--------Bonus-------*/

%%%% Prädikat
%% index2tree(+Index,?Baum)
index2tree([],[]).  % Abbruchbedingung, Index leer

index2tree(I,[E,VT,HT]) :-
    length(I,N),        % N für Länge des Index
    K is floor(N/2),    % K für die mittlere Position im Index
    nth0(K,I,E),        % E für das mittlere Element im Index
    split_index(I,0,K,N,VI,HI), % Initialisierung mit Index-Position 0
    index2tree(VI,VT),  % die 1. Hälfte des Index vor E
    index2tree(HI,HT).  % die 2. Hälfte des Index nach E

% split_index(Index,IndexPosition,TrennPosition,IndexPosMax,
%             IndexVorTrennPosition,IndexNachTrennPosition)
split_index(_,N,_,N,[],[]). % Abbruchbedingung, IndexPosMax erreicht

split_index(I,C,K,N,[E|VI],HI) :-
    C<K,            % IndexPosition C < TrennPosition K
    nth0(C,I,E),    % E fürs Element an der IndexPosition C
    C1 is C+1,      % C1 für die neue IndexPosition (um 1 erhöht)
    split_index(I,C1,K,N,VI,HI). % Weitere Zuteilung mit Element an C1 

split_index(I,C,K,N,VI,HI) :-
    C=K,            % IndexPosition C == TrennPosition K
    C1 is C+1,      % C1 für die neue IndexPosition (um 1 erhöht)
    split_index(I,C1,K,N,VI,HI). % Weitere Zuteilung mit Element an C1

split_index(I,C,K,N,VI,[E|HI]) :-
    C>K,            % IndexPosition C > TrennPosition K
    nth0(C,I,E),    % E für Index-Element an der IndexPosition
    C1 is C+1,      % C1 für die neue IndexPosition (um 1 erhöht)
    split_index(I,C1,K,N,VI,HI). % Weitere Zuteilung mit Element an C1

/*
%%%% Testfälle
%% index2tree(+Index,-Baum)
?- index2tree([[z,0],[a,1],[b,2],[c,3],[d,4]],B).
B = [[b, 2], [[a, 1], [[z, 0], [], []], []], 
             [[d, 4], [[c, 3], [], []], []]];
false.

%% index2tree(+Index,-Baum)
?- index2tree([[z,0],[a,1],[b,2],[c,3],[d,4],[e,5]],B).
B = [[c, 3], [[a, 1], [[z, 0], [], []], [[b, 2], [], []]], 
             [[e, 5], [[d, 4], [], []], []]];
false.

%% index2tree(+Index,-Baum)
?- index2tree([[z,0],[a,1],[b,2],[c,3],[d,4],[e,5],[f,6]],B).
B = [[c, 3], [[a, 1], [[z, 0], [], []], [[b, 2], [], []]], 
             [[e, 5], [[d, 4], [], []], [[f, 6], [], []]]];
false.

%% index2tree(+Index,-Baum)
?- index2tree([[z,0],[a,1],[b,2],[c,3],[d,4],[e,5],[f,6],[g,7]],B).
B = [[d, 4], [[b, 2], [[a, 1], [[z, 0], [], []], []], [[c, 3], [], []]], 
             [[f, 6], [[e, 5], [], []], [[g, 7], [], []]]];
false.

%% index2tree(+Index,+Baum)
?- index2tree([[z,0],[a,1],[b,2],[c,3],[d,4]], 
[[b, 2], [[a, 1], [[z, 0], [], []], []], [[d, 4], [[c, 3], [], []], []]]).
true;
false.

%% index2tree(+Index,+Baum)
?- index2tree([[z,0],[a,1],[b,2],[c,3],[d,4]], 
[[b, 2], [[a, 1], [[z, 0], [], []], []], [[d, 4], [], [[c, 3], [], []]]]).
false.

%% index2tree(+Index,-Baum)
?- text(6,T),wort_index(T,I),index2tree(I,B).

B = [[rekrutierungsbüro, 26], 
     [[gekommen, 13], 
      [[kurz, 6], 
       [[sind, 3], 
        [[drei, 1], [[bei, 0], [], []], [[terroranschlägen, 2], [], []]], 
        [[bagdad, 5], [[in, 4], [], []], []]], 
       [[menschen, 10], 
        [[mindestens, 8], [[hintereinander, 7], [], []], [[33, 9], [], []]], 
        [[leben, 12], [[ums, 11], [], []], []]]], 
      [[verletzt, 20], 
       [[50, 17], 
        [[mehr, 15], [[('.'), 14], [], []], [[als, 16], [], []]], 
        [[wurden, 19], [[iraker, 18], [], []], []]], 
       [[riss, 23], 
        [[selbstmordattentäter, 22], [[ein, 21], [], []], []], 
        [[einem, 25], [[vor, 24], [], []], []]]]], 
     [[einer, 40], 
      [[tod, 33], 
       [[28, 30], 
        [[polizei, 28], [[der, 27], [], []], [[west, 29], [], []]], 
        [[den, 32], [[mit, 31], [], []], []]], 
       [[mitteilte, 37], 
        [[die, 35], [[wie, 34], [], []], [[weiter, 36], [], []]], 
        [[starben, 39], [[(','), 38], [], []], []]]], 
      [[stadtzentrum, 47], 
       [[eine, 44], 
        [[attacke, 42], [[weiteren, 41], [], []], [[auf, 43], [], []]], 
        [[im, 46], [[polizeipatrouille, 45], [], []], []]], 
       [[sprengsatz, 50], 
        [[weiterer, 49], [[vier, 48], [], []], []], 
        [[schnellrestaurant, 52], [[detonierte, 51], [], []], []]]]]],

I = [[bei, 0], [drei, 1], [terroranschlägen, 2], [sind, 3], 
[in, 4], [bagdad, 5], [kurz, 6], [hintereinander, 7], [mindestens, 8], 
[33, 9], [menschen, 10], [ums, 11], [leben, 12], [gekommen, 13], 
[('.'), 14], [mehr, 15], [als, 16], [50, 17], [iraker, 18], 
[wurden, 19], [verletzt, 20], [ein, 21], [selbstmordattentäter, 22], 
[riss, 23], [vor, 24], [einem, 25], [rekrutierungsbüro, 26], 
[der, 27], [polizei, 28], [west, 29], [28, 30], [mit, 31], [den, 32], 
[tod, 33], [wie, 34], [die, 35], [weiter, 36], [mitteilte, 37], 
[(','), 38], [starben, 39], [einer, 40], [weiteren, 41], 
[attacke, 42], [auf, 43], [eine, 44], [polizeipatrouille, 45], 
[im, 46], [stadtzentrum, 47], [vier, 48], [weiterer, 49], 
[sprengsatz, 50], [detonierte, 51], [schnellrestaurant, 52]],

T = [bei, drei, terroranschlägen, sind, in, bagdad, kurz, 
hintereinander, mindestens, 33, menschen, ums, leben, gekommen, ('.'), 
mehr, als, 50, iraker, wurden, verletzt, ('.'), ein, 
selbstmordattentäter, riss, vor, einem, rekrutierungsbüro, der, 
polizei, in, west, bagdad, 28, iraker, mit, in, den, tod, ('.'), wie, 
die, polizei, weiter, mitteilte, (','), starben, bei, einer, weiteren, 
attacke, auf, eine, polizeipatrouille, im, stadtzentrum, vier, 
menschen, ('.'), ein, weiterer, sprengsatz, detonierte, in, einem, 
schnellrestaurant, ('.')];
false.
*/

