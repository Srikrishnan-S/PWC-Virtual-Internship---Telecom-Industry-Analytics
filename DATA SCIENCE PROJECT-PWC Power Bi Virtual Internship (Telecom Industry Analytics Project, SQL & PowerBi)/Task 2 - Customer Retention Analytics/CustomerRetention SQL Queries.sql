-- RETRIEVE DATA : 

SELECT * 
FROM PWC_DataAnalytics.dbo.ChurnDataset 

------------------------------------------------------------------------------------------------------------------------------------------------------

-- DATA TRANSFORMATION or DATA CLEANING :

-- 1) COLUMN TENURE FROM VARCHAR TO INT :
ALTER TABLE ChurnDataset
ALTER COLUMN tenure INT;

-- 2) COLUMN SENIOR CITIZEN FROM VARCHAR TO INT :
ALTER TABLE ChurnDataset
ALTER COLUMN SeniorCitizen INT;

-- 3) COLUMN NUM ADMIN TICKETS FROM VARCHAR TO INT :
ALTER TABLE ChurnDataset
ALTER COLUMN numAdminTickets INT;

-- 4) COLUMN NUM TECH TICKETS FROM VARCHAR TO INT :
ALTER TABLE ChurnDataset
ALTER COLUMN numTEchTickets INT;

-- 5) COLUMN MONTHLY CHARGES FROM VARCHAR TO FLOAT :
ALTER TABLE ChurnDataset
ALTER COLUMN MonthlyCharges FLOAT;

-- 6) COLUMN TOTAL CHARGES FROM VARCHAR TO FLOAT : 
ALTER TABLE ChurnDataset
ALTER COLUMN TotalCharges FLOAT;

-- B) TRANSFORMING TENURE MONTH TO YEARS IN NEW COLUMN :
ALTER TABLE PWC_DataAnalytics.dbo.ChurnDataset
ADD tenure_years VARCHAR(50);

UPDATE PWC_DataAnalytics.dbo.ChurnDataset
SET tenure_years = tenure

UPDATE PWC_DataAnalytics.dbo.ChurnDataset
SET tenure_years =
                  CASE WHEN tenure_years <= 1 THEN 'Within 1 Month'
						WHEN tenure_years > 1 AND tenure_years <= 12 THEN '0-1 Year'
						WHEN tenure_years > 12 AND tenure_years <= 24 THEN '1-2 Year' 
						WHEN tenure_years > 24 AND tenure_years <= 36 THEN '2-3 Year' 
						WHEN tenure_years > 36 AND tenure_years <= 48 THEN '3-4 Year'
						WHEN tenure_years > 48 AND tenure_years <= 60 THEN '4-5 Year' 
						WHEN tenure_years > 60 AND tenure_years <= 72 THEN '5-6 Year'
						ELSE 'Greater than 6 Year' 
				   END
                                    


SELECT *
FROM PWC_DataAnalytics.dbo.ChurnDataset

------------------------------------------------------------------------------------------------------------------------------------------------------

-- ANALYSIS :

SELECT * 
FROM PWC_DataAnalytics.dbo.ChurnDataset;

-- 1) SUMMARY ANALYSIS :

-- 1.1) TOTAL CUSTOMER COUNT :
SELECT COUNT(customerID) AS Total_Customer_Count
FROM PWC_DataAnalytics.dbo.ChurnDataset;

-- 1.1.1) CUSTOMER COUNT BY CHURN :
SELECT COUNT(customerID) AS Churn_Customer_Count
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes';

-- 1.1.2) CUSTOMER COUNT BY TENURE :
SELECT tenure_years, COUNT(customerID) AS Churn_Customer_Count
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY tenure_years;

---------------------------------------------------------------------------

-- 1.2) CHURN RATE :
SELECT 
	(COUNT(CASE WHEN Churn = 'Yes' THEN customerID ELSE NULL END) * 100) / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset) AS Churn_Rate
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes';

-- 1.2.1) CHURN RATE BY TENURE :
SELECT 
	tenure_years, 
	(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)) * 100 / COUNT(DISTINCT customerID) AS Churn_Rate
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY tenure_years;

