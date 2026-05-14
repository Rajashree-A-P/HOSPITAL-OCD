SELECT * FROM hospital_ocd.ocd_patient;
use hospital_ocd;

/*patient count by gender and average obsession scores*/

select 
      Gender,
      count(`Patient ID`) as patient_count,
      round(avg(`Y-BOCS Score (Obsessions)`),2 ) as avg_obs_score
	  from ocd_patient
      group by 1
      order by 2;
   
   /*patient count percentage*/ 
   
   with gender_count as 
   (select 
      Gender,
      count(`Patient ID`) as patient_count,
      round(avg(`Y-BOCS Score (Obsessions)`),2 ) as avg_obs_score
	  from ocd_patient
      group by gender),
	total as 
    ( select  sum(patient_count) as total_count
      from gender_count)
      select 
          g.gender,
          g.patient_count,
          g.avg_obs_score,
          t.total_count,
          round((g.patient_count/t.total_count*100),2) as percentage
          from gender_count g
           join total t ;
       
       /*Count of patients by ethnicity and their average obsession and compulsion score*/
       select 
		    Ethnicity,
			count(`Patient ID`) as patient_count,
			round(avg(`Y-BOCS Score (Obsessions)`),2 ) as avg_obs_score,
            round(avg(`Y-BOCS Score (Compulsions)`),2) as avg_compulsion_score
            from ocd_patient
            group by 1
            order by  2,3 asc;
       
           /*patient count by months*/
           
           set sql_safe_updates = 0;
           
UPDATE ocd_patient
SET `OCD Diagnosis Date` = STR_TO_DATE(`OCD Diagnosis Date`, '%Y-%m-%d')
where STR_TO_DATE(`OCD Diagnosis Date`, '%Y-%m-%d') is not null;
   
ALTER TABLE ocd_patient
MODIFY `OCD Diagnosis Date` DATE;

select 
date_format(`OCD Diagnosis Date`, '%Y-%m-%01 ') as month,
count(`Patient ID`) as patient_count
from ocd_patient
group by month
order by month desc ;

/*The most common obsession type*/

select 
`Obsession Type`,
count(`Patient ID`) as patient_count,
round(avg(`Y-BOCS Score (Obsessions)`),2) as avg_obsession_score
from ocd_patient
group by `Obsession Type`
order by patient_count desc limit 5 ;

/*The most common compulsion type*/

select 
`Compulsion Type`,
count(`Patient ID`) as patient_count,
round(avg(`Y-BOCS Score (Compulsions)`),2) as avg_compulsion_score
from ocd_patient
group by `Compulsion Type`
order by patient_count desc limit 5 ;

/*The most common obsession and compulsion type medications*/

select 
Medications,
`Obsession Type`,
`Compulsion Type`,
count(`Patient ID`) as patient_count,
round(avg(`Y-BOCS Score (Obsessions)`),2) as avg_obsession_score,
round(avg(`Y-BOCS Score (Compulsions)`),2) as avg_compulsion_score
from ocd_patient
group by 1,2,3
order by 4 desc limit 10 ;



