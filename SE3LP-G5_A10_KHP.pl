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

%%%% Pr�dikat
%% merkmalsvergleich(+Objekt,+Forderung)
% Die Liste der Objektmerkmale soll gleich lang bzw. l�nger sein als
% die Liste der geforderten Merkmale.
merkmalsvergleich(Objekt,Forderung) :-
    length(Objekt,NO), length(Forderung,NF), NO >= NF,
    mv(Objekt,Forderung), !.

%%%% Hilfspr�ikat
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
pilz([r�hren,lamellen],'keine Kategorie','nicht existent').
pilz([r�hren,roter_stiel],giftig,hexenr�hrling).
pilz([r�hren,roter_saft,am_baum],geniessbar,leberpilz).
pilz([r�hren,am_baum],ungeniessbar,baumpilz).
pilz([r�hren],essbar,[steinpilz,marone,butterpilz]).
pilz([braune_lamellen,gelbe_flecken],giftig,giftchampignon).
pilz([stinkend,braune_lamellen],ungeniessbar,karbolchampignon).
pilz([braune_lamellen],geniessbar,champignon).
pilz([lamellen,braune_kappe,abwischbare_punkte],geniessbar,perlpilz).
pilz([lamellen,punkte],giftig,[fliegenpilz,pantherpilz]).
pilz([lamellen],giftig,[knollenbl�tterpilz,fliegenpilz]).

%%%% Pr�dikat
%% pilz_kat(?Pilzmerkmale,?Kategorie,?Name)
pilz_kat(Pilzmerkmale,Kategorie,Pilzname) :-
    pilz(Merkmalsliste,Kat,Pilzname),                 % Fakten checken
    merkmalsvergleich(Pilzmerkmale,Merkmalsliste), !, % Vergleich
    (not(member(Kat,[giftig,ungeniessbar])) -> Kategorie = essbar;
    Kategorie = Kat). % Kat weder giftig noch ungeniessbar -> essbar

/*
%%%% Testf�lle
%% pilz_kat(+Pilzmerkmale,-Kategorie,-Name)
?- pilz_kat([am_baum,r�hren],Kategorie,Pilzname).
Kategorie = ungeniessbar,
Pilzname = baumpilz.

%% pilz_kat(+Pilzmerkmale,-Kategorie,-Name)
?- pilz_kat([r�hren],Kategorie,Pilzname).
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
%%%% Aufgabe 2.1: Bildung der Flexionsformen f�r deutsche Verben  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
Die Implementierung beschr�nkt sich auf Tabelle 1 im Aufgabenblatt 10.
Die Bildung der Flexionsformen wird in vier F�llen unterschieden:
    % stark flektierende Verben
    % Pr�sens
    % Pr�teritum
    % Perfektpartizip
F�r die letzten drei gibt es jeweils Pr�dikate, die unabh�ngig
voneinander gebraucht werden k�nnen.
*/

%%%% stark flektierende Verben (als Fakten festlegen)
stark(schreiben,schrieben,geschrieben).
stark(heben,hoben,gehoben).
stark(schlafen,schliefen,geschlafen).
stark(waschen,wuschen,gewaschen).
stark(treten,traten,getreten).
stark(trinken,tranken,getrunken).
stark(singen,sangen,gesungen).
stark(h�ngen,hingen,gehangen).
stark(haben,hatten,gehabt).
stark(sein,waren,gewesen).

%%%% Pr�sens
% In Tabelle 1 ist Pr�sens gleich Infinitiv, bis auf eine Ausnahme.
pr�sens(sein,sind) :- !. % Ausnahme
pr�sens(Inf,Inf).

%%%% Pr�teritum
pr�teritum(Inf,Pr�t) :- stark(Inf,Pr�t,_), !. % stark flektierend
% Die Konjugation beschr�nkt sich auf die Wortendung.
pr�teritum(Inf,Pr�t) :-
    atom_concat(Stamm,eln,Inf), atom_concat(Stamm,elten,Pr�t), !.
