select 
 salary_year_avg
 extract(year from salary_year_avg) 
 extract(month from salary_year_avg) 
from 
  job_postings_fact
LIMIT 5;
  
  

