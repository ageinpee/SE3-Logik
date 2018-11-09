
:- dynamic kategorie/3.        % ermoeglicht dynamische Veraenderung
%:- multifile kategorie/3.      % ermoeglicht verteilte Definition in mehreren Files

% kategorie(Id_Unterkategorie,Name_Unterkategorie,Id_Oberkategorie)
kategorie(1,buch,0).
kategorie(2,ebuch,0).
kategorie(3,hoerbuch,0).
kategorie(4,kinder,1).
kategorie(5,kinder,2).
kategorie(6,kinder,3).
kategorie(7,krimi,1).
kategorie(8,krimi,2).
kategorie(9,krimi,3).
kategorie(10,roman,1).
kategorie(11,roman,2).
kategorie(12,roman,3).
kategorie(13,sachbuch,1).
kategorie(14,sachbuch,2).
kategorie(15,bilderbuch,4).
kategorie(16,reisefuehrer,13).
kategorie(17,lexikon,13).
kategorie(18,lyrik,1).
kategorie(19,lyrik,3).
kategorie(20,bastelbuch,4).
kategorie(21,woerterbuch,13).

% produkt(PId,KId,Titel,Autor,Verlag,Jahr,Lagerbestand).
produkt(12345,10,sonnenuntergang,hoffmann_susanne,meister,2010,23).
produkt(12346,18,hoffnung,sand_molly,kasper,2015,319).
produkt(12347,7,winterzeit,wolf_michael,meister,2011,0).
produkt(12348,7,blutrache,wolf_michael,meister,2007,200).
produkt(12349,7,winterzeit,wolf_michael,meister,2015,100).

produkt(23456,11,sonnenuntergang,hoffmann_susanne,meister,2014,1).
produkt(23457,11,spuren_im_schnee,wolf_michael,meister,2014,1).
produkt(23458,8,blutrache,wolf_michael,meister,2015,1).

produkt(34567,19,hoffnung,sand_molly,audio,2016,51).
produkt(34568,9,winterzeit,wolf_michael,audio,2017,16).

% verkauft(PId,Jahr,Preis,Anzahl).
verkauft(12345,2010,24,391).
verkauft(12345,2011,24,129).
verkauft(12345,2012,24,270).
verkauft(12345,2013,24,350).
verkauft(12345,2014,24,168).
verkauft(12345,2015,24,89).
verkauft(12345,2016,24,30).
verkauft(12345,2017,24,2).
verkauft(12345,2018,12,22).
verkauft(12346,2015,19,45).
verkauft(12346,2016,19,137).
verkauft(12346,2017,14,83).
verkauft(12346,2018,14,97).
verkauft(12347,2011,39,71).
verkauft(12347,2012,39,23).
verkauft(12347,2013,39,11).
verkauft(12347,2014,29,15).
verkauft(12347,2015,29,17).
verkauft(12347,2016,29,9).
verkauft(12347,2017,23,8).
verkauft(12347,2018,23,5).
verkauft(12348,2007,29,430).
verkauft(12348,2008,34,380).
verkauft(12348,2009,39,137).
verkauft(12348,2010,39,24).
verkauft(12348,2011,39,0).
verkauft(12348,2012,39,0).
verkauft(12348,2013,29,0).
verkauft(12348,2014,29,0).
verkauft(12348,2015,29,0).
verkauft(12348,2016,19,0).
verkauft(12348,2017,9,0).
verkauft(12348,2018,2,0).
verkauft(12349,2015,29,412).
verkauft(12349,2016,29,257).
verkauft(12349,2017,29,12).
verkauft(12349,2018,17,213).

verkauft(23456,2014,13,0).
verkauft(23456,2015,13,1).
verkauft(23456,2016,13,3).
verkauft(23456,2017,13,2).
verkauft(23456,2018,13,0).
verkauft(23457,2014,13,1).
verkauft(23457,2015,13,2).
verkauft(23457,2016,13,1).
verkauft(23457,2017,2,70).
verkauft(23457,2018,2,5).
verkauft(23458,2015,13,12).
verkauft(23458,2016,13,21).
verkauft(23458,2017,13,13).
verkauft(23458,2018,13,19).

verkauft(34567,2016,21,52).
verkauft(34567,2017,21,39).
verkauft(34567,2018,21,45).
verkauft(34568,2017,3,23).
verkauft(34568,2018,3,2).


