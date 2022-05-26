/*Question 6*/
data LOANRISK;
set LOAN_RISK;
/* log each variable to base to shrink the extreme values*/
LOGage=log10(age);
LOGamount=log10(amount);
LOGduration=log(duration);
LOGinstalment=log(instalment);
run;
title 'Transformed Histogram';
proc univariate data = LOANRISK nextrval=5;
var LOGage
LOGamount
LOGduration
LOGinstalment;
histogram / normal(color=red mu=10 sigma=0.5);
inset mean std normal / position= ne;
run;	

/*Question 7*/
proc freq data = customer;
tables customer;
run;
proc freq data = assessment;
tables customer;
run;
proc freq data = rating;
tables customer;
run;
