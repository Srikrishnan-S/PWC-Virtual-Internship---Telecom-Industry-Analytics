-- READ DATA
SELECT * 
FROM PWC_DataAnalytics.dbo.CallCenterDataset

---------------------------------------------------------------------------

-- 1) Total Calls Recieved : 

-- 1.1) Overall Calls Received :
SELECT COUNT(Call_Id) AS Total_Calls_Received
FROM PWC_DataAnalytics.dbo.CallCenterDataset

-- 1.2) Total Calls by Topic :
SELECT Topic, COUNT(Call_Id) AS Total_Calls_Received
FROM PWC_DataAnalytics.dbo.CallCenterDataset
GROUP BY Topic

-- 1.3) Total Calls by Agent : 
SELECT Agent, COUNT(Call_Id) AS Total_Calls_Received
FROM PWC_DataAnalytics.dbo.CallCenterDataset
GROUP BY Agent

-- 1.4) Total Calls by Hour : 
SELECT DATEPART(HOUR, Time) AS DataHour, COUNT(Call_Id) AS Total_Calls_Received
FROM PWC_DataAnalytics.dbo.CallCenterDataset
GROUP BY DATEPART(HOUR, Time)

---------------------------------------------------------------------------

-- 2) Total Calls Answered : 

-- 2.1) Overall Calls Answered

SELECT COUNT(Answered_Y_N) AS Total_Calls_Answered
FROM PWC_DataAnalytics.dbo.CallCenterDataset
WHERE Answered_Y_N = 1

-- 2.2) Total Calls Answered by Topic :
SELECT Topic, COUNT(Answered_Y_N) AS Total_Calls_Answered
FROM PWC_DataAnalytics.dbo.CallCenterDataset
WHERE Answered_Y_N = 1
GROUP BY Topic

-- 2.3) Total Calls Answered by Agent :
SELECT Agent, COUNT(Answered_Y_N) AS Total_Calls_Answered
FROM PWC_DataAnalytics.dbo.CallCenterDataset
WHERE Answered_Y_N = 1
GROUP BY Agent

-- 2.4) Total Calls Answered by Hour :
SELECT DATEPART(HOUR, Time) AS DataHour, COUNT(Answered_Y_N) AS Total_Calls_Answered
FROM PWC_DataAnalytics.dbo.CallCenterDataset
WHERE Answered_Y_N = 1
GROUP BY DATEPART(HOUR, Time)

---------------------------------------------------------------------------

-- 3) Total Calls Resolved :

-- 3.1) Overall Calls Resolved : 
SELECT COUNT(Resolved) AS Total_Calls_Resolved
FROM PWC_DataAnalytics.dbo.CallCenterDataset
WHERE Resolved = 1

-- 3.2) Total Calls Resolved by Topic : 
SELECT Topic, COUNT(Resolved) AS Total_Calls_Resolved
FROM PWC_DataAnalytics.dbo.CallCenterDataset
WHERE Resolved = 1
GROUP BY Topic

-- 3.3) Total Calls Resolved by Agent : 
SELECT Agent, COUNT(Resolved) AS Total_Calls_Resolved
FROM PWC_DataAnalytics.dbo.CallCenterDataset
WHERE Resolved = 1
GROUP BY Agent

-- 3.4) Total Calls Resolved by Hour : 
SELECT DATEPART(HOUR, Time) AS DataHour, COUNT(Resolved) AS Total_Calls_Resolved
FROM PWC_DataAnalytics.dbo.CallCenterDataset
WHERE Resolved = 1
GROUP BY DATEPART(HOUR, Time)

---------------------------------------------------------------------------

-- 4) Speed of Answer :

-- 4.1) Average Speed of Answer :

SELECT AVG(ISNULL(Speed_of_answer_in_seconds, 0)) AS Average_Speed_Of_Call_Answered
FROM PWC_DataAnalytics.dbo.CallCenterDataset

-- 4.2) Average Speed of Answer by Topic :
SELECT Topic, AVG(ISNULL(Speed_of_answer_in_seconds, 0)) AS Average_Speed_Of_Call_Answered
FROM PWC_DataAnalytics.dbo.CallCenterDataset
GROUP BY Topic

-- 4.3) Average Speed of Answer by Agent :
SELECT Agent, AVG(ISNULL(Speed_of_answer_in_seconds, 0)) AS Average_Speed_Of_Call_Answered
FROM PWC_DataAnalytics.dbo.CallCenterDataset
GROUP BY Agent

-- 4.4) Average Speed of Answer by Hour :
SELECT DATEPART(HOUR, Time) AS DataHour, AVG(ISNULL(Speed_of_answer_in_seconds, 0)) AS Average_Speed_Of_Call_Answered
FROM PWC_DataAnalytics.dbo.CallCenterDataset
GROUP BY DATEPART(HOUR, Time)

