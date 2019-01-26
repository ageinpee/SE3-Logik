/*
SE3LP-18W-A09
Namen: Chung-Shan Kao, Harm Matthias Harms, Henrik Peters
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                              %%%%
%%%% Aufgabe 1: Wertesemantik                                     %%%%
%%%%                                                              %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
%%%% 1.
(list (cdr (cdr (cdr (quote (1 2 3 4)))))
      (car (cdr (quote (1 2 3 4)))))
      (cdr (cdr (cdr (quote (1 2 3 4)))))
           (cdr (cdr (quote (1 2 3 4))))
                (cdr (quote (1 2 3 4)))
                     (quote (1 2 3 4))
                     ==> (1 2 3 4)
                ==> (2 3 4)
           ==> (3 4)
      ==> (4)
      (car (cdr (quote (1 2 3 4))))
           (cdr (quote (1 2 3 4)))
                (quote (1 2 3 4))
                ==> (1 2 3 4)
           ==> (2 3 4)
      ==> 2
==> ((4) 2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 2.
(if (< (car (quote (5 -3 4 -2))) 0) 0 1)
    (< (car (quote (5 -3 4 -2))) 0)
       (car (quote (5 -3 4 -2)))
            (quote (5 -3 4 -2))
            ==> (5 -3 4 -2)
       ==> 5
    ==> #f
==> 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 3.
(cons (cdr (quote (1 . 2))) (cdr (quote (1 2 . 3))))
      (cdr (quote (1 . 2)))
           (quote (1 . 2))
           ==> (1 . 2)
      ==> 2
                            (cdr (quote (1 2 . 3)))
                                 (quote (1 2 . 3))
                                 ==> (1 2 . 3)
                            ==> (2 . 3)
==> (2 2 . 3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 4.
(map (lambda (x) (if (pair? x) (cdr x) x))
     (quote (lambda (x) (if (pair? x) (cdr x) x))))
     (quote (lambda (x) (if (pair? x) (cdr x) x)))
     ==> (lambda (x) (if (pair? x) (cdr x) x))
==> (lambda () ((pair? x) (cdr x) x))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 5.
(filter (curry < 5) (reverse (quote (1 3 5 7 9))))
                    (reverse (quote (1 3 5 7 9)))
                             (quote (1 3 5 7 9))
                             ==> (1 3 5 7 9)
                    ==> (9 7 5 3 1)
==> (9 7)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 6.
(filter (compose negative? (lambda (x) (- x 5))) (quote (1 3 5 7 9)))
                 negative? (lambda (x) (- x 5))  (quote (1 3 5 7 9))
                           (lambda (x) (- x 5))  (quote (1 3 5 7 9))
                                                 (quote (1 3 5 7 9))
                                                 ==> (1 3 5 7 9)
                           ==> (-4 -2 0 2 4)
                 ==> (#t #t #f #f #f)
==> (1 3)
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                              %%%%
%%%% Aufgabe 2: Programmverstehen                                 %%%%
%%%%                                                              %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% 1.
% Ermittelt, ob Liste x eine Teilsequenz (Unterbrechungen erlaubt) 
% von Liste y ist
/*
(define (foo1 x y)
  (if (null? x)
      #t
      (if (null? y)
          #f
          (if (eq? (car x) (car y))
              (foo1 (cdr x) (cdr y))
              (foo1 x (cdr y))))))
              
(foo1 '(2 3 4 6) '(1 2 3 4 5 6 7)) ==> #t
(foo1 '(2 3 4 4) '(1 2 3 4 5 6 7)) ==> #f
(foo1 '(2 3 4 8) '(1 2 3 4 5 6 7)) ==> #f
(foo1 '(2 3 6 4) '(1 2 3 4 5 6 7)) ==> #f
*/

%% foo1(+ListeX,+ListeY)
foo1([],_).
foo1([EX|X],[EY|Y]) :- EX = EY -> foo1(X,Y); foo1([EX|X],Y).

