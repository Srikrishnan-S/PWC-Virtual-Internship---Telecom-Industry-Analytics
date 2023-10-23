-- DIVERSITY & INCLUSION ANALYSIS :
---------------------------------------------------------------------------

SELECT * FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset;

---------------------------------------------------------------------------

-- TRANSFORMATION : Last_hrie_date from varchar to date
SELECT *
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset;

ALTER TABLE PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
ALTER COLUMN Last_hire_date DATE;

UPDATE PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
SET Last_hire_date = CAST(Last_hire_date AS DATE)

ALTER TABLE PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
ALTER COLUMN FY19_Performance_Rating INT;

ALTER TABLE PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
ALTER COLUMN FY20_Performance_Rating INT;

------------------------------------------------------------------------------------------------------------------------------------------------------

-- ANALYSIS:

SELECT *
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset;

-- TOTAL EMPLOYEE FY20 :
SELECT
	COUNT(Employee_ID) AS Total_Employee_Count
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset;

---------------------------------------------------------------------------

-- TOTAL EMPLOYEE FY21 :
SELECT
	SUM(CASE WHEN FY20_leaver = 'No' THEN 1 ELSE 0 END) AS Total_Employee_FY21
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset;

---------------------------------------------------------------------------

-- EMPLOYEE FY20 BY GENDER :
SELECT
	Gender, 
	COUNT(Employee_ID) AS Total_Employee_Count
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
GROUP BY Gender;

---------------------------------------------------------------------------

-- TOTAL EMPLOYEE FY21 BY GENDER :
SELECT
	Gender, 
	SUM(CASE WHEN FY20_leaver = 'No' THEN 1 ELSE 0 END) AS Total_Employee_FY21
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
GROUP BY Gender;

---------------------------------------------------------------------------

-- EMPLOYEE FY20 PERCENTAGE BY GENDER :
SELECT
	Gender, 
	CEILING(SUM(CASE WHEN FY20_leaver = 'No' THEN 1 ELSE 0 END) * 100 / (
	SELECT SUM(CASE WHEN FY20_leaver = 'No' THEN 1 ELSE 0 END) FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset))
	AS Employee_FY21
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
GROUP BY Gender;

---------------------------------------------------------------------------

-- EMPLOYEE FY21 PERCENTAGE BY GENDER :
SELECT
	Gender, 
	CEILING(COUNT(DISTINCT Employee_ID) * 100 / (SELECT COUNT(DISTINCT Employee_ID) FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset)) AS Employee_Count_Rate
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
GROUP BY Gender;

---------------------------------------------------------------------------

-- PROMOTION BY GENDER FY20 :
SELECT
	Promotion_in_FY20, 
	Gender, 
	SUM(CASE WHEN New_hire_FY20 = 'N' THEN 1 ELSE 0 END) AS Promotion_For_FY20
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
GROUP BY Gender, Promotion_in_FY20;

---------------------------------------------------------------------------

-- EMPLOYEE COUNT BY GENDER AFTER FY20 PROMOTION :
SELECT 
	Job_Level_after_FY20_promotions, 
	Gender, 
	COUNT(Employee_ID) AS Employee_FY20
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
GROUP BY Gender, Job_Level_after_FY20_promotions;

---------------------------------------------------------------------------

-- EMPLOYEE COUNT BY GENDER AFTER FY21 PROMOTION :
SELECT 
	Job_Level_after_FY21_promotions, 
	Gender, 
	SUM(CASE WHEN FY20_leaver = 'No' THEN 1 ELSE 0 END) AS Employee_FY21
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
GROUP BY Gender, Job_Level_after_FY21_promotions
HAVING SUM(CASE WHEN FY20_leaver = 'No' THEN 1 ELSE 0 END) > 0;

---------------------------------------------------------------------------

-- PROMOTION BY GENDER IN FY20 :
SELECT 
	SUM(CASE WHEN New_hire_FY20 = 'N' THEN 1 ELSE 0 END) AS EmployeE_Promotion_FY20
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
GROUP BY Promotion_in_FY20, Gender;

---------------------------------------------------------------------------

-- PROMOTION BY GENDER FY21 :
SELECT
	COUNT(DISTINCT Employee_ID) AS Employee_Promotion_FY21
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
GROUP BY Promotion_in_FY21, Gender;

---------------------------------------------------------------------------

-- PROMOTION RATE IN FY20 :
SELECT
	SUM(CASE WHEN New_hire_FY20 = 'N' AND Promotion_in_FY20 = 'Y' THEN 1 ELSE 0 END) * 100 / (
	SELECT SUM(CASE WHEN New_hire_FY20 = 'N' THEN 1 ELSE 0 END)) AS Promotion_Rate_FY20
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset;

