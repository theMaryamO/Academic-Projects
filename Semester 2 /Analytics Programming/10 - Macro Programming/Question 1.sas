/*symbolgen resolves the macro variables in the sas log window*/
options symbolgen;
/*assign a macro variable to week and and weight and index for each*/
%let var= week;
%let var_weight=weight;
%let index= 1;
%let index2 =2;

/* create a title for each output using macro*/ 
%let title= %str(This is a  test!);
title "&title";
title2 "&var.&index data";
  data TEST;
  /* replace the previous data step with macro variables*/
      input
        &var.&index.
        &var_weight.&index.
        &var.&index2.
        &var_weight.&index2.
      ;
  datalines;
  15 70 25 74 
  ;
  run;
  %macro print;
  proc print data= TEST noobs;
    var &var.&index.
		/*confirm it works*/
		&var_weight.&index.
		&var.&index2.
		&var_weight.&index2;

 run;
 %mend print;
 %print;
/*specifies the log messages will not be displayed*/
options nosymbolgen;

