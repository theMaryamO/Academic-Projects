/* 1.)Importing CSV data set called DATES*/
filename pwd 'C:\Users\Folashikemi\OneDrive - De Montfort University\P2586104\Documents\IMAT5168 Analytical Programming Mark\Lab 5';
data DATES;
	infile
		pwd (psa05-creddates.csv) dsd firstobs=2 missover;
	input
			ID_Number
			day_of_rating
			month_of_rating
			year_of_rating
;
	label 
			ID_Number = 'ID Number'
			day_of_rating = 'Day of Rating'
			month_of_rating = 'Month of Rating'
			year_of_rating = 'Month of Rating'
;
run;
	ods exclude enginehost;
/*2.)validating the imported variables*/
proc contents data = DATES
	varnum;
run;
	ods select all;
proc freq data = DATES;
	table 	
			day_of_rating
			month_of_rating
			year_of_rating
;
run;

proc means data= DATES n nmiss min max;
	var 	ID_Number
;
run;
proc print data = DATES;
run;
/*3.) convert date to SAS DATE using CATX function.
	Note: the suggested function in the link provided won't work with large data sets*/
data CR_DATES (keep= ID_Number Ratings_date);
 set DATES;
 	Ratings_date = input (catx('/',day_of_rating,month_of_rating,year_of_rating), ddmmyy10.);
 informat
	Ratings_date ddmmyy10.;
format
	Ratings_date ddmmyy10.;
run;

proc print 
data = CR_DATES
label
;
run;
/* 4.) no unneccassary variable to drop*/
