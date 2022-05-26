data energy;
	input intake;
	diff = intake - 7725;	/* Calculate difference */
	label intake = 'Daily energy intake (kJ)';
datalines;
5260	
5470
5640
6180
6390
6515
6805
7515
7515
8230
8770
;
run;

proc univariate data= energy;
	var intake diff;
	qqplot intake / normal (mu=est sigma=est);
	histogram intake / normal;
run;