pr�teritum(Inf,Pr�t) :-
    atom_concat(Stamm,ern,Inf), atom_concat(Stamm,erten,Pr�t), !.
pr�teritum(Inf,Pr�t) :-
    atom_concat(Stamm,ten,Inf), atom_concat(Stamm,teten,Pr�t), !.
pr�teritum(Inf,Pr�t) :-
    atom_concat(Stamm,den,Inf), atom_concat(Stamm,deten,Pr�t), !.
pr�teritum(Inf,Pr�t) :-
    atom_concat(Stamm,en,Inf), atom_concat(Stamm,ten,Pr�t).

%%%% Partizip
% Unterscheidung zwischen drei F�llen:
partizip(Inf,Part) :- stark(Inf,_,Part), !. % stark flektierend
partizip(Inf,Part) :- % regul�re Verben mit unabtrennbaren Pr�fixen
    atom_concat(Pr�fix,Stamm,Inf),
    untrennbar(Pr�fixliste), member(Pr�fix,Pr�fixliste),
    partizip_endung(Stamm,X), atom_concat(Pr�fix,X,Part), !.
partizip(Inf,Part) :- % regul�re Verben ohne Pr�fix
    partizip_endung(Inf,X), atom_concat(ge,X,Part).

%%%% Liste der untrennbaren Pr�fixen (erweiterbar)
untrennbar([be,emp,ent,er,ge,hinter,miss,ver,zer]).

%% regul�re Verben ohne Pr�fix: Wortendungen festlegen
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

%%%% Pr�dikat
%% flexion(+Infinitiv,?Pr�sens,?Pr�teritum,?Partizip)
%% flexion(?Infinitiv,+Pr�sens,?Pr�teritum,?Partizip)
flexion(Inf,Pr�s,Pr�t,Part) :-
    pr�sens(Inf,Pr�s), pr�teritum(Inf,Pr�t), partizip(Inf,Part).
% Da pr�sens/2 zuerst behandelt wird, muss bei flexion/4 Infinitiv
% und/oder Pr�sens bereits instanziiert sein.