---------------------------------------------------------------------------

-- PROMOTION RATE IN FY20 BY GENDER :
-- MALE
SELECT 
	SUM(CASE WHEN New_hire_FY20 = 'N' AND Promotion_in_FY20 = 'Y' AND Gender = 'Male' THEN 1 ELSE 0 END) * 100 / (
	SELECT SUM(CASE WHEN New_hire_FY20 = 'N' AND Promotion_in_FY20 = 'Y' THEN 1 ELSE 0 END)) AS Promotion_Rate_FY20_Male
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset;

-- FEMALE :
SELECT 
	SUM(CASE WHEN New_hire_FY20 = 'N' AND Promotion_in_FY20 = 'Y' AND Gender = 'Female' THEN 1 ELSE 0 END) * 100 / (
	SELECT SUM(CASE WHEN New_hire_FY20 = 'N' AND Promotion_in_FY20 = 'Y' THEN 1 ELSE 0 END)) AS Promotion_Rate_FY20_Female
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset;

---------------------------------------------------------------------------

-- PROMOTION RATE IN FY21 :
SELECT
	SUM(CASE WHEN Promotion_in_FY21 = 'Yes' THEN 1 ELSE 0 END) * 100 / (
	SELECT
		SUM(CASE WHEN In_base_group_for_Promotion_FY21 = 'Yes' THEN 1 ELSE 0 END)
	FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset) AS Promotion_Rate_FY21
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset;

SELECT * FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset;
---------------------------------------------------------------------------

-- PROMOTION RATE IN FY21 BY GENDER :
-- MALE
SELECT 
	SUM(CASE WHEN Promotion_in_FY21 = 'Yes' AND Gender = 'Male' THEN 1 ELSE 0 END) * 100 / (
	SELECT SUM(CASE WHEN Promotion_in_FY21 = 'Yes' THEN 1 ELSE 0 END)) AS Promotion_Rate_FY21_Male
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset;

-- FEMALE :
SELECT 
	SUM(CASE WHEN Promotion_in_FY21 = 'Yes' AND Gender = 'Female' THEN 1 ELSE 0 END) * 100 / (
	SELECT SUM(CASE WHEN Promotion_in_FY21 = 'Yes' THEN 1 ELSE 0 END)) AS Promotion_Rate_FY21_Female
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset;

---------------------------------------------------------------------------

-- HIRING RATE FY20 :
WITH HiringRate AS(
	SELECT
		COUNT(DISTINCT Employee_ID) AS Total_Employee, 
		SUM(CASE WHEN New_hire_FY20 = 'Y' THEN 1 ELSE 0 END) AS New_Hire_Count, 
		SUM(CASE WHEN New_hire_FY20 = 'N' THEN 1 ELSE 0 END) AS Old_Count
	FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
)
SELECT 
	(New_Hire_Count * 100) / ((Total_Employee + Old_Count)/2) AS Hiring_Rate_FY20
FROM HiringRate;

---------------------------------------------------------------------------

-- HIRING RATE FY20 BY GENDER :
WITH HiringRateGedner AS(
	SELECT
		Gender, 
		COUNT(DISTINCT Employee_ID) AS Total_Employee, 
		SUM(CASE WHEN New_hire_FY20 = 'Y' THEN 1 ELSE 0 END) AS New_Hire_Count, 
		SUM(CASE WHEN New_hire_FY20 = 'N' THEN 1 ELSE 0 END) AS Old_Count
	FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
	GROUP BY Gender
)
SELECT 
	Gender, 
	CEILING((New_Hire_Count * 100) / ((Total_Employee + Old_Count)/2)) AS Hiring_Rate_FY20
FROM HiringRateGedner;

---------------------------------------------------------------------------

-- EMPLOYEE EXIT RATE:
WITH ExitRate AS(
	SELECT
		COUNT(DISTINCT Employee_ID) AS Total_Employee, 
		SUM(CASE WHEN FY20_leaver = 'Yes' THEN 1 ELSE 0 END) AS New_Hire_Count, 
		SUM(CASE WHEN New_hire_FY20 = 'N' THEN 1 ELSE 0 END) AS Old_Count
	FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
)
SELECT 
	(New_Hire_Count * 100) / ((Total_Employee + Old_Count)/2) AS Hiring_Rate_FY20
FROM ExitRate;

---------------------------------------------------------------------------

