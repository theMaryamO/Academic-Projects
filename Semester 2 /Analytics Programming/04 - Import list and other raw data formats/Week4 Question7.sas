filename pwd "C:\Users\Folashikemi\OneDrive - De Montfort University\P2586104 (vfiler1.lec-admin.dmu.ac.ukHome4)\Documents\IMAT5168 Analytical Programming Mark\Lab 4";
data Example2D;
infile pwd(Example2d.dat);
	input
	/*	line	pos		variable	format */
		#1 		@1		id  		5.
		 		@6		line 		2.
				@8		v1			8.	
		#2		@19		v2			3.
				@58		v3 $		2.
				@79		v4 $		5.
		#3		@20		v5			1.
		#11		@20		v6			4.
	;
run;
proc print data = Example2D;
run;