/*
%%%% Testf�lle
%% flexion(+Infinitiv,-Pr�sens,-Pr�teritum,-Partizip)
?- flexion(sein,Pr�sens,Pr�teritum,Partizip).
Pr�sens = sind,
Pr�teritum = waren,
Partizip = gewesen.

%% flexion(+Infinitiv,-Pr�sens,-Pr�teritum,-Partizip)
?- flexion(haben,Pr�sens,Pr�teritum,Partizip).
Pr�sens = haben,
Pr�teritum = hatten,
Partizip = gehabt.

%% flexion(+Infinitiv,-Pr�sens,-Pr�teritum,-Partizip)
?- flexion(h�ngen,Pr�sens,Pr�teritum,Partizip).
Pr�sens = h�ngen,
Pr�teritum = hingen,
Partizip = gehangen.

%% flexion(+Infinitiv,-Pr�sens,-Pr�teritum,-Partizip)
?- flexion(bewundern,Pr�sens,Pr�teritum,Partizip).
Pr�sens = bewundern,
Pr�teritum = bewunderten,
Partizip = bewundert.

%% flexion(+Infinitiv,-Pr�sens,-Pr�teritum,-Partizip)
?- flexion(versch�tten,Pr�sens,Pr�teritum,Partizip).
Pr�sens = versch�tten,
Pr�teritum = versch�tteten,
Partizip = versch�ttet.

%% flexion(+Infinitiv,-Pr�sens,-Pr�teritum,-Partizip)
?- flexion(hobeln,Pr�sens,Pr�teritum,Partizip).
Pr�sens = hobeln,
Pr�teritum = hobelten,
Partizip = gehobelt.

%% flexion(+Infinitiv,-Pr�sens,-Pr�teritum,-Partizip)
?- flexion(wundern,Pr�sens,Pr�teritum,Partizip).
Pr�sens = wundern,
Pr�teritum = wunderten,
Partizip = gewundert.

%% flexion(+Infinitiv,-Pr�sens,-Pr�teritum,-Partizip)
?- flexion(fl�chten,Pr�sens,Pr�teritum,Partizip).
Pr�sens = fl�chten,
Pr�teritum = fl�chteten,
Partizip = gefl�chtet.

%% flexion(+Infinitiv,-Pr�sens,-Pr�teritum,-Partizip)
?- flexion(wenden,Pr�sens,Pr�teritum,Partizip).
Pr�sens = wenden,
Pr�teritum = wendeten,
Partizip = gewendet.

%% flexion(+Infinitiv,-Pr�sens,-Pr�teritum,-Partizip)
?- flexion(h�ren,Pr�sens,Pr�teritum,Partizip).
Pr�sens = h�ren,
Pr�teritum = h�rten,
Partizip = geh�rt.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Aufgabe 2.2: Konjugation bzgl. Neubildungen und Abweichungen %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
%%%% Neubildungen
Bei neu gebildeten Verben wird die typische deutsche Laut-Buchstaben-
Zuordnung �fters nicht eingehalten. Dennoch stimmt anscheinend die
Verbbeugung solcher Neubildungen, sofern sie phonomorphologisch
"eingedeutscht" sind, wie die folgenden Testf�lle zeigen:

%% flexion(+Infinitiv,-Pr�sens,-Pr�teritum,-Partizip)
?- flexion(googeln,Pr�sens,Pr�teritum,Partizip).
Pr�sens = googeln,
Pr�teritum = googelten,
Partizip = gegoogelt.

%% flexion(+Infinitiv,-Pr�sens,-Pr�teritum,-Partizip)
?- flexion(d�deln,Pr�sens,Pr�teritum,Partizip).
Pr�sens = d�deln,
Pr�teritum = d�delten,
Partizip = ged�delt.

%% flexion(+Infinitiv,-Pr�sens,-Pr�teritum,-Partizip)
?- flexion(recyceln,Pr�sens,Pr�teritum,Partizip).
Pr�sens = recyceln,
Pr�teritum = recycelten,
Partizip = gerecycelt.

%% flexion(+Infinitiv,-Pr�sens,-Pr�teritum,-Partizip)
?- flexion(grepen,Pr�sens,Pr�teritum,Partizip).
Pr�sens = grepen,
Pr�teritum = grepten,
Partizip = gegrept.

%% flexion(+Infinitiv,-Pr�sens,-Pr�teritum,-Partizip)
?- flexion(smsen,Pr�sens,Pr�teritum,Partizip).
Pr�sens = smsen,
Pr�teritum = smsten,
Partizip = gesmst.
*/