---------------------------------------------------------------------------

-- 5) Satisfactory Rating :

-- 5.1) Average Satisfactory Rating :
SELECT AVG(ISNULL(Satisfaction_rating, 0)) AS Average_Satisfactory_Rating
FROM PWC_DataAnalytics.dbo.CallCenterDataset

-- 5.2) Average Satisfactory Rating by Topic:
SELECT Topic, AVG(ISNULL(Satisfaction_rating, 0)) AS Average_Satisfactory_Rating
FROM PWC_DataAnalytics.dbo.CallCenterDataset
GROUP BY Topic

-- 5.3) Average Satisfactory Rating by Agent:
SELECT Agent, AVG(ISNULL(Satisfaction_rating, 0)) AS Average_Satisfactory_Rating
FROM PWC_DataAnalytics.dbo.CallCenterDataset
GROUP BY Agent

-- 5.4) Average Satisfactory Rating by Hour:
SELECT DATEPART(HOUR, Time) AS DataHour, AVG(ISNULL(Satisfaction_rating, 0)) AS Average_Satisfactory_Rating
FROM PWC_DataAnalytics.dbo.CallCenterDataset
GROUP BY DATEPART(HOUR, Time)

---------------------------------------------------------------------------

-- 6.A) Ratio Calls Answered and Abandoned :
SELECT COUNT(Call_Id) AS Calls_Received, 
       CASE WHEN Answered_Y_N = 1 THEN 'Yes' ELSE 'No' END AS Calls_Answered_and_Abandoned
FROM PWC_DataAnalytics.dbo.CallCenterDataset
GROUP BY Answered_Y_N

-- 6.B) Percentage of Calls Answered and Abandoned : 
SELECT 
      CEILING(SUM(CASE WHEN Answered_Y_N = 1 THEN 1 ELSE 0 END) * 100 / COUNT(Call_Id)) AS Percentage_Calls_Answered, 
	  CEILING(SUM(CASE WHEN Answered_Y_N = 0 THEN 1 ELSE 0 END) * 100 / COUNT(Call_Id)) AS Percentage_Calls_Abandoned
FROM PWC_DataAnalytics.dbo.CallCenterDataset

---------------------------------------------------------------------------

-- 7.A) Ratio of Calls Resolved and Unresolved : 
SELECT COUNT(Call_Id) AS Calls_Received, 
       CASE WHEN Resolved = 1 THEN 'Yes' ELSE 'No' END AS Calls_Resolved_and_Unresolved
FROM PWC_DataAnalytics.dbo.CallCenterDataset
GROUP BY Resolved

-- 7.B) Percentage of Calls Resolved and Unresolved :
SELECT 
      CEILING(SUM(CASE WHEN Resolved = 1 THEN 1 ELSE 0 END) * 100 / COUNT(Call_Id)) AS Percentage_Calls_Answered, 
	  CEILING(SUM(CASE WHEN Resolved = 0 THEN 1 ELSE 0 END) * 100 / COUNT(Call_Id)) AS Percentage_Calls_Abandoned
FROM PWC_DataAnalytics.dbo.CallCenterDataset

---------------------------------------------------------------------------

-- Total Calls Received by Months vs Answered and Abandoned :
SELECT 
      (CASE WHEN MONTH(Date) = 1 THEN 'Jan'
	       WHEN MONTH(Date) = 2 THEN 'Feb'
		   WHEN MONTH(Date) = 3 THEN 'Mar' 
		   ELSE NULL 
		   END) AS Months, 
	  COUNT(Call_ID) AS Total_Calls_Received, 
	  SUM(CASE WHEN Answered_Y_N = 1 THEN 1 ELSE 0 END) AS Calls_Answered, 
	  SUM(CASE WHEN Answered_Y_N = 0 THEN 1 ELSE 0 END) AS Calls_Abandoned
FROM PWC_DataAnalytics.dbo.CallCenterDataset
GROUP BY MONTH(Date)

---------------------------------------------------------------------------

-- Average Talk Duration in Minutes by Calls Answered vs Resolved and Unresolved :
SELECT DATEPART(MINUTE, AvgTalkDuration) AS Avg_Mins, 
       SUM(CASE WHEN Answered_Y_N = 1 THEN 1 ELSE 0 END) AS Calls_Answered, 
	   SUM(CASE WHEN Resolved = 1 THEN 1 ELSE 0 END) AS Resolved,
	   SUM(CASE WHEN Resolved = 0 THEN 1 ELSE 0 END) AS Unresolved
FROM PWC_DataAnalytics.dbo.CallCenterDataset
WHERE AvgTalkDuration IS NOT NULL
GROUP BY DATEPART(MINUTE, AvgTalkDuration)