/*
?- foo1([2,3,4,6],[1,2,3,4,5,6,7]).
true.

?- foo1([2,3,4,4],[1,2,3,4,5,6,7]).
false.

?- foo1([2,3,4,8],[1,2,3,4,5,6,7]).
false.

?- foo1([2,3,6,4],[1,2,3,4,5,6,7]).
false.


%% Vergleich

Hinsichtlich der Abbruchbedingung für die Rekursion muss bei der 
Funktion foo1 zwischen positiven Fällen (null? x) und negativen Fällen 
(null? y) unterschieden werden. Im Gegensatz dazu benötigt das 
Prädikat foo1/2 lediglich eine Abbruchbedingung  foo1([],_) für 
positive Fälle.

Des Weiteren verhält sich das Prädikat foo1/2 zwar so wie die Funktion 
foo1. Allerdings bleibt mit solcher Implementierung nur noch eine 
sinnvolle Instanziierungsvariante übrig, näml. foo1(+ListeX,+ListeY). 

Eine alternative Implementierung sieht so aus:
    foo1([],_).
    foo1([E|X],[E|Y]) :- foo1(X,Y), !.
    foo1(X,[_|Y]) :- foo1(X,Y).
Mit cut ! in der 2. Klausel beschränkt sich die Instanziierungs-
variation immer noch auf foo1(+ListeX,+ListeY). Ohne cut ! in der 2.
Klausel sind dann alle Instanziierungsvarianten anwendbar.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 2.
% Sucht Elemente aus Liste x aus, die Liste y nicht hat, und 
% kombiniert in einer Ergebnisliste diese Elemente mit Liste y
/*
(define (foo2 x y)
  (if (null? x)
      y
      (if (member (car x) y)
          (foo2 (cdr x) y)
          (cons (car x) (foo2 (cdr x) y)))))
          
(foo2 '(1 2 3 4 5 6 7) '(2 4 6)) ==> '(1 3 5 7 2 4 6)          
*/

%% foo2(+ListeX,+ListeY,?ErgebnisZ)
foo2([],Y,Y).
foo2([E|X],Y,Z) :- member(E,Y), foo2(X,Y,Z), !.
foo2([E|X],Y,[E|Z]) :- foo2(X,Y,Z).
/*
?- foo2([1,2,3,4,5,6,7],[2,4,6],Z).
Z = [1, 3, 5, 7, 2, 4, 6].


%% Vergleich 

Damit sich das Prädikat foo2/3 so verhält wie die Funktion foo2, sind
zwei Anpassungen nötig: 

(a) Neben zwei Listen X und Y als Argumente
wird ein drittes Argument für Zwischenergebnisse und das Endergebnis
benötigt. 

(b) Ein cut ! muss in der 2. Klausel eingesetzt werden. Ohne cut ! in
der 2. Klausel ist in der 3. Klausel not(member(E,Y)) explizit zu 
spezifizieren.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 3.
% Sucht Elemente aus Liste x aus, die Liste y nicht hat
/*
(define (foo3 x y)
  (if (null? x)
      (quote ())
      (if (member (car x) y)
          (foo3 (cdr x) y)
          (cons (car x) (foo3 (cdr x) y)))))
          
(foo3 '(1 2 3 4 5 6 7) '(2 4 6)) ==> '(1 3 5 7)
*/

%% foo3(+ListeX,+ListeY,?ErgebnisZ)
foo3([],_,[]).
foo3([E|X],Y,Z) :- member(E,Y), foo3(X,Y,Z), !.
foo3([E|X],Y,[E|Z]) :- foo3(X,Y,Z).
/*
?- foo3([1,2,3,4,5,6,7],[2,4,6],Z).
Z = [1, 3, 5, 7].


%% Vergleich 

Die Funktionen foo2 und foo3 unterscheiden sich lediglich in der 
Rückgabe beim Abbruch der Rekursion, nämlich Liste y in foo2 und '()
in foo3.

Analog unterschieden sich die Prädikate foo2/3 und foo3/3 auch nur
in der Rückgabe beim Abbruch der Rekursion, nämlich Y in foo2/3 und
[] in foo3/3.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 4.
% Bestimmt das max. Element in Liste x
/*
(define (foo4 x)
  (letrec
      ((foo4a (lambda (x y)
                (if (null? x) y
                    (if (> (car x) y)
                        (foo4a (cdr x) (car x))
                        (foo4a (cdr x) y))))))
    (foo4a (cdr x) (car x))))
    
(foo4 '(1 3 5 7 2 4 6)) ==> 7
*/

%% foo4(+ListeX,?MaximumY)
foo4([E|X],Y) :- foo4a(X,E,Y).
foo4a([],Y,Y).
foo4a([E|X],Z,Y) :- E > Z -> foo4a(X,E,Y); foo4a(X,Z,Y).
/*
?- foo4([1,3,5,7,2,4,6],Y).
Y = 7.


%% Vergleich

Das Prädikat foo4/2 lässt sich komplett analog zur Funktion foo4 
implementieren. Das Stützprädikat foo4a/3 entspricht der Hilfsfunktion
foo4a in der Funktion foo4. Allerdings benötigt das Stützprädikat
foo4a/3 ein zusätzliches Argument für Zwischenergebnisse (nämlich der
max. Wert während der Rekursion) und das Endergebanis (also der max.
Wert in der ganzen Liste X).
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 5.
% Holt jeweils einen Vektor aus Liste x und Liste y heraus und
% berechnet das Skalarprodukt der zwei Vektoren
% (Wenn Liste x kürzer ist als Liste y, nimmt Liste y zu einem Vektor.
%  Der andere Vektor entsteht aus den ersten n Elementen von Liste y,
%  wobei n die Länge von Liste x ist. Analog, wenn Liste y kürzer als
%  Liste x ist.)
/*
(define (foo5 x y)
  (if (or (null? x) (null? y))
      0
      (+ (* (car x) (car y))
         (foo5 (cdr x) (cdr y)))))
         
(foo5 '(1 3 5 7) '(2 4 6)) ==> 44    ; 1*2 + 3*4 + 5*6 = 44
*/