---------------------------------------------------------------------------

-- 1.3) TOTAL ADMIN TICKETS :
SELECT
	SUM(numAdminTickets) AS Total_Admin_Tickets
FROM PWC_DataAnalytics.dbo.ChurnDataset;

-- 1.3.1) TOTAL ADMIN TICKETS BY CHURN :
SELECT
	Churn,
	SUM(CASE WHEN Churn = 'Yes' THEN numAdminTickets 
		WHEN Churn = 'No' THEN numAdminTickets ELSE NULL END) AS Total_Admin_Tickets_by_Churn
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes' OR Churn = 'No'
GROUP BY Churn;

-- 1.3.2) TOTAL ADMIN TICKETS BY TENURE :
SELECT
	tenure_years, 
	SUM(numAdminTickets) AS Total_Admin_Tickets_by_Tenure
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY tenure_years;

---------------------------------------------------------------------------

-- 1.4) TOTAL TECH TICKETS :
SELECT 
	SUM(numTechTickets) AS Total_Tech_Tickets
FROM PWC_DataAnalytics.dbo.ChurnDataset;
	
-- 1.4.1) TOTAL TECH TICKETS BY CHURN :
SELECT
	Churn, 
	SUM(CASE WHEN Churn = 'Yes' THEN numTechTickets
		WHEN Churn = 'No' THEN numTechTickets
		ELSE NULL END) AS Total_Tech_Tickets_by_Churn
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes' OR Churn = 'No'
GROUP BY Churn;

-- 1.4.2) TOTAL TECH TICKETS BY TENURE :
SELECT
	tenure_years, 
	SUM(numTechTickets) AS Total_Tech_Tickets_by_Tenure
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY tenure_years;

---------------------------------------------------------------------------

-- 1.5) AVERAGE MONTHLY CHARGE :
SELECT ROUND(AVG(MonthlyCharges), 1) AS Average_Monthly_Charges
FROM PWC_DataAnalytics.dbo.ChurnDataset;

-- 1.5.1) AVERAGE MONTHLY CHARGE BY CHURN :
SELECT
	Churn, 
	ROUND(AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges
				WHEN Churn = 'No' THEN MonthlyCharges
				ELSE NULL END), 1) AS Average_Monthly_Charges_by_Churn
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes' OR Churn = 'No'
GROUP BY Churn;

-- 1.5.2) AVERAGE MONTHLY CHARGE BY TENURE :
SELECT
	tenure_years, 
	ROUND(AVG(MonthlyCharges), 1) AS Average_Monthly_Charges_by_Tenure
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY tenure_years;

---------------------------------------------------------------------------

-- 1.6) TOTAL REVENUE :
SELECT
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset;

-- 1.6.1) TOTAL REVENUE BY CHURN :
SELECT
	Churn, 
	SUM(CASE WHEN Churn = 'Yes' THEN TotalCharges
				WHEN Churn = 'No' THEN TotalCharges
				ELSE NULL END) AS Total_Revenue_by_Churn
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes' OR Churn = 'No'
GROUP BY Churn;

-- 1.6.2) TOTAL REVENUE BY TENURE :
SELECT
	tenure_years, 
	SUM(TotalCharges) AS Total_Revenue_by_Tenure
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY tenure_years;

------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2) CUSTOMER DEMOGRAPHIC SEGMENT :

-- CUSTOMER BY GENDER :
SELECT
	gender, 
	COUNT(DISTINCT customerID) AS Total_Customer_Id
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY gender;

-- PERCENT :
SELECT
	gender, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY gender;

-- CHURN BY CUSTOMER vs GENDER :
SELECT
	gender, 
	COUNT(DISTINCT customerID) AS Total_Customer_Id
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY gender;

-- CHURN RATE BY CUSTOMER vs GENDER :
SELECT
	gender, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY gender;

-- REVENUE BY GENDER :
SELECT
	gender, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY gender;

--PERCENTAGE :
SELECT
	gender, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY gender;

-- CHURN BY REVENUE vs GENDER :
SELECT
	gender, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY gender;

