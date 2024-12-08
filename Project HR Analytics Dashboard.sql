Create database Human_resources_analytics;
Use Human_resources_analytics;
CREATE TABLE hr_1 (
  `Age` int DEFAULT NULL,
  `Attrition` Varchar(50),
  `BusinessTravel` Varchar(50),
  `DailyRate` int DEFAULT NULL,
  `Department` Varchar(50),
  `DistanceFromHome` int DEFAULT NULL,
  `Education` int DEFAULT NULL,
  `EducationField` Varchar(50),
  `EmployeeCount` int DEFAULT NULL,
  `EmployeeNumber` int DEFAULT NULL,
  `EnvironmentSatisfaction` int DEFAULT NULL,
  `Gender` Varchar(50),
  `HourlyRate` int DEFAULT NULL,
  `JobInvolvement` int DEFAULT NULL,
  `JobLevel` int DEFAULT NULL,
  `JobRole` Varchar(50),
  `JobSatisfaction` int DEFAULT NULL,
  `MaritalStatus`Varchar(50));
  
  CREATE TABLE `hr_2` (
  `Employee ID` int DEFAULT NULL,
  `MonthlyIncome` int DEFAULT NULL,
  `MonthlyRate` int DEFAULT NULL,
  `NumCompaniesWorked` int DEFAULT NULL,
  `Over18` Varchar(50),
  `OverTime` Varchar(50),
  `PercentSalaryHike` int DEFAULT NULL,
  `PerformanceRating` int DEFAULT NULL,
  `RelationshipSatisfaction` int DEFAULT NULL,
  `StandardHours` int DEFAULT NULL,
  `StockOptionLevel` int DEFAULT NULL,
  `TotalWorkingYears` int DEFAULT NULL,
  `TrainingTimesLastYear` int DEFAULT NULL,
  `WorkLifeBalance` int DEFAULT NULL,
  `YearsAtCompany` int DEFAULT NULL,
  `YearsInCurrentRole` int DEFAULT NULL,
  `YearsSinceLastPromotion` int DEFAULT NULL,
  `YearsWithCurrManager` int DEFAULT NULL);
  Drop Table hr_2;
load data infile 'HR_2.csv' into table hr_2
fields terminated by ","
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

select @@secure_file_priv;

load data infile 'HR_1.csv' into table hr_1
fields terminated by ","
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

#Create view Total_Employees AS
Select Count(EmployeeCount) As Total_Employees 
from Hr_1;

#Create view Total_Departments AS
Select count(distinct(department)) As Total_Departments 
from Hr_1;

#Create view Total_Education AS
Select count(distinct(Education)) As Total_Education 
from Hr_1;

#Create view Total_JobRoles AS
Select count(distinct(JobRole)) As Total_JobRoles 
from Hr_1;

#Create view Average_Yearsatcompany AS
select avg(YearsAtCompany) As Average_Yearsatcompany 
From Hr_2;

#Create view Workforce_Tower AS
Select Gender, Count(EmployeeCount)
from Hr_1
Group by Gender;

# 1.Average Attrition rate for all Departments

#Create view Average_Attrition_rate_for_all_Departments as
select Department,(sum(case Attrition when 'yes' then 1 else 0 end)) as avg_attrition 
from hr_1 
group by department
order by department ;

# 2.Average Hourly rate of Male Research Scientist   

#Create view Average_Hourly_rate_of_Male_Research_Scientist AS
select Gender, JobRole, avg(HourlyRate) as avg_hourlyrate FROM hr_1 
where gender='male'and jobrole="research scientist";

# 3.Attrition rate Vs Monthly income stats      

SELECT
    hr_1.Attrition,
    COUNT(*) AS CountOfEmployees,
    AVG(hr_2.MonthlyIncome) AS AverageMonthlyIncome,
    MAX(hr_2.MonthlyIncome) AS MaxMonthlyIncome,
    MIN(hr_2.MonthlyIncome) AS MinMonthlyIncome,
    SUM(hr_2.MonthlyIncome) AS TotalMonthlyIncome
FROM hr_1
INNER JOIN hr_2 ON hr_1.Employeenumber = hr_2.`Employee ID`
GROUP BY hr_1.Attrition;

# 4.Average working years for each Department
#Create View Average_working_years_for_each_Department AS
select hr_1.Department ,avg(hr_2.YearsAtCompany) as avg_work_year 
from  hr_1
inner join hr_2
on hr_1.EmployeeNumber = hr_2.`Employee ID`
group by hr_1.Department;
 
 -- 5.Job Role Vs Work life balance

select hr_1.jobrole, avg(hr_2.worklifebalance) as avg_worklife_balance
from hr_1 inner join hr_2 on hr_1.employeenumber = hr_2.`Employee ID`
group by hr_1.jobrole
order by avg_worklife_balance desc;

-- 6. Attrition rate Vs Year since last promotion relation
SELECT hr_2.YearsSinceLastPromotion, 
       COUNT(*) AS TotalEmployees,
       SUM(CASE WHEN hr_1.Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritedEmployees,
       (SUM(CASE WHEN hr_1.Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRatePercent
FROM hr_1 inner join hr_2 on hr_1.employeenumber = hr_2.`Employee ID`
GROUP BY hr_2.YearsSinceLastPromotion
ORDER BY hr_2.YearsSinceLastPromotion;