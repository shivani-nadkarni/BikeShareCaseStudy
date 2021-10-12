/* 
 * 
I have imported 12 xlsx spreadsheets, 
each containing monthly data on bike rides,
from September 2020 to August 2021.

Each spreadsheet represents a table for that month.
 *
 */

-- 'BikeShareCaseStudy' is the name of the database.
use BikeShareCaseStudy;

-- Show Tables present in this database.
SELECT
  *
FROM
  BikeShareCaseStudy.INFORMATION_SCHEMA.TABLES;

-- Create Table 'BikeRides' that will contain all 12 months data.
DROP TABLE IF EXISTS BikeRides;
CREATE TABLE
	BikeRides (
		ride_id nvarchar(255),
		rideable_type nvarchar(255),
		started_at datetime,
		ended_at datetime,
		start_station_name nvarchar(255),
		start_station_id nvarchar(50),
		end_station_name nvarchar(255),
		end_station_id nvarchar(50),
		start_lat float,
		start_lng float,
		end_lat float,
		end_lng float,
		member_casual nvarchar(255),
		ride_length datetime,
		day_of_week float
	);


-- Merge all tables into single 'BikeRides' table.
INSERT into BikeRides
	SELECT 
		ride_id, rideable_type,
		started_at, ended_at,
		start_station_name, cast(start_station_id as nvarchar),
		end_station_name, cast(end_station_id as nvarchar),
		start_lat, start_lng,
		end_lat, end_lng,
		member_casual,
		ride_length, day_of_week
	FROM TripData202009
UNION ALL
	SELECT 
		ride_id, rideable_type,
		started_at, ended_at,
		start_station_name, cast(start_station_id as nvarchar),
		end_station_name, cast(end_station_id as nvarchar),
		start_lat, start_lng,
		end_lat, end_lng,
		member_casual,
		ride_length, day_of_week
	FROM TripData202010
UNION ALL
	SELECT
		ride_id, rideable_type,
		started_at, ended_at,
		start_station_name, cast(start_station_id as nvarchar),
		end_station_name, cast(end_station_id as nvarchar),
		start_lat, start_lng,
		end_lat, end_lng,
		member_casual,
		ride_length, day_of_week
	FROM TripData202011
UNION ALL
	SELECT  
		ride_id, rideable_type,
		started_at, ended_at,
		start_station_name, cast(start_station_id as nvarchar),
		end_station_name, end_station_id,
		start_lat, start_lng,
		end_lat, end_lng,
		member_casual,
		ride_length, day_of_week
	FROM TripData202012
UNION ALL
	SELECT
		ride_id, rideable_type,
		started_at, ended_at,
		start_station_name, cast(start_station_id as nvarchar),
		end_station_name, cast(end_station_id as nvarchar),
		start_lat, start_lng,
		end_lat, end_lng,
		member_casual,
		ride_length, day_of_week
	FROM TripData202101
UNION ALL
	SELECT
		ride_id, rideable_type,
		started_at, ended_at,
		start_station_name, cast(start_station_id as nvarchar),
		end_station_name, cast(end_station_id as nvarchar),
		start_lat, start_lng,
		end_lat, end_lng,
		member_casual,
		ride_length, day_of_week
	FROM TripData202102
UNION ALL
	SELECT
		ride_id, rideable_type,
		started_at, ended_at,
		start_nation_name as start_station_name, cast(start_station_id as nvarchar),
		end_station_name, cast(end_station_id as nvarchar),
		start_lat, start_lng,
		end_lat, end_lng,
		member_casual,
		ride_length, day_of_week
	FROM TripData202103
UNION ALL
	SELECT
		ride_id, rideable_type,
		started_at, ended_at,
		start_station_name, cast(start_station_id as nvarchar),
		end_station_name, cast(end_station_id as nvarchar),
		start_lat, start_lng,
		end_lat, end_lng,
		member_casual,
		ride_length, day_of_week
	FROM TripData202104
UNION ALL
	SELECT
		ride_id, rideable_type,
		started_at, ended_at,
		start_station_name, cast(start_station_id as nvarchar),
		end_station_name, cast(end_station_id as nvarchar),
		start_lat, start_lng,
		end_lat, end_lng,
		member_casual,
		ride_length, day_of_week
	FROM TripData202105
UNION ALL
	SELECT
		ride_id, rideable_type,
		started_at, ended_at,
		start_station_name, cast(start_station_id as nvarchar),
		end_station_name, cast(end_station_id as nvarchar),
		start_lat, start_lng,
		end_lat, end_lng,
		member_casual,
		ride_length, day_of_week
	FROM TripData202106
UNION ALL
	SELECT
		ride_id, rideable_type,
		started_at, ended_at,
		start_station_name, cast(start_station_id as nvarchar),
		end_station_name, cast(end_station_id as nvarchar),
		start_lat, start_lng,
		end_lat, end_lng,
		member_casual,
		ride_length, day_of_week
	FROM TripData202107
UNION ALL
	SELECT
		ride_id, rideable_type,
		started_at, ended_at,
		start_station_name, cast(start_station_id as nvarchar),
		end_station_name, cast(end_station_id as nvarchar),
		start_lat, start_lng,
		end_lat, end_lng,
		member_casual,
		ride_length, day_of_week
	FROM TripData202108

-- This displays the number of rows modified by the previous transaction
SELECT @@RowCount;

-- Total records
SELECT 
	COUNT(*)
FROM
	BikeRides


-- Find average ride length across the year
SELECT
	CAST(CAST(AVG(CAST(ride_length AS FLOAT)) AS datetime) AS time)
FROM
	BikeRides