%% foo5(+ListeX,+ListeY,?ErgebnisZ)
foo5([],_,0).
foo5(_,[],0).
foo5([EX|X],[EY|Y],Z) :- Z1 is EX*EY, foo5(X,Y,Z2), !, Z is Z1+Z2.
/*
?- foo5([1,3,5,7],[2,4,6],Z).
Z = 44.


%% Vergleich

Bei der Funktion foo5 dürfen Funktionen verschachtelt werden, wie z.B.
(+ (* (car x) (car y)) (foo5 (cdr x) (cdr y))). Beim Prädikat foo5/3
müssen die Schritte hintereinander implementiert werden, wie z.B. in
der 3. Klausel. Andererseits lassen sich die 1. und 2. Klausel von
foo5/3 so zusammenfassen: foo5(X,Y,0) :- X=[]; Y=[]. Dies ist vom
Aufbau her der Funktion foo5 ähnlicher.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                              %%%%
%%%% Aufgabe 3: Programmentwicklung                               %%%%
%%%%                                                              %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Repräsentation der Peano-Zahlen in den Reimplementationen
% {'(0), '(s (0)), '(s (s (0))), '(s (s (s (0)))), ...}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% lt(?Term1,?Term2)
lt(0,s(_)).
lt(s(X),s(Y)) :- lt(X,Y).
/*
(define (lt x y)
  (if (equal? y '(0)) #f
      (if (equal? x '(0)) #t
          (lt (cadr x) (cadr y)))))
          
(lt '(0)         '(s (0))     ) ==> #t
(lt '(0)         '(s (s (0))) ) ==> #t
(lt '(s (0))     '(s (s (0))) ) ==> #t
(lt '(0)         '(0)         ) ==> #f
(lt '(s (0))     '(0)         ) ==> #f
(lt '(s (s (0))) '(s (0))     ) ==> #f
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% add(?Summand1,?Summand2,?Summe)
add(0,X,X).
add(s(X),Y,s(R)) :- add(X,Y,R).
/*
(define (add x y)
  (cond [(equal? x '(0)) y]
        [(equal? y '(0)) x]
        [else (list (car x) (add (cadr x) y))]))

(add '(0)         '(0))     ==> '(0)
(add '(0)         '(s (0))) ==> '(s (0))
(add '(s (0))     '(0))     ==> '(s (0))
(add '(s (0))     '(s (0))) ==> '(s (s (0)))
(add '(s (s (0))) '(s (0))) ==> '(s (s (s (0))))
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% int2peano(+Integer,?Peano)
int2peano(0,0).
int2peano(N,s(P)) :- N > 0, N1 is N - 1, int2peano(N1,P), !.
/*
(define (int2peano N)
  (if (= N 0) '(0)
      (list 's (int2peano (- N 1)))))
      
(int2peano 0) ==> '(0)
(int2peano 4) ==> '(s (s (s (s (0)))))
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Vergleich
/*
% Richtungsunabhängigkeit geht bei den Reimplementationen in Scheme 
  verloren.
  
% Es ist so festgelegt worden, dass '(0) in den Reimplementationen die
  Peano-Zahl 0 repräsentiert. Für die Peano-Zahl 1 oder größer wird 
  das Symbol 's mit der vorherigen Zahl in eine Liste gepackt, z.B.
  '(s (0)), '(s (s (0))), '(s (s (s (0)))) usw. 
  
% Aufgrund der einzigen Unregelmäßigkeit bei der Repräsentation müssen
  Fälle mit '(0) immer gesondert behandelt werden. Beispielsweise 
  nimmt die Funktion lt zwei Argumente x und y. Sowohl Fälle mit
  (equal? x '(0)) als auch mit (equal? y '(0)) müssen gesondert
  behandelt werden.
  
% Die Funktion add benötigt lediglich zwei Summanden x und y. Ein 
  zusätzliches Argument für die Summe ist nicht nötig. Im Gegensatz 
  dazu braucht das Prädikat add/3 drei Terme: Summand1, Summand2 und 
  Summe.
  
% Bei der Funktion int2peano werden Funktionen verschachtelt, nämlich
  (list 's (int2peano (- N 1))). Die drei verschachtelten Funktionen
  müssen beim Prädikat int2peano/2 in drei Schritten hintereinander
  implementiert, also N > 0, N1 is N - 1, int2peano(N1,P).
*/

