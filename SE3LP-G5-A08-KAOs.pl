% SE3LP-18W-A08


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                              %%%%
%%%% Aufgabe 1: Chat-Bots                                         %%%%
%%%%                                                              %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Gespräch gestalten                                           %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Reaktion auf Eingabe aussuchen
% sublis(Input,Response)
sublis(Input,Response) :-
    rule(Input,ResList),	   % Reaktion zufällig auswählen
    !,						   % Abbruch wenn 1. Regel gefunden
    flatten(ResList,Response). % Reaktion als Liste verflachen			

/*
%% Testfall
?- sublis(['I',dreamt,about,winning,a,lottery],Response).
Response = [['Have', you, ever, fantasized], 
			[about, winning, a, lottery], 
            [while, you, were, awake, (?)]].

?- sublis(['I',dreamt,about,winning,a,lottery],Response).
Response = [['Have', you, ever, dreamt], 
			[about, winning, a, lottery], [(?)]].
*/

%%%% Interaktionszyklus starten
% chatbot\0
chatbot :-
    write_ln('\nWELCOME to Chat-Bot!'),
    write_ln('\nINPUT FORMAT'),
    write_ln('\tEach input is a simple sentence, phrase, or a word.'),
    write_ln('\tPlease submit the input in single quotation marks.'),
    write_ln('\tCapitalize the first word of the input sentence.'),
    write_ln('\tFor instance, \'Hello there!\' is a valid input.'),
    write_ln('\t\'I dont have money.\' is also a valid input.'),
    write_ln('\n\tDo not forget the period to submit an input!'),
    write_ln('\nPUNCTUATION'),
    write_ln('\tFour punctuation marks are allowed in the input.'),
    write_ln('\tTheses are \',\', \'.\', \'!\', and \'?\'.'),
    write_ln('\nGOODBYE'),
    write_ln('\tSubmit \'Bye\' to end the dialog.\n'),
    repeat,
	read(Input),		% Eingabe
	respond(Input), !.	% Reaktion

%%%% Reaktion auf Eingabe gestalten
% respond(Input)
respond('Bye') :- !. % Abbruch
respond('bye') :- !. % Abbruch
respond(Input) :-
    remove_punctuation(Input,InputRemove),		   % Interpunktion weg
    atomic_list_concat(InputList,' ',InputRemove), % string2list
    sublis(InputList,ResSublis),			       % Reaktion aussuchen
    atomic_list_concat(ResSublis,' ',Response),    % list2string
    write_ln(Response), 					       % Ausgabe
    write_ln(''),
    fail.                                          % Iteration
% atomic_list_concat(?List,+Separator,?Atom)

% remove_punctuation(StringOld,StringNew)
remove_punctuation(X,Y) :- 
    atom_chars(X,Xs), remove_punct(Xs,[],Ys), atom_chars(Y,Ys).

remove_punct([],Acc,Ys) :- reverse(Acc,Ys),!. % Abbruch
remove_punct([H|T],Acc,Ys) :-
    member(H,[',','.','?','!']), % mögliche Interpunktion
    remove_punct(T,Acc,Ys),!.    
remove_punct([H|T],Acc,Ys) :-
    remove_punct(T,[H|Acc],Ys).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Mustervergleich und Perspektive umkehren                     %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Mustervergleich
% pat_match\5 führt einen Mustervergleich durch,
% indem ermittel wird, ob ein Muster in der Eingabe vorhanden ist,
% und dann die Variable(n) im Pattern instanziiert
pat_match(Input,Patterns,Keywords,Addition,Instance) :-
    member(Pattern,Patterns),  % mögliche Patterns durchgehen
    sublist(Pattern,Input),!,  % Pattern im Input suchen
    member(Keyword,Keywords),  % Keyword in Kandidaten suchen
    nth0(N,Input,Keyword),     % Position von Keyword ermitteln
    N1 is N+Addition,          % Position der Variable
    drop(Input,N1,Instance).   % Variable instanziieren

% drop(List,Pos,SublistFromPos)
drop(Xs,N,Ys) :- drop(Xs,0,N,Ys). % Aufzählen initialisieren
drop(Xs,N,N,Xs).                  % Abbruch
drop([_|Xs],C,N,Ys) :- C < N, C1 is C+1, drop(Xs,C1,N,Ys).

