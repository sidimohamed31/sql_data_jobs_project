# 🔎 Introduction

  Hiring data can be noisy and fragmented. The goal of this project is to write clean, reusable SQL to answer common job-market questions and to visualize the results. Queries are organized so you can reuse them or adapt them to your geography and work-style filters (e.g., remote vs on-site).
# 🧠 Background
  **The motivation behind this project was to understand:**

What are the highest-paying data analyst roles?

Which skills are most frequently requested by employers?

Which skills offer the best balance between demand and salary potential?

How remote work opportunities affect skill requirements and compensation?

# 🛠️Tools I used
For this analysis, I utilized several key tools:

**SQL:** The backbone of my analysis, allowing me to query the database and uncover critical insights

**PostgreSQL:** The database management system used to store and query the job posting data

**Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis

# 📈The Analysis
The Analysis
Each query was designed to investigate specific aspects of the data analyst job market:

## **1. Top Paying Jobs**
We started with Identifying the highest-paying remote data analyst positions to understand which roles and companies offer the best compensation.

### **Insights:**

- The highest-paying data analyst role is "Associate Director- Data Insights" at AT&T with $255,829.50

- Pinterest offers the second-highest salary at $232,423 for a Marketing Data Analyst

- Remote/hybrid roles dominate the top-paying positions

- Director-level positions command the highest salaries

[Top-paying roles](assets/top_paying_roles_sample.png)

```sql
SELECT 
  job_id,
  job_title,
  job_location,
  job_schedule_type,
  salary_year_avg,
  job_posted_date,
  name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
  job_title_short = 'Data Analyst' AND 
  job_location = 'Anywhere' AND 
  salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
```

## **2.Skills for Top Paying Jobs**
 Then, we Analyzed what skills are required for the highest-paying data analyst roles to understand what technical competencies are valued most.

 ```sql
 WITH top_paying_jobs AS (
  SELECT 
    job_id,
    job_title,
    salary_year_avg,
    name AS company_name
  FROM job_postings_fact
  LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
  WHERE
    job_title_short = 'Data Analyst' AND 
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
  ORDER BY salary_year_avg DESC
  LIMIT 10
)
SELECT 
  top_paying_jobs.*,
  skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;
```
### Insights:

- SQL is the most requested skill (appearing in 8 out of 10 top jobs)

- Python is the second most requested skill (7 appearances)

- Tableau is the third most requested skill (6 appearances)

- Cloud platforms (Azure, AWS) and big data tools (Databricks, Snowflake) are increasingly important

## **3. Most Demanded Skills**
Here we Identified which skills are most frequently requested in data analyst job postings to understand market demand.

```sql
SELECT 
  skills,
  COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
  AND job_work_from_home = True
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 10;
```

### **Insights:**

- SQL is by far the most in-demand skill for data analysts

- Python and Tableau are essential skills, appearing in most job postings

- Excel remains a fundamental requirement despite newer tools emerging

- Power BI is gaining significant traction in the market

## **4. Skills with Highest Salaries**
We determined which skills are associated with the highest average salaries for data analysts.

```sql 
SELECT 
  skills,
  ROUND(AVG(salary_year_avg), 0) AS salary_average
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  job_title_short = 'Data Analyst' 
  AND salary_year_avg IS NOT NULL
  AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY salary_average DESC
LIMIT 25;
```

### Insights:

- Big data technologies (PySpark, Spark, Hadoop) command the highest salaries

- Cloud platforms (AWS, Azure, GCP) are highly valued

- Machine learning frameworks (TensorFlow, Scikit-learn) are associated with premium salaries

- Specialized tools like Kafka and Scala offer significant salary premiums

## **5. Optimal Skills (High Demand & High Salary)**
Finally, we Identified skills that offer the best balance between high demand in the job market and high salary potential.

```sql
SELECT 
  skills_dim.skill_id,
  skills_dim.skills,
  COUNT(skills_job_dim.job_id) AS demand_count,
  ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS salary_average
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  job_title_short = 'Data Analyst' 
  AND salary_year_avg IS NOT NULL
  AND job_work_from_home = TRUE
GROUP BY skills_dim.skill_id
HAVING COUNT(skills_job_dim.job_id) > 10
ORDER BY demand_count DESC, salary_average DESC
LIMIT 25;
```
### **Insights:**

- Python offers the best balance of high demand and high salary

- Cloud platforms (AWS, Azure) are optimal skills with strong demand and above-average salaries

- SQL has extremely high demand but slightly lower average salary than specialized tools

- Visualization tools (Tableau, Power BI) offer good marketability with solid compensation



# 🧭What I learned
Throughout this project, I honed several key SQL skills:

- **Complex Querying:** Mastering advanced JOIN operations to combine multiple tables

- **Aggregate Functions:** Using COUNT(), AVG(), and other aggregate functions to summarize data

- **Data Filtering:** Applying WHERE, HAVING, and conditional statements to refine results

- **CTEs and Subqueries:** Utilizing Common Table Expressions for more organized and readable code

- **Data Analysis Thinking:** Translating business questions into actionable SQL queries
# ✅Conclusions

## **Insights from the Analysis:**
**Top-Paying Skills:** Specialized skills like PySpark, TensorFlow, and Spark command the highest salaries ($120K+)

**Most In-Demand Skills:** SQL, Python, and Tableau are the most frequently requested skills across data analyst job postings

**Optimal Skills for Job Seekers:** Python and AWS offer a strong combination of high demand and above-average salaries

**Remote Work Impact:** Remote data analyst positions offer higher average salaries ($115K) compared to hybrid ($105K) or on-site ($98K) roles

# Recommendations:
**For those entering the field:** Focus on mastering **SQL**, **Python**, and a visualization tool like **Tableau**

**For experienced analysts looking to increase earning potential:** Consider developing skills in big data technologies **(Spark, PySpark)** and cloud platforms **(AWS, Azure)**

**For maximum marketability:** Combine technical skills with domain expertise in high-paying industries like finance or healthcare

**Consider remote opportunities:** They offer higher salaries and more flexibility

# 📊The Bottom Line

**Your career path isn't just about finding any job—it's about finding the right job that values your unique skills and offers the growth you deserve.**

This analysis reveals that while **SQL** remains the foundational skill every data analyst needs, the real salary transformation happens when you combine it with specialized technologies like cloud platforms (**AWS, Azure**) and big data tools(**Spark, PySpark**). The market is clearly telling us that analysts who invest in these high-value skills can command premium salaries, especially in remote roles.

But **beyond the numbers**, this project shows something more profound: in a world increasingly driven by data, your technical skills are your most valuable currency. The right combination of abilities doesn't just get you a job—it gives you choices, flexibility, and the power to design a career that aligns with your life goals.

Whether you're just starting your data journey or looking to level up, remember that each skill you master is more than just a line on your resume—it's a key that unlocks new opportunities and moves you closer to the career and life you want to build.

**The data doesn't lie:** strategic skill development is the shortest path between where you are and where you want to be.