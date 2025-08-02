WITH demand_skills AS(
    SELECT 
        Count(skills_job_dim.job_id) AS demand_count,
        skills_dim.skills,
        skills_dim.skill_id
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id=job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id=skills_job_dim.skill_id
    WHERE 
        job_title_short='Data Analyst' 
        AND salary_year_avg IS NOT NULL 
        AND job_work_from_home=True
    GROUP BY 
        skills_dim.skill_id
),  most_paying AS(
    SELECT 
        ROUND(AVG(salary_year_avg),0) AS avg_salary,
        skills_dim.skill_id
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id=job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id=skills_job_dim.skill_id
    WHERE 
        job_title_short='Data Analyst' 
        AND salary_year_avg IS NOT NULL 
        AND job_work_from_home=True
    GROUP BY 
        skills_dim.skill_id
)

SELECT 
    demand_skills.skill_id,
    demand_skills.skills,
    demand_count,
    avg_salary
FROM demand_skills
INNER JOIN most_paying ON demand_skills.skill_id=most_paying.skill_id
WHERE demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;