% sublist(?Subliste,?Liste) % Vorlesungsskript Bespiel 5c
sublist(Sub,L) :- append(Pre,_,L), append(_,Sub,Pre).

%%%% Perspektive umkehren
% viewpoint(InputList,OutputList)
viewpoint(InputList,OutputList) :-
    viewpoint(InputList,[],OutputList), % Endrekursion initialisieren
    !. 		                            % viewpoint\3 nur 1-mal ausführen

viewpoint([],Acc,OutputList) :- reverse(Acc,OutputList). % Abbruch

% 1. Person zur 2. Person
viewpoint(['I'|Rest],Acc,OutputList) :-   % 'I' durch 'you' ersetzen
    viewpoint(Rest,[you|Acc],OutputList).
viewpoint([am|Rest],Acc,OutputList) :-    % 'am' durch 'are' ersetzen
    viewpoint(Rest,[are|Acc],OutputList).
viewpoint(['I',was|Rest],Acc,OutputList) :-    % 'I was' durch
    viewpoint(Rest,[were,you|Acc],OutputList). % 'you were' ersetzen
viewpoint([my|Rest],Acc,OutputList) :-    % 'my' durch 'your' ersetzen
    viewpoint(Rest,[your|Acc],OutputList).
viewpoint([me|Rest],Acc,OutputList) :-    % 'me' durch 'you' ersetzen
    viewpoint(Rest,[you|Acc],OutputList).
viewpoint([mine|Rest],Acc,OutputList) :-  % 'mine' durch 'yours' ersetzen
    viewpoint(Rest,[yours|Acc],OutputList).

% 2. Person zur 1. Person
viewpoint([Conj,you,are|Rest],Acc,OutputList) :-  
    check_conj(Conj), % 'you are' nach Konj. durch 'I am' ersetzen
    viewpoint(Rest,[am,'I',Conj|Acc],OutputList).
viewpoint([Conj,you,were|Rest],Acc,OutputList) :-  
    check_conj(Conj), % 'you were' nach Konj. durch 'I was' ersetzen
    viewpoint(Rest,[was,'I',Conj|Acc],OutputList).
viewpoint([Conj,you,Word|Rest],Acc,OutputList) :-  
    check_conj(Conj),                     % 'you' durch 'I' ersetzen
    not(member(Word,[are,were])),
    viewpoint(Rest,[Word,'I',Conj|Acc],OutputList).
viewpoint([you|Rest],Acc,OutputList) :-   % 'you' durch 'me' ersetzen
    viewpoint(Rest,[me|Acc],OutputList).
viewpoint([your|Rest],Acc,OutputList) :-  % 'your' durch 'my' ersetzen
    viewpoint(Rest,[my|Acc],OutputList).
viewpoint([yours|Rest],Acc,OutputList) :- % 'yours' durch 'mine' ersetzen
    viewpoint(Rest,[mine|Acc],OutputList).
    
viewpoint([Word|Rest],Acc,OutputList) :-  % sonst keine Änderung
    viewpoint(Rest,[Word|Acc],OutputList).

check_conj(Word) :-
    member(
        Word,
        [that,if,whether,while,why,when,whenever,where,wherever,what,
         whatever,which,whichever,whom,who,whoever,how,though,altough,
         unless,till,until,since,because,whereas,do,
         may,'May',might,'Might',will,'Will',would,'Would',must,'Must',
         can,'Can',could,'Could',should,'Should',shall,'Shall']).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Regeln aufstellen                                            %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
Die Regeln basieren auf den Lehrmaterialien des Moduls 
SE3 Funktionale Programmierung WiSe 2018/2019 an der UHH
von Prof. Dr. Leonie Dreschler-Fischer.

Um flexiblere Gespräche zu ermöglichen, werden die Regeln nicht als
Fakten aufgestellt. Stattdessen variiert der Mustervergleich von Regel
zu Regel.
*/

rule(Input,Response) :-  
    member(Input,[['Hello'|_],
                  ['Hi'|_],
                  ['How',do,you,do|_]]),
    random_member(
        Response, % Reaktion zufällig auswählen
        [['How do you do? Please state your problem.']]).

