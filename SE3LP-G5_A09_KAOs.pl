/* 
SE3LP-18W-A09
Namen: Chung-Shan Kao, Harm Matthias Harms, Henrik Peters
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                              %%%%
%%%% Aufgabe 1: Vektoralgebra                                     %%%%
%%%%                                                              %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Aufgabe 1.1: Skalarprodukt zweier Vektoren                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Prädikat
%% skalarprodukt(+VektorX,+VektorY,?Produkt)
skalarprodukt(VektorX,VektorY,Produkt) :-
    skalarprodukt(VektorX,VektorY,0,Produkt). % Akk=0 für Endrekursion

skalarprodukt([],[],Akk,Akk). % Abbruch der Endrekursion
skalarprodukt([WertX|RestX],[WertY|RestY],Akk,Produkt) :- 
    W is WertX*WertY, AkkNeu is Akk+W, % AkkNeu = Akk + WertX*WertY
    skalarprodukt(RestX,RestY,AkkNeu,Produkt). % Rekursion

/*
%%%% Testfall
%% skalarprodukt(+VektorX,+VektorY,?Produkt)
?- skalarprodukt([1,3,5],[2,0,4],Produkt).
Produkt = 22.
https://www.mathe-online.at/materialien/Andreas.Pester/files/Vectors/skalarprodukt_zweier_vektoren.htm
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Aufgabe 1.2: Betrag eines Vektors                            %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Prädikat
%% vektorbetrag(+Vektor,?Betrag)
vektorbetrag(Vektor,Betrag) :- 
    skalarprodukt(Vektor,Vektor,Produkt), % Summe aller X*X
    Betrag is sqrt(Produkt).              % Quadratwurzel berechnen
    
/*
%%%% Testfall
%% vektorbetrag(+Vektor,-Betrag)
vektorbetrag([4,3,2],Betrag).
Betrag = 5.385164807134504.
https://www.mathe-lexikon.at/algebra/vektoralgebra/vektor-grundlagen/betrag-des-vektors.html
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Aufgabe 1.3: Cosinus des Winkels zwischen zwei Vektoren      %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Prädikat
%% sim(+VektorX,+VektorY,?KosinusXY)
sim(VektorX,VektorY,KosinusXY) :-
    skalarprodukt(VektorX,VektorY,Produkt), % Summe aller X*Y
    vektorbetrag(VektorX,BetragX),          % Betrag von VektorX
    vektorbetrag(VektorY,BetragY),          % Betrag von VektorY
    KosinusXY is Produkt/(BetragX*BetragY). % Kosinus des Winkels

%%%% HilfsPrädikat für den Testfall
%% vektorenwinkel(+VektorX,+VektorY,?Winkel)
vektorenwinkel(VektorX,VektorY,Winkel) :- % Winkel von VektorX/VektorY
    sim(VektorX,VektorY,KosinusXY),       % Kosinus des Winkels
    ArkuskosinusXY is acos(KosinusXY),    % Arkuskosinus für Bogenmaß
    Winkel is (ArkuskosinusXY/pi)*180.    % Bogenmaß zum Grad
  
/*
%%%% Testfall
%% sim(+VektorX,+VektorY,?KosinusXY)
?- sim([1,4,-2],[-3,3,1],KosinusXY).
KosinusXY = 0.3504383220252312.

?- vektorenwinkel([1,4,-2],[-3,3,1],KosinusXY)
KosinusXY = 69.48587281503896.
https://www.mathe-online.at/materialien/Andreas.Pester/files/Vectors/winkel_zwischen_vektoren.htm
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                              %%%%
%%%% Aufgabe 2: Algebra für komprimierte Vektoren                 %%%%
%%%%                                                              %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Aufgabe 2.1: Besetzungsdichte für kompr. Repräsentation      %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
Die Besetzungsdichte soll mindestens 50% betragen, damit sich die
vorgeschlagene Repräsentation lohnt.

Sei n die Länge des Vektors und d die Dichte der Besetzung. Dann ist 
zu erwarten, dass 2*(n*d) kleiner als oder gleich n ist, also
d größer als oder gleich 50%.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Aufgabe 2.2: Komprimieren dünn besetzter Termvektoren        %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Prädikat
%% komprimier(+Vektor,?VektorNeu)
komprimier(Vektor,VektorNeu) :- komprimier(Vektor,0,[],VektorNeu).

komprimier([],_,Akk,VektorNeu):- reverse(Akk,VektorNeu). % Abbruch

komprimier([Wert|Rest],Index,Akk,VektorNeu) :-
    Wert is 0, IndexNeu is Index+1, !, % Wert==0, dann überspringen
    komprimier(Rest,IndexNeu,Akk,VektorNeu). % Rekursion

komprimier([Wert|Rest],Index,Akk,VektorNeu) :-
    IndexNeu is Index+1,               % not(Wert==0), Wert aufnehmen
    komprimier(Rest,IndexNeu,[Wert,IndexNeu|Akk],VektorNeu). % Rekur.

/*
%%%% Testfall
%% komprimier(+Vektor,-VektorNeu)
?- komprimier([3,0,0,5,0,0,0,2,0,0],VektorNeu).
VektorNeu = [1, 3, 4, 5, 8, 2].
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Aufgabe 2.3: Modifikation der drei Prädikate aus Aufgabe 1   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
%%%% Idee anhand Beispiele erläutern

%% 1. Fall
% Komprimierte Vektoren gleicher Längen,
% aber mit unterschiedlichen Schlüsseln
?- komprimier([3,0,0,5,0,0,0,2,0,0],VektorX).
VektorX = [1, 3, 4, 5, 8, 2].
?- komprimier([3,0,5,0,0,0,2,0,0,0],VektorY).
VektorY = [1, 3, 3, 5, 7, 2].

%% 2. Fall
% Komprimierte Vektoren unterschiedlicher Längen
?- komprimier([3,0,0,5,0,0,0,2,0,0],VektorX).
VektorX = [1, 3, 4, 5, 8, 2].
komprimier([3,0,5,0,0,0,2,4,0,1],VektorY).
VektorY = [1, 3, 3, 5, 7, 2, 8, 4, 10, 1].

In beiden Fällen müssen VektorX und VektorY miteinander hinsichtlich
der Schlüssel gematcht werden, bevor der Kosinus des Winkels zwischen
ihnen berechnet wird.

Die Idee besteht also darin, dass ein Hilfsprädikat schluessel_match 
beide Vektoren miteinander matcht, damit die Prädikate aus Aufgabe 1
direkt auf die gematchten Vektoren angewandt werden können. Beispiele:

%% 1. Fall
% VX für den gematchten VektorX
% VY für den gematchten VektorY
?- komprimier([3,0,0,5,0,0,0,2,0,0],VektorX), 
   komprimier([3,0,5,0,0,0,2,0,0,0],VektorY), 
   schluessel_match(VektorX,VektorY,VX,VY).
VektorX = [1, 3, 4, 5, 8, 2],
VektorY = [1, 3, 3, 5, 7, 2],
VX = [3, 0, 5, 0, 2],
VY = [3, 5, 0, 2, 0].

%% 2. Fall
% VX für den gematchten VektorX
% VY für den gematchten VektorY
?- komprimier([3,0,0,5,0,0,0,2,0,0],VektorX), 
   komprimier([3,0,5,0,0,0,2,4,0,1],VektorY), 
   schluessel_match(VektorX,VektorY,VX,VY).
VektorX = [1, 3, 4, 5, 8, 2],
VektorY = [1, 3, 3, 5, 7, 2, 8, 4, 10, 1],
VX = [3, 0, 5, 0, 2, 0],
VY = [3, 5, 0, 2, 4, 1].
*/