-- CHURN RATE BY REVENUE vs GENDER :
SELECT
	gender, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY gender;

---------------------------------------------------------------------------

-- CUSTOMER BY SENIOR CITIZEN :
SELECT
	SeniorCitizen, 
	COUNT(DISTINCT customerID) AS Total_Customer_Id
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY SeniorCitizen;

-- PERCENT :
SELECT
	SeniorCitizen, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY SeniorCitizen;

-- CHURN BY CUSTOMER vs SENIOR CITIZEN :
SELECT
	SeniorCitizen, 
	COUNT(DISTINCT customerID) AS Total_Customer_Id
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY SeniorCitizen;

-- CHURN RATE BY CUSTOMER vs SENIOR CITIZEN :
SELECT
	SeniorCitizen, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY SeniorCitizen;

-- REVENUE BY SENIOR CITIZEN :
SELECT
	SeniorCitizen, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY SeniorCitizen;

--PERCENTAGE :
SELECT
	SeniorCitizen, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY SeniorCitizen;

-- CHURN BY REVENUE vs SENIOR CITIZEN :
SELECT
	SeniorCitizen, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY SeniorCitizen;

-- CHURN RATE BY REVENUE vs SENIOR CITIZEN :
SELECT
	SeniorCitizen, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY SeniorCitizen;
---------------------------------------------------------------------------

-- CUSTOMER BY DEPENDENTS :
SELECT
	Dependents, 
	COUNT(DISTINCT customerID) AS Total_Customer_Id
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY Dependents;

-- PERCENT :
SELECT
	Dependents, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY Dependents;

-- CHURN BY CUSTOMER vs DEPENDENTS :
SELECT
	Dependents, 
	COUNT(DISTINCT customerID) AS Total_Customer_Id
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY Dependents;

-- CHURN RATE BY CUSTOMER vs DEPENDENTS :
SELECT
	Dependents, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY Dependents;

-- REVENUE BY DEPENDENTS :
SELECT
	Dependents, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY Dependents;

--PERCENTAGE :
SELECT
	Dependents, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY Dependents;

-- CHURN BY REVENUE vs DEPENDENTS :
SELECT
	Dependents, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY Dependents;

-- CHURN RATE BY REVENUE vs DEPENDENTS :
SELECT
	Dependents, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY Dependents;

---------------------------------------------------------------------------

-- CUSTOMER BY PARTNER :
SELECT
	Partner, 
	COUNT(DISTINCT customerID) AS Total_Customer_Id
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY Partner;

-- PERCENT :
SELECT
	Partner, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY Partner;

-- CHURN BY CUSTOMER vs PARTNER :
SELECT
	Partner, 
	COUNT(DISTINCT customerID) AS Total_Customer_Id
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY Partner;

-- CHURN RATE BY CUSTOMER vs PARTNERS :
SELECT
	Partner, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY Partner;

-- REVENUE BY PARTNER :
SELECT
	Partner, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY Partner;

--PERCENTAGE :
SELECT
	Partner, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY Partner;

-- CHURN BY REVENUE vs PARTNER :
SELECT
	Partner, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY Partner;

-- CHURN RATE BY REVENUE vs PARTNERS
SELECT
	Partner, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY Partner;

------------------------------------------------------------------------------------------------------------------------------------------------------

-- 3) SERVICE SEGMENT ANALYSIS :

