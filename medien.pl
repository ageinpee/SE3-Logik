
:- dynamic produkt/7, verkauft/4.        % ermoeglicht dynamische Veraenderung
%:- multifile produkt/7, verkauft/4.      % ermoeglicht verteilte Definition in mehreren Files

% produkt(PId,Kategorie,Titel,Autor,Verlag,Jahr,Lagerbestand).
produkt(12345,buch,sonnenuntergang,hoffmann_susanne,meister,2010,23).
produkt(12346,buch,hoffnung,sand_molly,kasper,2015,319).
produkt(12347,buch,winterzeit,wolf_michael,meister,2011,204).
produkt(12348,buch,blutrache,wolf_michael,meister,2007,0).
produkt(12349,buch,winterzeit,wolf_michael,meister,2015,100).

produkt(23456,ebuch,sonnenuntergang,hoffmann_susanne,meister,2014,1).
produkt(23457,ebuch,spuren_im_schnee,wolf_michael,meister,2014,1).
produkt(23458,ebuch,blutrache,wolf_michael,meister,2015,1).

produkt(34567,hoerbuch,hoffnung,sand_molly,audio,2016,51).
produkt(34568,hoerbuch,winterzeit,wolf_michael,audio,2017,16).

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

