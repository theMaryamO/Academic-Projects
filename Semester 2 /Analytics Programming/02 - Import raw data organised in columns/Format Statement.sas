/* pwd = Present Working Directory*/
/* The location for the data file */
data CREDIT;
          infile
              'D:\Sas\credit.dat'
			  missover /* set current variable to missing */
			  ;
          input
			   ID_Number /*1-3 */
			   Cheque_Account /*5 numeric variable*/
			   Duration_in_months /*7-8 non standard data */
			   Credit_History  /*10 numeric variable */
			   Purpose $ /* 12 numeric variable */
			   Credit_Amount /* 14-18 numeric variable */
			   Savings_accounts_bonds /* numeric variable */
			   Present_empolyment_since /*22 numeric variable */
			   Instalment_rate_income /*24 */
			   Personal_status_and_sex /* 26 numeric variable*/
			   Other_debtors_guarantors /* 28 numeric variable*/
			   Present_residence_since /* 30 numeric and character variable */
			   Property /* 32 numeric variable */
			   Age_in_years /*34-36 numeric data */
			   Other_instalment_plans /* numeric data */
			   Housing /* numeric data */
			   Number_of_existing_credits /* 42 */
			   Job /* 44 numeric data */
			   Number_of_dependents /*46*/
			   Telephone /*48 numeric data */
			   Foreign_worker $ /*50 numeric*/
         ;

		  label

			   ID_Number = 'ID Number'
			   Cheque_Account = 'Cheque Account'
			   Duration_in_months = ' Duration in months'
			   Credit_History = ' Credit History'
			   Purpose = 'Purpose'
			   Credit_Amount = ' Credit Amount'
			   Savings_accounts_bonds = 'Saving accounts/bonds'
			   Present_empolyment_since = 'Present empolyment since'
			   Instalment_rate_income = 'Instalment rate % income'
			   Personal_status_and_sex = 'Personal stauts and sex'
			   Other_debtors_guarantors = 'Other debtors/guarantors'
			   Present_residence_since = 'Present residence since'
			   Property 'Property'
			   Age_in_years 'Age in years'
			   Other_instalment_plans = 'Other instalment plans' 
			   Housing = 'Housing'
			   Number_of_existing_credits = ' Number of existing credits'
			   Job = 'Job'
			   Number_of_dependents = 'Number of dependents'
			   Telephone = 'Telephone'
			   Foreign_worker = 'Foreign worker'
;
proc contents data = CREDIT;
run;
  proc print data = CREDIT (obs=10);
  run;
proc format library = sasuser
; 
 value cr_account 1 = '<£0'
 				  2 = '£0<=<£200'
				  3 = '>=£200'
				  4 = 'no cheque amount'
;
value cr_history 0 ='no credits taken/all credits paid back duly'
				 1 ='all credits at this bank paid back duly'
				 2='existing credits paid back duly till now'
				 3='delay in paying off in the past'
				 4='critical account/other credits existing (not at this bank)'
			     9='missing'
;
value $pr		 0='car (new)'
				 1='car (used)'
				 2='furniture/equipment'
				 3='radio/television'
				 4='domestic appliances'
				 5='repairs'
				 6='education'
				 7='vacation'
				 8='retraining'
          	 	 9='business'
				 X='others'
;
value sab		 1= '< £100'
				 2= '£100 <= < £500'
				 3='£500 <= < £1000'
				 4='>= £1000'
				 5='unknown/no savings account'
;
value pes		 1='unemployed'
				 2='< 1 year'
				 3='1 <= < 4 years'
				 4='4 <= < 7 years'
		 		 5='>= 7 years'
;
value pse 		 1='male :divorced/separated'
				 2='female:divorced/separated/married'
				 3='male :single'
				 4='male :married/widowed'
 				 5='female:single'
				 9='missing'
;
value odg		 1='none'
				 2='co-applicant'
				 3='guarantor'
			     9='missing'
;
value prs 
				 4='4 years or more'
				 9='missing'
;
value prp		 1='real estate'
				 2='if not 1: building society savings agreement/life insurance'
				 3='if not 1/2: car or other'
				 4='unknown /no property'
;
value aiy		 999=' missing'
;
value oip 		 1='bank'
				 2='stores'
				 3='none'
				 9='missing'
;
value hsg		 1='rent'
				 2='own'
				 3='for free'
				 9='missing'
;
value job		 1='unemployed'
				 2='unskilled'
				 3='skilled employee/official'
				 4='management/self-employed/highly qualified employee/officer'
				 9='missing'
;
value tel 		 1='yes, registered under the customers name'
				 2='no'
				 9='missing'
;
value $fw		 1='yes'
				 other = ' '
;
run;
proc print data = CREDIT;
format 
Cheque_Account cr_account. Credit_History cr_history. Purpose $pr. Savings_accounts_bonds sab. Present_empolyment_since pes. 
Personal_status_and_sex pse. Other_debtors_guarantors odg. Present_residence_since prs. Property prp. Age_in_years aiy.
Other_instalment_plans oip. Housing hsg. Job job. Telephone tel. Foreign_worker $fw.
;
run;
