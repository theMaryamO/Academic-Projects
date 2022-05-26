data amess1978;
	input
		ventilation
		folate
		@@
	;
	datalines;
 1 243 2 206 3 241
 1 251 2 210 3 258
 1 275 2 226 3 270
 1 291 2 249 3 293
 1 347 2 255 3 328
 1 354 2 273
 1 380 2 285
 1 392 2 295
 2 309
 	;
run;

proc means 
	data = amess1978 n mean std fw=5 maxdec=1 nonobs;
	class ventilation;
	var folate;
run;

proc univariate 
	data = amess1978;
	class ventilation;
	var folate;
	qqplot /normal(mu=est sigma=est);
	histogram /normal;
run;

proc sgplot
	data = amess1978;
	* scatter x=ventilation y=folate;
	vbox folate / group=ventilation;
	xaxis min=0 max=4;
	yaxis min=0;
run;

proc anova
	data = amess1978;
	class ventilation;
	model folate=ventilation;
	means ventilation /lsd; 
run; 

proc glm
	data = amess1978;
	class ventilation;
	model folate=ventilation;
	means ventilation /lsd hovtest=bartlett;
	output out=amess1978p p=predicted r=residual;
run;	

proc univariate 
	data=amess1978p
	plot normal;
	var residual;
	qqplot /normal(mu=est sigma=est);
 	histogram /normal;
run;

proc sgplot 
	data=amess1978p;
	scatter x=predicted y=residual;
 	refline 0 / axis=y;
run;

data fentress1986;
	input
		treatment
		headaches
		@@
	;
	datalines;
 1 62 2 69 3 50
 1 74 2 43 3 -120
 1 86 2 100 3 100
 1 74 2 94 3 -288
 1 91 2 100 3 4
 1 37 2 98 3 -76
 	;
run;

proc means 
	data = fentress1986 n mean std fw=5 maxdec=1 nonobs;
	class treatment;
	var headaches;
run;

proc univariate 
	data = fentress1986;
	class treatment;
	var headaches;
	qqplot /normal(mu=est sigma=est);
	histogram /normal;
run;

proc glm
	data = fentress1986;
	class treatment;
	model headaches=treatment;
	means treatment /lsd hovtest=bartlett;
	output out=fentress1986p p=predicted r=residual;
run;	

proc univariate 
	data = fentress1986p;
	var residual;
	qqplot /normal(mu=est sigma=est);
 	histogram /normal;
run;

proc sgplot 
	data = fentress1986p;
 	scatter x=predicted y=residual;
 	refline 0 / axis=y;
run;

proc npar1way wilcoxon
	data = fentress1986;
	class treatment;
	var headaches;
run;
