options symbolgen mprint mlogic;
%let dsn = LOAN_RISK;
/* process the data using ds_vars*/
%macro lst(dsn);
      %local dsid cnt rc;
      %global ds_vars;
      %let ds_vars=; /*call all variables*/
      %let dsid= %sysfunc(open(&dsn));
      %if &dsid ne 0 %then %do;  
      %let cnt= %sysfunc(attrn(&dsid, nvars));
      %do i= 1 %to &cnt;
      %let ds_vars=&ds_vars %sysfunc(varname(&dsid,&i));
      %end;
	  %put ds_vars=ds_vars;
	  %end;
      %else %put &dsn cannot be opened.;
      %let rc= %sysfunc(close(&dsid));
      %mend lst;
	  %lst(LOAN_RISK)
	  %put macro variable ds_vars =&ds_vars;
	  /* create a macro variable that outputs many procedures*/
%macro many;
	ods select position;
	proc contents data=&dsn 
			  varnum;
	title "DATA SET &dsn"; 
run;
	ods select all;
	proc print data=&dsn (OBS=10);
   	format &ds_vars;
run;
	proc print data =&dsn (OBS=10)label;
run;
%mend many;
%many;

options nosymbolgen nomprint nomlogic;

