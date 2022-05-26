	/*set locale to United Kingdom*/
options locale = English_UnitedKingdom;
/*obtain file from folder*/
filename abc 'C:\Users\Folashikemi\OneDrive - De Montfort University\P2586104\Documents\IMAT5168 Analytical Programming Mark\Assessment';

data FE;
/*import FE as a CSV File*/
 infile abc (IMAT5168-FE.csv)
 		dsd
 		firstobs=2;
		length
		Institution_Type  $80 /*to prevent SAS remove shrinking the data*/
		Region  $80
 ;

input 
		Institution_Type $
		Region $
		Total_GLH1
		Learners1
		Total_GLH2
		Learners2
		Total_GLH3
		Learners3  
;
label
		Institution_Type = 'Institution Type'
		Region = 'Region'
		Total_GLH1 = 'Total GLH Year1'
		Learners1 = 'Learner 1'
		Total_GLH2 = 'Total GLH Year2'
		Learners2 = 'Learner 2'
		Total_GLH3 = 'Total GLH Year3'
		Learners3 = 'Learner 3'
;
run;
data FORM;
/*import FORM as a CSV file)*/
	infile abc (IMAT5168-6FORM.csv)
		dsd
		firstobs=2;
		length
		Institution_Type $80 /*to prevent SAS remove shrinking the data*/
		Region $80
;
input
		Institution_Type $
		Region $
		Total_GLH1
		Learners1
		Total_GLH2
		Learners2
		Total_GLH3
		Learners3
;
label
		Institution_Type = 'Institution Type'
		Region = 'Region'
		Total_GLH1 = 'Total GLH 1'
		Learners1 = 'Learner 1'
		Total_GLH2 = 'Total GLH 2'
		Learners2 = 'Learner 2'
		Total_GLH3 = 'Total GLH 3'
		Learners3 = 'Learner 3'
;
run;
/*Use SQL Query to Merge FE and FROM as a table*/
title 'JOINED FE & SIXTH FORM';
proc sql;
create table FE_FORM as
select * from FE
union all
select * from FORM 
quit;

/*
	content returns details about variables: type, size
	exclude: enginehost
	varum returns order: variable creation
*/
ods exclude enginehost;
proc contents 
	data=FE_FORM
	varnum
	;
run;
ods select all;
/*summarise catergorial variables*/
proc means
	data= FE_FORM 
	n nmiss std min p25 median p75 max;
	var 
		Total_GLH1
		Learners1
		Total_GLH2
		Learners2
		Total_GLH3
		Learners3
;
run;
/*summarise class variables*/
proc freq
	data=FE_FORM;
	table 
		Institution_Type
		Region 
;
run;
/*Detail = Create a variable to identify Guided_LH and Learners for each Year*/
data CR_FE_FORM;
set FE_FORM;
	Year=1;
	Guided_LH=Total_GLH1;
	Learners=Learners1;
	output;
	Year=2;
	Guided_LH=Total_GLH2;
	Learners=Learners2;
	output;
	Year=3;
	Guided_LH=Total_GLH3;
	Learners=Learners3;
	output;
	keep
		Institution_Type
		Region
		Year 
		Guided_LH
		Learners
;
	label
		Year='Year' 
		Guided_LH ='Guided Learning Hours'
		Learners='Learners'
;
run;
proc print 
	data=CR_FE_FORM
	label;
run;
/* Eliminate rows with aggregate values by deleting empty rows*/
data REF_FE_FORM;
set CR_FE_FORM;
	if nmiss(of _numeric_) 
	OR  cmiss(of _character_) > 0 
	then delete
;
run;
proc print 
	data=REF_FE_FORM;
run;
/*create a new variable for GLH per Learners from Guided_LH and Learners*/
data FE_FORM_PER;
set REF_FE_FORM;
	GLH_per_learners = divide(Guided_LH, Learners)
;
	label
	GLH_per_learners ='GLH Per Learner'
;
run;
/*create new variable for size using GLH values*/
proc format;
	value Total_GLH
		1='Large'
		2='Large-medium'
		3='Medium'
		4='Small-medium'
		5='Small'
;
run;

data FE_FORM_NEW;
set FE_FORM_PER;
	if Guided_LH >= 3000000 then Total_GLH =1;
	if 2000000 <= Guided_LH < 3000000 then Total_GLH = 2;
	if 1000000 <= Guided_LH < 2000000 then Total_GLH = 3;
	if 500000 <= Guided_LH < 1000000 then Total_GLH = 4;
	if Guided_LH < 500000 then Total_GLH = 5;
format 
	Total_GLH Total_GLH.
