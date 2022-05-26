/*
	psa= 06
	requirement= create EXERCISE data set
	
	changed= 2020.03.01
*/

data EXERCISE;
	infile
		datalines
	;
	input 
  		ID   		 
  		diet
		exercise_type 
  		pulse1 
  		pulse2 
  		pulse3
  	;
	label
		ID = 'ID'
		diet = 'Diet'
		exercise_type = 'Exercise Type' 
  		pulse1 = 'Pulse 1'
  		pulse2 = 'Pulse 2'
  		pulse3 = 'Pulse 3'
		;
	datalines;
1     1         1       85       85       88
2     1         1       90       92       93
3     1         1       97       97       94
4     1         1       80       82       83
5     1         1       91       92       91
6     1         2       83       83       84
7     1         2       87       88       90
8     1         2       92       94       95
9     1         2       97       99       96
10    1         2      100       97      100
11    2         1       86       86       84
12    2         1       93      103      104
13    2         1       90       92       93
14    2         1       95       96      100
15    2         1       89       96       95
16    2         2       84       86       89
17    2         2      103      109       90
18    2         2       92       96      101
19    2         2       97       98      100
20    2         2      102      104      103
21    3         1       93       98      110
22    3         1       98      104      112
23    3         1       98      105       99
24    3         1       87      132      120
25    3         1       94      110      116
26    3         2       95      126      143
27    3         2      100      126      140
28    3         2      103      124      140
29    3         2       94      135      130
30    3         2       99      111      150
;
run;

proc print data =EXERCISE;
run;


/*QUESTION 7*/
proc sort data = EXERCISE;
by ID   		 
   diet
   exercise_type;
run;

proc transpose data=EXERCISE out= EXERCISELONG (rename=(_name_=pulsetype col1=pulse));
by ID   		 
   diet
   exercise_type ;
var pulse1 pulse2 pulse3;
run;

proc print data = EXERCISELONG label;
run;


/*QUESTION 8*/
proc transpose data=EXERCISELONG out=EXERCISEWIDE (drop=_name_)
prefix = pulse;
by id exercise_type diet;
run;

proc print data = EXERCISEWIDE;
run;
 
proc compare data = EXERCISE compare = EXERCISEWIDE;
title ' COMPARE THE TWO TRANSPOSED DATA SETS';
RUN;
