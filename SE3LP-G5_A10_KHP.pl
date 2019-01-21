/*
SE3LP-18W-A09
Namen: Chung-Shan Kao, Harm Matthias Harms, Henrik Peters
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                              %%%%
%%%% Aufgabe 1: Defaults (1)                                      %%%%
%%%%                                                              %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Aufgabe 1.1: Kategorisieren mittels Merkmalsvergleich        %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Prädikat
%% merkmalsvergleich(+Objekt,+Forderung)
% Die Liste der Objektmerkmale soll gleich lang bzw. länger sein als
% die Liste der geforderten Merkmale.
merkmalsvergleich(Objekt,Forderung) :-
    length(Objekt,NO), length(Forderung,NF), NO >= NF,
    mv(Objekt,Forderung), !.

%%%% Hilfspräikat
%% mv(Objektmerkmalsliste,ListeGeforderterMerkmale)
% Es wird rekursiv kontrolliert, ob jedes geforderte Merkmal in der
% Objektmerkmalsliste vorkommt.
mv(_,[]). % Abbruch, alle geforderten Merkmale kontrolliert
mv(Objekt,[Merkmal|Rest]) :- member(Merkmal,Objekt), mv(Objekt,Rest).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Aufgabe 1.2: Regelsystem zur Kategorisierung von Pilzen      %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Fakten von Pilzen
%% pilz(Merkmale,Kategorie,Pilzname)
pilz([röhren,lamellen],'keine Kategorie','nicht existent').
pilz([röhren,roter_stiel],giftig,hexenröhrling).
pilz([röhren,roter_saft,am_baum],geniessbar,leberpilz).
pilz([röhren,am_baum],ungeniessbar,baumpilz).
pilz([röhren],essbar,[steinpilz,marone,butterpilz]).
pilz([braune_lamellen,gelbe_flecken],giftig,giftchampignon).
pilz([stinkend,braune_lamellen],ungeniessbar,karbolchampignon).
pilz([braune_lamellen],geniessbar,champignon).
pilz([lamellen,braune_kappe,abwischbare_punkte],geniessbar,perlpilz).
pilz([lamellen,punkte],giftig,[fliegenpilz,pantherpilz]).
pilz([lamellen],giftig,[knollenblätterpilz,fliegenpilz]).

%%%% Prädikat
%% pilz_kat(?Pilzmerkmale,?Kategorie,?Name)
pilz_kat(Pilzmerkmale,Kategorie,Pilzname) :-
    pilz(Merkmalsliste,Kat,Pilzname),                 % Fakten checken
    merkmalsvergleich(Pilzmerkmale,Merkmalsliste), !, % Vergleich
    (not(member(Kat,[giftig,ungeniessbar])) -> Kategorie = essbar;
    Kategorie = Kat). % Kat weder giftig noch ungeniessbar -> essbar

/*
%%%% Testfälle
%% pilz_kat(+Pilzmerkmale,-Kategorie,-Name)
?- pilz_kat([am_baum,röhren],Kategorie,Pilzname).
Kategorie = ungeniessbar,
Pilzname = baumpilz.

%% pilz_kat(+Pilzmerkmale,-Kategorie,-Name)
?- pilz_kat([röhren],Kategorie,Pilzname).
Kategorie = essbar,
Pilzname = [steinpilz, marone, butterpilz].
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                              %%%%
%%%% Aufgabe 2: Defaults (2)                                      %%%%
%%%%                                                              %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Aufgabe 2.1: Bildung der Flexionsformen für deutsche Verben  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
Die Implementierung beschränkt sich auf Tabelle 1 im Aufgabenblatt 10.
Die Bildung der Flexionsformen wird in vier Fällen unterschieden:
    % stark flektierende Verben
    % Präsens
    % Präteritum
    % Perfektpartizip
Für die letzten drei gibt es jeweils Prädikate, die unabhängig
voneinander gebraucht werden können.
*/

