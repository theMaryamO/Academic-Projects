/* pwd = Present Working Directory */
 /* The location for the data file */
 ;

 data HOUSE;
 /* ... using input from the income.dat file */
 infile 'D:\Sas\income.dat';
 /* ... creating the following variables */
 input 
  income1  /* numeric, principal income */
  income2  /* numeric, secondary income */
  size   /* numeric, family size */
  ownrent  /* numeric, owns or rents house */
  amount   /* numeric, rent/mortgage payment */
  utility  /* numeric, average monthly utility payment */
  location /* numeric, city location */
 ;
 /* ... which have the following display names */
 label
  income1  = 'Principal income'
  income2  = 'Secondary income'
  size   = 'Size of family'
  ownrent  = 'Own or rent house'
  amount   = 'Amount of mortgage or rent payment'
  utility  = 'Average monthly utility payment'
  location  = 'Location in city'
 ;
run;
proc print data =HOUSE;
run;
 /* tabulate a descriptive summary for principle income by location */
  proc tabulate data=HOUSE;
    /* divide the incomes into groups by... */
   class  location;
    /* calculate descriptive statistics for... */
   var income1;   
    /* for each location show the summary */
   table location all, income1 * (n min p25 median p75 max mean std);
  run;  
/* tabulate the frequency of owners/renters by location */
 proc freq data = HOUSE;
 tables location * ownrent;
 run;
 
