/* 1.)importing the SAS data set called RATINGS*/
options locale = English_UnitedKingdom;
filename pwd 'C:\Users\Folashikemi\OneDrive - De Montfort University\P2586104 (vfiler1.lec-admin.dmu.ac.ukHome4)\Documents\IMAT5168 Analytical Programming Mark\Lab 5';
data RATINGS;
		infile pwd (psa05-credrating.dat) missover
;
		input 
				ID_Number 
				Rating $	  
;
		label 
				ID_Number =	'ID Number'
	  			Rating =	'Ratings'
;
run;
ods exclude enginehost;
/* 2.)Perform appropriate validation on the imported variables*/
proc contents 
	data=RATINGS
	varnum
	;
run;
ods select all;
proc freq data =RATINGS;
table Rating; 
run;

proc means data = RATINGS n nmiss min max;
var 	ID_Number
;
run;
proc print data =RATINGS
label
noobs;
run;


/*3.)converting the text values to numerical values using if statement. 
This will create a new variable called Rate which will validate missing values or error in the raw data*/
data CR_RATINGS;
set RATINGS;
if Rating = 'bad' then rate = 0;
if Rating = 'good' then rate = 1;
/* to check for missing values or error in the data*/
if Rating = '' 	then rate = .;
run;
/*observe a new variable rate, was created*/
proc print data =CR_RATINGS
label
noobs;
run; 

/*4.)set output format which will detect erroneous and missing values*/
proc format;
	value 
		rate
		 	0='bad'
		 	1='good'
			other =.
;
run;
data CR_RATINGS;
set CR_RATINGS;
format 
rate rate.;
run;

proc print data = CR_RATINGS;
format rate;
run;
 ods exclude enginehost;
 /*5.)revalidate the data */
proc contents 
	data=CR_RATINGS
	varnum
	;
run;
ods select all;

/* difficulty understanding proc compare/but its meant to confirm that the values in rate is the same as ratings*/
proc compare base=RATINGS
compare=CR_RATINGS;
var rating ;
with rate;
run;
proc freq data =CR_RATINGS;
	table rate rating;
run;

proc means data = CR_RATINGS n nmiss min max;
var 	ID_Number
		
;
run;
proc print data =CR_RATINGS
label
noobs;
run;
 /*6.) Drop unneccessary variables*/
data CR_RATINGS;
set CR_RATINGS;
drop Rating;
rename rate = Rating;
run;
proc print data =CR_RATINGS
label
noobs;
run;



