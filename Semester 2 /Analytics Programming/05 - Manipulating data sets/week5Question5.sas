proc format;
	value  Rating 
			1 = good
			0 = bad
			other = .
;
run; 

proc sql;
create table SQLMERGE as 
select CUSTOMER.*, CR_RATINGS.Rating, CR_DATES.Ratings_date
from CUSTOMER full join CR_RATINGS on CUSTOMER.ID_Number = CR_RATINGS.ID_Number
full join CR_DATES on 
CR_RATINGS.ID_Number =  CR_DATES.ID_Number;
quit;

data SQLMERGE;
set SQLMERGE;
format Rating Rating.;
run;
proc print data = SQLMERGE;
FORMAT Rating;
run;

proc freq data = SQLMERGE;
table ID_Number Rating Ratings_date;
run; 

proc print data = SQLMERGE;
run;