;
label
	Total_GLH = 'GLH Size'
;
run;
/*Exploratory data analysis
viewing the 5-number summary*/
ods exclude enginehost;
proc contents
	data=FE_FORM_NEW
	varnum;
	run;
ods select all;
proc means 
	data=FE_FORM_NEW
	n std min p25 median p75 max;
	var 
		GLH_per_learners
;
run;
proc freq 
	data=FE_FORM_NEW;
	table Institution_Type
		  Region
		  Year
		  Total_GLH
;
run;
title 'Summary table of GLH Per Learner by Region, Institution Type, Size and Year';
proc tabulate 
	data=FE_FORM_NEW
	format=9.;
	class 
		Region Institution_Type Total_GLH Year 
	;
	var 
		GLH_per_learners 
	;
	table
		Region*Institution_Type*Total_GLH*Year * (GLH_per_learners),
		n min q1 median *F=9.1 q3 max mean std
	;
run;
/*view the distribution */
proc univariate 
	data=FE_FORM_NEW normaltest
	plot normal;
;
	var GLH_per_learners;
	histogram /normal;
 	qqplot 
	/ normal(mu=est sigma=est);
	inset min median skewness kurtosis/ 
	header='Summary Statistics'
	position=nw;
title 'Distribution of GLH per Learner';
run;

/*attempt to make distribution normal*/
data FE_FORM_LOG;
set FE_FORM_NEW;
	/* log each variable to base to shrink the extreme values*/
		LogGLH_pl=log(GLH_per_learners+1);
		run;
title 'Transformed GLH Per Learner';
proc univariate 
	data =FE_FORM_LOG nextrval=5
	normaltest
	plot normal 
;
	var 
		LogGLH_pl
;
	histogram / normal;
	qqplot/
	normal(color=red mu=est sigma=est);
	inset mean std normal /
	header='Summary Statistics'
	position=nw;
run;

/*Assume non-parametric test
use Wilcoxon Test for Institution Type becuase its has two independent levels*/
title 'Effects of Institution Type on GLH Per Learner';
proc npar1way 
	data = FE_FORM_NEW wilcoxon
	median plots=(wilcoxonboxplot medianplot);
	class Institution_Type;
	var GLH_per_learners;
	output out=ITNP; 
run;
title 'Effects of Region on GLH Per Learner';
proc npar1way
	data =FE_FORM_NEW;
	class Region;
	var GLH_per_learners;
run;
title 'Effects of GLH Size on GLH Per Learner';
proc npar1way
	data =FE_FORM_NEW;
	class Total_GLH;
	var GLH_per_learners;
run;
title 'Effects of Year on GLH Per Learner';
proc npar1way
	data =FE_FORM_NEW;
	class Year;
	var GLH_per_learners;
run;
/* Two-way ANOVA
sort the data to view the effects of variables in two-anova against 
		GLH Per Learner*/

proc sort data= FE_FORM_NEW; 
	by Institution_type Total_GLH;
	run;
ods noproctitle;
ods graphics / imagemap=on labelmax=10000 tipmax=10000;
/*test for interaction between Region and Year for each  Institution_Type and SIze*/
title 'Effect of interaction of Region and year on GLH per Learner';
proc glm 
	data= FE_FORM_NEW;
	by Institution_Type Total_GLH;
 	class Region Year;
 	model /* includes interaction */
		GLH_per_learners=
			Region
			Year 
			Region*Year;/* interaction */
 	lsmeans Region Year Region*Year;
	output /* save residuals for later */
		out=INGLM 
		p=predicted r=residual;
	run; quit;
ods graphics off;

proc univariate 
	data=INGLM 
	plot normal;
 var residual;
 histogram /normal;
 qqplot /normal(mu=est sigma=est);
 run; quit;
ods noproctitle;
ods graphics / imagemap=on labelmax=10000 tipmax=10000;
/*test without interaction*/
proc glm
	data=FE_FORM_NEW;
	by Institution_Type Total_GLH;
	class 
		Region 
		Year;
	model 
		GLH_per_learners= Region Year ;
	means 	
		Region /lsd regwq tukey hovtest=bartlett;
	means
		Year /lsd regwq tukey hovtest=bartlett;
	/*lsmeans 
		Region 
		Year/adjust=tukey pdiff=all alpha=0.05 cl;*/
	output 
		out=NINGLM r=residual p=predicted;
run; quit;
ods graphics off;
/* check the residual is normally distributed*/
 proc univariate
 	data=NINGLM
	plot normal;
	var residual;
	histogram/normal;
	qqplot/normal(mu=est sigma=est)
;
run;

			