/*
%%%% Abweichungen
Die Implementierung beschr�nkt sich auf Tabelle 1 im Aufgabenblatt 10.
Die Tabelle umfasst aber nur einen Teil der Konjugationskategorien.

Regelm��ige Verben aus den Kategorien, die nicht in der Tabelle mit
aufgelistet sind, k�nnen von der korrekten Beugung abweichen, z.B.
"flektieren", "�ffnen" und "atmen".

Au�erdem sind die meisten unregelm��igen Verben nicht ber�cksichtigt
worden.

Zusammengesetzte Verben wie "hinterherblicken", deren Pr�fix mit einer
untrennbaren Pr�fix �berlappt, werden nicht korrekt konjugiert.

Pr�fixen wie durch-, �ber-, um-, unter- und wider-, die sowohl
trennbar als auch untrennbar sein k�nnen, m�ssen gesondert behandelt
werden.

Verben wie "kennenlernen", die aus zwei Verben bestehen, werden au�er
Acht gelassen.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Aufgabe 2.3: Konjugation v. Verben mit abtrennbaren Pr�fixen %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Betroffen sind im Grunde das Perfektpartizip.
% https://www.deutschplus.net/pages/Trennbare_untrennbare_Verben

%%%% Liste der trennbaren Pr�fixen
% Die Liste kann beliebig erweitert werden, z.B. um zusammengesetzte
% Pr�fixen wie "herbei" und "vorbei" oder spezifische Pr�fixen wie die
% bei "urauff�hren".
trennbar([ab,an,auf,aus,bei,dar,ein,fehl,f�r,inne,los,mit,nach,r�ck,
          vor,wieder,zu,zurecht,zusammen,zwischen]).

%%%% Partizip
% Unterscheidung zwischen vier F�llen
partizip2(Inf,Part) :- stark(Inf,_,Part), !. % stark flektierend
partizip2(Inf,Part) :- % regul�re Verben mit unabtrennbaren Pr�fixen
    atom_concat(Pr�fix,Stamm,Inf),
    untrennbar(Pr�fixliste), member(Pr�fix,Pr�fixliste),
    partizip_endung(Stamm,X), atom_concat(Pr�fix,X,Part), !.
partizip2(Inf,Part) :- % regul�re Verben mit unabtrennbaren Pr�fixen
    atom_concat(Pr�fix,Stamm,Inf), trennbar(Pr�fixliste),
    member(Pr�fix,Pr�fixliste), partizip_endung(Stamm,X),
    atom_concat(ge,X,Y), atom_concat(Pr�fix,Y,Part), !.
partizip2(Inf,Part) :- % regul�re Verben ohne Pr�fix
    partizip_endung(Inf,X), atom_concat(ge,X,Part).

%%%% Pr�dikat
%% flexion2(+Infinitiv,?Pr�sens,?Pr�teritum,?Partizip)
%% flexion2(?Infinitiv,+Pr�sens,?Pr�teritum,?Partizip)
flexion2(Inf,Pr�s,Pr�t,Part) :-
    pr�sens(Inf,Pr�s), pr�teritum(Inf,Pr�t), partizip2(Inf,Part).

/*
%%%% Testfall
%% flexion2(+Infinitiv,-Pr�sens,-Pr�teritum,-Partizip)
?- flexion2(absagen,Pr�sens,Pr�teritum,Partizip).
Pr�sens = absagen,
Pr�teritum = absagten,
Partizip = abgesagt.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Bonus: Regelm��igkeiten innerhalb der starken Verben         %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
Die Implementierung basiert auf der Tabelle (von Nr. A1 bis B7) unter
https://www.deutschplus.net/pages/Tabelle_starker_Verben.
Es ist viel zu umfangreich, Regelm��igkeiten aus unregelm��igen Verben
herzuleiten. Bei der vorliegenden Implementierung wird haupts�chlich
die Idee veranschaulicht. Auf Korrektheit und Vollst�ndigkeit k�nnte
nur sehr bedingt geachtet werden.
*/

%%%% Pr�dikat
%% sv_flexion(+Infinitiv,?Pr�sens,?Pr�teritum,?Partizip)
% Unterscheidung zwischen f�nf F�llen
sv_flexion(sein,sind,waren,gewesen) :- !. % 1. Fall: Sonderfall

% 2. Fall:
% Verben, die mit Pr�fixen anders konjugiert werden, wie z.B.
% "schaffen" (vgl. "beschaffen")
sv_flexion(Inf,Inf,Pr�t,Part) :- stark_verb(Inf,Pr�t,Part), !.

stark_verb(schaffen,schufen,schaffen).
stark_verb(geschehen,geschahen,geschehen).
stark_verb(essen,a�en,gegessen).