%%%% stark flektierende Verben (als Fakten festlegen)
stark(schreiben,schrieben,geschrieben).
stark(heben,hoben,gehoben).
stark(schlafen,schliefen,geschlafen).
stark(waschen,wuschen,gewaschen).
stark(treten,traten,getreten).
stark(trinken,tranken,getrunken).
stark(singen,sangen,gesungen).
stark(hängen,hingen,gehangen).
stark(haben,hatten,gehabt).
stark(sein,waren,gewesen).

%%%% Präsens
% In Tabelle 1 ist Präsens gleich Infinitiv, bis auf eine Ausnahme.
präsens(sein,sind) :- !. % Ausnahme
präsens(Inf,Inf).

%%%% Präteritum
präteritum(Inf,Prät) :- stark(Inf,Prät,_), !. % stark flektierend
% Die Konjugation beschränkt sich auf die Wortendung.
präteritum(Inf,Prät) :-
    atom_concat(Stamm,eln,Inf), atom_concat(Stamm,elten,Prät), !.
präteritum(Inf,Prät) :-
    atom_concat(Stamm,ern,Inf), atom_concat(Stamm,erten,Prät), !.
präteritum(Inf,Prät) :-
    atom_concat(Stamm,ten,Inf), atom_concat(Stamm,teten,Prät), !.
präteritum(Inf,Prät) :-
    atom_concat(Stamm,den,Inf), atom_concat(Stamm,deten,Prät), !.
präteritum(Inf,Prät) :-
    atom_concat(Stamm,en,Inf), atom_concat(Stamm,ten,Prät).

%%%% Partizip
% Unterscheidung zwischen drei Fällen:
partizip(Inf,Part) :- stark(Inf,_,Part), !. % stark flektierend
partizip(Inf,Part) :- % reguläre Verben mit unabtrennbaren Präfixen
    atom_concat(Präfix,Stamm,Inf),
    untrennbar(Präfixliste), member(Präfix,Präfixliste),
    partizip_endung(Stamm,X), atom_concat(Präfix,X,Part), !.
partizip(Inf,Part) :- % reguläre Verben ohne Präfix
    partizip_endung(Inf,X), atom_concat(ge,X,Part).

%%%% Liste der untrennbaren Präfixen (erweiterbar)
untrennbar([be,emp,ent,er,ge,hinter,miss,ver,zer]).

%% reguläre Verben ohne Präfix: Wortendungen festlegen
partizip_endung(Inf,X) :-
    atom_concat(Stamm,eln,Inf), atom_concat(Stamm,elt,X), !.
partizip_endung(Inf,X) :-
    atom_concat(Stamm,ern,Inf), atom_concat(Stamm,ert,X), !.
partizip_endung(Inf,X) :-
    atom_concat(Stamm,ten,Inf), atom_concat(Stamm,tet,X), !.
partizip_endung(Inf,X) :-
    atom_concat(Stamm,den,Inf), atom_concat(Stamm,det,X), !.
partizip_endung(Inf,X) :-
    atom_concat(Stamm,en,Inf), atom_concat(Stamm,t,X).

%%%% Prädikat
%% flexion(+Infinitiv,?Präsens,?Präteritum,?Partizip)
%% flexion(?Infinitiv,+Präsens,?Präteritum,?Partizip)
flexion(Inf,Präs,Prät,Part) :-
    präsens(Inf,Präs), präteritum(Inf,Prät), partizip(Inf,Part).
% Da präsens/2 zuerst behandelt wird, muss bei flexion/4 Infinitiv
% und/oder Präsens bereits instanziiert sein.

