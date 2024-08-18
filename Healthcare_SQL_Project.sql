
-- getting every data from the table
select * from PortfolioProject..healthcare 

-- Deleted table which was a cloned 
alter table healthcare 
drop column name  

-- chaging the date format 

select cast(dateofadmission as date) as admission_date from healthcare 


alter table healthcare 
add Admissiondate date;

update healthcare 
set Admissiondate = cast(dateofadmission as date)   


alter table healthcare 
add Discharge_date date;


update healthcare 
set Discharge_date = Convert(date,Dischargedate )   



alter table healthcare 
drop column dateofadmission , Dischargedate    

-- lets check the count of patients with different medical Condition 
select count(*) as total ,MedicalCondition , 
from healthcare
Group by MedicalCondition 
order by total desc


-- lets cehck the count of patients with different blood group 
select   BloodType,  count(*) as total 
from healthcare
Group by BloodType 
order by total desc;


---- lets cehck the count of patients based on thier gender ,  medical condition and bloodtype
select  Gender ,  Medicalcondition , BloodType , count(*) as total 
from healthcare
Group by Gender,Medicalcondition,BloodType
order by total desc; 



-- Getting Details of patient named Scott Harris 

select distinct * from healthcare 
where name = 'Scott Harris'


-- lets check the count of Issurance provided by Issurance Providers 
select  InsuranceProvider ,  count(*) as total 
from healthcare
Group by InsuranceProvider
order by total desc;


-- Write an SQL query to list all patients who have been diagnosed with "Obesity". 

select  distinct * from healthcare 
where MedicalCondition =  'Obesity'

-- Write an SQL query to find the names and admission details of patients who were admitted on '2022-09-22'. 

select distinct * from healthcare 
where admissiondate = '2022-09-22' 

-- Write an SQL query to calculate the total billing amount grouped by each insurance provider. 

select InsuranceProvider , sum(cast(BillingAmount as bigint)) as Total 
from healthcare 
group by InsuranceProvider 
order by total desc  


-- Write an SQL query to identify the doctor(s) who handled the most patient admissions. 

select doctor , count(*) as numofaddmission from healthcare 
group by doctor 
order by numofaddmission desc

-- : Write an SQL query to list all patients diagnosed with "Obesity" who are between the ages of 50 and 70, and also display their admission hospital.


select * from healthcare 
where MedicalCondition = 'Obesity' and Age Between 50 and  70  
order by age  

-- how much doctors does each hospital has ?

select  distinct count(doctor) as count_of_dr , Hospital  
from PortfolioProject..healthcare 
Group by Hospital  
order by count_of_dr desc;

-- Write an SQL query to retrieve the names and admission details of patients with blood type 'A+' who were admitted within the last year. 

select * from healthcare 
where BloodType = 'A+' and Admissiondate >=  '2023-01-01' 
order by Admissiondate  

-- write an SQL query to calculate the average billing amount for each medical condition and then list the patients whose billing amount is more than twice the average for their respective condition.


WITH AvgBilling AS (
  SELECT MedicalCondition, AVG(BillingAmount) AS AvgAmount
  FROM healthcare
  GROUP BY MedicalCondition
)
SELECT h.Name, h.MedicalCondition, h.BillingAmount, a.AvgAmount
FROM healthcare h
JOIN AvgBilling a ON h.MedicalCondition = a.MedicalCondition
WHERE h.BillingAmount > 2 * a.AvgAmount;




-- test reults based on different medical condition 

select medicalcondition , testresults ,count(*) as total 
from PortfolioProject..healthcare
group by medicalcondition , testresults 
order by total desc;


-- create a age group column based on thier medical conditon 

WITH agegroup AS (
    SELECT 
        MedicalCondition,
        age,
        CASE 
            WHEN age <= 30 THEN 'Adult' 
            WHEN age <= 60 THEN 'MiddleAged'
            ELSE 'OldAged' 
        END AS age_group
    FROM PortfolioProject..healthcare 
)

SELECT 
    a.age_group, 
    h.MedicalCondition, 
    COUNT(*) AS total 
FROM PortfolioProject..healthcare h
JOIN agegroup a 
    ON h.MedicalCondition = a.MedicalCondition
GROUP BY 
    a.age_group, 
    h.MedicalCondition 
ORDER BY 
    a.age_group DESC;

--Use a CTE to calculate the average age of patients for each medical condition in the dataset.

WITH patient_data AS (
    SELECT 
        MedicalCondition,
        age
    FROM PortfolioProject..healthcare
)
SELECT 
    MedicalCondition,
    AVG(age) AS average_age
FROM patient_data
GROUP BY MedicalCondition
ORDER BY average_age DESC;

-- Identify medical conditions where more than 50% of the patients are classified as 'OldAged'.
WITH age_group as (
select medicalcondition ,
				age,
		case
			when age <= 30 then 'Adult' 
			when age <=  60 then 'MiddleAged'
			else 'OldAged' End as agegroup
			from PortfolioProject..healthcare
		) 

-- Write a query to find the percentage distribution of each age group ('Adult', 'MiddleAged', 'OldAged') within each medical condition.

WITH agegroup AS (
    SELECT 
        MedicalCondition,
        CASE 
            WHEN age <= 30 THEN 'Adult' 
            WHEN age <= 60 THEN 'MiddleAged'
            ELSE 'OldAged' 
        END AS age_group
    FROM PortfolioProject..healthcare 
),
group_counts AS (
    SELECT 
        MedicalCondition,
        age_group,
        COUNT(*) AS group_count
    FROM agegroup
    GROUP BY MedicalCondition, age_group
),
total_counts AS (
    SELECT 
        MedicalCondition,
        SUM(group_count) AS total_count
    FROM group_counts
    GROUP BY MedicalCondition
)
SELECT 
    g.MedicalCondition,
    g.age_group,
    g.group_count,
    t.total_count,
    (CAST(g.group_count AS FLOAT) / t.total_count) * 100 AS percentage
FROM group_counts g
JOIN total_counts t
    ON g.MedicalCondition = t.MedicalCondition
ORDER BY MedicalCondition, age_group;


-- how much doctors does each hospital has ?

select  distinct count(doctor) as count_of_dr , Hospital  
from PortfolioProject..healthcare 
Group by Hospital  
order by count_of_dr desc;