-- EMPLOYEE EXIT RATE BY GENDER:
WITH ExitRateGender AS (
    SELECT
        Gender, 
        COUNT(DISTINCT Employee_ID) AS Total_Employee, 
        SUM(CASE WHEN FY20_leaver = 'Yes' THEN 1 ELSE 0 END) AS Leaver_Count, 
        SUM(CASE WHEN New_hire_FY20 = 'N' THEN 1 ELSE 0 END) AS Old_Count
    FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
    GROUP BY Gender
)

SELECT 
    Gender, 
    CEILING((Leaver_Count * 100.0) / ((Total_Employee + Old_Count)/2)) AS Exit_Rate_FY20
FROM ExitRateGender;

---------------------------------------------------------------------------

-- PERFORMANCE RATING IN FY19 BY GENDER AND JOB LEVEL:
SELECT
	Job_Level_before_FY20_promotions, Gender,
	AVG(CASE WHEN New_hire_FY20 = 'N' THEN FY19_Performance_Rating ELSE 0 END) AS Performance_Rating_FY19
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
GROUP BY Job_Level_before_FY20_promotions, Gender
HAVING AVG(CASE WHEN New_hire_FY20 = 'N' THEN FY19_Performance_Rating ELSE 0 END) > 0;

---------------------------------------------------------------------------

-- AVERAGE OF PERFORMANCE RATING IN FY19 :
SELECT
	AVG(FY19_Performance_Rating) AS Performance_Rating_FY19
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
WHERE New_hire_FY20 = 'N';


---------------------------------------------------------------------------

-- AVERAGE PERFORMANCE RATING BY GENDER IN FY19 :
SELECT
	Gender, 
	AVG(FY19_Performance_Rating) AS Performance_Rating_FY19
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
WHERE New_hire_FY20 = 'N'
GROUP BY Gender;

---------------------------------------------------------------------------

-- PERFORMANCE RATING IN FY20 BY GENDER AND JOB LEVEL :
SELECT 
	Job_Level_after_FY20_promotions, 
	Gender, 
	AVG(FY20_Performance_Rating) AS Performance_Rating_FY20
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
GROUP BY Job_Level_after_FY20_promotions, Gender;

---------------------------------------------------------------------------

-- AVERAGE PERFORMANCE RATING IN FY20 :
SELECT 
	AVG(FY20_Performance_Rating) AS Performance_Rating_FY20
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset;

---------------------------------------------------------------------------

-- AVERAGE PERFORMANCE RATING BY GENDER IN FY20 :
SELECT 
	Gender, 
	AVG(FY20_Performance_Rating) AS Performance_Rating_FY20
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
GROUP BY Gender;

---------------------------------------------------------------------------

-- AGE GROUP BY GENDER :
SELECT
	Gender, 
	Age_group, 
	COUNT(DISTINCT Employee_ID) AS Employee_Count
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
GROUP BY Gender, Age_group;

---------------------------------------------------------------------------

-- AGE GROUP BY EXECUTIVE LEVEL BY GENDER :
SELECT
	Gender, 
	Age_group, 
	COUNT(DISTINCT Employee_ID) AS Employee_Count_at_Executive_Level
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
WHERE Job_Level_after_FY20_promotions = '1 - Executive'
GROUP BY Gender, Age_group;

---------------------------------------------------------------------------

-- REGION BY GENDER :
SELECT
	Gender, 
	[Region group  nationality 1], 
	COUNT(DISTINCT Employee_ID) AS Employee_Count
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
GROUP BY Gender, [Region group  nationality 1];

---------------------------------------------------------------------------

-- REGION BY EXECUTIVE LEVEL BY GENDER :
SELECT
	[Region group  nationality 1], 
	Age_group, 
	COUNT(DISTINCT Employee_ID) AS Employee_Count_at_Executive_Level
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
WHERE Job_Level_after_FY20_promotions = '1 - Executive'
GROUP BY [Region group  nationality 1], Age_group;

---------------------------------------------------------------------------

-- JOB TYPE BY GENDER :
SELECT
	Gender, 
	Time_type, 
	COUNT(DISTINCT Employee_ID) AS Employee_Count
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
GROUP BY Gender, Time_type;

---------------------------------------------------------------------------

-- JOB TYPE BY EXECUTIVE LEVEL BY GENDER :
SELECT
	Time_type, 
	Gender, 
	COUNT(DISTINCT Employee_ID) AS Employee_Count_at_Executive_Level
FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset
WHERE Job_Level_after_FY20_promotions = '1 - Executive'
GROUP BY Time_type, Gender;

---------------------------------------------------------------------------

SELECT * FROM PWC_DataAnalytics.dbo.DiversityInclusion_Dataset;

---------------------------------------------------------------------------
