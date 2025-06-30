create database HR_project;
use hr_project;
select * from hr_1;
select * from hr_2;

#Q1 Average Attrition Department wise
select ifnull(Department, "Grand_avg_attrition_rate") as Department,
concat(round(sum(case when Attrition = "Yes" then 1 else 0 end)*100/count(Attrition),2), "%") as Attrition_Rate from hr_1
group by Department with rollup;

#Q2 Average hourly rate for Male Research Scientists
select concat("₹ ", round(avg(HourlyRate),2)) Avg_hr_rate_Male_research_scientist from hr_1
where JobRole = "Research Scientist" and Gender = "Male"; 

#Q3 Attrition Rate Vs Monthly Income Stats
select ifnull(MonthlyIncomeStats, "Grand_avg_attrition_rate") as MonthlyIncomeStats,
concat(round(avg(case when h1.Attrition = "Yes" then 1 else 0 end)*100, 2),"%") Avg_Attrition_Rate
from (
select EmployeeID,
case when MonthlyIncome between 0 and 10000 then '0-10000'
when MonthlyIncome between 10001 and 20000 then '10001-20000'
when MonthlyIncome between 20001 and 30000 then '20001-30000'
when MonthlyIncome between 30001 and 40000 then '30001-40000'
else '40001-51000'
end as MonthlyIncomeStats from hr_2) as income_bins
join hr_1 h1 on income_bins.EmployeeID = h1.EmployeeNumber
group by MonthlyIncomeStats with rollup;

#Q4 Average Working Years for each department
select ifnull(a.Department, 'Grand_avg_total_working_years') as Department,
round(avg(b.TotalWorkingYears),2)Avg_Working_Years
from hr_1 as a join hr_2 as b
on a.EmployeeNumber = b.EmployeeID
group by a.Department with rollup;

#Q5 Job Role Vs Work Life Balance
select ifnull(a.JobRole, 'Grand_avg_Work_life_balance') as JobRole, 
round(avg(b.WorkLifeBalance),2)Work_Life_Balance
from hr_1 as a join hr_2 as b
on a.EmployeeNumber = b.EmployeeID
group by a.JobRole with rollup;

#Q6 Attrition Rate Vs Year since Last Promotion Relation
select ifnull(Last_Promotion_bins.YearsSinceLastPromotionStats, "Grand_avg_Attrition_Rate") YearsSinceLastPromotion, 
concat(round(avg(case when h1.Attrition = "Yes" then 1 else 0 end)*100, 2),"%") Avg_Attrition_Rate
from (
select EmployeeID,
case when YearsSinceLastPromotion between 0 and 8 then '00-08'
when YearsSinceLastPromotion between 9 and 16 then '09-16'
when YearsSinceLastPromotion between 17 and 24 then '17-24'
when YearsSinceLastPromotion between 25 and 32 then '25-32'
else '33-40'
end as YearsSinceLastPromotionStats from hr_2) as Last_Promotion_bins
join hr_1 h1 on Last_Promotion_bins.EmployeeID = h1.EmployeeNumber
group by Last_Promotion_bins.YearsSinceLastPromotionStats with rollup;

#Q7 Department Male-Female share
select ifnull(Department, "Grand_total_percentage") as Department, 
concat(round(sum(case when Gender = "Male" then 1 else 0 end)*100/count(Gender),2), "%") as Male_perentage,
concat(round(sum(case when Gender = "Female" then 1 else 0 end)*100/count(Gender),2), "%") as Female_percentage
from hr_1 group by Department with rollup;

#Q8 Monthly Salary Vs Overtime
select 
  ifnull(MonthlyIncomeStats, "Grand_Total_count") as MonthlyIncomeStats,
  concat(round(count(case when OverTime = 'Yes' then 1 end) / 1000, 2), ' K') as Yes_overtime,
  concat(round(count(case when OverTime = 'No' then 1 end) / 1000, 2), ' K') as No_overtime
from (
  select 
    OverTime,
    case 
      when MonthlyIncome between 0 and 10000 then '0-10000'
      when MonthlyIncome between 10001 and 20000 then '10001-20000'
      when MonthlyIncome between 20001 and 30000 then '20001-30000'
      when MonthlyIncome between 30001 and 40000 then '30001-40000'
      else '40001-51000' 
    end as MonthlyIncomeStats
  from hr_2
) as income_bins
group by MonthlyIncomeStats
with rollup;