rule(Input,Response) :- 
	member(Word,[computer,computers]),
    member(Word,Input),!,
	random_member(
    	Response, % Reaktion zufällig auswählen
        [['Do computers worry you?'],
         ['What do you think about machines?'],
         ['Why do you mention computers?'],
         ['Waht do you think machines have to do with your problem?']]).        

rule(Input,Response) :- 
    member(Word,[name,names]),
	member(Word,Input),!,
	random_member(
    	Response, % Reaktion zufällig auswählen
        [['I am not interest in names.']]).        

rule(Input,Response) :- 
	member(Word,[sorry,'Sorry']),
    member(Word,Input),!,
	random_member(
    	Response, % Reaktion zufällig auswählen
        [['Please do not apologize.'],
         ['Apologies are not necessary.'],
         ['What feelings do you have when you apologize?']]).        

rule(Input,Response) :- 
    pat_match(Input,[['I',remember,that],
                     ['I',_,remember,that],
                     ['I',recall,that],
                     ['I',_,recall,that]],[remember,recall],1,X),
    viewpoint(X,Y),
	random_member(
    	Response, % Reaktion zufällig auswählen
        [['What else do you remember?'],
         ['Why do you recall',Y,'right now?']]).        

rule(Input,Response) :- 
    pat_match(Input,[['I',remember],
                     ['I',_,remember],
                     ['I',recall],
                     ['I',_,recall]],[remember,recall],1,X),
    viewpoint(X,Y),
	random_member(
    	Response, % Reaktion zufällig auswählen
        [['Do you often think of',Y,'?'],
         ['Does thinking of',Y,'bring you anything else to mind?'],
         ['What in the present situation reminds you of',Y,'?'],
         ['What is the connection between me and',Y,'?']]).        

rule(Input,Response) :- 
    pat_match(Input,[['Do',you,remember,that],
                     ['Dont',you,remember,that],
                     ['Do',you,recall,that],
                     ['Dont',you,recall,that]],[remember,recall],1,X),
    viewpoint(X,Y),
	random_member(
    	Response, % Reaktion zufällig auswählen
        [['Did you think I would forget',Y,'?'],
         ['Why do you think I should recall',Y,'now?']]).        

rule(Input,Response) :- 
    pat_match(Input,[['Do',you,remember],['Dont',you,remember],
                     ['Do',you,recall],['Dont',you,recall]],
             [remember,recall],1,X),
    viewpoint(X,Y),
	random_member(
    	Response, % Reaktion zufällig auswählen
        [['What about',Y,'?'],
         ['You mentioned',Y,'.']]).        

rule(Input,Response) :- 
    pat_match(Input,[[if],[whether]],[if,whether],2,X),
    viewpoint(X,[_|Y]),
	random_member(
    	Response, % Reaktion zufällig auswählen
        [['Do you really think it is likely that',Y,'?'],
         ['Do you wish that',Y,'?'],
         ['What do you think about that',Y,'?'],
         ['Really -- if',Y,'?']]).        

rule(Input,Response) :-
    member(Sub,[[my,mother],['My',mother],[my,mom],['My',mom]]),
    sublist(Sub,Input),!, % 'my mother' in der Eingabe
    random_member(
        Response, % Reaktion zufällig auswählen
        [['Who else in your family?'],
         ['Tell me more about your family.']]).
 
rule(Input,Response) :- 
    member(Sub,[[my,father],['My',father]]),
    sublist(Sub,Input),!, % 'my father' in der Eingabe
    random_member(
        Response, % Reaktion zufällig auswählen
        [['Does he influence you strongly?'],
         ['What else comes to mind when you think of your father?']]).

rule(Input,Response) :-  
    pat_match(Input,[['I',dreamt],['I',_,dreamt],['I',kept,dreaming]],
              [dreamt,dreaming],1,X),
    viewpoint(X,Y),
    random_member(
        Response, % Reaktion zufällig auswählen
        [['Really -- ',Y,'?'],
         ['Have you ever fantasized',Y,'while you are awake?'],
         ['Have you ever dreamt',Y,'?']]).

