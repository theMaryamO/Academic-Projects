/* question 2 */
/*create an informat and format for regions allocated to categories*/
proc format;
value
region
1 ='north'
2 ='middle'
3 ='south'
;

invalue
regions

    'London and South East' = 1
    'South Central' = 1
    'South West' = 1
    'East Midlands' = 2
    'East of England' = 2
    'Wales' = 2
    'West Midlands' = 2
    'Yorkshire and Humber' = 3
    'North East' = 3
    'North West' = 3
;
run;

/*QUESTION 1*/
/*using a macro variable named file*/
%let file=C:\Users\Folashikemi\OneDrive - De Montfort University\P2586104\Documents\IMAT5168 Analytical Programming Mark\Lab 9;
options validvarname=v7;
proc import 
datafile="&file\psa09-npda.xlsx"
	out=NPDA /*(rename=(VAR4 = Currency_Unit))*/
	dbms=xlsx
	/* to replace exsisting files */
	replace
;
getnames=yes;
datarow=2;
run;
proc print data = npda;
run;
/*Check that each instance is unique*/
proc freq data=npda;
table unit;
run;
proc freq data=npda;
table region;
run;
/*Validate the remaining data*/
proc means data=npda;
var patients1-patients7 target1-target7;
run;

/*QUESTION 2*/
/*Use if statement to create new Variable v_new as 'New Regions'*/
data NPDA_REGION;
set NPDA;
if region='London and South East' then v_new = 1;
if region='South Central' then v_new = 1;
if region='South West' then v_new = 1;
if region='East Midlands' then v_new = 2;
if region='East of England' then v_new = 2;
if region='Wales' then v_new = 2;
if region='West Midlands' then v_new = 2;
if region='Yorkshire and Humber' then v_new = 3;
if region='North East' then v_new = 3;
if region='North West' then v_new = 3;
label v_new= 'New Regions';
format v_new region.;
run;
title 'Output table';
proc print data= NPDA_REGION label;
run;

/*create a year variable from the known mapping of target and patient*/
data TRAG_PATIENT ;
set NPDA_REGION;
year= 7; *2017;
patients= patients7;
target= target7;
output;
year= 6; *2016;
patients= patients6;
target= target6;
output;
year= 5; *2015;
patients= patients5;
target= target5;
output;
year= 4; *2014;
patients= patients4;
target= target4;
output;
year= 3; *2013;
patients= patients3;
target= target3;
output;
year= 2; *2012;
patients= patients2;
target= target2;
output;
year= 1; *2011;
patients= patients1;
target= target1;
output;
keep
 unit
 region
 year
 v_new
 target
 patients
 ;
 run;
/*tabulate the new variable 'V' against the the required statistics*/
proc tabulate
 data = TRAG_PATIENT;
 class v_new year;
 var target;
 table 
 year * v_new * (target)
 , n nmiss min p25 median p75 max mean std;
 run;
 proc freq data= NPDA_REGION;
 table v_new;
 run;

 /*QUESTION 3*/
 proc SQL;
 create 
 table North_South as
 select *
 from TRAG_PATIENT
 order by year;
 delete from North_South
 where v_new = 2 /*to output proportion of patients with HbA1c less than 58 mmol/mol*/;
 quit;
 proc print data = North_South  label;
 run;
 proc ttest
 data=North_South;
 class v_new;
 var target;
 by Year;
 run;

 /*QUESTION 4*/

  proc sort data= TRAG_PATIENT;
 by Year;
 run;
 proc glm
 data=TRAG_PATIENT;
 by year;
 class v_new;
 model target= v_new;
 means v_new /REGWQ Tukey welch hovtest;
 output out= v_newfit r= resid p=predicted;
 run;

 proc univariate
 data=v_newfit plot normal;
 by year;
 var resid;
 histogram /normal;
 qqplot /normal(mu=est sigma=est);
 run;
/*QUESTION 5*/
 proc sgscatter data=TRAG_PATIENT;
 plot target*patients / reg= (cli clm);
 by year;
 run;

 /*QUESTION 6*/
 proc reg data=TRAG_PATIENT;
 model target = patients /
 p r
 cli
 clm
 ;
 by year;
 output out= REG p=yhat r=resid;
 run;

 proc univariate
 data = REG
 plot normal;
 var resid;
 qqplot / normal (mu=est sigma=est);
 histogram / normal;
 by year;
 run;
proc sgplot data=REG;
reg x=patients y=target /clm cli;
by year;
run;
