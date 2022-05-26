options locale = English_UnitedKingdom;

filename pwd 'C:\Users\Folashikemi\OneDrive - De Montfort University\P2586104 (vfiler1.lec-admin.dmu.ac.ukHome4)\Documents\IMAT5168 Analytical Programming Mark\Lab 5';
proc format;
	value cr_account
		1 = '< £0' 
		2 = '£0 - £200'
		3 = '>= £200'
		4 = 'no account'
		. = 'missing'
		other = 'ERROR'
	;
	value cr_history
		0 = 'all paid'
		1 = 'bank paid'
		2 = 'paid before'
		3 = 'delay in paying'
		4 = 'not paid'
		. = 'missing'
		other = 'ERROR'
	;
	value $cr_purpose
		'0' 	= 'car (new)'
		'1' 	= 'car (used)'
		'2' 	= 'furniture etc'
		'3' 	= 'radio/tv'
		'4' 	= 'appliances'
		'5' 	= 'repairs'
		'6' 	= 'education'
		'7' 	= 'vacation'
		'8' 	= 'retraining'
		'9' 	= 'business'
		'X' 	= 'others'
		'' 		= 'missing'
		other 	= 'ERROR'
	;
	value cr_savings
		1 = '<£100'
		2 = '£100 - £500'
		3 = '£500 - £1000'
		4 = '>= £1000'
		5 = 'no account'
		. = 'missing'
		other = 'ERROR'
	;
	value cr_employment
		1 = 'unemployed'
		2 = '< 1 year'
		3 = '1 - 4 years'
		4 = '4 - 7 years'
		5 = '>= 7 years'
		. = 'missing'
		other = 'ERROR'
	;
	value cr_married
		1 = 'male   :was married'
		2 = 'female :is or was married'
		3 = 'male   :single'
		4 = 'male   :is married'
		5 = 'female :single'
		. = 'missing'
		other = 'ERROR'
	;
	value cr_debtors
		1 = 'none' 
		2 = 'co-applicant'
		3 = 'guarantor' 
		. = 'missing'
		other = 'ERROR'
	;
	value cr_resident
		1 = '1 year'
		2 = '2 years'
		3 = '3 years'
		4 = '>=4 years'
		. = 'missing'
		other = 'ERROR'
	;
	value cr_property
		1 = 'real estate'
		2 = 'if not 1: building society loan'
		3 = 'if not 1/2: car or other'
		4 = 'no property'
		. = 'missing'
		other = 'ERROR'
	;
	value cr_plans
		1 = 'bank'
		2 = 'stores'
		3 = 'none'
		. = 'missing'
		other = 'ERROR'
	;
	value cr_housing
		1 = 'rent'
		2 = 'own'
		3 = 'for free'
		. = 'missing'
		other = 'ERROR'
	;
	value cr_job
		1 = 'unemployed'
		2 = 'unskilled'
		3 = 'skilled employee'
		4 = 'management'
		. = 'missing'
		other = 'ERROR'
	;	
	value cr_telephone
		1 = 'yes'
		2 = 'no'
		. = 'missing'
		other = 'ERROR'
	;	
	value cr_foreign
		1 = 'yes'
		. = 'no'
		other = 'ERROR'
	;
run;

data CUSTOMER;							
infile 
		pwd(credit.dat)
		missover
	;
	input									
		ID_Number	1-3						
		account		5						
		duration	7-8						
		history		10						
		purpose $ 	12-13					
		amount		14-18					
		savings		20						
		employment	22						
		instalment	24						
		married		26						
		debtors		28						
		resident	30						
		property	32						
		age			34-36					
		plans		38						
		housing		40						
		credits		42						
		job			44						
		dependents	46						
		telephone	48						
		foreign		50						
	;
	label
		ID_Number 	= 'ID Number'
		account		= 'Chequing account [overdraft?]'
		duration	= 'Duration in months'
		history		= 'Credit history'
		purpose		= 'Purpose [of loan?]'
		amount		= 'Credit amount [requested?]'
		savings		= 'Savings accounts/bonds'
		employment	= 'Present employment since'
		instalment	= 'Instalment rate % income'
		married		= 'Personal status and sex'
		debtors		= 'Other debtors/guarantors'
		resident	= 'Present residence since'
		property	= 'Property [purchase method?]'
		age			= 'Age in years'
		plans		= 'Other instalment plans'
		housing		= 'Housing [ownership?]'
		credits		= 'Number of existing credits'
		job			= 'Job [type?]'
		dependents	= 'Number of dependents'
		telephone	= 'Telephone [line rental?]'
		foreign		= 'Foreign worker'
	;
	format
		account 		cr_account.
		history 		cr_history.
		purpose 		$cr_purpose.
		amount 			nlmnlgbp8.0
		savings 		cr_savings.
		employment 		cr_employment.
		married 		cr_married.
		debtors 		cr_debtors.
		resident 		cr_resident.
		property 		cr_property.
		plans 			cr_plans.
		housing 		cr_housing.
		job 			cr_job.
		telephone 		cr_telephone.
		foreign 		cr_foreign.
	;
run;

ods exclude enginehost;
proc contents 
	data=CUSTOMER
	varnum
	;
run;
ods select all;

proc print data=CUSTOMER(obs=10);
	format
		account
		history
		purpose
		amount 
		savings
		employment
		married 
		debtors 
		resident
		property
		plans 	
		housing 
		job 	
		telephone
		foreign 
	;
run;

/*
	requirement= feedback about variable: value
	note= observations limit: 10
	note= label: present
	note= observation number: removed
*/

proc freq data = CUSTOMER;
/* use table statement to choose particular variables*/
table account
	  history
	  purpose
	  amount 
	  savings
	  employment
	  married 
	  debtors 
	  resident
	  property
	  plans 	
	  housing 
	  job 	
	  telephone
	  foreign
	  ;
run;
proc means data = CUSTOMER n nmiss min max;
var 	ID_Number 												
		duration										
		amount
		age	
		instalment							
		credits											
		dependents
;
run;	
data  CUSTOMER;
set  CUSTOMER;
/*9 and 999 is the mapping assigned to missing values in raw data*/
if (history = 9) then history =.;
if (married = 9) then married =.;
if (debtors = 9) then debtors =.;
if (resident = 9) then resident =.;
if (age = 999) then age =.;
if (plans = 9) then plans =.;
if (housing =9) then housing =.;
if (job = 9) then job =.;
if (telephone = 9) then telephone =.;
run;
proc print 
	data=CUSTOMER(obs=10)
	label
	noobs
	;
run;