-- CUSTOMER BY PHONE SERVICE :
SELECT
	PhoneService, 
	COUNT(customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY PhoneService;

-- PERCENT :
SELECT
	PhoneService, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY PhoneService;

-- CHURN BY CUSTOMER vs PHONE SERVICE :
SELECT
	PhoneService, 
	COUNT(customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY PhoneService;

-- CHURN RATE BY CUSTOMER vs PHONE SERVICE :
SELECT
	PhoneService, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY PhoneService;

-- REVENUE BY PHONE SERVICE :
SELECT
	PhoneService, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY PhoneService;

--PERCENTAGE :
SELECT
	PhoneService, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY PhoneService;

-- CHURN BY REVENUE vs PHONE SERVICE :
SELECT
	PhoneService, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY PhoneService;

-- CHURN RATE BY REVENUE vs PHONE SERVICE :
SELECT
	PhoneService, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY PhoneService;

---------------------------------------------------------------------------

-- CUSTOMER BY INTERNET SERVICE :
SELECT
	InternetService, 
	COUNT(customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY InternetService;

-- PERCENT :
SELECT
	InternetService, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY InternetService;

-- CHURN BY CUSTOMER vs INTERNET SERVICE :
SELECT
	InternetService, 
	COUNT(customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY InternetService;

-- CHURN RATE BY CUSTOMER vs INTERNET SERVICE :
SELECT
	InternetService, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY InternetService;

-- REVENUE BY INTERNET SERVICE :
SELECT
	InternetService, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY InternetService;

--PERCENTAGE :
SELECT
	InternetService, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY InternetService;

-- CHURN BY REVENUE vs INTERNET SERVICE :
SELECT
	InternetService, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY InternetService;

-- CHURN RATE BY REVENUE vs INTERNET SERVICE :
SELECT
	InternetService, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY InternetService;

---------------------------------------------------------------------------

-- CUSTOMER BY MULTIPLE LINES :
SELECT
	MultipleLines, 
	COUNT(customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY MultipleLines;

-- PERCENT :
SELECT
	MultipleLines, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY MultipleLines;

-- CHURN BY CUSTOMER vs MULTIPLE LINES :
SELECT
	MultipleLines, 
	COUNT(customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY MultipleLines;

-- CHURN RATE BY CUSTOMERS vs MULTIPLE LINES :
SELECT
	MultipleLines, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY MultipleLines;

-- REVENUE BY MULTIPLE LINES :
SELECT
	MultipleLines, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY MultipleLines;

--PERCENTAGE :
SELECT
	MultipleLines, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY MultipleLines;

-- CHURN BY REVENUE vs MULTIPLE LINES :
SELECT
	MultipleLines, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY MultipleLines;

-- CHURN RATE BY REVENUE vs MULTIPLE LINES :
SELECT
	MultipleLines, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY MultipleLines;

---------------------------------------------------------------------------

-- CUSTOMER BY STREAMING TVs :
SELECT
	StreamingTV, 
	COUNT(customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY StreamingTV;

-- PERCENT :
SELECT
	StreamingTV, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY StreamingTV;

-- CHURN BY CUSTOMER vs STREAMING TVs :
SELECT
	StreamingTV, 
	COUNT(customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY StreamingTV;

-- CHURN RATE BY CUSTOMERS vs STREAMING TVs :
SELECT
	StreamingTV, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY StreamingTV;

-- REVENUE BY STREAMING TVs :
SELECT
	StreamingTV, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY StreamingTV;

--PERCENTAGE :
SELECT
	StreamingTV, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY StreamingTV;

-- CHURN BY REVENUE vs STREAMING TVs :
SELECT
	StreamingTV, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY StreamingTV;

-- CHURN RATE BY REVENUE vs STREAMING TVs :
SELECT
	StreamingTV, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY StreamingTV; 

---------------------------------------------------------------------------

-- CUSTOMER BY STREAMING MOVIES :
SELECT
	StreamingMovies, 
	COUNT(customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY StreamingMovies;

-- PERCENT :
SELECT
	StreamingMovies, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY StreamingMovies;

-- CHURN BY CUSTOMER vs STREAMING MOVIES :
SELECT
	StreamingMovies, 
	COUNT(customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY StreamingMovies;

-- CHURN RATE BY CUSTOMERS vs STREAMING MOVIES :
SELECT
	StreamingMovies, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY StreamingMovies;

-- REVENUE BY STREAMING MOVIES :
SELECT
	StreamingMovies, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY StreamingMovies;

--PERCENTAGE :
SELECT
	StreamingMovies, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY StreamingMovies;

-- CHURN BY REVENUE vs STREAMING MOVIES :
SELECT
	StreamingMovies, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY StreamingMovies;

-- CHURN RATE BY REVENUE vs STREAMING MOVIES :
SELECT
	StreamingMovies, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY StreamingMovies;

---------------------------------------------------------------------------

-- CUSTOMER BY ONLINE SECURITY :
SELECT
	OnlineSecurity, 
	COUNT(customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY OnlineSecurity;

-- PERCENT :
SELECT
	OnlineSecurity, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY OnlineSecurity;

-- CHURN BY CUSTOMER vs ONLINE SECURITY :
SELECT
	OnlineSecurity, 
	COUNT(customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY OnlineSecurity;

-- CHURN RATE BY CUSTOMERS vs ONLINE SECURITY :
SELECT
	OnlineSecurity, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY OnlineSecurity;

-- REVENUE BY ONLINE SECURITY :
SELECT
	OnlineSecurity, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY OnlineSecurity;

--PERCENTAGE :
SELECT
	OnlineSecurity, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY OnlineSecurity;

-- CHURN BY REVENUE vs ONLINE SECURITY :
SELECT
	OnlineSecurity, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY OnlineSecurity;

-- CHURN RATE BY REVENUE vs ONLINE SECURITY :
SELECT
	OnlineSecurity, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY OnlineSecurity;

---------------------------------------------------------------------------

-- CUSTOMER BY ONLINE BACKUP :
SELECT
	OnlineBackup, 
	COUNT(customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY OnlineBackup;

-- PERCENT :
SELECT
	OnlineBackup, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY OnlineBackup;

-- CHURN BY CUSTOMER vs ONLINE BACKUP :
SELECT
	OnlineBackup, 
	COUNT(customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY OnlineBackup;

-- CHURN RATE BY CUSTOMERS vs ONLINE BACKUP :
SELECT
	OnlineBackup, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY OnlineBackup;

-- REVENUE BY ONLINE SECURITY :
SELECT
	OnlineBackup, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY OnlineBackup;

--PERCENTAGE :
SELECT
	OnlineBackup, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY OnlineBackup;

-- CHURN BY REVENUE vs ONLINE BACKUP :
SELECT
	OnlineBackup, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY OnlineBackup;

-- CHURN RATE BY REVENUE vs ONLINE BACKUP :
SELECT
	OnlineBackup, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY OnlineBackup;

---------------------------------------------------------------------------

-- CUSTOMER BY DEVICE PROTECTION :
SELECT
	DeviceProtection, 
	COUNT(customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY DeviceProtection;

-- PERCENT :
SELECT
	DeviceProtection, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY DeviceProtection;

-- CHURN BY CUSTOMER vs DEVICE PROTECTION :
SELECT
	DeviceProtection, 
	COUNT(customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY DeviceProtection;

-- CHURN RATE BY CUSTOMERS vs DEVICE PROTECTION :
SELECT
	DeviceProtection, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY DeviceProtection;

-- REVENUE BY DEVICE PROTECTION :
SELECT
	DeviceProtection, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY DeviceProtection;

--PERCENTAGE :
SELECT
	DeviceProtection, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY DeviceProtection;

-- CHURN BY REVENUE vs DEVICE PROTECTION :
SELECT
	DeviceProtection, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY DeviceProtection;

-- CHURN RATE BY REVENUE vs DEVICE PROTECTION :
SELECT
	DeviceProtection, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY DeviceProtection;

---------------------------------------------------------------------------

-- CUSTOMER BY TECH SUPPORT :
SELECT
	TechSupport, 
	COUNT(customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY TechSupport;

-- PERCENT :
SELECT
	TechSupport, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY TechSupport;

-- CHURN BY CUSTOMER vs TECH SUPPORT :
SELECT
	TechSupport, 
	COUNT(customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY TechSupport;

-- CHURN RATE BY CUSTOMERS vs TECH SUPPORT :
SELECT
	TechSupport, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY TechSupport;

-- REVENUE BY TECH SUPPORT :
SELECT
	TechSupport, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY TechSupport;

--PERCENTAGE :
SELECT
	TechSupport, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY TechSupport;

-- CHURN BY REVENUE vs TECH SUPPORT :
SELECT
	TechSupport, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY TechSupport;

-- CHURN RATE BY REVENUE vs TECH SUPPORT :
SELECT
	TechSupport, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY TechSupport;
------------------------------------------------------------------------------------------------------------------------------------------------------
-- 4) ACCOUNT TYPE SEGMENT :

-- CUSTOMER BY PAPERLESS BILLING
SELECT
	PaperlessBilling, 
	COUNT(DISTINCT customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY PaperlessBilling;

-- PERCENT :
SELECT
	PaperlessBilling, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY PaperlessBilling;

-- CUSTOMER BY PAPERLESS BILLING vs CHURN
SELECT
	PaperlessBilling, 
	COUNT(DISTINCT customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY PaperlessBilling;

-- CHURN RATE BY CUSTOMERS vs PAPERLESS BILLING :
SELECT
	PaperlessBilling, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY PaperlessBilling;

-- REVENUE BY PAPERLESS BILLING :
SELECT
	PaperlessBilling, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY PaperlessBilling;

--PERCENTAGE :
SELECT
	PaperlessBilling, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY PaperlessBilling;

-- REVENUE BY PAPERLESS BILLING vs CHURN:
SELECT
	PaperlessBilling, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY PaperlessBilling;

-- CHURN RATE BY REVENUE vs PAPERLESS BILLING :
SELECT
	PaperlessBilling, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY PaperlessBilling;

---------------------------------------------------------------------------

-- CUSTOMER BY CONTRACT
SELECT
	Contract, 
	COUNT(DISTINCT customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY Contract;

-- PERCENT :
SELECT
	Contract, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY Contract;

-- CUSTOMER BY CONTRACT vs CHURN
SELECT
	Contract, 
	COUNT(DISTINCT customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY Contract;

-- CHURN RATE BY CUSTOMERS vs CONTRACT :
SELECT
	Contract, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY Contract;

-- REVENUE BY CONTRACT :
SELECT
	Contract, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY Contract;

--PERCENTAGE :
SELECT
	Contract, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY Contract;

-- REVENUE BY CONTRACT vs CHURN:
SELECT
	Contract, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY Contract;

-- CHURN RATE BY REVENUE vs CONTRACT :
SELECT
	Contract, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY Contract;

---------------------------------------------------------------------------

-- CUSTOMER BY PAYMENT METHOD :
SELECT
	PaymentMethod, 
	COUNT(DISTINCT customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY PaymentMethod;

-- PERCENT :
SELECT
	PaymentMethod, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY PaymentMethod;

-- CUSTOMER BY PAYMENT METHOD vs CHURN
SELECT
	PaymentMethod, 
	COUNT(DISTINCT customerID) AS Total_Customers
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY PaymentMethod;

-- CHURN RATE BY CUSTOMERS vs PAYMENT METHOD :
SELECT
	PaymentMethod, 
	CEILING(COUNT(DISTINCT customerID) * 100 / (SELECT COUNT(DISTINCT customerID) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Customer
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY PaymentMethod;

-- REVENUE BY PAYMENT METHOD :
SELECT
	PaymentMethod, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY PaymentMethod;

--PERCENTAGE :
SELECT
	PaymentMethod, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset)) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
GROUP BY PaymentMethod;

-- REVENUE BY PAYMENT METHOD vs CHURN:
SELECT
	PaymentMethod, 
	SUM(TotalCharges) AS Total_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY PaymentMethod;

-- CHURN RATE BY REVENUE vs PAYMENT METHOD :
SELECT
	PaymentMethod, 
	CEILING(SUM(TotalCharges) * 100 / (SELECT SUM(TotalCharges) FROM PWC_DataAnalytics.dbo.ChurnDataset WHERE Churn = 'Yes')) AS Rate_by_Revenue
FROM PWC_DataAnalytics.dbo.ChurnDataset
WHERE Churn = 'Yes'
GROUP BY PaymentMethod;

---------------------------------------------------------------------------

SELECT * FROM PWC_DataAnalytics.dbo.ChurnDataset

