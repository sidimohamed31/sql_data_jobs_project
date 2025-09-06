WITH top_paying_jobs AS (
  select 
    job_id,
    job_title,
    salary_year_avg,
    name AS company_name
  from 
    job_postings_fact
  left join company_dim on job_postings_fact.company_id = company_dim.company_id
  WHERE
    job_title_short = 'Data Analyst' AND 
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
  order BY
    salary_year_avg DESC
  limit 10
)
select 
  top_paying_jobs.*,
  skills
from top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY 
  salary_year_avg DESC;



