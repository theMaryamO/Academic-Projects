options symbolgen mprint mlogic;
/*create %let global options*/
%let title = Ames 1978;
%let title2 = One-way ANOVA Analyis of;
%let ventvar =ventilation;
%let fol = folate;
%let dsn = amess1978;
%let out =RESIDUALS;
%let pred = predicted;
%let redl = residual;
title "&title2 &title showing &ventvar and &fol";
data &dsn;
	input
		&ventvar
		&fol
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
	data = &dsn n mean std fw=5 maxdec=1 nonobs;
	class &ventvar;
	var &fol;
run;

proc univariate 
	data = &dsn;
	class &ventvar;
	var &fol;
	qqplot /normal(mu=est sigma=est);
	histogram /normal;
run;

proc sgplot
	data = &dsn;
	* scatter x=ventilation y=folate;
	vbox &fol / group=&ventvar;
	xaxis min=0 max=4;
	yaxis min=0;
run;
/*observe the calculated variable folate by class variable ventilation*/
proc anova
	data = &dsn;
	class &ventvar;
	model &fol=&ventvar;
	means &ventvar /lsd; 
run; 
/* proc glm to get the least squares to fit general linear models*/
proc glm
	data = &dsn;
	class &ventvar;
	model &fol=&ventvar;
	means &ventvar /lsd hovtest=bartlett;
	output out=&out p=&pred r=&redl;
run;	
/*proc univariate to see if resdiuals follow a normal distribution*/
proc univariate 
	data=&out
	plot normal;
	var &redl;
	qqplot /normal(mu=est sigma=est);
 	histogram /normal;
run;
/* specified a scatter plot to view the correlation*/
proc sgplot 
	data=&out;
	scatter x=&pred y=&redl;
 	refline 0 / axis=y;
run;
options nosymbolgen nomprint nomlogic;
