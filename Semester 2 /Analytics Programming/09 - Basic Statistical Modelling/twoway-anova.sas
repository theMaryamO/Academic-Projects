proc format;
	value size 
		1 = 'small' 
		2 = 'large'
	;
	value design 
		1 = 'a' 
		2 = 'b' 
		3 = 'c'
	;
run;

data advert;
	infile datalines;
	input 
		size 
		design 
		requests 
		@@
	;
format 
	size size. 
	design design.
	;
label
	size = 'Size of design'
	design = 'Catalog requests'
	;
datalines;
1 1 9 1 1 13 1 1 12
1 2 22 1 2 14 1 2 17
1 3 10 1 3 18 1 3 12
2 1 13 2 1 9 2 1 13
2 2 25 2 2 29 2 2 24
2 3 18 2 3 14 2 3 14
;
run;

/* calculate the data needed for the profile plot */
proc means 
	data= advert
	;
	var requests;
	by size design;
	output out=means mean=mean;
run;

/* create a profile plot */
proc gplot 
	data=means;
	plot mean*size=design
		/ 	vaxis = 0 to 30 by 5
	;
 	symbol i=join;
run;

proc glm 
	data= advert;
 	class design size;
 	model requests=design size design*size; /* includes interaction */
 	lsmeans design size design*size;
 	output out=interact p=predicted r=residual;
run;

proc glm 
	data= advert;
 	class design size;
 	model requests=design size; /* excludes interaction */
 	means design /lsd;
 	means size /lsd;
 	output out=nointeract p=predicted r=residual;
run;

/* if you use proc glm alone, the program does not terminate so use 'quit;' here */

proc univariate 
	data=nointeract;
	var residual;
 	histogram /normal;
 	qqplot /normal(mu=est sigma=est);
run;