/*
%%%% Testfälle
%% flexion(+Infinitiv,-Präsens,-Präteritum,-Partizip)
?- flexion(sein,Präsens,Präteritum,Partizip).
Präsens = sind,
Präteritum = waren,
Partizip = gewesen.

%% flexion(+Infinitiv,-Präsens,-Präteritum,-Partizip)
?- flexion(haben,Präsens,Präteritum,Partizip).
Präsens = haben,
Präteritum = hatten,
Partizip = gehabt.

%% flexion(+Infinitiv,-Präsens,-Präteritum,-Partizip)
?- flexion(hängen,Präsens,Präteritum,Partizip).
Präsens = hängen,
Präteritum = hingen,
Partizip = gehangen.

%% flexion(+Infinitiv,-Präsens,-Präteritum,-Partizip)
?- flexion(bewundern,Präsens,Präteritum,Partizip).
Präsens = bewundern,
Präteritum = bewunderten,
Partizip = bewundert.

%% flexion(+Infinitiv,-Präsens,-Präteritum,-Partizip)
?- flexion(verschütten,Präsens,Präteritum,Partizip).
Präsens = verschütten,
Präteritum = verschütteten,
Partizip = verschüttet.

%% flexion(+Infinitiv,-Präsens,-Präteritum,-Partizip)
?- flexion(hobeln,Präsens,Präteritum,Partizip).
Präsens = hobeln,
Präteritum = hobelten,
Partizip = gehobelt.

%% flexion(+Infinitiv,-Präsens,-Präteritum,-Partizip)
?- flexion(wundern,Präsens,Präteritum,Partizip).
Präsens = wundern,
Präteritum = wunderten,
Partizip = gewundert.

%% flexion(+Infinitiv,-Präsens,-Präteritum,-Partizip)
?- flexion(flüchten,Präsens,Präteritum,Partizip).
Präsens = flüchten,
Präteritum = flüchteten,
Partizip = geflüchtet.

%% flexion(+Infinitiv,-Präsens,-Präteritum,-Partizip)
?- flexion(wenden,Präsens,Präteritum,Partizip).
Präsens = wenden,
Präteritum = wendeten,
Partizip = gewendet.

%% flexion(+Infinitiv,-Präsens,-Präteritum,-Partizip)
?- flexion(hören,Präsens,Präteritum,Partizip).
Präsens = hören,
Präteritum = hörten,
Partizip = gehört.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Aufgabe 2.2: Konjugation bzgl. Neubildungen und Abweichungen %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
%%%% Neubildungen
Bei neu gebildeten Verben wird die typische deutsche Laut-Buchstaben-
Zuordnung öfters nicht eingehalten. Dennoch stimmt anscheinend die
Verbbeugung solcher Neubildungen, sofern sie phonomorphologisch
"eingedeutscht" sind, wie die folgenden Testfälle zeigen:

%% flexion(+Infinitiv,-Präsens,-Präteritum,-Partizip)
?- flexion(googeln,Präsens,Präteritum,Partizip).
Präsens = googeln,
Präteritum = googelten,
Partizip = gegoogelt.

%% flexion(+Infinitiv,-Präsens,-Präteritum,-Partizip)
?- flexion(dödeln,Präsens,Präteritum,Partizip).
Präsens = dödeln,
Präteritum = dödelten,
Partizip = gedödelt.

%% flexion(+Infinitiv,-Präsens,-Präteritum,-Partizip)
?- flexion(recyceln,Präsens,Präteritum,Partizip).
Präsens = recyceln,
Präteritum = recycelten,
Partizip = gerecycelt.

%% flexion(+Infinitiv,-Präsens,-Präteritum,-Partizip)
?- flexion(grepen,Präsens,Präteritum,Partizip).
Präsens = grepen,
Präteritum = grepten,
Partizip = gegrept.

%% flexion(+Infinitiv,-Präsens,-Präteritum,-Partizip)
?- flexion(smsen,Präsens,Präteritum,Partizip).
Präsens = smsen,
Präteritum = smsten,
Partizip = gesmst.
*/

