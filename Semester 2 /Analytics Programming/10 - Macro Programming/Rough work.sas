%macro doloop;
  %do age=11 %to 15 %by 2;
    title Age=&age.;
    proc print data=sashelp.class(where=(age=&age.));
    run;
  %end;
%mend;
%doloop;


data one;
  input x y;
datalines;
1 2
;

%macro lst(dsn);
  %local dsid cnt rc;
  %global x;
  %let x=;
  %let dsid=%sysfunc(open(&dsn));
   %if &dsid ne 0 %then %do;  %let cnt=%sysfunc(attrn(&dsid,nvars));

   %do i = 1 %to &cnt;
    %let x=&x %sysfunc(varname(&dsid,&i));
   %end;

  %end;
    %else %put &dsn cannot be open.;
  %let rc=%sysfunc(close(&dsid));

%mend lst;

%lst(one)

%put macro variable x = &x;  


