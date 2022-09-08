--Creating the tables and importing the data we just cleaned in excel.

CREATE TABLE companies_eeo(
company	VARCHAR(200),
year INTEGER,
race VARCHAR(350), 	
gender VARCHAR (350)	,
job_category VARCHAR(350),	
count INTEGER
)

SELECT * FROM companies_eeo


CREATE TABLE diversity_demographics(
job_category VARCHAR (350),
race_ethnicity VARCHAR (350),
gender	VARCHAR (350),
count	INTEGER,
percentage DECIMAL(5,2)
)

SELECT * FROM diversity_demographics

CREATE TABLE distributions_data(
company	VARCHAR (250),
percentage	DECIMAL (5,2),
demographics VARCHAR (350),
job_category VARCHAR (350)
)

SELECT * FROM distributions_data

--Exploring the data

SELECT *
FROM distributions_data
WHERE company <> 'anonymous'

SELECT DISTINCT job_category
FROM distributions_data

SELECT DISTINCT job_category, job_level, race
FROM companies_eeo

--Dividing the jobs into levels
--for easier understanding of where the various demographics fall under

SELECT *,
CASE WHEN job_category = 'Administrative support' THEN 'Mid level'
WHEN job_category = 'Sales workers' THEN 'Mid level'
WHEN job_category = 'Professionals' THEN 'High level'
WHEN job_category = 'Managers' THEN 'High level'
WHEN job_category = 'Service workers' THEN 'Low level'
WHEN job_category = 'Executives' THEN 'High level'
WHEN job_category = 'operatives' THEN 'Low level'
WHEN job_category = 'Craft workers' THEN 'Low level'
WHEN job_category = 'laborers and helpers' THEN 'Low level'
WHEN job_category = 'Technicians' THEN 'Low level'
ELSE 'non job category'
END AS job_level
FROM companies_eeo


ALTER TABLE companies_eeo
ADD COLUMN job_level VARCHAR (250)

UPDATE companies_eeo
SET job_level = (
CASE WHEN job_category = 'Administrative support' THEN 'Mid level'
WHEN job_category = 'Sales workers' THEN 'Mid level'
WHEN job_category = 'Professionals' THEN 'High level'
WHEN job_category = 'Managers' THEN 'High level'
WHEN job_category = 'Service workers' THEN 'Low level'
WHEN job_category = 'Executives' THEN 'High level'
WHEN job_category = 'operatives' THEN 'Low level'
WHEN job_category = 'Craft workers' THEN 'Low level'
WHEN job_category = 'laborers and helpers' THEN 'Low level'
WHEN job_category = 'Technicians' THEN 'Low level'
ELSE 'non job category'
END 
)    
  
SELECT DISTINCT race
FROM companies_eeo

--Exploratory analysis on the dataset 

--Gender representation at job levels
SELECT DISTINCT gender, SUM (count), job_level
FROM companies_eeo
WHERE  race <> 'Overall_totals' AND job_level <> 'non job category'
GROUP BY gender, job_level
ORDER BY job_level, SUM(count) DESC

--Race representation among female high level  jobs
SELECT SUM (count), race,job_level
FROM companies_eeo
WHERE race <> 'Overall_totals' AND job_level <> 'non job category'
AND gender = 'female' AND job_level ='High level'
GROUP BY race, job_level

--Race representation among male high level jobs
SELECT SUM (count), race,job_level
FROM companies_eeo
WHERE race <> 'Overall_totals' AND job_level <> 'non job category'
AND gender = 'male' AND job_level ='High level'
GROUP BY race, job_level

-- Race representation among female mid level jobs
SELECT SUM (count), race
FROM companies_eeo
WHERE race <> 'Overall_totals' AND job_level <> 'non job category'
AND gender = 'female' AND job_level ='Mid level'
GROUP BY race

--Race representation among male mid level jobs
SELECT SUM (count), race
FROM companies_eeo
WHERE race <> 'Overall_totals' AND job_level <> 'non job category'
AND gender = 'male' AND job_level ='Mid level'
GROUP BY race

--Race representation among female low level jobs
SELECT SUM (count), race
FROM companies_eeo
WHERE race <> 'Overall_totals' AND job_level <> 'non job category'
AND gender = 'female' AND job_level ='Low level'
GROUP BY race

--Race representation among male low level jobs
SELECT SUM (count), race
FROM companies_eeo
WHERE race <> 'Overall_totals' AND job_level <> 'non job category'
AND gender = 'male' AND job_level ='Low level'
GROUP BY race


