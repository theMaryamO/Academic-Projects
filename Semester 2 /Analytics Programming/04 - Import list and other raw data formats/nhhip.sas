data headers;
infile "C:\Users\p2586104\OneDrive - De Montfort University\P2586104 (vfiler1.lec-admin.dmu.ac.ukHome4)\Documents\IMAT5168 Analytical Programming Mark\Lab 4\NHFD2019.xlsx"
dsd;
lrecl = 99999 ;
length clinical_governance_meeting_established $39 ;
do until length (_infile_) = 0;
	input Clinical_governance_meeting_established $39 @567;
	output;
end;
stop;
run;
	   
 




proc import datafile = 'C:\Users\p2586104\OneDrive - De Montfort University\P2586104 (vfiler1.lec-admin.dmu.ac.ukHome4)\Documents\IMAT5168 Analytical Programming Mark\Lab 4\NHFD2019.xlsx'
	out=NHF 	DBMS = xlsx;
	Getnames = yes;
	LRECL = 300;
	run;
	proc print data = NHF;
	run;
	
