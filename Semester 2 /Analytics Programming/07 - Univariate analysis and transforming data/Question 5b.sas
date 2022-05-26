/*Create SQL tables*/
/*age*/
filename pwd 'C:\Users\Folashikemi\OneDrive - De Montfort University\P2586104\Documents\IMAT5168 Analytical Programming Mark\Lab 7';
data age_extremeobs;
infile
	 pwd(age_extremeobs.csv)
	 delimiter=','
	 firstobs=8
;
input 
Value
customer
Obs
@@
;
run;
proc sort data = age_extremeobs;
by customer;
run;
proc sql;
create table lowerextremeobs_age as 
select *
from age_extremeobs
where value < 66;
quit;
title 'Lower ExtremeObs Age';
proc print data = lowerextremeobs_age;
run;

proc sql;
create table higherextremeobs_age as 
select *
from age_extremeobs
where value > 21;
quit;
title 'Higher ExtremeObs Age';
proc print data = higherextremeobs_age;
run;

/*amount*/
filename pwd 'C:\Users\Folashikemi\OneDrive - De Montfort University\P2586104\Documents\IMAT5168 Analytical Programming Mark\Lab 7';
data amount_extremeobs;
infile
	 pwd(amount_extremeobs.csv)
	 delimiter=','
	 firstobs=8
;
input 
Value
customer
Obs
@@
;
run;
proc sort data = amount_extremeobs;
by customer;
run;
proc sql;
create table loweramount_extremeobs as 
select *
from amount_extremeobs
where value < 12579;
quit;
title 'Lower ExtremeObs Amount';
proc print data = loweramount_extremeobs;
run;

proc sql;
create table higheramount_extremeobs as 
select *
from amount_extremeobs
where value > 454;
quit;
title 'Higher ExtremeObs Amount';
proc print data = higheramount_extremeobs;
run;

/*duration*/
filename pwd 'C:\Users\Folashikemi\OneDrive - De Montfort University\P2586104\Documents\IMAT5168 Analytical Programming Mark\Lab 7';
data duration_extremeobs;
infile
	 pwd(duration_extremeobs.csv)
	 delimiter=','
	 firstobs=8
;
input 
Value
customer
Obs
@@
;
run;
proc sort data = duration_extremeobs;
by customer;
run;
proc sql;
create table lowerduration_extremeobs as 
select *
from duration_extremeobs
where value < 54;
quit;
title 'Lower ExtremeObs Duration';
proc print data = lowerduration_extremeobs;
run;

proc sql;
create table higherduration_extremeobs as 
select *
from duration_extremeobs
where value > 6;
quit;
title 'Higher ExtremeObs Duration';
proc print data = higherduration_extremeobs;
run;

/*Instalment*/
filename pwd 'C:\Users\Folashikemi\OneDrive - De Montfort University\P2586104\Documents\IMAT5168 Analytical Programming Mark\Lab 7';
data instalment_extremeobs;
infile
	 pwd(instalment_extremeobs.csv)
	 delimiter=','
	 firstobs=8
;
input 
Value
customer
Obs
@@
;
run;
proc sort data = instalment_extremeobs;
by customer;
run;
proc sql;
create table lowerinstalment_extremeobs as 
select *
from instalment_extremeobs
where value < 4;
quit;
title 'Lower ExtremeObs Instalment';
proc print data = lowerinstalment_extremeobs;
run;

proc sql;
create table higherinstalment_extremeobs as 
select *
from instalment_extremeobs
where value > 1;
quit;
title 'Higher ExtremeObs Instalment';
proc print data = higherinstalment_extremeobs;
run;
