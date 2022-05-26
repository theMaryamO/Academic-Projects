
options symbolgen mprint mlogic;
/*create a macro variable that reads work.LOAN_RISK, Create a csv file for age extreme obs*/
%macro createtxtfl(dsn,age,customer);
ods csvall file= 'C:\Users\Folashikemi\OneDrive - De Montfort University\P2586104\Documents\IMAT5168 Analytical Programming Mark\Lab 10\age_extremeobs.csv';
ods select extremeobs;
proc univariate data= &dsn nextrobs= 10;
var &age;
id &customer;
run;
ods select all;
ods csvall close;
%mend createtxtfl;
%createtxtfl(dsn=work.LOAN_RISK,age=age,customer=customer);
/*create a data step to import Age Extreme Obs*/
%let path=C:\Users\Folashikemi\OneDrive - De Montfort University\P2586104\Documents\IMAT5168 Analytical Programming Mark\Lab 10\;
%let var = Value;
%let var2 = customer;
%let var3 = Obs;
/*create a macro variable for data, var delimiter*/
%macro show_extreme_obs(data,flname,delimiter); 
data &data;
infile
	 "&path&flname..csv" /*call the macro variables path and flname to get age extreme obs data set*/
	 dlm=&delimiter
	 firstobs=8
;
input 
var
var2
var3
@@
;
run;
%mend;
%show_extreme_obs(AGE_EXTREME,age_extremeobs,",");

/*create a macro varibale using into statement in SQL*/
 proc sql;
          create table AGE_EXTREMES as
              select * 
			  into :name separated by " "
              from LOAN_RISK
              where customer in (
                  select customer
                  from AGE_EXTREME
              )
              order by age desc;
      quit;
      %macro printed (data);
      proc print data= &data label noobs;
      run;  
%mend;
%printed(AGE_EXTREMES);

options nosymbolgen nomprint nomlogic;