/*
%%%% Abweichungen
Die Implementierung beschränkt sich auf Tabelle 1 im Aufgabenblatt 10.
Die Tabelle umfasst aber nur einen Teil der Konjugationskategorien.

Regelmäßige Verben aus den Kategorien, die nicht in der Tabelle mit
aufgelistet sind, können von der korrekten Beugung abweichen, z.B.
"flektieren", "öffnen" und "atmen".

Außerdem sind die meisten unregelmäßigen Verben nicht berücksichtigt
worden.

Zusammengesetzte Verben wie "hinterherblicken", deren Präfix mit einer
untrennbaren Präfix überlappt, werden nicht korrekt konjugiert.

Präfixen wie durch-, über-, um-, unter- und wider-, die sowohl
trennbar als auch untrennbar sein können, müssen gesondert behandelt
werden.

Verben wie "kennenlernen", die aus zwei Verben bestehen, werden außer
Acht gelassen.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Aufgabe 2.3: Konjugation v. Verben mit abtrennbaren Präfixen %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Betroffen sind im Grunde das Perfektpartizip.
% https://www.deutschplus.net/pages/Trennbare_untrennbare_Verben

%%%% Liste der trennbaren Präfixen
% Die Liste kann beliebig erweitert werden, z.B. um zusammengesetzte
% Präfixen wie "herbei" und "vorbei" oder spezifische Präfixen wie die
% bei "uraufführen".
trennbar([ab,an,auf,aus,bei,dar,ein,fehl,für,inne,los,mit,nach,rück,
          vor,wieder,zu,zurecht,zusammen,zwischen]).

%%%% Partizip
% Unterscheidung zwischen vier Fällen
partizip2(Inf,Part) :- stark(Inf,_,Part), !. % stark flektierend
partizip2(Inf,Part) :- % reguläre Verben mit unabtrennbaren Präfixen
    atom_concat(Präfix,Stamm,Inf),
    untrennbar(Präfixliste), member(Präfix,Präfixliste),
    partizip_endung(Stamm,X), atom_concat(Präfix,X,Part), !.
partizip2(Inf,Part) :- % reguläre Verben mit unabtrennbaren Präfixen
    atom_concat(Präfix,Stamm,Inf), trennbar(Präfixliste),
    member(Präfix,Präfixliste), partizip_endung(Stamm,X),
    atom_concat(ge,X,Y), atom_concat(Präfix,Y,Part), !.
partizip2(Inf,Part) :- % reguläre Verben ohne Präfix
    partizip_endung(Inf,X), atom_concat(ge,X,Part).

%%%% Prädikat
%% flexion2(+Infinitiv,?Präsens,?Präteritum,?Partizip)
%% flexion2(?Infinitiv,+Präsens,?Präteritum,?Partizip)
flexion2(Inf,Präs,Prät,Part) :-
    präsens(Inf,Präs), präteritum(Inf,Prät), partizip2(Inf,Part).

/*
%%%% Testfall
%% flexion2(+Infinitiv,-Präsens,-Präteritum,-Partizip)
?- flexion2(absagen,Präsens,Präteritum,Partizip).
Präsens = absagen,
Präteritum = absagten,
Partizip = abgesagt.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Bonus: Regelmäßigkeiten innerhalb der starken Verben         %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
Die Implementierung basiert auf der Tabelle (von Nr. A1 bis B7) unter
https://www.deutschplus.net/pages/Tabelle_starker_Verben.
Es ist viel zu umfangreich, Regelmäßigkeiten aus unregelmäßigen Verben
herzuleiten. Bei der vorliegenden Implementierung wird hauptsächlich
die Idee veranschaulicht. Auf Korrektheit und Vollständigkeit könnte
nur sehr bedingt geachtet werden.
*/

%%%% Prädikat
%% sv_flexion(+Infinitiv,?Präsens,?Präteritum,?Partizip)
% Unterscheidung zwischen fünf Fällen
sv_flexion(sein,sind,waren,gewesen) :- !. % 1. Fall: Sonderfall

