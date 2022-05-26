/*using a macro variable named file*/
%let file=C:\Users\Folashikemi\OneDrive - De Montfort University\P2586104 (vfiler1.lec-admin.dmu.ac.ukHome4)\Documents\IMAT5168 Analytical Programming Mark\Lab 4;
options validvarname=v7;
proc import 
datafile="&file\NHFD2019.xlsx"
	out=NHFD2019 
	dbms=xlsx
	/* to replace exsisting files */
	replace
;
proc print data = NHFD2019
label
noobs
;
run;
