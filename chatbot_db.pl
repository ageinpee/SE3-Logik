/* SE3LP-18W-A07
  Namen: Chung-Shan Kao, Harm Matthias Harms, Henrik Peters
*/

/*========================*/
/*=== Chatbot Database ===*/
/*========================*/

%% rule(Pattern, Response)

rule([[hallo]],
     [[moin]]).
rule([[moin]],
     [[moin]]).
rule([[wie, isset, '?']],
     [[muss]]).
rule([[moin, moin]],
     [[laber, nicht, so, viel, '!']]).
rule([[ok]],
     [[ja, wat, ok, '?', mach, '!']]).
rule([[wie, war, dein], Event, ['?']],
     [[das], Event, [war, gut, '.', hattest, du auch,], Event, ['?']]).
rule([[wie, war, dein], Event, ['?']],
     [[das], Event, [war, gut, '.', was, gab, es, zu, essen, '?']]).
rule([[wie, war, dein], Event, ['?']],
     [[das], Event, [war, gut, '.', gab, es, geschenke, '?']]).
rule([[ja]],
     [[toll]]).
rule([[nein]],
     [[krise, bruder]]).
rule([[bruder, muss, los]],
     [[hade, bruder]]).
rule([[es, gab], Food],
     [[hui, '!'], Food, [ist, eine, meiner, leibspeisen]]).
rule([[ja, gab, es]],
     [[klasse, welche, geschenke, hast, du, denn, geKRIEGt, '?']]).
rule([[ja, ich, habe, ein], Geschenk, [bekommen]],
     [[das, klingt, so, als, haetten, dich, deine, eltern, nicht, lieb, '.',
       meinst, du, deine, eltern, haben, dich, lieb, '?']]).
rule([[ja, ich, habe, eine], Geschenk, [bekommen]],
     [[das, klingt, so, als, haetten, dich, deine, eltern, nicht, lieb, '.',
       meinst, du, deine, eltern, haben, dich, lieb, '?']]).
rule([[ja, ich, habe, einen], Geschenk, [bekommen]],
     [[das, klingt, so, als, haetten, dich, deine, eltern, nicht, lieb, '.',
       meinst, du, deine, eltern, haben, dich, lieb, '?']]).
%rule([],
%     []).
%rule([],
%     []).
%rule([],
%     []).
%rule([],
%     []).
%rule([],
%     []).
%rule([],
%     []).
%rule([],
%     []).
%rule([],
%     []).
%rule([],
%     []).
%rule([],
%     []).
%rule([],
%     []).
