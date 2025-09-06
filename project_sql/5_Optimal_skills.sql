SELECT 
   skills_dim.skill_id,
   skills_dim.skills,
   count(skills_job_dim.job_id) AS demand_count,
   round(AVG(job_postings_fact.salary_year_avg), 0) As salary_average
from job_postings_fact
INNER JOIN skills_job_dim 
        ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim 
        ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
   job_title_short = 'Data Analyst' 
   AND salary_year_avg IS NOT NULL
   AND job_work_from_home = TRUE
GROUP BY
   skills_dim.skill_id
HAVING
   count(skills_job_dim.job_id) > 10
ORDER BY
   demand_count ,
   salary_average DESC
LIMIT 25