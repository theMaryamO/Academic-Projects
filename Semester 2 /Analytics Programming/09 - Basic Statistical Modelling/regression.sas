data manatee_deaths;
  input year nboats manatees @@;
  datalines;
77 447 13  78 460 21   79 481 24   80 498 16
81 513 24  82 512 20   83 526 15   84 559 34
85 585 33  86 614 33   87 645 39   88 675 43
89 711 50  90 719 47
;
run;

proc sgplot
	data = manatee_deaths;
	scatter y=manatees x=nboats;
run;

proc reg data=manatee_deaths;
  model manatees = nboats / p r cli clm;
  output out=man_pred p=yhat r=resid;
run;

proc univariate 
	data = man_pred;
	var resid;
	qqplot /normal(mu=est sigma=est);
	histogram /normal;
run;

proc sgplot data=man_pred;   *  Y vs. X plot with;
  reg x=nboats y=manatees/clm cli; * pred. reg. line and;
run;                               * and conf/pred limits;

proc sgplot data=man_pred;
  histogram resid;              * histogram of residuals;
  density resid / type=normal;  *   with normal density;
run;

proc sgplot data=man_pred;   *  Y vs. X plot with;
  reg x=nboats y=manatees;   *     pred. reg. line and;
  loess x=nboats y=manatees; *     loess fit superimposed;
run;

proc sgplot data=man_pred;
  loess x=yhat y=resid;      * residuals vs. predicted ;
  refline 0 / axis=y;        *  plot with e=0 reference;
run;




