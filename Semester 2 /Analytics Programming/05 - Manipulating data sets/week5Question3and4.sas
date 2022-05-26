/* 1.)sort all data sets by ID_Number using proc sort*/
proc sort data=CR_RATINGS;
 		  by ID_Number;
run;
proc sort data=CR_DATES;
 		  by ID_Number;
run;
proc sort data=CUSTOMER;
 		  by ID_Number;
run;
/*3.) set out put format for Rating*/
proc format;
	invalue $Rating 
			'good'=1
			'bad'=0
			other = .
;
run; 
/* 1.) Merge CUSTOMER CR_RATINGS CR_DATE*/
data CREDIT;
merge CUSTOMER CR_RATINGS CR_DATES;
		by ID_Number ;
label 
		Ratings_date='Ratings Date'
; 									/*2.)Set new Label for Ratings Date*/
informat Rating $Rating.
;
run;

proc print data=CREDIT label;
format Rating;
run;

/*created a new data set to for mismatched record in one-to-one merge
Note: In the output only CR_DATES have '0' because to represent  missing values*/

data MCREDIT /*Merged Credit = MCREDIT*/;
set CREDIT;
merge CUSTOMER(in=CUSTOMERX) CR_RATINGS(in=CR_RATINGSX) CR_DATES(in=CR_DATESX);
by ID_Number;/*Key/primary variable thats the relationship between the three data sets*/
fromCUSTOMER = CUSTOMERX; 
fromCR_RATINGS = CR_RATINGSX; 
fromCR_DATES = CR_DATESX;
run;
/* Cross-Tabular Frequency Table to identify mismatched records*/
proc freq data = MCREDIT; 
tables fromCUSTOMER*fromCR_RATINGS*fromCR_DATES;
run;
proc print data=MCREDIT;
run;
