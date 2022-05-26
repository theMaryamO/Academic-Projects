
filename pwd 'insert file path';

data FE;
 infile pwd(IMAT5168-FE.csv)
 		dsd
 		firstobs=2;
		length
		Institution  $40
		Region  $40
 ;

input 
		Institution $
		Region $
		GLH1
		Learners1
		GLH2
		Learners2
		GLH3
		Learners3  
;
label
		Institution = 'Institution Type'
		Region = 'Region'
		GLH1 = 'Total GLH Year 1'
		Learners1 = 'Learner 1'
		GLH2 = 'Total GLH Year 2'
		Learners2 = 'Learner 2'
		GLH3 = 'Total GLH Year 3'
		Learners3 = 'Learner 3'
;
run;
data SIXTHFORM;
	infile pwd (IMAT5168-6FORM.csv)
		dsd
		firstobs=2;
		length
		Institution $40
		Region $40
;
input
		Institution $
		Region $
		GLH1
		Learners1
		GLH2
		Learners2
		GLH3
		Learners3
;
label
		Institution = 'Institution Type'
		Region = 'Region'
		Total_GLH1 = 'Total GLH 1'
		Learners1 = 'Learner 1'
		Total_GLH2 = 'Total GLH 2'
		Learners2 = 'Learner 2'
		Total_GLH3 = 'Total GLH 3'
		Learners3 = 'Learner 3'
;
run;

proc sql;
create table FEFORM_SQL as
select * from FE
union all
select * from SIXTHFORM 
quit;

proc print data= FEFORM_SQL noobs label;
run;

proc means
	data= FEFORM_SQL
	n nmiss std min max;
	var 
		GLH1
		Learners1
		GLH2
		Learners2
		GLH3
		Learners3
;
run;
/*summarise class variables*/
proc freq
	data=FEFORM_SQL;
	table 
		Institution
		Region 
;
run;
/*Detail = Create a variable to identify Guided_LH and Learners for each Year*/
data FEFORM_YEAR;
set FEFORM_SQL;
	Year=1;
	GLH=GLH1;
	Learners=Learners1;
	output;
	Year=2;
	GLH=GLH2;
	Learners=Learners2;
	output;
	Year=3;
	GLH=GLH3;
	Learners=Learners3;
	output;
	keep
		Institution
		Region
		Year 
		GLH
		Learners
;
	label
		Year='Year' 
		GLH ='Guided Learning Hours'
		Learners='Learners'
;
run;
proc print 
	data=FEFORM_YEAR
	label;
run;
/* Eliminate rows with aggregate values*/
proc sql;
create table FEFORM_ELI as
select * from FEFORM_YEAR
delete from FEFORM_ELI
where Region=' ';
quit;
proc sql;
create table FEFORM_ELI2 as
select * from FEFORM_ELI
delete from FEFORM_ELI2
where Learners=' ';
quit;
proc sql;
create table FEFORM_DON as
select * from FEFORM_ELI2
delete from FEFORM_DON
where GLH=' ';
quit;

proc print data=FEFORM_DON;
run;

proc tabulate
	data=FEFORM_DON
	format =9.;
	class
		Institution
		Region
		Year
;
	var
		GLH
;
	table 
		Institution * Region * Year *(Guided_LH),
		n nmiss min q1 median * f=9.1 q3 max mean std
;
run;

data FEFORM_GLH;
set FEFORM_DON;
	GLH_per_learners = divide(GLH, Learners)
;
	label
	GLH_per_learners ='GLH Per Learner'
;
run;

proc format;
	value GLH_size
		1='Large'
		2='Large-medium'
		3='Medium'
		4='Small-medium'
		5='Small'
;
run;

data FEFORM_SIZE;
set FEFORM_GLH;
	if GLH >= 3000000 then GLH_size =1;
	if 2000000 <= GLH < 3000000 then GLH_size = 2;
	if 1000000 <= GLH < 2000000 then GLH_size = 3;
	if 500000 <= GLH < 1000000 then GLH_size = 4;
	if GLH < 500000 then GLH_size = 5;
format 
	GLH_size GLH_size.
;
run;

proc univariate 
	data=FEFORM_SIZE normaltest
	plot normal;
;
	var GLH_per_learners;
	histogram /normal;
 	qqplot 
	/ normal(mu=est sigma=est);
run;

data FEFORM_NRM;
set FEFORM_SIZE;
		LogGLH =log(GLH_per_learners);
		run;
title 'Transformed GLH Per Learner';
proc univariate 
	data =FEFORM_NRM
	normaltest
	plot normal 
;
	var 
		LogGLH
;
	histogram / normal;
	qqplot/
	normal(color=red mu=est sigma=est);
run;

/*Assume non-parametric test*/
proc npar1way 
	data = FEFORM_SIZE wilcoxon
	median plots=(wilcoxonboxplot medianplot)
	edf;
	class Institution;
	var GLH_per_learners;
	output out=ITNP; 
run;

proc npar1way
	data =FEFORM_SIZE;
	class Region;
	var GLH_per_learners;
run;

proc npar1way
	data =FEFORM_SIZE;
	class GLH_size;
	var GLH_per_learners;
run;

proc npar1way
	data =FEFORM_SIZE;
	class Year;
	var GLH_per_learners;
run;
/* Two-way ANOVA*/
proc sort data= FEFORM_SIZE; 
	by Institution GLH_SIZE;
	run;

proc glm 
	data= FEFORM_SIZE;
	by Institution GLH_size;
 	class Region Year;
 	model /* includes interaction */
		GLH_per_learners=
			Region
			Year 
			Region*Year;/* interaction */
 	lsmeans Region Year Region*Year ;
	quit;

proc glm
	data=FEFORM_SIZE;
	by Institution GLH_size;
	class 
		Region 
		Year;
	model 
		GLH_per_learners= Region Year ;
	lsmeans 
		Region 
		Year/;
	output 
		out=ANOVATEST r=residual p=predicted;
quit;

 proc univariate
 	data=ANOVATEST
	plot normal;
	var residual;
	histogram/normal;
	qqplot/normal(mu=est sigma=est)
;
run;

			