% 2. Fall:
% Verben, die mit Präfixen anders konjugiert werden, wie z.B.
% "schaffen" (vgl. "beschaffen")
sv_flexion(Inf,Inf,Prät,Part) :- stark_verb(Inf,Prät,Part), !.

stark_verb(schaffen,schufen,schaffen).
stark_verb(geschehen,geschahen,geschehen).
stark_verb(essen,aßen,gegessen).

% 3. Fall:
% Verben mit untrennbaren Präfixen
% Die Beugung bezieht sich auf die Wortendung.
sv_flexion(Inf,Inf,Prät,Part) :-
    atom_concat(Präfix,Stamm,Inf),
    untrennbar(Präfixliste), member(Präfix,Präfixliste),
    sv_endung(Stamm,X,Y), atom_concat(Präfix,X,Prät),
    atom_concat(Präfix,Y,Part), !.

% 4. Fall
% Verben mit trennbaren Präfixen
% Die Beugung beinhaltet Wortendung und ge- zw. Präfix und Stamm.
sv_flexion(Inf,Inf,Prät,Part) :-
    atom_concat(Präfix,Stamm,Inf),
    trennbar(Präfixliste), member(Präfix,Präfixliste),
    sv_endung(Stamm,X,Y), atom_concat(Präfix,X,Prät),
    atom_concat(ge,Y,Z), atom_concat(Präfix,Z,Part), !.

% 5. Fall
% Sonstige Verben (theoretisch: Verben ohne Präfix)
sv_flexion(Inf,Inf,Prät,Part) :-
    sv_endung(Inf,Prät,X), atom_concat(ge,X,Part).

%%%% Wortendung bilden
% Unterscheidung zwischen zwei Kategorien
%% 1. Kategorie
% Verben mit einem gemeinsamen Endteil, dessen Konjugation analog
% erfolgt, z.B. "schlagen" ("schlugen", "geschlagen") und "tragen"
% ("trugen", "getragen").
sv_endung(Inf,Prät,Inf) :- % schlagen, tragen
    atom_concat(Vor,agen,Inf), atom_concat(Vor,ugen,Prät), !.
sv_endung(Inf,Prät,Inf) :- % braten, raten
    atom_concat(Vor,aten,Inf), atom_concat(Vor,ieten,Prät), !.
sv_endung(Inf,Prät,Inf) :- % empfangen, fangen
    atom_concat(Vor,angen,Inf), atom_concat(Vor,ingen,Prät), !.
sv_endung(Inf,Prät,Part) :- % befehlen, empfehlen, stehlen
    atom_concat(Vor,ehlen,Inf), atom_concat(Vor,ahlen,Prät),
    atom_concat(Vor,ohlen,Part), !.
sv_endung(Inf,Prät,Inf) :- % lesen, genesen
    atom_concat(Vor,esen,Inf), atom_concat(Vor,asen,Prät), !.
sv_endung(Inf,Prät,Part) :- % gebären, gären
    atom_concat(Vor,ären,Inf), atom_concat(Vor,aren,Prät),
    atom_concat(Vor,boren,Part), !.
sv_endung(Inf,Prät,Inf) :- % fressen, messen, vergessen
    atom_concat(Vor,essen,Inf), atom_concat(Vor,aßen,Prät), !.
sv_endung(Inf,Prät,Part) :- % brechen, sprechen, stechen
    atom_concat(Vor,echen,Inf), atom_concat(Vor,achen,Prät),
    atom_concat(Vor,ochen,Part).
sv_endung(Inf,Prät,Part) :- % gelten, schelten
    atom_concat(Vor,elten,Inf), atom_concat(Vor,alten,Prät),
    atom_concat(Vor,olten,Part), !.
sv_endung(Inf,Prät,Part) :- % sterben, verderben, werben
    atom_concat(Vor,erben,Inf), atom_concat(Vor,arben,Prät),
    atom_concat(Vor,orben,Part), !.