-- Find max ride length in 12 month
-- run this entire enclosed script together to find max
DECLARE @zerodate AS datetime
DECLARE @newdate AS datetime
SET @zerodate=CAST(0 AS datetime)

SELECT
	@newdate = CAST(max(CAST(ride_length AS FLOAT)) AS datetime)
FROM
	BikeRides

SELECT 
	 CAST(DATEDIFF(day, @zerodate, @newdate) AS nvarchar) + ' Days ' 
	 + CAST(DATEDIFF(HH, @zerodate, @newdate)%(24) AS nvarchar) + ' Hours' ;
---------------------------------------------------

-- Find count of rides and average ride length from each start station.
SELECT
	start_station_name, 
	COUNT(ride_id) AS count_of_rides,
	CAST(CAST(AVG(CAST(ride_length AS FLOAT)) AS datetime) AS time) AS avg_ride_length
FROM
	BikeRides
WHERE
	start_station_name IS NOT NULL
	AND start_station_name <> ''
GROUP BY
	start_station_name
ORDER BY
	start_station_name;

-- Number of rides on each weekday
SELECT
	CASE day_of_week
		WHEN 1 THEN 'Sunday'
		WHEN 2 THEN 'Monday'
		WHEN 3 THEN 'Tuesday'
		WHEN 4 THEN 'Wednesday'
		WHEN 5 THEN 'Thursday'
		WHEN 6 THEN 'Friday'
		WHEN 7 THEN 'Saturday'
	END day_of_week,
	COUNT(ride_id) AS count_of_rides,
	CAST(CAST(AVG(CAST(ride_length AS FLOAT)) AS datetime) AS time) AS avg_ride_length
FROM
	BikeRides
GROUP BY
	day_of_week
ORDER BY 
	count_of_rides DESC


-- count of rides and average ride length for each member type
SELECT
	member_casual,
	COUNT(ride_id) AS count_of_rides,
	CAST(CAST(AVG(CAST(ride_length AS FLOAT)) AS datetime) AS time) AS avg_ride_length
FROM
	BikeRides
GROUP BY
	member_casual


-- Find the preferred ride type of each member category
SELECT
	member_casual,
	CASE day_of_week
		WHEN 1 THEN 'Sunday'
		WHEN 2 THEN 'Monday'
		WHEN 3 THEN 'Tuesday'
		WHEN 4 THEN 'Wednesday'
		WHEN 5 THEN 'Thursday'
		WHEN 6 THEN 'Friday'
		WHEN 7 THEN 'Saturday'
	END day_of_week,
	COUNT(ride_id) AS count_of_rides,
	CAST(CAST(AVG(CAST(ride_length AS FLOAT)) AS datetime) AS time) AS avg_ride_length,
	CAST(
		DATEDIFF(day, 
				 CAST(0 AS datetime), 
				 CAST(max(CAST(ride_length AS FLOAT)) AS datetime)
		) AS nvarchar
	) + ' Days ' 
	+ CAST(
		   DATEDIFF(HH, 
					CAST(0 AS datetime), 
					CAST(max(CAST(ride_length AS FLOAT)) AS datetime)
		   )%(24) AS nvarchar
	) + ' Hours '
	+ CAST(
		   DATEDIFF(MI, 
					CAST(0 AS datetime), 
					CAST(max(CAST(ride_length AS FLOAT)) AS datetime)
		   )%(60) AS nvarchar
	) + ' Minutes' AS max_ride_length
FROM
	BikeRides
GROUP BY
	member_casual,
	day_of_week
ORDER BY
	member_casual,
	count_of_rides DESC

-- Preferred days of week by member type
SELECT
	member_casual,
	CASE day_of_week
		WHEN 1 THEN 'Sunday'
		WHEN 2 THEN 'Monday'
		WHEN 3 THEN 'Tuesday'
		WHEN 4 THEN 'Wednesday'
		WHEN 5 THEN 'Thursday'
		WHEN 6 THEN 'Friday'
		WHEN 7 THEN 'Saturday'
	END day_of_week,
	COUNT(ride_id) AS count_of_rides,
	CAST(CAST(AVG(CAST(ride_length AS FLOAT)) AS datetime) AS time) AS avg_ride_length
FROM
	BikeRides
GROUP BY
	member_casual,
	day_of_week
ORDER BY
	member_casual,
	count_of_rides DESC

--- Share of bike rides by each member type for every month
WITH T1 AS (
	SELECT
		YEAR(started_at) AS year,
		MONTH(started_at) AS month,
		member_casual,
		COUNT(member_casual) AS count_members
	FROM 
		BikeRides
	GROUP BY
		YEAR(started_at),
		MONTH(started_at),
		member_casual
) SELECT
	year,
	month,
	CONVERT(decimal(5,2),count_members*100.0/(SUM(count_members) OVER (PARTITION  BY year, month))) AS member_percent
FROM 
	T1
order by
	year, month, member_casual

-- Share of bike rides by each member type -> rideable type across months

WITH T1 AS (
	SELECT
		YEAR(started_at) AS year,
		MONTH(started_at) AS month,
		member_casual,
		rideable_type,
		COUNT(member_casual) AS count_members,
		CAST(CAST(AVG(CAST(ride_length AS FLOAT)) AS datetime) AS time) AS avg_ride_length
	FROM 
		BikeRides
	GROUP BY
		YEAR(started_at),
		MONTH(started_at),
		member_casual,
		rideable_type
) SELECT
	year,
	month,
	member_casual,
	rideable_type,
	CONVERT(decimal(5,2),count_members*100.0/(SUM(count_members) 
			OVER (PARTITION  BY year, month, member_casual))) AS ride_type_percent,
	avg_ride_length
FROM 
	T1
order by
	year, month, member_casual, rideable_type
