filename pwd 'C:\Users\Folashikemi\OneDrive - De Montfort University\P2586104 (vfiler1.lec-admin.dmu.ac.ukHome4)\Documents\IMAT5168 Analytical Programming Mark\Lab 4';
data MEXRATE202002;
/*firstobs=2 to start reading the data from the second observation*/
/* using dsd (delimiter-sensitive data) statement to separate the variable*/
infile pwd (exrates-monthly-0220.CSV) firstobs=2 dsd;	
/*use the length statement is input values with longer than 8 characters
I chose 50 just as an assumption incase i miss a value*/
length 
	country$ 50.
	currency$ 50.
;
input 
	Country $
	Currency $
	Currency_Code $
	Currency_Unit_per_pound
	Start_Date
	End_Date
;
/* use informat to convert non-standard data to standard data */
informat 
	Start_Date	DDMMYY10.
	End_Date	DDMMYY10.
;
/*use format to convert standard data to nonstandard data*/
format
	Start_Date	DDMMYY10.
	End_Date	DDMMYY10.
;
run;
proc print 
	data = MEXRATE202002;
	var Country 
	Currency 
	Currency_Code 
	Currency_Unit_per_pound
	Start_Date
	End_Date
;
run;