sv_endung(Inf,Prät,Part) :- % fechten, flechten
    atom_concat(Vor,echten,Inf), atom_concat(Vor,ochten,Prät),
    atom_concat(Vor,ochten,Part), !.
sv_endung(Inf,Prät,Part) :- % quellen, schwellen
    atom_concat(Vor,ellen,Inf), atom_concat(Vor,ollen,Prät),
    atom_concat(Vor,ollen,Part), !.

%% 2. Kategorie
% Beispiel: "stehen"
% Solche Verben sind mit trennbaren und untrennbaren Präfixen
% kommbinierbar, z.B. "anstehen" und "verstehen".
% Die Konjugation des Wortstamms ist gleich.
sv_endung(Inf,Prät,Part) :- sv(Inf,Prät,Part), !.

% Verben, die mit trennbaren und untrennbaren Präfixen kombinierbar
% sind. Das Partizip ohne Präfix ge- wird übergeben (z.B. "standen"
% statt "gestanden"), damit auch untrennbare Präfix bestückt werden
% kann (z.B. "verstanden").
sv(stehen,stand,standen).
sv(gehen,ging,gangen).
sv(wägen,wogen,wogen).
sv(melken,molken,gemolken).
sv(weben,woben,woben).
sv(schmelzen,schmolzen,schmolzen).
sv(heben,hoben,hoben).
sv(werfen,warfen,worfen).
sv(treffen,trafen,troffen).
sv(nehmen,nahmen,nommen).
sv(helfen,halfen,holfen).
sv(schrecken,schraken,schrocken).
sv(treten,traten,treten).
sv(bergen,bargen,borgen).
sv(geben,gaben,geben).
sv(sehen,sahen,sehen).
sv(schlafen,schliefen,schlafen).
sv(lassen,ließen,lassen).
sv(halten,hielten,halten).
sv(fallen,fielen,fallen).
sv(blasen,bliesen,blasen).
sv(waschen,wuschen,gewaschen).
sv(wachsen,wuchsen,wachsen).
sv(laden,luden,laden).
sv(graben,gruben,graben).
sv(fahren,fuhren,fahren).
sv(backen,buken,backen).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                              %%%%
%%%% Aufgabe 3: Strukturtransformatin                             %%%%
%%%%                                                              %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Die Prädikate können zusammengestellt werden, um eine Formel zu
% vereinfachen. In der Aufgabenstellung heißt es zwar, dass die
% arithmetischen Ausdrücken nur unter Verwendung der Operatoren '+'
% und '*' gebildet werden. Im ersten Beispiel kommt jedoch noch '-'
% vor. Beim Implementieren der Prädikate sind also drei Operatoren
% berücksichtigt worden.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Aufgabe 3.1: Beseitigen von neutralen und Nullelementen      %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Prädikat
%% beseitigen(+FormelAlt,?FormelNeu)

% Abbruch: ohne 0 in der neuen Formel
beseitigen(F,F) :- atomic(F), F \= 0, !.

% Nullelemente beseitigen
beseitigen(F+_*0,G) :- beseitigen(F,G), !.
beseitigen(F+0*_,G) :- beseitigen(F,G), !.
beseitigen(_*0+F,G) :- beseitigen(F,G), !.
beseitigen(0*_+F,G) :- beseitigen(F,G), !.

% neutrale Elemente beseitigen
beseitigen(F+0,G) :- beseitigen(F,G), !.
beseitigen(0+F,G) :- beseitigen(F,G), !.

beseitigen(F*1,G) :- beseitigen(F,G), !.
beseitigen(1*F,G) :- beseitigen(F,G), !.

% Rekursion in drei Fällen
beseitigen(F1+F2,G1+G2) :- beseitigen(F1,G1), beseitigen(F2,G2).
beseitigen(F1-F2,G1-G2) :- beseitigen(F1,G1), beseitigen(F2,G2).
beseitigen(F1*F2,G1*G2) :- beseitigen(F1,G1), beseitigen(F2,G2).