rule(Input,Response) :-  
    pat_match(Input,[[dream,about],[dream,of],[dream,_,about]],
              [dream],2,X),
    viewpoint(X,Y),
    random_member(
        Response, % Reaktion zufällig auswählen
        [['How do you feel about',Y,'in reality?']]).

rule(Input,Response) :-  
    member(dream,Input),!,
    random_member(
        Response, % Reaktion zufällig auswählen
        [['What does dream suggest to you?'],
         ['Do you dream often?'],
         ['What persons appear in your dream?'],
         ['Do you believe that dream has to do with your problem?']]).

rule(Input,Response) :-  
    pat_match(Input,[['I',want],['I',_,want],
                     ['I',wanted],['I',_,wanted],
                     ['I',need],['I',_,need],
                     ['I',needed],['I',_,needed]],
             [want,wanted,need,needed],1,X),
    viewpoint(X,Y),
    random_member(
        Response, % Reaktion zufällig auswählen
        [['What would it mean if you got',Y,'?'],
         ['Why do you want',Y,'?'],
         ['Supose you got',Y,'soon.']]).

rule(Input,Response) :-  
    pat_match(Input,[['I',_,glad],['I',_,_,glad]],[glad],1,X),
    viewpoint(X,Y),
    random_member(
        Response, % Reaktion zufällig auswählen
        [['How have I helped you be happy',Y,'?'],
         ['What makes you happy just now',Y,'?'],
         ['Can you explain why you are suddenly happy',Y,'?']]).

rule(Input,Response) :-  
    member(sad,Input),!,
    random_member(
        Response, % Reaktion zufällig auswählen
        [['I am sorry to hear you are depressed.'],
         ['I am sure it is not pleasant to be sad.']]).

rule(Input,Response) :-  
    pat_match(Input,[[are,like],[are,_,like],[are,the,same,as],
                     [are,_,the,same,as]],[like,as],1,X),
    nth0(N,Input,are),
    N1 is N-1,
    nth0(N1,Input,Z),
    downcase_atom(Z,Y),
    random_member(
        Response, % Reaktion zufällig auswählen
        [['What resemblance do you see between',Y,'and',X,'?'],
         ['What other connections do you see?']]).

rule(Input,Response) :-  
    pat_match(Input,[['is',like],['is',_,like],['is',the,same,as],
                     ['is',_,the,same,as]],[like,as],1,X),
    nth0(N,Input,'is'),
    N1 is N-1,
    nth0(N1,Input,Z),
    downcase_atom(Z,Y),
    random_member(
        Response, % Reaktion zufällig auswählen
        [['In what way is it that',Y,'is like',X,'?'],
         ['What resemblance do you see?'],
         ['Could there realy be some connection?'],
         ['How?']]).

rule(Input,Response) :-  
    member(alike,Input),!,
    random_member(
        Response, % Reaktion zufällig auswählen
        [['In what way?'],
         ['What similarities are there?']]).

rule(Input,Response) :-
    pat_match(Input,[['Who',am,'I'],[who,'I',am],[who,'I',was],
                     [who,'I',_,am],[who,'I',_,was]],[am,was],1,_),
    random_member(
        Response, % Reaktion zufällig auswählen
        [['Why do you say \'am\'?'],
         ['I do not understand that.']]).

rule(Input,Response) :-  
    pat_match(Input,[['I',was],['I',_,was]],[was],1,X),
    viewpoint(X,Y),
    random_member(
        Response, % Reaktion zufällig auswählen
        [['Were you really',Y,'?'],
         ['Perhaps I already knew why you were',Y,'.'],
         ['Why do you tell me you were',Y,'now?']]).

rule(Input,Response) :-  
    pat_match(Input,[[was,'I'],['Was','I']],['I'],1,X),
    viewpoint(X,Y),
    random_member(
        Response, % Reaktion zufällig auswählen
        [['What if you were',Y,'?'],
         ['Do you think you were',Y,'?'],
         ['What would it mean that you were',Y,'?']]).

rule(Input,Response) :-  
    pat_match(Input,[['I',am],['I',_,am]],['am'],1,X),
    viewpoint(X,Y),
    random_member(
        Response, % Reaktion zufällig auswählen
        [['In what way are you',Y,'?'],
         ['Do you want to be',Y,'?']]).