%%%% Hilfsprädikat
%% schluessel_match(+VektorX,+VektorY,?VX,?VY)
schluessel_match(VektorX,VektorY,VX,VY) :-
    schluessel_match(VektorX,VektorY,[],[],VX,VY). % AkkX=[], AkkY=[]

schluessel_match([],[],AkkX,AkkY,VX,VY) :- % Abbruch der Endrekursion
    !, reverse(AkkX,VX), reverse(AkkY,VY). % beide Listen umdrehen

% WX für den 1 Wert in VektorX, RX für den Rest des VektorX ohne WX
schluessel_match([_,WX|RX],[],AkkX,AkkY,VX,VY) :- % VektorY leer
    !, schluessel_match(RX,[],[WX|AkkX],[0|AkkY],VX,VY). % Rekursion

% WY für den 1 Wert in VektorY, RY für den Rest des VektorY ohne WY
schluessel_match([],[_,WY|RY],AkkX,AkkY,VX,VY) :- % VektorX leer
    !, schluessel_match([],RY,[0|AkkX],[WY|AkkY],VX,VY).

% SX für den Schlüssel von WX, SY für den Schlüssel von WY
schluessel_match([SX,WX|RX],[SY,WY|RY],AkkX,AkkY,VX,VY) :-
    SX < SY, !, % Wenn SX < SY, WX zu AkkX hinzufügen, VektorY bleibt 
    schluessel_match(RX,[SY,WY|RY],[WX|AkkX],[0|AkkY],VX,VY). % Rekur.

schluessel_match([SX,WX|RX],[SY,WY|RY],AkkX,AkkY,VX,VY) :-
    SX > SY, !, % Wenn SX > SY, WY zu AkkX hinzufügen, VektorX bleibt
    schluessel_match([SX,WX|RX],RY,[0|AkkX],[WY|AkkY],VX,VY). % Rekur.

schluessel_match([_,WX|RX],[_,WY|RY],AkkX,AkkY,VX,VY) :- % SX==SY
    schluessel_match(RX,RY,[WX|AkkX],[WY|AkkY],VX,VY). % Rekursion

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Aufgabe 2.4: Index für einen Text                            %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
?- consult('texte.pl').

%%%% Prädikat 
%% text2index(+Text,?Index)
text2index(Text,Index) :-
    sort(Text,TextS), 		% Wörter sortieren und Duplikate entfernen
    ohne_stop(TextS,TextO), % Stoppwörter entfernen
    text2index(TextO,0,[],Index). % Akk=[], Schlüssel fängt von 0 an

text2index([],_,Akk,Index) :- reverse(Akk,Index). % Abbruch Endrekur.
text2index([Wort|Rest],N,Akk,Index) :-
    N1 is N + 1, % Schlüssel für das nächste Inhaltswort festlegen
    text2index(Rest,N1,[[Wort,N]|Akk],Index).     % Rekursion

/* Zwei Hilfsprädikate zum Erzeugen eines Index für Textsammlung */
%%%% Hilfsprädikat zum Entfernen von Stoppwörtern
%% ohne_stop(+TextInput,?TextOutput)
ohne_stop(TextInput,TextOutput) :-
    stop(Stops), % Stops für die Liste der Stoppwörter
    ohne_stop(Stops,TextInput,[],TextOutput). % Akk=[] für Endrekur.

ohne_stop(_,[],Akk,TextOutput) :- !, reverse(Akk,TextOutput).   

ohne_stop(Stops,[Wort|Rest],Akk,TextOutput) :-
    member(Wort,Stops), !, % Wort ist ein Stoppwort, also entfernen
    ohne_stop(Stops,Rest,Akk,TextOutput). % Rekursion

ohne_stop(Stops,[Wort|Rest],Akk,TextOutput) :-
    number(Wort), !,       % Wort ist eine Zahl, auch entfernen
    ohne_stop(Stops,Rest,Akk,TextOutput). % Rekursion

