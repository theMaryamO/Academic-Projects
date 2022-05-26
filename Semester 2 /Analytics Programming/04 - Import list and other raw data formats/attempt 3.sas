data header;
/*length id $ 16.;*/
infile datalines 
delimiter = '';
input id:& $ 17.
	  table
	  gender 
	  race
;
datalines;
Shola Awosolabiyi  42 2 2 
;
run;
