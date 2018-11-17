:- multifile produkt/7.
:- multifile kategorie/3.
 
% Für A03.2.2, damit ein Produkt eine falsche Kategorie hat.
produkt(99999,9001,keine_kategorie,me,human,2020,9000).

%Für A03.2.2, damit eine Kategorie keine gültige ober Kategorie hat.
kategorie(9000, nicht_gueltige_oberkategorie, 8999).
%Für A03.2.4
kategorie(8999, erste_ober, 0).
kategorie(8999, zweite_ober, 0).