% 3. Fall:
% Verben mit untrennbaren Pr�fixen
% Die Beugung bezieht sich auf die Wortendung.
sv_flexion(Inf,Inf,Pr�t,Part) :-
    atom_concat(Pr�fix,Stamm,Inf),
    untrennbar(Pr�fixliste), member(Pr�fix,Pr�fixliste),
    sv_endung(Stamm,X,Y), atom_concat(Pr�fix,X,Pr�t),
    atom_concat(Pr�fix,Y,Part), !.

% 4. Fall
% Verben mit trennbaren Pr�fixen
% Die Beugung beinhaltet Wortendung und ge- zw. Pr�fix und Stamm.
sv_flexion(Inf,Inf,Pr�t,Part) :-
    atom_concat(Pr�fix,Stamm,Inf),
    trennbar(Pr�fixliste), member(Pr�fix,Pr�fixliste),
    sv_endung(Stamm,X,Y), atom_concat(Pr�fix,X,Pr�t),
    atom_concat(ge,Y,Z), atom_concat(Pr�fix,Z,Part), !.

% 5. Fall
% Sonstige Verben (theoretisch: Verben ohne Pr�fix)
sv_flexion(Inf,Inf,Pr�t,Part) :-
    sv_endung(Inf,Pr�t,X), atom_concat(ge,X,Part).

%%%% Wortendung bilden
% Unterscheidung zwischen zwei Kategorien
%% 1. Kategorie
% Verben mit einem gemeinsamen Endteil, dessen Konjugation analog
% erfolgt, z.B. "schlagen" ("schlugen", "geschlagen") und "tragen"
% ("trugen", "getragen").
sv_endung(Inf,Pr�t,Inf) :- % schlagen, tragen
    atom_concat(Vor,agen,Inf), atom_concat(Vor,ugen,Pr�t), !.
sv_endung(Inf,Pr�t,Inf) :- % braten, raten
    atom_concat(Vor,aten,Inf), atom_concat(Vor,ieten,Pr�t), !.
sv_endung(Inf,Pr�t,Inf) :- % empfangen, fangen
    atom_concat(Vor,angen,Inf), atom_concat(Vor,ingen,Pr�t), !.
sv_endung(Inf,Pr�t,Part) :- % befehlen, empfehlen, stehlen
    atom_concat(Vor,ehlen,Inf), atom_concat(Vor,ahlen,Pr�t),
    atom_concat(Vor,ohlen,Part), !.
sv_endung(Inf,Pr�t,Inf) :- % lesen, genesen
    atom_concat(Vor,esen,Inf), atom_concat(Vor,asen,Pr�t), !.
sv_endung(Inf,Pr�t,Part) :- % geb�ren, g�ren
    atom_concat(Vor,�ren,Inf), atom_concat(Vor,aren,Pr�t),
    atom_concat(Vor,boren,Part), !.
sv_endung(Inf,Pr�t,Inf) :- % fressen, messen, vergessen
    atom_concat(Vor,essen,Inf), atom_concat(Vor,a�en,Pr�t), !.
sv_endung(Inf,Pr�t,Part) :- % brechen, sprechen, stechen
    atom_concat(Vor,echen,Inf), atom_concat(Vor,achen,Pr�t),
    atom_concat(Vor,ochen,Part).
sv_endung(Inf,Pr�t,Part) :- % gelten, schelten
    atom_concat(Vor,elten,Inf), atom_concat(Vor,alten,Pr�t),
    atom_concat(Vor,olten,Part), !.
sv_endung(Inf,Pr�t,Part) :- % sterben, verderben, werben
    atom_concat(Vor,erben,Inf), atom_concat(Vor,arben,Pr�t),
    atom_concat(Vor,orben,Part), !.
sv_endung(Inf,Pr�t,Part) :- % fechten, flechten
    atom_concat(Vor,echten,Inf), atom_concat(Vor,ochten,Pr�t),
    atom_concat(Vor,ochten,Part), !.
sv_endung(Inf,Pr�t,Part) :- % quellen, schwellen
    atom_concat(Vor,ellen,Inf), atom_concat(Vor,ollen,Pr�t),
    atom_concat(Vor,ollen,Part), !.