ohne_stop(Stops,[Wort|Rest],Akk,TextOutput) :-   % nicht Stopwort
    ohne_stop(Stops,Rest,[Wort|Akk],TextOutput). % Rekursion

%%%% Hilfsprädikat zum Erzeugen einer Liste aller Wörter aus Sammlung
%% wortsammlung(+ListeTextnummern,?Wortliste)
wortsammlung(Textliste,Wortliste) :-
    flatten(Textliste,AlleWoerter), % alle Wörter mit Duplikaten
    sort(AlleWoerter,Wortliste).    % sortieren, Duplikate entfernen

%%%% Hilfsprädikat zum Erzeugen einer Liste der Texte aus Textsammlung
textsammlung(Nummerliste,Textliste) :-
    textsammlung(Nummerliste,[],Textliste). % Akk=[] für Endrekur.

textsammlung([],Akk,Textliste) :- reverse(Akk,Textliste). % Abbruch
textsammlung([N|Rest],Akk,Textliste) :- 
    text(N,Text), textsammlung(Rest,[Text|Akk],Textliste). % Rekur.
    
/*
%%%% Testfall: Erzeugen eines Index für alle Wörter aus Textsammlung
%% wortsammlung(+ListeTextnummern,-Wortliste)
%% text2index(+Text,-Index)
?- textsammlung([1,2,3,4,5,6,7,8,9,10,11],Textliste), 
   wortsammlung(Textliste,Wortliste),
   text2index(Wortliste,Index).
Index = [[abgetrennten, 0], [absturz, 1], [abuja, 2], [adc, 3], 
[aktienbörse, 4], [all, 5], [alle, 6], [allmählich, 7], 
['amazon.com', 8], [anbieten, 9], [anderswo, 10], [anfang, 11], 
[angaben, 12], [angezündet, 13], [anklage, 14], [anschläge, 15], 
[anschlägen, 16], [anti, 17], [antwort, 18], [arbeitsgruppe, 19], 
[armee, 20], [art, 21], [atommächte, 22], [attacke, 23], 
[aufgenommenen, 24], [aufruhr, 25], [aufständische, 26], [august, 27], 
[ausgenommen, 28], [ausgesetzt, 29], [ausgewiesenen, 30], 
[ausgeübt, 31], [ausnahmen, 32], [ausreichenden, 33], 
[ausreichten, 34], [außenpolitischen, 35], [außenstaatssekretäre, 36], 
[außerhalb, 37], [bagdad, 38], [bahn, 39], [barot, 40], [bars, 41], 
[befand, 42], [befindet, 43], [begann, 44], [beginnen, 45], 
[begrenzte, 46], [behörden, 47], [beiden, 48], [beider, 49], 
[bekannt, 50], [bemannte, 51], [bericht, 52], [berichten, 53], 
[berichtete, 54], [beriet, 55], [berufung, 56], [berüchtigten, 57], 
[bestätigte, 58], [betriebe, 59], [betroffen, 60], 
[bevollmächtigte, 61], [beweise, 62], [bewohntes, 63], [bezos, 64], 
[bezug, 65], [bierkneipen, 66], [bieten, 67], [bisher, 68], 
[blair, 69], [bleiben, 70], [blick, 71], [blieben, 72], [blitz, 73], 
[blue, 74], [bombay, 75], [bombe, 76], [bombenanschläge, 77], 
[bombenattrappen, 78], [bombenserie, 79], [bombentaugliche, 80], 
[bringen, 81], [brite, 82], [briten, 83], [britische, 84], 
[bundespolizei, 85], [bundesregierung, 86], [bus, 87], [bush, 88], 
[busreisenden, 89], [creme, 90], [csu, 91], [damals, 92], 
[darauf, 93], [darsteller, 94], [darstellung, 95], [delhi, 96], 
[demnach, 97], [derweil, 98], [detonierte, 99], [deutschen, 100], 
[dhiren, 101], [dienstag, 102], [diskussionen, 103], [drittel, 104], 
[druck, 105], [drängte, 106], [durchführen, 107], [duschgel, 108], 
[duty, 109], [dürfe, 110], [dürfen, 111], [e, 112], [eckpunkte, 113], 
[effektiver, 114], [ehud, 115], [eigenen, 116], [eigentliche, 117], 
[einschätzung, 118], [einsetzen, 119], [entlassen, 120], [erde, 121], 
[ereignete, 122], [ergebnisse, 123], [erhielt, 124], 
[erinnerung, 125], [erklärungen, 126], [erlaubnis, 127], 
[erschossen, 128], [ersten, 129], [erstmals, 130], [erwartet, 131], 
[etwa, 132], [eu, 133], [experte, 134], [experten, 135], 
[expertenkommission, 136], [explosion, 137], [faa, 138], 
[fachleuten, 139], [fallen, 140], [fernstraße, 141], 
[feuerwerke, 142], [feuerwerksrakete, 143], [film, 144], 
[finanzgruppe, 145], [firma, 146], [flammen, 147], [flughafen, 148], 
[flughafenbetreibers, 149], [flughäfen, 150], [flugpassagiere, 151], 
[flugzeug, 152], [flugzeuge, 153], [flugzeugen, 154], [flüchen, 155], 
[flüssige, 156], [flüssiger, 157], [flüssigsprengstoff, 158], 
[frankfurter, 159], [fraport, 160], [free, 161], [freue, 162], 
[freunden, 163], [friedensgespräche, 164], [friedensgesprächen, 165], 
[frontal, 166], [früh, 167], [früheren, 168], [fälle, 169], 
[förderung, 170], [führt, 171], [gebaut, 172], [gebiet, 173], 
[gebäude, 174], [gefilmt, 175], [gefolgt, 176], [gefordert, 177], 
[gefährliche, 178], [gefängnis, 179], [geführt, 180], 
[gegenstände, 181], [gekauft, 182], [gekommen, 183], [gelten, 184], 
[gelungen, 185], [gelächter, 186], [gemeinsame, 187], [genaue, 188], 
[generelles, 189], [genommen, 190], [george, 191], [geplant, 192], 
[geplanten, 193], [geraucht, 194], [gerd, 195], [geriet, 196], 
[gerufen, 197], [gesagt, 198], [gesamt, 199], [gesamtstrategie, 200], 
[geschäften, 201], [gesehen, 202], [gesprengt, 203], [gestartet, 204], 
[geteilten, 205], [getestet, 206], [getränke, 207], [getötet, 208], 
[gezündet, 209], [ging, 210], [gleichen, 211], [großbritannien, 212], 
[großteil, 213], [grundsatzrede, 214], [größe, 215], [gründer, 216], 
[haar, 217], [haft, 218], [halbjahr, 219], [handelsunternehmens, 220], 
[handgepäck, 221], [handy, 222], [hauptstadt, 223], [heiligtum, 224], 
[heraus, 225], [herben, 226], [hieß, 227], [hintereinander, 228], 
[hintern, 229], [holen, 230], [hundert, 231], [hunderte, 232], 
[hysterischem, 233], [höchste, 234], [indien, 235], [indischen, 236], 
[indischer, 237], [inlandsfluggesellschaft, 238], [inneren, 239], 
[innerhalb, 240], [insbesondere, 241], [insgesamt, 242], 
[internationalen, 243], [irak, 244], [iraker, 245], [irakischen, 246], 
[iran, 247], [islamistische, 248], [isoliert, 249], 
[israelischen, 250], [iwf, 251], [jackass, 252], [jahr, 253], 
[jahre, 254], [jahrhundert, 255], [jede, 256], [jeff, 257], 
[juli, 258], [junger, 259], [jährige, 260], [jährigen, 261], 
[kabine, 262], [kamera, 263], [kaschmir, 264], [khan, 265], 
[kleinbusse, 266], [koalitionsfraktionen, 267], [kommerziellen, 268], 
[konflikt, 269], [konflikte, 270], [kongresswahlen, 271], 
[konkreter, 272], [konstruktive, 273], [kontrollen, 274], 
[kontrolleure, 275], [kontrollpunkt, 276], [krankenhaus, 277], 
[kriege, 278], [krise, 279], [kräfte, 280], [kurs, 281], [kurz, 282], 
[künftig, 283], [künftigen, 284], [landes, 285], [lashkar, 286], 
[lasse, 287], [latifija, 288], [laut, 289], [leben, 290], 
[lebenslanger, 291], [lediglich, 292], [legten, 293], [leitung, 294], 
[liegt, 295], [london, 296], [londoner, 297], [luft, 298], 
[luftfahrtbehörde, 299], [luftfahrtvertreter, 300], [länder, 301], 
[lösen, 302], [maccido, 303], [magazins, 304], [maschine, 305], 
[massenentführung, 306], [maßnahmen, 307], [medikamenten, 308], 
[mehrheitlich, 309], [mengen, 310], [menschen, 311], [messer, 312], 
[mindestens, 313], [ministerpräsidenten, 314], [mitarbeiter, 315], 
[mitteilte, 316], [mittwoch, 317], [mitverantwortung, 318], 
[mohammad, 319], [mohammadu, 320], [montag, 321], [moslemische, 322], 
[movie, 323], [muss, 324], [möglich, 325], [mögliche, 326], 
[möglicherweise, 327], [müller, 328], [nachdem, 329], 
[nachgeschult, 330], [nachrichtenagentur, 331], 
[nachrichtenmagazin, 332], [nachstellen, 333], [nadschaf, 334], 
[nahen, 335], [nahost, 336], [nan, 337], [neu, 338], [neue, 339], 
[neuen, 340], [new, 341], [newark, 342], [nichtraucherschutz, 343], 
[nichtraucherschutzgesetz, 344], [nichts, 345], [niederlage, 346], 
[nigerianischen, 347], [nigerianischer, 348], [november, 349], 
[offiziellen, 350], [olmert, 351], [online, 352], [operiert, 353], 
[opferzahl, 354], [origin, 355], [osten, 356], [pakistan, 357], 
[pakistanische, 358], [parfüm, 359], [parlamentsgebäude, 360], 
[passagiermaschine, 361], [per, 362], [personen, 363], 
[pistolen, 364], [plante, 365], [planung, 366], [polizei, 367], 
[polizeiangaben, 368], [polizeipatrouille, 369], [praktisch, 370], 
[premierminister, 371], [privaten, 372], [projekt, 373], 
[prudential, 374], [präsident, 375], [punkten, 376], 
[putschversuch, 377], [quartals, 378], [rakete, 379], 
[raketentests, 380], [ranghohen, 381], [rasierschaum, 382], 
[rauchen, 383], [rauchverbot, 384], [raumfahrt, 385], 
[raumflüge, 386], [raumflügen, 387], [raumkapsel, 388], 
[reaktion, 389], [rede, 390], [regeln, 391], [regelungen, 392], 
[region, 393], [reinen, 394], [rekrutierungsbüro, 395], 
[republikaner, 396], [rettungskräfte, 397], [riaz, 398], [riss, 399], 
[rissen, 400], [räumen, 401], [sagte, 402], [samstag, 403], 
[schiiten, 404], [schmuggeln, 405], [schmutzige, 406], 
[schnellrestaurant, 407], [schutz, 408], [schwachsinnige, 409], 
[schweren, 410], [seattle, 411], [sehen, 412], [selbst, 413], 
[selbstmordattentäter, 414], [serie, 415], 
[sicherheitsbestimmungen, 416], [sicherheitsdienstes, 417], 
[sicherheitskontrollen, 418], [sitz, 419], [sokoto, 420], 
[solle, 421], [sondern, 422], [sonntag, 423], [sorgen, 424], 
[speisegaststätten, 425], [spezialnahrung, 426], [spiegel, 427], 
[sprach, 428], [spray, 429], [sprecher, 430], [sprengsatz, 431], 
[sprengvorrichtungen, 432], [staaten, 433], [staatliche, 434], 
[stadtzentrum, 435], [stammten, 436], [starben, 437], [start, 438], 
[stattgefunden, 439], [stehen, 440], [stoffe, 441], [stoppten, 442], 
[strang, 443], [strategie, 444], [strategiewechsel, 445], 
[street, 446], [streitthema, 447], [stunts, 448], [stürzte, 449], 
[substanzen, 450], [sultan, 451], [sunniten, 452], [sunnitische, 453], 
[syrien, 454], [szene, 455], [süddeutschen, 456], [südlich, 457], 
[tag, 458], [tage, 459], [tagesordnung, 460], [teil, 461], 
[terror, 462], [terroranschlägen, 463], [terrorgruppe, 464], 
[testern, 465], [testrakete, 466], [tests, 467], [texas, 468], 
[the, 469], [tod, 470], [toiba, 471], [tony, 472], [toten, 473], 
[transatlantikflüge, 474], [transportierte, 475], [treffen, 476], 
[trudeln, 477], [täter, 478], [täuschten, 479], [u, 480], [um, 481], 
[umfasse, 482], [unabhängig, 483], [unabhängigkeit, 484], 
[unentdeckt, 485], [unterhändler, 486], [us, 487], [usa, 488], 
[verantwortlich, 489], [verboten, 490], 
[verbraucherstaatssekretär, 491], [verbündete, 492], [verdeckte, 493], 
[vereitelt, 494], [vereitelten, 495], [vergleichbare, 496], 
[verletzt, 497], [verletzten, 498], [verletzungen, 499], 
[vermutlich, 500], [verordnung, 501], [verschiedenen, 502], 
[verschleppt, 503], [verständigt, 504], [versuch, 505], 
[verurteilt, 506], [verübt, 507], [videokonferenz, 508], 
[vollführen, 509], [vorerst, 510], [vorfall, 511], 
[vorschriften, 512], [w, 513], [waghalsige, 514], [wall, 515], 
[washington, 516], [weder, 517], [weist, 518], [weißer, 519], 
[weltbank, 520], [weltraumbahnhof, 521], [wenige, 522], [west, 523], 
[westafrikanischen, 524], [wichtigste, 525], [wochenende, 526], 
[währungsfonds, 527], [würdenträger, 528], [york, 529], [yorker, 530], 
[zahnpasta, 531], [zdf, 532], [zeitgleich, 533], [zeitgleiche, 534], 
[zeitung, 535], [zentrale, 536], [ziehen, 537], [ziel, 538], 
[zufolge, 539], [zugeschaltet, 540], [zukunft, 541], [zunächst, 542], 
[zusammengekommen, 543], [zuständige, 544], [zweitägige, 545], 
[zünden, 546], [ähnlich, 547], [überdenken, 548], [überfall, 549], 
[überlebenden, 550], [überzeugung, 551]].
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Aufgabe 2.5: Komprimierter Termvektor für einen Text         %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Prädikat
%% termvektor(+Text,?Vektor,+Index)
termvektor(Text,Vektor,Index) :-
    ohne_stop(Text,TextO), % Stoppwörter aus dem Text entfernen
    worthaeufigkeit(TextO,Haeufigkeitsliste), % Worthäufigkeit
    termvektor(Haeufigkeitsliste,[],Vektor,Index). % Akk=[]

termvektor([],Akk,Vektor,_) :- reverse(Akk,Vektor). % Abbruch Rekur.
termvektor([[Wort,Wert]|Rest],Akk,Vektor,Index) :-
    wort2schluessel(Wort,Schluessel,Index), % Schlüssel fürs Wort
    termvektor(Rest,[Wert,Schluessel|Akk],Vektor,Index). % Rekur.

%%%% Hilfsprädikat zum Ermitteln der Worthäufigkeit für einen Text
worthaeufigkeit(Text,Haeufigkeitsliste) :-
    sort(Text,Wortliste), % eine Wortliste aus Text erstellen
    worthaeufigkeit(Wortliste,Text,[],Haeufigkeitsliste). % Akk=[]

worthaeufigkeit([],_,Akk,Haeufigkeitsliste) :-
    reverse(Akk,Haeufigkeitsliste). % Abbruch der Endrekursion

worthaeufigkeit([Wort|Rest],Text,Acc,Haeufigkeitsliste) :-
    findall(Wort,member(Wort,Text),WortList), % alle Vorkommnisse
    length(WortList,N), % Anzahl aller Vorkommnisse eines Wortes
    worthaeufigkeit(Rest,Text,[[Wort,N]|Acc],Haeufigkeitsliste).

%%%% Hilfsprädikat zum Ermitteln des Schlüssels eines Wortes im Index
%% wort2schluessel(?Wort,?Schluessel,+Index)
wort2schluessel(Wort,Schluessel,[[Wort,Schluessel]|_]) :- !. % Abbr.
wort2schluessel(Wort,Schluessel,[_|Rest]) :-  % Wort nicht gefunden 
    wort2schluessel(Wort,Schluessel,Rest).    % Rekursion

/*
%%%% Testfall
%% 
?- wortsammlung([1,2,3,4,5,6,7,8,9],Wortliste),
   text2index(Wortliste,Index),
   text(6,Text6),
   termvektor(Text6,Vektor,Index).
Vektor = [23, 1, 38, 2, 99, 1, 183, 1, 228, 1, 245, 2, 282, 1, 290, 1, 
311, 2, 313, 1, 316, 1, 367, 2, 369, 1, 395, 1, 399, 1, 407, 1, 
414, 1, 431, 1, 435, 1, 437, 1, 463, 1, 470, 1, 497, 1, 523, 1].
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Aufgabe 2.6: Speicherplatzersparnis durch Komprimieren       %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
Sei n die Anzahl der Wörter in einem Text und d die Dichte der 
Besetzung der Wörter im Index. Dann beläuft sich die Länge des 
komprimierten Termvektors auf 2*(n*d). 

Die Speicherplatzreduktion beträgt dann 2*(n*d) - n.

Je kleiner die Besetzungsdichte d ist, desto größer ist die
Speicherplatzersparnis, die durch die oben genannten Speicherplatz-
reduktion gemessen wird.

Die Besetzungsdichte d hängt von der Anzahl verschiedener Wörter in 
einem Text ab. Je mehr verschiedene Wörter in einem Text vorkommen,
destor größer ist die Besetzungsdichte, die dann bewirkt, dass der
Termvektor mehr Speicherplatz beansprucht.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                              %%%%
%%%% Aufgabe 3: Dokumentenrecherche                               %%%%
%%%%                                                              %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Aufgabe 3.1: Paare von Texten hoher und geringer Ähnlichkeit %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
Die Ähnlichkeitsmatrix für die elf Texte aus texte.pl sieht so aus:
[[1.000,0.000,0.015,0.000,0.034,0.022,0.000,0.000,0.013,0.034,0.000],
 [0.000,1.000,0.015,0.000,0.035,0.000,0.021,0.000,0.054,0.000,0.049],
 [0.015,0.015,1.000,0.062,0.071,0.131,0.068,0.012,0.044,0.000,0.016],
 [0.000,0.000,0.062,1.000,0.012,0.015,0.000,0.009,0.009,0.000,0.020],
 [0.034,0.035,0.071,0.012,1.000,0.126,0.076,0.065,0.037,0.032,0.000],
 [0.022,0.000,0.131,0.015,0.126,1.000,0.176,0.017,0.000,0.000,0.000],
 [0.000,0.021,0.068,0.000,0.076,0.176,1.000,0.000,0.015,0.019,0.097],
 [0.000,0.000,0.012,0.009,0.065,0.017,0.000,1.000,0.020,0.026,0.029],
 [0.013,0.054,0.044,0.009,0.037,0.000,0.015,0.020,1.000,0.062,0.021],
 [0.034,0.000,0.000,0.000,0.032,0.000,0.019,0.026,0.062,1.000,0.009],
 [0.000,0.049,0.016,0.020,0.000,0.000,0.097,0.029,0.021,0.009,1.000]]

In der Matrix sind die Kosinus-Werte des Winkels zwischen den zwei
Termvektoren von je zwei Texten aus texte.pl. Entlang der Diagonale
von links oben nach rechts unten sind alle elf Werte 1.0; das heißt,
dass der Winkel 0 beträgt, wenn ein Text mit sich selbst verglichen
wird. Außerdem ist die Matrix symmetrisch bzgl. der genannten
Diagnonal.


%% Etwas ähnliche Texte: text(6,Text6) und text(7,Text7)

Der Matrix ist zu entnehmen, dass sich ein höherer Wert von ca. 0.176 
aus dem Ähnlichkeitsvergleich zwischen den Text6 und Text7 ergibt. Wir
können die zwei Texte ohne Stoppwörter und ohne Duplikate vergleichen:

Txt6 = [attacke, bagdad, detonierte, gekommen, hintereinander, 
iraker, kurz, leben, menschen, mindestens, mitteilte, polizei, 
polizeipatrouille, rekrutierungsbüro, riss, schnellrestaurant, 
selbstmordattentäter, sprengsatz, stadtzentrum, starben, 
terroranschlägen, tod, verletzt, west].

Txt7 = [angaben, aufständische, bagdad, befindet, berüchtigten, 
bewohntes, busreisenden, erschossen, fernstraße, führt, gebiet, 
getötet, heiligtum, insgesamt, irak, irakischen, kleinbusse, 
kontrollpunkt, latifija, massenentführung, mehrheitlich, menschen, 
mindestens, nadschaf, polizei, polizeiangaben, samstag, schiiten, 
stoppten, sunniten, sunnitische, südlich, täter, täuschten, 
verschleppt, verübt, wichtigste, überfall].

Es gibt also Wortüberlappungen wie 'bagdad', 'menschen', 'mindestens' 
und 'polizei'. Noch anschaulicher sind die zwei Termvektoren, wobei
die Schlüssel 38, 311, 313 und 367 in beiden Vektoren erscheinen:

Vektor6 = [23, 1, 38, 2, 99, 1, 183, 1, 228, 1, 245, 2, 282, 1, 
290, 1, 311, 2, 313, 1, 316, 1, 367, 2, 369, 1, 395, 1, 399, 1, 
407, 1, 414, 1, 431, 1, 435, 1, 437, 1, 463, 1, 470, 1, 497, 1, 
523, 1].

Vektor7 = [12, 1, 26, 1, 38, 1, 43, 1, 57, 1, 63, 1, 89, 1, 128, 1, 
141, 1, 171, 1, 173, 1, 208, 1, 224, 1, 242, 1, 244, 1, 246, 1, 
266, 1, 276, 1, 288, 1, 306, 1, 309, 1, 311, 1, 313, 1, 334, 1, 
367, 1, 368, 1, 403, 2, 404, 2, 442, 1, 452, 1, 453, 1, 457, 1, 
478, 1, 479, 1, 503, 1, 507, 1, 525, 1, 549, 1].


%% Unähnliche Texte: text(6,Text6) und text(10,Text10)

Wenn wir aber Text6 und Text10 miteinander vergleichen, ergibt sich ein
Kosinus-Wert von 0.0. Wortüberlappungen liegen nicht vor, auch wenn
Text10 länger als Text7 ist:

Txt6 = [attacke, bagdad, detonierte, gekommen, hintereinander, 
iraker, kurz, leben, menschen, mindestens, mitteilte, polizei, 
polizeipatrouille, rekrutierungsbüro, riss, schnellrestaurant, 
selbstmordattentäter, sprengsatz, stadtzentrum, starben, 
terroranschlägen, tod, verletzt, west].

Txt10 = [bericht, berichtete, berufung, bleiben, bombenattrappen, 
bundespolizei, demnach, deutschen, drittel, einschätzung, entlassen, 
ersten, experten, fallen, flughafen, flughafenbetreibers, flughäfen, 
frankfurter, fraport, fälle, gefährliche, gegenstände, gelungen, 
getestet, halbjahr, innerhalb, insgesamt, kontrollen, kontrolleure, 
messer, mitarbeiter, nachgeschult, nachrichtenmagazin, pistolen, 
privaten, quartals, schmuggeln, sicherheitsdienstes, spiegel, testern, 
tests, unentdeckt, verdeckte, vergleichbare, wochenende, zufolge, 
ähnlich].

Vektor6 = [23, 1, 38, 2, 99, 1, 183, 1, 228, 1, 245, 2, 282, 1, 
290, 1, 311, 2, 313, 1, 316, 1, 367, 2, 369, 1, 395, 1, 399, 1, 
407, 1, 414, 1, 431, 1, 435, 1, 437, 1, 463, 1, 470, 1, 497, 1, 
523, 1].

VektorY = [15, 1, 27, 1, 32, 1, 33, 1, 34, 1, 46, 1, 58, 1, 60, 1, 
67, 1, 77, 1, 80, 1, 81, 1, 90, 1, 92, 1, 95, 1, 108, 1, 109, 1, 
111, 1, 132, 1, 133, 2, 134, 1, 137, 1, 148, 2, 150, 1, 151, 1, 
152, 1, 153, 2, 154, 1, 156, 1, 157, 1, 158, 1, 161, 1, 166, 1, 
172, 1, 182, 1, 184, 2, 190, 1, 201, 1, 207, 1, 217, 1, 221, 1, 
227, 1, 230, 1, 262, 1, 289, 1, 296, 1, 298, 1, 304, 1, 308, 1, 
310, 1, 325, 1, 326, 1, 339, 2, 340, 1, 349, 1, 359, 1, 382, 1, 
389, 1, 391, 1, 405, 1, 408, 1, 416, 1, 418, 1, 426, 1, 429, 1, 
432, 1, 436, 1, 441, 3, 450, 1, 461, 1, 462, 1, 478, 1, 481, 1, 
495, 1, 500, 1, 501, 1, 512, 1, 531, 1, 532, 2].


%% Tendenz

Generell zeigt die Matrix, dass die Kosinus-Werte zwischen zwei 
unterschiedlichen Texten klein sind. Wie wir in der obigen Analyse 
beobachten konnten, lassen die kleinen Werte u.a. darauf zurückführen, 
dass verschiedene Wortformen aus dem gleichen Wortstamm bei den 
Vergleichen nicht berücksichtigt werden.

Beispielsweise sind 'detonierte', 'detoniert', 'detonieren' und 
'detonierten' alle abgeleiteten Wortformen desselben Wortes. Dennoch 
werden sie als verschiedene Wörter in den Index eingetragen.

Nicht berücksichtigt sind auch Komposita (zusammengesetzte Wörter).
Beispielsweise hängen wahrscheinlich 'polizei' und 'polizeipatrouille'
miteinander zusammen; allerdings sind sie zwei getrennte Einträge im
Index.

Des Weiteren wird lexikalische Semantik komplett außer Acht gelassen.
Synonyme und Wörter mit ähnlichen Bedeutungen werden im Index als
unabhängige Wörter aufgenommen.

Insgesamt basiert der Ähnlichkeitsvergleich, der hier implementiert
wurde, ausschließlich darauf, dass eine exakte Wortform in zwei Texten
vorkommt. Die Implementierung schränkt die Ähnlichkeit zu viel ein,
ohne syntaktische und semantische Ähnlichkeiten zwischen Wörtern
einzubeziehen.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Aufgabe 3.2: Ähnlichkeiten zwischen Suchanfragen und Texten  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
%%%% 1. Fall
%% Anfrage: [bagdad,menschen,polizei,stadtzentrum]
%% text(6,Text6)
Alle vier Schlüsselwörter in der Anfrage kommen in Text6 vor. Ein Wort
erscheint zweimal im Text. Der Kosinus-Wert ist relativ hoch:

?- textsammlung([1,2,3,4,5,6,7,8,9,10,11],Textliste),
   wortsammlung(Textliste,Wortliste),
   text2index(Wortliste,Index),
   text(6,TextX), termvektor(TextX,VektorX,Index),
   termvektor([bagdad,menschen,polizei,stadtzentrum],VektorY,Index),
   schluessel_match(VektorX,VektorY,VX,VY),
   sim(VX,VY,KosinusXY).
KosinusXY = 0.5833333333333334.

%%%% 2. Fall
%% Anfrage: [bagdad,menschen,polizei,stadtzentrum]
%% text(7,Text7)
Drei von vier Schlüsselwörtern in der Anfrage kommen in Text7 vor. 
Jedes der drei Wörter erscheint jeweils einmal im Text. Somit ist der 
Kosinus-Wert bereits wesentlich geringer als im 1. Fall:

?- textsammlung([1,2,3,4,5,6,7,8,9,10,11],Textliste),
   wortsammlung(Textliste,Wortliste),
   text2index(Wortliste,Index),
   text(7,TextX), termvektor(TextX,VektorX,Index),
   termvektor([bagdad,menschen,polizei,stadtzentrum],VektorY,Index),
   schluessel_match(VektorX,VektorY,VX,VY),
   sim(VX,VY,KosinusXY).
KosinusXY = 0.22613350843332272.

%%%% 3. Fall
%% Anfrage: [bagdad,menschen,polizei,stadtzentrum]
%% text(10,Text10)
Kein Schlüsselwörter in der Anfrage kommt in Text10 vor. Wie erwartet
ergibt sich ein Kosinus-Wert von 0:

?- textsammlung([1,2,3,4,5,6,7,8,9,10,11],Textliste),
   wortsammlung(Textliste,Wortliste),
   text2index(Wortliste,Index),
   text(10,TextX), termvektor(TextX,VektorX,Index),
   termvektor([bagdad,menschen,polizei,stadtzentrum],VektorY,Index),
   schluessel_match(VektorX,VektorY,VX,VY),
   sim(VX,VY,KosinusXY).
KosinusXY = 0.0.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Bonus: Ähnlichkeitsmatrix für gegebene Texte                 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Prädikat
%% aehnlichkeitsmatrix(+Textliste,?Matrix,+Index)
aehnlichkeitsmatrix(Textliste,Matrix,Index) :- % Akk=[] für Endrek.
    aehnlichkeitsmatrix(Textliste,Textliste,[],Matrix,Index).

aehnlichkeitsmatrix([],_,Akk,Matrix,_) :- !, reverse(Akk,Matrix).

aehnlichkeitsmatrix([Text|Rest],Textliste,Akk,Matrix,Index) :-
    aehnlichkeitsvektor(Text,Textliste,Vektor,Index), % Ä.-Vektor
    aehnlichkeitsmatrix(Rest,Textliste,[Vektor|Akk],Matrix,Index).

%%%% Hilfsprädikat: Ähnlichkeitsvektor mit einem Text und Textliste
aehnlichkeitsvektor(Text,Textliste,Vektor,Index) :- % Ähnl.-Vektor
    aehnlichkeitsvektor(Text,Textliste,[],Vektor,Index). % Akk=[]

aehnlichkeitsvektor(_,[],Akk,Vektor,_) :- !, reverse(Akk,Vektor).

aehnlichkeitsvektor(TextX,[TextY|Rest],Akk,Vektor,Index) :-
    termvektor(TextX,VektorX,Index), % Termvektor für TextX
    termvektor(TextY,VektorY,Index), % Termvektor für TextY
    schluessel_match(VektorX,VektorY,VX,VY), % Vektoren matchen
    sim(VX,VY,KosinusXY), % Kosinus des Winkels zw. VX und VY
    aehnlichkeitsvektor(TextX,Rest,[KosinusXY|Akk],Vektor,Index).

/*
%%%% Testfall
%% aehnlichkeitsmatrix(+Textliste,-Matrix,+Index)
?- textsammlung([1,2,3,4,5,6,7,8,9,10,11],Textliste),
   wortsammlung(Textliste,Wortliste),text2index(Wortliste,Index),
   aehnlichkeitsmatrix(Textliste,Matrix,Index).
Matrix = [[1.0, 0.0, 0.015170682161267662, 0.0, 0.03397647942917503, 
0.022473328748774737, 0.0, 0.0, 0.013159033899195382, 
0.03424938726253708, 0.0], [0.0, 1.0, 0.01545427085630454, 0.0, 
0.03461160877674433, 0.0, 0.020707884164064556, 0.0, 
0.053620073751110914, 0.0, 0.048932674830098534], 
[0.015170682161267662, 0.01545427085630454, 1.0, 0.06214364186982008, 
0.07087387592709371, 0.13126025510803613, 0.06784535315527584, 
0.011543158305430273, 0.04391893458348875, 0.0, 0.01603183878361375], 
[0.0, 0.0, 0.06214364186982008, 1.0, 0.011598150010653683, 
0.015342910298305389, 0.0, 0.009444896294427423, 0.00898388836761542, 
0.0, 0.0196764677457008], [0.03397647942917503, 0.03461160877674433, 
0.07087387592709371, 0.011598150010653683, 0.9999999999999999, 
0.12598815766974242, 0.07597371763975863, 0.06463056119412346, 
0.03688555567816587, 0.03200102404915462, 0.0], [0.022473328748774737, 
0.0, 0.13126025510803613, 0.015342910298305389, 0.12598815766974242, 
1.0, 0.17588161767036212, 0.017099639201419235, 0.0, 0.0, 0.0], 
[0.0, 0.020707884164064556, 0.06784535315527584, 0.0, 
0.07597371763975863, 0.17588161767036212, 1.0, 0.0, 
0.014712247158412494, 0.01914598952668709, 0.09666807227574198], 
[0.0, 0.0, 0.011543158305430273, 0.009444896294427423, 
0.06463056119412346, 0.017099639201419235, 0.0, 1.0000000000000002, 
0.02002504697287036, 0.02605987620285215, 0.02923917237500966], 
[0.013159033899195382, 0.053620073751110914, 0.04391893458348875, 
0.00898388836761542, 0.03688555567816587, 0.0, 0.014712247158412494, 
0.02002504697287036, 1.0000000000000002, 0.06196971660197944, 
0.020859000384170642], [0.03424938726253708, 0.0, 0.0, 0.0, 
0.03200102404915462, 0.0, 0.01914598952668709, 0.02605987620285215, 
0.06196971660197944, 1.0, 0.009048384396853446], [0.0, 
0.048932674830098534, 0.01603183878361375, 0.0196764677457008, 0.0, 
0.0, 0.09666807227574198, 0.02923917237500966, 0.020859000384170642, 
0.009048384396853446, 1.0000000000000002]].
*/

