proc format;
	value prentice_bmi
		1 = 'lean'
		2 = 'obese'
		. = 'missing'
		other = 'error'
	;
run;

data prentice1986;
	input
		bmi
		energy
		@@
	;
	label
		bmi = 'BMI outcome'
		energy = 'Energy expenditure (MJ/day)'
	;
	format
		bmi prentice_bmi.
	;
	datalines;
1 6.13 2 8.79
1 7.05 2 9.19
1 7.48 2 9.21
1 7.48 2 9.68
1 7.53 2 9.69
1 7.58 2 9.97
1 7.90 2 11.51
1 8.08 2 11.85
1 8.09 2 12.79
1 8.11
1 8.40
1 10.15
1 10.88
	;
run;

proc univariate
	data = prentice1986;
	var energy;
	qqplot energy / normal(mu=est sigma=est); 
run;

proc ttest
	data = prentice1986;
	class bmi; /* outcome of bmi assessment */
	var energy; /* energy expenditure */
run;
