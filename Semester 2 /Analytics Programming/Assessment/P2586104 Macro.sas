options symbolgen mprint mlogic;
/*%let library = macro;                /* set name of user library 
libname &library "&path";         /* set location of user library 
options fmtsearch=(&library);  */       
%let path=C:\Users\Folashikemi\OneDrive - De Montfort University\P2586104\Documents\IMAT5168 Analytical Programming Mark\Assessment\;
%let var = Institution;
%let var2 = Region;
%let var3 = GLH;
%let var4 = Learners;
%let index1 = 1;
%let index2 = 2;
%let index3 = 3;
%macro import(data,flname);
data &data;
infile
	 "&path&flname..csv" 
	 dsd
	 firstobs=2;
	 length
	 &var $80
	 &var2 $80
;
input 
&var $
&var2 $
&var3.&index1.
&var4.&index1.
&var3.&index2.
&var4.&index2.
&var3.&index3.
&var4.&index3.
;
run;
%mend import;
%import(FE,IMAT5168-FE);
%import(SIXTHFORM,IMAT5168-6FORM);
%macro merge(dsn,data1,data2);
proc sql noprint;
   create table &dsn as
      select * from &data1
      union all
      select * from &data2;
	quit;
%mend merge;
%merge(FE_FORM,FE,SIXTHFORM);
%macro validate(dsn);
/*macro for validating the data */
ods exclude enginehost;
proc contents 
	data=&dsn
	varnum
	;
run;
ods select all;
/*summarise catergorial variables*/
proc means
	data= &dsn 
	n nmiss std min max;
	var 
		&var3.&index1.
		&var4.&index1.
		&var3.&index2.
		&var4.&index2.
		&var3.&index3.
		&var4.&index3.
;
run;
/*summarise class variables*/
proc freq
	data=&dsn;
	table 
		&var
		&var2
;
run;
%mend validate;
%validate(FE_FORM);

/* create assignment variable*/
%let dsn = FE_FORM;
%let year= year;
%let GLH = GLH;
%let Learners= Learners;

%macro create(dwn,dmn);
data &dwn;
set &dsn;
	&year=&index1;
	&GLH=&var3.&index1.;
	&Learners=&var4.&index1.;
	output;
	&year=&index2;
	&GLH=&var3.&index2.;
	&var4=&var4.&index2.;
	output;
	&year=&index3;
	&GLH=&var3.&index3.;
	&Learners=&var4.&index3.;
	output;
	keep
		&var
		&var2
		&year 
		&GLH
		&Learners
;
	label
		&year='Year' 
		&GLH ='Guided Learning Hours'
		&Learners='Learners'
;
run;
/*eliminate missing rows*/
data &dmn;
set &dwn;
		if nmiss(of _numeric_) 
	OR  cmiss(of _character_) > 0 
	then delete
;
run;
%mend create;
%create(FEFORM_CR,FEFORM_ELI);

%let GLHPL= GLH_per_learners;
%let dmn = FEFORM_ELI;
%macro divide(ddn);
data &ddn;
set &dmn;
	&GLHPL = divide(&GLH, &Learners)
;
	label
	&GLHPL ='GLH Per Learner'
;
run;
%mend divide;
%divide(FEFORM_DEL);

/*proc format 
proc format;
	value Total_GLH
		1='Large'
		2='Large-medium'
		3='Medium'
		4='Small-medium'
		5='Small'
;
run;

data &dsg;
set &ddn;
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
options nosymbolgen nomprint nomlogic;*/