/*
%%%% Testfälle
%% beseitigen(+FormelAlt,-FormelNeu)
?- beseitigen(b+0+c*0,G).
G = b.

%% beseitigen(+FormelAlt,-FormelNeu)
?- beseitigen((a*b+a)*(b+0+c*0)*(1+d+2-3),G).
G = (a*b+a)*b*(1+d+2-3).
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Aufgabe 3.2: Auswerten rein numerischer (Teil-)Ausdrücke     %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Die Vorbedingung zur Anwendung des Prädikats ist es, dass alle
% Summanden Nummer sind.

%%%% Prädikat
%% auswerten(+Formel,?Ergebnis)

auswerten(F,F) :- number(F), !. % Abbruch

% arithmetisches Auswerten in drei Fällen
auswerten(F1+F2,G) :- number(F1), number(F2), G is F1+F2, !.
auswerten(F1-F2,G) :- number(F1), number(F2), G is F1-F2, !.
auswerten(F1*F2,G) :- number(F1), number(F2), G is F1*F2, !.

% Rekursion in drei Fällen
auswerten(F1+F2,G) :-
    auswerten(F1,G1), auswerten(F2,G2), auswerten(G1+G2,G).
auswerten(F1-F2,G) :-
    auswerten(F1,G1), auswerten(F2,G2), auswerten(G1-G2,G).
auswerten(F1*F2,G) :-
    auswerten(F1,G1), auswerten(F2,G2), auswerten(G1*G2,G).

/*
%%%% Testfall
%% auswerten(+Formel,-Ergebnis)
?- auswerten(1+2-3,G).
G = 6.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Bonus 1: Ausklammern gemeinsamer Faktoren                    %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Prädikat
%% ausklammern(+FormelAlt,?FormelNeu)

ausklammern(F,F) :- atom(F), !. % Abbruch

% vier Ausklammervarianten wegen Kommutativität
ausklammern(A*B+C*B,G1*G2) :-
  ausklammern(A+C,G1), ausklammern(B,G2), !.
ausklammern(A*B+B*C,G1*G2) :-
    ausklammern(A+C,G1), ausklammern(B,G2), !.
ausklammern(B*A+C*B,G1*G2) :-
    ausklammern(A+C,G1), ausklammern(B,G2), !.
ausklammern(B*A+B*C,G1*G2) :-
    ausklammern(A+C,G1), ausklammern(B,G2), !.

% Rekursion in drei Fällen
ausklammern(F1+F2,G1+G2) :- ausklammern(F1,G1), ausklammern(F2,G2).
ausklammern(F1-F2,G1-G2) :- ausklammern(F1,G1), ausklammern(F2,G2).
ausklammern(F1*F2,G1*G2) :- ausklammern(F1,G1), ausklammern(F2,G2).

/*
%%%% Testfälle
%% ausklammern(+FormelAlt,-FormelNeu)
?- ausklammern(a*b+c*b,G).
G = (a+c)*b.

%% ausklammern(+FormelAlt,-FormelNeu)
?- ausklammern((a*b+c*b)*d+(a*b+c*b)*e,G).
G = (d+e)*((a+c)*b).
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Bonus 2: Zusammenfassen der Addition gleicher Summande       %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Die Idee besteht darin, die Häufigkeit aller Summanden in der Formel
% durch ein Prädikat akkumulieren/3 zu ermitteln. Dann sorgt das
% Prädikat zf/4 dafür, dass die Summanden samt der jeweiligen
% Häufigkeit stückweise (mittels compound_name_arguments/3) zu der
% neuen Formel hinzugefügt.

%%%% Prädikat
%% zusammenfassen(+FormelAlt,?FormelNeu)
zusammenfassen(F,G) :-
    akkumulieren(F,[],Akkumulation),   % Häufigkeit ermitteln
    sort(Akkumulation,[Summand|Rest]), % sortieren; 1. Summand holen
    findall(Summand,member(Summand,Akkumulation),Haeufigkeit),
    length(Haeufigkeit,N), % Häufigkeit des 1. Summanden bestimmen
    (N is 1 -> X=Summand; X=N*Summand),
    zf(Rest,Akkumulation,X,G). % Hinzufügen ab dem 2. Summanden
    % X ist der 1. Summand, der als Startwert des Akkumulators dem
    % Prädikat zf/4 übergeben wird

%% zf(+Summandenlisten,+Häufigkeitsliste,+Akkumulator,?FormelNeu)
zf([],_,Acc,Acc). % Abbruch
zf([Summand|Rest],Akkumulation,Acc,G) :- % ein Summand aus der Liste
    findall(Summand,member(Summand,Akkumulation),Haeufigkeit),
    length(Haeufigkeit,N), % Häufigkeit des Summanden bestimmen
    (N is 1 -> X=Summand; X=N*Summand), % X ist ein Summand mit Koeff.
    compound_name_arguments(AccNeu,+,[Acc,X]), % Summand hinzufügen
    zf(Rest,Akkumulation,AccNeu,G). % Rekursion

%% akkumulieren(+Formel,+Akkumulator,?ListeAllerVorkommnisseSummanden
akkumulieren(Formel,Acc,[Formel|Acc]) :- atom(Formel), !. % Abbruch
akkumulieren(Formel,Acc,Akkumulation) :-
    compound_name_arguments(Formel,+,[Restformel,Summand]),
    akkumulieren(Restformel,[Summand|Acc],Akkumulation). % Rekursion

/*
%%%% Testfälle
%% zusammenfassen(+FormelAlt,-FormelNeu)
?- zusammenfassen(a+b+a+b,G).
G = 2*a+2*b.

%% zusammenfassen(+FormelAlt,-FormelNeu)
?- zusammenfassen(a+b+a*b+a+b,G).
G = 2*a+2*b+a*b.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Bonus 3: Nach-Innen-Treiben eines negativen Vorzeichens      %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Das Prädikat behandelt nicht tiefere Verschachtelungen.
% (siehe den letzten Testfall)

%%%% Prädikat
%% neg_nach_innen(+FormelAlt,?FormelNeu)
neg_nach_innen(F,F) :- atom(F), !.   % Basisfall
neg_nach_innen(-F,-F) :- atom(F), !. % Basisfall

% drei mögliche Fälle mit einem negativen Vorzeichen
neg_nach_innen(-(F1+F2),G1-G2) :-
    neg_nach_innen(-F1,G1), neg_nach_innen(F2,G2), !.
neg_nach_innen(-(F1-F2),G1+F2) :- neg_nach_innen(-F1,G1), !.
neg_nach_innen(-(F1*F2),G1*F2) :- neg_nach_innen(-F1,G1), !.

% Rekursion in drei Fällen
neg_nach_innen(F1+F2,G1+G2) :-
    neg_nach_innen(F1,G1), neg_nach_innen(F2,G2).
neg_nach_innen(F1-F2,G1-G2) :-
    neg_nach_innen(F1,G1), neg_nach_innen(F2,G2).
neg_nach_innen(F1*F2,G1*G2) :-
    neg_nach_innen(F1,G1), neg_nach_innen(F2,G2).

/*
%%%% Testfälle
%% neg_nach_innen(+FormelAlt,-FormelNeu).
?- neg_nach_innen(-((a+b)*c),G).
G = (-a-b)*c.

%% neg_nach_innen(+FormelAlt,-FormelNeu).
?- neg_nach_innen(-(a+b)*c,G).
G = (-a-b)*c.

%% neg_nach_innen(+FormelAlt,-FormelNeu).
?- neg_nach_innen(-(a-b)*c,G).
G = (-a+b)*c

%% neg_nach_innen(+FormelAlt,-FormelNeu).
?- neg_nach_innen(-(a+(b-c))*c,G).
G = (-a-(b-c))*c.
*/