%% 2. Kategorie
% Beispiel: "stehen"
% Solche Verben sind mit trennbaren und untrennbaren Pr�fixen
% kommbinierbar, z.B. "anstehen" und "verstehen".
% Die Konjugation des Wortstamms ist gleich.
sv_endung(Inf,Pr�t,Part) :- sv(Inf,Pr�t,Part), !.

% Verben, die mit trennbaren und untrennbaren Pr�fixen kombinierbar
% sind. Das Partizip ohne Pr�fix ge- wird �bergeben (z.B. "standen"
% statt "gestanden"), damit auch untrennbare Pr�fix best�ckt werden
% kann (z.B. "verstanden").
sv(stehen,stand,standen).
sv(gehen,ging,gangen).
sv(w�gen,wogen,wogen).
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
sv(lassen,lie�en,lassen).
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

% Die Pr�dikate k�nnen zusammengestellt werden, um eine Formel zu
% vereinfachen. In der Aufgabenstellung hei�t es zwar, dass die
% arithmetischen Ausdr�cken nur unter Verwendung der Operatoren '+'
% und '*' gebildet werden. Im ersten Beispiel kommt jedoch noch '-'
% vor. Beim Implementieren der Pr�dikate sind also drei Operatoren
% ber�cksichtigt worden.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Aufgabe 3.1: Beseitigen von neutralen und Nullelementen      %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Pr�dikat
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

% Rekursion in drei F�llen
beseitigen(F1+F2,G1+G2) :- beseitigen(F1,G1), beseitigen(F2,G2).
beseitigen(F1-F2,G1-G2) :- beseitigen(F1,G1), beseitigen(F2,G2).
beseitigen(F1*F2,G1*G2) :- beseitigen(F1,G1), beseitigen(F2,G2).