rule(Input,Response) :-  
    pat_match(Input,[[am,'I'],['Am','I']],['I'],1,X),
    viewpoint(X,Y),
    random_member(
        Response, % Reaktion zufällig auswählen
        [['Do you believe you are',Y,'?'],
         ['Would you want to be',Y,'?'],
         ['You wish I would tell you you are',Y,'?']]).

rule(Input,Response) :-  
    pat_match(Input,[[are,you],['Are',you]],[you],1,X),
    viewpoint(X,Y),
    random_member(
        Response, % Reaktion zufällig auswählen
        [['Why are you interested in whether I am',Y,'or not?'],
         ['Would you prefer if I were not',Y,'?'],
         ['Perhaps I am',Y,'in your fantasies.']]).

rule(Input,Response) :-  
    pat_match(Input,[[you,are],['You',are]],[are],1,X),
    viewpoint(X,Y),
    random_member(
        Response, % Reaktion zufällig auswählen
        [['What makes you think I am',Y,'?']]).

rule(Input,Response) :-  
    member(because,Input),!,
    random_member(
        Response, % Reaktion zufällig auswählen
        [['Is that the real reason?'],
         ['What other reasons might there be?'],
         ['Does that reason seem to explain anything else?']]).

rule(Input,Response) :-  
    pat_match(Input,[[were,you],['Were',you]],[you],1,X),
    viewpoint(X,Y),
    random_member(
        Response, % Reaktion zufällig auswählen
        [['Perhaps I was',Y,'.'],
         ['What do you think?'],
         ['What if I had been',Y,'?']]).

rule(Input,Response) :-  
    pat_match(Input,[['I',cannot],['I',can,not]],[cannot,not],1,X),
    viewpoint(X,Y),
    random_member(
        Response, % Reaktion zufällig auswählen
        [['Maybe you could',Y,'now.'],
         ['What if you could',Y,'?']]).

rule(Input,Response) :-  
    pat_match(Input,[['I',feel],['I',felt],['I',_,feel],
                     ['I',_,felt]],[feel,felt],1,X),
    viewpoint(X,Y),
    random_member(
        Response, % Reaktion zufällig auswählen
        [['Do you often feel',Y,'?'],
         ['What other feelings do you have?']]).

rule(Input,Response) :-  
    pat_match(Input,[['I',_,you]],[you],-1,X),
    nth0(0,X,Y),
    random_member(
        Response, % Reaktion zufällig auswählen
        [['Perhaps in you fantasy we',Y,'each other.']]).

rule(Input,Response) :-  
    pat_match(Input,[[why,dont,you],['Why',dont,you]],[you],1,X),
    viewpoint(X,Y),
    random_member(
        Response, % Reaktion zufällig auswählen
        [['Shouldnt you',Y,'yourself?'],
         ['Do you believe I do not',Y,'?'],
         ['Perhaps I will',Y,'in good time.']]).

rule(Input,Response) :-
    member(X,[yes,'Yes']),
    member(X,Input),!,
    random_member(
        Response, % Reaktion zufällig auswählen
        [['You seem quite postive.'],
         ['You are sure.'],
         ['I understand.']]).

rule(Input,Response) :-
    member(X,[no,'No']),
    member(X,Input),!,
    random_member(
        Response, % Reaktion zufällig auswählen
        [['Why not?'],
         ['You are being a bit negative.'],
         ['Are you saying \'no\' just to be negative?']]).

rule(Input,Response) :-
    member(X,[someone,'Someone',somebody,'Somebody',
              something,'Something']),
    member(X,Input),!,
    random_member(
        Response, % Reaktion zufällig auswählen
        [['Can you be more specific?']]).

rule(Input,Response) :-
    member(X,[everyone,'Everyone',everybody,'Everybody']),
    member(X,Input),!,
    random_member(
        Response, % Reaktion zufällig auswählen
        [['Surely not everyone.'],
         ['Can you think of anyone in particular?'],
         ['Who for example?'],
         ['You are thinking of a special person, right?']]).

rule(Input,Response) :-
    member(X,[always,'Always']),
    member(X,Input),!,
    random_member(
        Response, % Reaktion zufällig auswählen
        [['Can you think of a specific example?'],
         ['When?'],
         ['What incident are you thinking of?'],
         ['Really -- always?']]).