-- Total race representation at all job levels
SELECT DISTINCT race, SUM (count), job_level
FROM companies_eeo
WHERE  race <> 'Overall_totals' AND job_level <> 'non job category' 
GROUP BY race, job_level
ORDER BY job_level, SUM(count) DESC


--Total count of hires at all job levels
SELECT COUNT (count), job_level
FROM companies_eeo
WHERE  race <> 'Overall_totals' AND job_level <> 'non job category'
GROUP BY job_level

-- Total sum of hires at job levels
SELECT  SUM(count), job_level
FROM companies_eeo
WHERE  race <> 'Overall_totals' AND job_level <> 'non job category'
AND count <> 0
GROUP BY job_level

--Some more analysis but won't be visualised

--Genders vs levels
--Showing the count of genders that populate each level

SELECT
SUM (
CASE 
    WHEN job_level = 'High level'  
    AND gender = 'female'
    AND count <> 0
    THEN 1
    ELSE 0
    END) AS high_level_female,
 SUM (
CASE 
    WHEN job_level = 'High level'  
    AND gender = 'male'
    AND count <> 0
    THEN 1
    ELSE 0
    END) AS high_level_male,
SUM (
CASE 
    WHEN job_level = 'Mid level'  
    AND gender = 'female'
    AND count <> 0
    THEN 1
    ELSE 0
    END) AS mid_level_female,
 SUM (
CASE 
    WHEN job_level = 'Mid level'  
    AND gender = 'male'
    AND count <> 0
    THEN 1
    ELSE 0
    END) AS mid_level_male,
SUM (
CASE 
    WHEN job_level = 'Low level'  
    AND gender = 'female'
    AND count <> 0
    THEN 1
    ELSE 0
    END) AS low_level_female,
 SUM (
CASE 
    WHEN job_level = 'Low level'  
    AND gender = 'male'
    AND count <> 0
    THEN 1
    ELSE 0
    END) AS low_level_male
FROM companies_eeo

-- Are there companies who have no white person in high level jobs?
SELECT COUNT (*)
FROM companies_eeo
WHERE race = 'White' 
AND job_level = 'High level' AND count = 0
        --Shows no female high level employee in pinterest


-- Disparity between male and female hires whose race is white
SELECT SUM(count), job_level, gender, race
FROM companies_eeo
WHERE race = 'White' 
AND job_level = 'High level' 
AND race <> 'Overall_totals'
GROUP BY race, job_level, gender

SELECT SUM (count) OVER (PARTITION BY gender), gender, race
FROM companies_eeo
WHERE race = 'White' 
AND count <> 0 



-- Count of african american and white hires
-- Based on gender and job level (High and low level only).

SELECT
SUM (
CASE 
    WHEN job_level = 'High level' 
    AND race = 'Black_or_African_American' 
    AND gender = 'female'
    AND count <> 0
    THEN 1
    ELSE 0
    END) AS high_level_black_female,
    
SUM (
CASE 
    WHEN job_level = 'High level' 
    AND race = 'Black_or_African_American' 
    AND gender = 'male'
    AND count <> 0
    THEN 1
    ELSE 0
    END) AS high_level_black_male,

SUM (
CASE 
    WHEN job_level = 'High level' 
    AND race = 'White' 
    AND gender = 'female'
    AND count <> 0
    THEN 1
    ELSE 0
    END) AS high_level_white_female,
    
SUM (
CASE 
    WHEN job_level = 'High level' 
    AND race = 'White' 
    AND gender = 'male'
    AND count <> 0
    THEN 1
    ELSE 0
    END) AS high_level_white_male,
    
SUM (
CASE 
    WHEN job_level = 'Low level' 
    AND race = 'Black_or_African_American' 
    AND gender = 'female'
    AND count <> 0
    THEN 1
    ELSE 0
    END) AS Low_level_black_female,   
    
SUM (
CASE 
    WHEN job_level = 'Low level' 
    AND race = 'Black_or_African_American' 
    AND gender = 'male'
    AND count <> 0
    THEN 1
    ELSE 0
    END) AS Low_level_black_male,
    
    SUM (
CASE 
    WHEN job_level = 'Low level' 
    AND race = 'White' 
    AND gender = 'male'
    AND count <> 0
    THEN 1
    ELSE 0
    END) AS Low_level_white_male,
    
SUM (
CASE 
    WHEN job_level = 'Low level' 
    AND race = 'White' 
    AND gender = 'female'
    AND count <> 0
    THEN 1
    ELSE 0
    END) AS Low_level_white_female
    FROM companies_eeo

