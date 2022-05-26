 data CREDIT;
          infile
               datalines
          ;
          input
               Cheque_Account 5 /* Cheque Account*/;
          datalines;
1   1 42 2 2 7882  1 4 2 3 3 4 2 45  3 3 1 3 2 1 
          ;
  run;  
  proc contents data =CREDIT;
  run;
  proc print data =CREDIT;
  run;
  proc format;
	value cr_account 1= '<£0'
					 2= '£0 <=...< £200'
					 3= '...>=£200'
					 4= 'no cheque account'
run;

