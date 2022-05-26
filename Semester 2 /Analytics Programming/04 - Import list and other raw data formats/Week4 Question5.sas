data Experiment1978;
	input
		ventilation
		folate
		@@ /* more data on the same line */
	;
	datalines;
 1 243 2 206 3 241
 1 251 2 210 3 258
 1 275 2 226 3 270
 1 291 2 249 3 293
 1 347 2 255 3 328
 1 354 2 273
 1 380 2 285
 1 392 2 295
       2 309
run;
proc print 
	data=Experiment1978
	label
	noobs
	;
run;