rule(Input,Response) :-
    member(X,[what,'What']),
    member(X,Input),!,
    random_member(
        Response, % Reaktion zufällig auswählen
        [['Why do you ask?'],
         ['Does that question interest you?'],
         ['What is it you really want to know?'],
         ['What do you think?'],
         ['What comes to your mind when you ask that?']]).

rule(Input,Response) :-
    member(X,[perhaps,'Perhaps']),
    member(X,Input),!,
    random_member(
        Response, % Reaktion zufällig auswählen
        [['You do not seem quite certain.']]).

rule(Input,Response) :-  
    pat_match(Input,[[are],['Are']],[are,'Are'],1,X),
    viewpoint(X,Y),
    random_member(
        Response, % Reaktion zufällig auswählen
        [['Did you think they might not be',Y,'?'],
         ['Possibly they are',Y,'.']]).

rule(_,Response) :- % kein vorhandes Muster in Eingabe gefunden
    random_member(
        Response, % Reaktion zufällig auswählen
        [['Very interesting!'],
         ['I am not sure I understand you fully.'],
         ['What does that suggest to you?'],
         ['Please continue.'],
         ['Go on.'],
         ['Do you feel strongly about discussing such things?']]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Testfälle durchführen                                        %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Die Eingabesätze in den Testfällen stammen aus den Lehrmaterialien
% des Moduls SE3 Funktionale Programmierung WiSe 2018/2019 an der UHH
% von Prof. Dr. Leonie Dreschler-Fischer.

% Im 1. Test sind die Eingabesätze Teil des damaligen Gesprächs mit
% Eliza, ein Programm von Joseph Weizenbaum.

/*
?- chatbot.

WELCOME to Chat-Bot!

INPUT FORMAT
	Each input is a simple sentence, phrase, or a word.
	Please submit the input in single quotation marks.
	Capitalize the first word of the input sentence.
	For instance, 'Hello there!' is a valid input.
	'I dont have money.' is also a valid input.

	Do not forget the period to submit an input!

PUNCTUATION
	Four punctuation marks are allowed in the input.
	Theses are ',', '.', '!', and '?'.

GOODBYE
	Submit 'Bye' to end the dialog.

|: 'Men are all alike.'.
What similarities are there?

|: 'They are always bugging us abou something or another.'.
Can you be more specific?

|: 'Well, my boyfriend make me come here.'.
Very interesting!

|: 'He says I am depressed much of the time.'.
Do you want to be depressed much of the time ?

|: 'It is true. I am unhappy.'.
Do you want to be unhappy ?

|: 'I need some help. That much is certain.'.
Why do you want some help That much is certain ?

|: 'Perhaps I could learn to get along with my mother.'.
Who else in your family?

|: 'Bye'.

true.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
?- chatbot.

WELCOME to Chat-Bot!

INPUT FORMAT
	Each input is a simple sentence, phrase, or a word.
	Please submit the input in single quotation marks.
	Capitalize the first word of the input sentence.
	For instance, 'Hello there!' is a valid input.
	'I dont have money.' is also a valid input.

	Do not forget the period to submit an input!

PUNCTUATION
	Four punctuation marks are allowed in the input.
	Theses are ',', '.', '!', and '?'.

GOODBYE
	Submit 'Bye' to end the dialog.

|: 'Hello there!'.
How do you do? Please state your problem.

|: 'I want to test this program.'.
Supose you got to test this program soon.

|: 'I could see if it works.'.
What do you think about that ?

|: 'No, not really.'.
Why not?

|: 'No.'.
Why not?

|: 'Forget it. I was wondering how general the program is.'.
Why do you tell me you were wondering how general the program is now?

|: 'I felt like it.'.
Do you often feel like it ?

|: 'I feel this is enough.'.
Do you often feel this is enough ?

|: 'Bye'.

true.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
?- chatbot.

WELCOME to Chat-Bot!

INPUT FORMAT
	Each input is a simple sentence, phrase, or a word.
	Please submit the input in single quotation marks.
	Capitalize the first word of the input sentence.
	For instance, 'Hello there!' is a valid input.
	'I dont have money.' is also a valid input.

	Do not forget the period to submit an input!

PUNCTUATION
	Four punctuation marks are allowed in the input.
	Theses are ',', '.', '!', and '?'.

GOODBYE
	Submit 'Bye' to end the dialog.

|: 'Hello, I am Max Mustermann.'.
How do you do? Please state your problem.

|: 'Would you please introduce yourself?'.
Very interesting!

|: 'To be, or not to be, that is the question.'.
Very interesting!

|: 'Please tell me, who you are.'
|: .
What makes you think I am ?

|: 'I think, therefore I am.'.
Do you want to be ?

|: 'Whence are we, and why are we?'.
Did you think they might not be we and why are we ?

|: 'I have a dream.'.
Do you believe that dream has to do with your problem?

|: 'The quick Dreams, the passion winged ministers of Thought.'.
Very interesting!

|: 'Martin Luther King said that one day this nation will rise up, live out the true meaning of its creed.'.
Very interesting!

|: 'All animals are equal, but some are more equal than others.'.
Did you think they might not be equal but some are more equal than others ?

|: 'From each according to his abilities to each according to his needs.'.
Very interesting!

|: 'According to Karl Marx, the history of all hitherto existing society is the history of class struggle.'.
I am not sure I understand you fully.

|: 'A riot is at bottom the language of the unheard, again from M.L.K.'.
Please continue.

|: 'I think the necessity of being ready increases. Look to it. It was A. Lincoln.'.
Do you feel strongly about discussing such things?

|: 'The ballot is sronger than the bullet. Again from Abraham Lincoln.'.
Please continue.

|: 'The philosophers have only interpreted the world in various ways. The point is to change it.'.
Please continue.

|: 'You have not a single clue what I am talking about, do you?'.
In what way are you talking about do me ?

|: 'You can fool all the people some of the time and some people all the time, but you cannot fool all the people all the time.'.
What does that suggest to you?

|: 'Dear Chat-Bot, you are the one fixed point in a changing age.'.
What makes you think I am the one fixed point in a changing age ?

|: 'You see but you do not observe.'.
I am not sure I understand you fully.

|: 'Computers are useless. Picasso said that they can only give you answers. You dont even give answers.'.
Did you think they might not be useless Picasso said that they can only give me answers You dont even give answers ?

|: 'Are you a parrot?'
|: .
Perhaps I am a parrot in your fantasies.

|: 'There is but one step from the grotesque to the horrible, according to Conan Doyle.'.
Go on.

|: 'And now for something completely different. Let us talk about science.'.
Can you be more specific?

|: 'You know who critics are? The men who failed in literature and art.'.
Possibly they are The men who failed in literature and art .

|: 'Silly question.'.
Go on.

|: 'What do you think about statistics?'.
Does that question interest you?

|: 'There are three kinds of lies. Lies, damned lies, and statistics, so Disraeli.'.
Did you think they might not be three kinds of lies Lies damned lies and statistics so Disraeli ?

|: 'No, not really.'.
Are you saying 'no' just to be negative?

|: 'I never deny, I never contradict, I sometimes forget.'.
Go on.

|: 'Ich bin der Geist, der stets verneint.'.
Very interesting!

|: 'Why dont you pay attention? I believe you dont understand a single word I am saying.'.
Do you want to be saying ?

|: 'Be not faithless but believing.'.
I am not sure I understand you fully.

|: 'Believing where we cannot prove.'.
Very interesting!

|: 'To burn always with this hard, gemlike flame, to maintain this ecstasy, is success in life. Quote from Walter Pater.'.
Can you think of a specific example?

|: 'I pant, I sink, I tremble, I expire!'.
I am not sure I understand you fully.

|: 'Always look at the bright side of life.'.
Can you think of a specific example?

|: 'I never had a piece of toast partcularly long and wide, but fell upon the sanded floor, and always on the buttered side.'.
Can you think of a specific example?

|: 'As I said, always.'.
Can you think of a specific example?

|: 'I always have a uotation ready. It saves original thinking.'.
When?

|: 'Dont think twice. It is all right. Just forget it.'.
I am not sure I understand you fully.

|: 'And may there be no sadness of farewell. Good night.'.
Are you saying 'no' just to be negative?

|: 'Bye'.

true.
*/
