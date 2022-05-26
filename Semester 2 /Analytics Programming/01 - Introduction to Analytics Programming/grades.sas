data GRADES;      infile datalines;
   input
     student         /* student id */
     gender $
     exam1           /* first exam mark */
     exam2           /* second exam mark */
     coursework $    /* coursework grade */
   ;   
datalines;  
  1 M 70 82 A
  2 M 62 54 B
  3 F 72 73 A
  4 M 60 65 B
  5 F 52 50 B
  6 F 81 78 B
  7 F 40 49 C
  8 M 59 60 C
  9 M 64 66 C
  10 F 64 63 B
  11 M 69 70 A
  12 M 75 72 A 
  13 M 38 50 B
  14 F 63 69 B 
  15 M 61 45 C   
    ;
run;
proc print
   data = GRADES;
run;  
 proc sgplot data=GRADES;
      scatter x=exam1 y=exam2 / group=coursework datalabel=student;
      ellipse x=exam1 y=exam2;
      reg x=exam1 y=exam2 / nomarkers;
      xaxis min=0 max=100;
      yaxis min=0 max=100;
  run;  
