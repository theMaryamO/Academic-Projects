/*using a macro variable named file*/
%let file=C:\Users\Folashikemi\OneDrive - De Montfort University\P2586104 (vfiler1.lec-admin.dmu.ac.ukHome4)\Documents\IMAT5168 Analytical Programming Mark\Lab 4;
options validvarname=v7;
proc import 
datafile="&file\exrates-monthly-0220.CSV"
/*use rename statement to correct variable with VAR4 as column name*/
	out=MEXRATE202002 (rename=(VAR4 = Currency_Unit))
	dbms=csv
	/* to replace exsisting files */
	replace
;
/*to prevent sas from shorting the values*/
guessingrows=max;
run;
proc print data = MEXRATE202002
label
noobs
;
run;
