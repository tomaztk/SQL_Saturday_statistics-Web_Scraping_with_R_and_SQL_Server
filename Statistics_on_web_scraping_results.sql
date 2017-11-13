/*
Title: SqlSaturday statistics - web scraping with R and SQL Server
Author: Tomaz Kastrun
Blog: http://tomaztsql.wordpress.com
Date; 13.11.2017

*/


USE SQLSaturday;
GO


SELECT count(*) FROM SQLSatSessions WITH(NOLOCK);
GO

--
-- CLEAN DATA
--


-- not interested in sessions without title
DELETE FROM SQLSatSessions
WHERE
	SqlSatTitle IS NULL
-- (303 rows affected)

-- not interested in sessions without speakers
DELETE FROM SQLSatSessions
WHERE
	SqlSatSpeaker IS NULL
-- (11 rows affected)


-- We don't want sessions that will be announced, because we want them now!
DELETE FROM SQLSatSessions
WHERE
	SqlSatTitle like '%To be Announced%'
-- (61 rows affected)


-- Lunch sessions are not my thing
DELETE FROM SQLSatSessions
WHERE
	SqlSatTitle like 'Sponsor lunchtime session%'
-- (10 rows affected)


-- Sorry guys, but not counting you, either
DELETE FROM SQLSatSessions
WHERE
	SqlSatTitle like '%ponsor sessio%'
-- (9 rows affected)


-- Original question: How many time was Query store presented in past 100 SQLSaturday events:

SELECT 
count(*) AS nof_sessions
,'Query Store' AS topic
FROM sqlsatsessions
WHERE SqlSatTitle like '%query store%'

UNION ALL

SELECT 
count(*) AS nof_sessions
,'Azure ML' AS topic
FROM sqlsatsessions
 WHERE SqlSatTitle like '%Azure ML%' OR SqlSatTitle like '%azure machine learning%'

 UNION ALL

SELECT 
count(*) AS nof_sessions
,'PowerShell' AS topic
FROM sqlsatsessions
WHERE SqlSatTitle like '%powershell%' 

UNION ALL

SELECT 
count(*) AS nof_sessions
,'R Server' AS topic
FROM sqlsatsessions
WHERE SqlSatTitle like '%R Server%'  or SqlSatTitle like '%R Services%'  or SqlSatTitle like '%Microsoft R%' or SqlSatTitle like '%MRO%' or SqlSatTitle like 'R SQL Server 2017%' 
or SqlSatTitle like 'R' 

UNION ALL

SELECT 
count(*) AS nof_sessions
,'Python' AS topic
FROM sqlsatsessions
WHERE SqlSatTitle like '%Python%'

UNION ALL

SELECT 
count(*) AS nof_sessions
,'Azure in General' AS topic
FROM sqlsatsessions
WHERE SqlSatTitle like '%Azure%'