/*
%%%% Testf�lle
%% beseitigen(+FormelAlt,-FormelNeu)
?- beseitigen(b+0+c*0,G).
G = b.

%% beseitigen(+FormelAlt,-FormelNeu)
?- beseitigen((a*b+a)*(b+0+c*0)*(1+d+2-3),G).
G = (a*b+a)*b*(1+d+2-3).
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Aufgabe 3.2: Auswerten rein numerischer (Teil-)Ausdr�cke     %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Die Vorbedingung zur Anwendung des Pr�dikats ist es, dass alle
% Summanden Nummer sind.

%%%% Pr�dikat
%% auswerten(+Formel,?Ergebnis)

auswerten(F,F) :- number(F), !. % Abbruch

% arithmetisches Auswerten in drei F�llen
auswerten(F1+F2,G) :- number(F1), number(F2), G is F1+F2, !.
auswerten(F1-F2,G) :- number(F1), number(F2), G is F1-F2, !.
auswerten(F1*F2,G) :- number(F1), number(F2), G is F1*F2, !.

% Rekursion in drei F�llen
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

%%%% Pr�dikat
%% ausklammern(+FormelAlt,?FormelNeu)

ausklammern(F,F) :- atom(F), !. % Abbruch

% vier Ausklammervarianten wegen Kommutativit�t
ausklammern(A*B+C*B,G1*G2) :-
  ausklammern(A+C,G1), ausklammern(B,G2), !.
ausklammern(A*B+B*C,G1*G2) :-
    ausklammern(A+C,G1), ausklammern(B,G2), !.
ausklammern(B*A+C*B,G1*G2) :-
    ausklammern(A+C,G1), ausklammern(B,G2), !.
ausklammern(B*A+B*C,G1*G2) :-
    ausklammern(A+C,G1), ausklammern(B,G2), !.

% Rekursion in drei F�llen
ausklammern(F1+F2,G1+G2) :- ausklammern(F1,G1), ausklammern(F2,G2).
ausklammern(F1-F2,G1-G2) :- ausklammern(F1,G1), ausklammern(F2,G2).
ausklammern(F1*F2,G1*G2) :- ausklammern(F1,G1), ausklammern(F2,G2).

/*
%%%% Testf�lle
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

% Die Idee besteht darin, die H�ufigkeit aller Summanden in der Formel
% durch ein Pr�dikat akkumulieren/3 zu ermitteln. Dann sorgt das
% Pr�dikat zf/4 daf�r, dass die Summanden samt der jeweiligen
% H�ufigkeit st�ckweise (mittels compound_name_arguments/3) zu der
% neuen Formel hinzugef�gt.

%%%% Pr�dikat
%% zusammenfassen(+FormelAlt,?FormelNeu)
zusammenfassen(F,G) :-
    akkumulieren(F,[],Akkumulation),   % H�ufigkeit ermitteln
    sort(Akkumulation,[Summand|Rest]), % sortieren; 1. Summand holen
    findall(Summand,member(Summand,Akkumulation),Haeufigkeit),
    length(Haeufigkeit,N), % H�ufigkeit des 1. Summanden bestimmen
    (N is 1 -> X=Summand; X=N*Summand),
    zf(Rest,Akkumulation,X,G). % Hinzuf�gen ab dem 2. Summanden
    % X ist der 1. Summand, der als Startwert des Akkumulators dem
    % Pr�dikat zf/4 �bergeben wird

%% zf(+Summandenlisten,+H�ufigkeitsliste,+Akkumulator,?FormelNeu)
zf([],_,Acc,Acc). % Abbruch
zf([Summand|Rest],Akkumulation,Acc,G) :- % ein Summand aus der Liste
    findall(Summand,member(Summand,Akkumulation),Haeufigkeit),
    length(Haeufigkeit,N), % H�ufigkeit des Summanden bestimmen
    (N is 1 -> X=Summand; X=N*Summand), % X ist ein Summand mit Koeff.
    compound_name_arguments(AccNeu,+,[Acc,X]), % Summand hinzuf�gen
    zf(Rest,Akkumulation,AccNeu,G). % Rekursion

%% akkumulieren(+Formel,+Akkumulator,?ListeAllerVorkommnisseSummanden
akkumulieren(Formel,Acc,[Formel|Acc]) :- atom(Formel), !. % Abbruch
akkumulieren(Formel,Acc,Akkumulation) :-
    compound_name_arguments(Formel,+,[Restformel,Summand]),
    akkumulieren(Restformel,[Summand|Acc],Akkumulation). % Rekursion

/*
%%%% Testf�lle
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

% Das Pr�dikat behandelt nicht tiefere Verschachtelungen.
% (siehe den letzten Testfall)

%%%% Pr�dikat
%% neg_nach_innen(+FormelAlt,?FormelNeu)
neg_nach_innen(F,F) :- atom(F), !.   % Basisfall
neg_nach_innen(-F,-F) :- atom(F), !. % Basisfall

% drei m�gliche F�lle mit einem negativen Vorzeichen
neg_nach_innen(-(F1+F2),G1-G2) :-
    neg_nach_innen(-F1,G1), neg_nach_innen(F2,G2), !.
neg_nach_innen(-(F1-F2),G1+F2) :- neg_nach_innen(-F1,G1), !.
neg_nach_innen(-(F1*F2),G1*F2) :- neg_nach_innen(-F1,G1), !.

% Rekursion in drei F�llen
neg_nach_innen(F1+F2,G1+G2) :-
    neg_nach_innen(F1,G1), neg_nach_innen(F2,G2).
neg_nach_innen(F1-F2,G1-G2) :-
    neg_nach_innen(F1,G1), neg_nach_innen(F2,G2).
neg_nach_innen(F1*F2,G1*G2) :-
    neg_nach_innen(F1,G1), neg_nach_innen(F2,G2).

/*
%%%% Testf�lle
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

