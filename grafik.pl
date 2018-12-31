% draw(+Size)
% draws a graphics with a given Size

draw(Size) :-
% define size of the display (picture size + scroll bar area)
SizeD is Size+20,
% create a new display and open it
new(Display,picture('*** Your picture''s name ***',size(SizeD,SizeD))),
send(Display,open),
send(Display,background,colour(black)), %* MK: ggf. Farbe auf 'white' stellen

% draw the object on the display
(
     draw_object(Display,Size,Size /* , ***add additional parameters if needed *** */);
     true
),
% if desired save the display as .jpg
write_ln('Save the graphics (y/n): '),
get_single_char(A),
put_code(A),nl,
(A=:=121 ->
  (write_ln('enter file name: '),
   read_line_to_codes(user_input,X),
   atom_codes(File,X),
   atom_concat(File,'.jpg',FileName),
   get(Display,image,Image),
   send(Image,save,FileName,jpeg) ) ; true ),

!.


% draw_object(Display,Size,CurrentSize,*** add additional parameters here, if needed ***)
% draws a gradient graphics of size Size into Display
% CurrentSize is decreased recursively fom Size to 0
draw_object(_,_,0 /* , *** add additional parameters here, if needed *** */). 
draw_object(Name,Size,CSize /* , *** add additional parameters here, if needed *** */) :- 
CSize > 0 ,        % only for positive integers

% *** insert the computation of graphical parameters here ***

% *** create and draw the current graphical object here ***

% *** send all additional parameters to the current graphical object ***

% decrement CurrentSize and call draw_object recursively
CSizeNew is CSize - 2,

% writeln(CSizeNew),
draw_object(Name,Size,CSizeNew).



% Call the program and see the result
:- draw( 400 ).   % specify the desired display size in pixel here (required argument)   




% ========== Tests from XPCE-guide Ch 5 ==========

% destroy objects
mkfree :-
free(@p),
free(@bo),
free(@ci),
free(@bm),
free(@tx),
free(@bz).

% create picture / window
mkp :-
new( @p , picture('Demo Picture') ) ,
send( @p , open ).

% generate objects in picture / window
mkbo :-
send( @p , display , new(@bo,box(100,100)) ).
mkci :-
send( @p , display , new(@ci,circle(50)) , point(25,25) ).
mkbm :-
send( @p , display , new(@bm,bitmap('32x32/books.xpm')) , point(100,100) ).
mktx :-
send( @p , display , new(@tx,text('Hello')) , point(120,50) ).
mkbz :-
send( @p , display , new(@bz,bezier_curve(
  point(50,100),point(120,132),point(50,160),point(120,200))) ).

% modify objects
mkboc :-
send( @bo , radius , 10 ).
mkcic :-
send( @ci , fill_pattern , colour(orange) ).
mktxc :-
send( @tx , font , font(times,bold,18) ).
mkbzc :-
send( @bz , arrows , both ).

