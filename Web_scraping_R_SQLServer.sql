/*
Title: SqlSaturday statistics - web scraping with R and SQL Server
Author: Tomaz Kastrun
Blog: http://tomaztsql.wordpress.com
Date; 13.11.2017

*/

USE [master];
GO

CREATE DATABASe SQLSaturday;
GO

USE SQLSaturday;
GO

/*
-- TEST
EXEC sp_execute_external_script
	 @language = N'R'
	,@script = N'
				library(curl)
				library(httr)
				library(rvest)
				library(XML)

				url_schedule <- ''http://www.sqlsaturday.com/687/Sessions/Schedule.aspx''
				cf <- curl_fetch_memory(url_schedule, handle=TRUE)
				cf$status_code
				OutputDataSet <- data.frame(cf)
				'

*/

DROP TABLE IF EXISTS SQLSatSessions;
GO

CREATE TABLE SQLSatSessions
(
 id SMALLINT IDENTITY(1,1) NOT NULL
,SqlSat SMALLINT NOT NULL
,SqlSatTitle NVARCHAR(500)  NULL
,SQLSatSpeaker NVARCHAR(200)  NULL
)



CREATE OR ALTER PROCEDURE GetSessions
	@eventID SMALLINT
AS

DECLARE @URL VARCHAR(500)
SET @URL = 'http://www.sqlsaturday.com/' +CAST(@eventID AS NVARCHAR(5)) + '/Sessions/Schedule.aspx'

PRINT @URL

DECLARE @TEMP TABLE
(
	 SqlSatTitle  NVARCHAR(500)
	,SQLSatSpeaker  NVARCHAR(200)
)

DECLARE @RCODE NVARCHAR(MAX)
SET @RCODE = N'     
				    library(rvest)
					library(XML)
					library(dplyr)
					library(httr)
					library(curl)
					library(selectr)
					
					#URL to schedule
					url_schedule <- "'
			
DECLARE @RCODE2 NVARCHAR(MAX)					
SET @RCODE2 = N'"
					#Read HTML
					webpage <-  html_session(url_schedule) %>%
						 read_html()

					# Event schedule
					schedule_info <- html_nodes(webpage, ''.session-schedule-cell-info'') # OK

					# Extracting HTML content
					ht <- html_text(schedule_info)

					df <- data.frame(data=ht)

					#create empty DF
					df_res <- data.frame(title=c(), speaker=c())

							for (i in 1:nrow(df)){
							  #print(df[i])
							  if (i %% 2 != 0) #odd flow
								print(paste0("title is: ", df$data[i]))
							  if (i %% 2 == 0) #even flow
								print(paste0("speaker is: ", df$data[i]))
							 df_res <- rbind(df_res, data.frame(title=df$data[i], speaker=df$data[i+1]))
							}

					df_res_new = df_res[seq(1, nrow(df_res), 2), ]
					OutputDataSet <- df_res_new ';


DECLARE @FINAL_RCODE NVARCHAR(MAX)
SET @FINAL_RCODE = CONCAT(@RCODE, @URL, @RCODE2)
-- PRINT @FINAL_RCODE

INSERT INTO @Temp
EXEC sp_execute_external_script
	 @language = N'R'
	,@script = @FINAL_RCODE


INSERT INTO SQLSatSessions (sqlSat,SqlSatTitle,SQLSatSpeaker)
SELECT 
	 @EventID AS sqlsat
	,SqlSatTitle
	,SqlSatSpeaker
FROM @Temp


-- the best SQLSaturday event - SQLSaturday Slovenia
EXECUTE GetSessions @eventID = 687



--- Walk through 100 EVENTS
DECLARE @i SMALLINT = 600

WHILE (@i < 690)
BEGIN
	EXECUTE GetSessions @eventID = @i
	SET @i += 1
	SELECT  CONCAT('Working on SQLSat event ', @i)
END
