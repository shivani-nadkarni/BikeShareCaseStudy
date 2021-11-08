# BikeShareCaseStudy
## Introduction
Cyclistic is a fictional company that offers bike sharing facility. This firm has two major categories of riders: casual riders and annual members. Casual riders are the ones who avail the single-ride passes and full-day passes. Annual members have one-year pass to use the bikes. 

## Problem Description 
The business analysts have determined that the Annual members are more profitable to the the company and focus has to be on expanding this userbase. The firm wants to come up with marketing strategies in order to execute this mission.

## Project Objective
This project aims to analyse Bike Rides data for the last one year and to investigate how annual members and casual riders use Cyclistic bikes differently. At the end some suggestions are provided that may encourage casual riders to take up annual membership.

## Technologies & Tools
* Microsoft Excel
* SQL
* Microsoft SQL Server Management Studio
* R Programming Language
* R Studio

## Data Analysis Phases
I've split the entire data analysis scope into 6 phases namely ASK, PREPARE, PROCESS, ANALYSE, SHARE and ACT. This file captures overview of each step. To view detailed report, be sure to check out [bikeShareCaseStudyReport.docx](https://github.com/shivani-nadkarni/BikeShareCaseStudy/blob/master/caseStudyReport.docx).

### Ask
The Business Goal that we need to solve – To Design  Marketing strategies to convert casual riders into annual members.

As a Junior Data Analyst my first task is to analyse data and find the answer to the following.
*“How do annual members and casual riders use Cyclistic bikes differently?”*

### Prepare

#### Data Source
I’m using a public dataset which can be found here [click here to view the dataset](https://divvy-tripdata.s3.amazonaws.com/index.html).
I’ll be using the data for the rides that occurred in the last 12 months i.e. September 2020 to September 2021.

#### Description of the data
There are 12 .csv files, each contains one month worth of ride data. Each ride record in these files captures attributes of the occurred ride like ride id, start date, end date and so on.

### Process

To clean data, I’ve performed the following checks on each file like removal of duplicate rows, data validation, null checks, formatting the data. Following are the detailed steps I followed using Microsoft Excel

#### Cleaning

1.	Removed all duplicates rows.
2.	Verified that “rideable_type” and “member_casual” columns have only categorical values and no nulls.
3.	The date-time columns have been formatted as “dd-mm-yyyy hh:mm:ss”.
4.	Some “ride_id” values are formatted as text. For some of these, it results into error as scientific notation points to more than 250 characters. Such rows have been eliminated. Also, “ride_id” values have been consistently kept in the range 14-20 characters using LEFT function.
5.	Removed whitespaces for “start_station_name” and “end_station_name” using TRIM function.
6.	Also, there are presence of records with end time occurring before start time. Such records have been eliminated.
7.	For consistency, “start_station_id” and “end_station_id” have been formatted as text.

#### Manipulation
Additionally, I’ve created new columns in each file. Following are the steps I’ve followed
1)	Create a new column and name it “ride_length”.
a)	Ride length is calculated by subtracting the column “started_at” from the column “ended_at”. 
b)	Format the value in “hh:mm:ss” using the custom format “[hh]:mm:ss”.
2)	Create another column “day_of_week”.
a)	Calculate day of week by using the spreadsheet formula WEEKDAY(C2,1)
b)	Here numerical value 1 = Sunday and 7 = Saturday
3)	Repeat this for each file.

### Analyse

To Analyse the data, one of the best ways is to use Pivot tables. I created 5 pivot for each month, you can check this out [monthly_analysis.xlsx](https://github.com/shivani-nadkarni/BikeShareCaseStudy/blob/master/year_view_analysis.xlsx) Following lists the purpose of each table. 

#### Descriptive Analysis
I’ve performed initial analysis using pivot tables for each month separately.
1)	Pivot Table 1 : This depicts ride numbers and average ride length for each of the weekdays.
2)	Pivot Table 2 : This analyses the number of rides and average ride length for each of the rideable types namely docked bike, classic bike and electric bike.
3)	Pivot Table 3 : This compares the number of rides and average ride length for each of the member types i.e. casual and annual.
4)	Pivot Table 4 : This displays the average and maximum ride length across the month.
5)	Pivot Table 5 : This table records the number of rides and average ride length for each of the start stations.

I’ve collated these summaries for each month and put together in one spreadsheet do determine monthly as well as seasonal analysis.
Some interesting facts and trends that I’ve found out are as follows:
1)	The longest ride occurred in June-July 2021 with a record of roughly 38 days!
2)	Mid months of the year i.e. May to September recorded high number of bike rides with peak of 822k being recorded in July itself.
3)	November to February witnessed low ride number. February recorded the lowest dip with just 50k rides.
4)	Streeter Dr & Grand Ave is the most popular start station with as high as 15k rides in one month.

#### Month-wise Comparisons
Some other important observations are:

1)	Classic bikes are the most popular choice with 2 out of every 3 rides being with classic bike..
2)	Docked bikes are a favorite for those who ride for more than 1 hour.
3)	Casual riders have higher average ride length than annual member. Almost double of the later.
4)	Saturdays and Sundays witnessed highest number of rides. Average ride length has also been recorded high for these two days.

#### Year-view Analysis using SQL
I will use SQL to merge all the monthly data to do an overall year analysis. I will be using Microsoft SQL Server to do all database operations.

All the step-by-step queries can be found here [bikesharecasestudy.sql](https://github.com/shivani-nadkarni/BikeShareCaseStudy/blob/master/SQLscript.sql). Be sure to check out [bikeShareCaseStudyReport.docx](https://github.com/shivani-nadkarni/BikeShareCaseStudy/blob/master/caseStudyReport.docx) to view all important figures and outputs.

The analysis unraveled some interesting trends amongst the annual members and casual riders. Following is the analysis.

1)	Annual members recorded increase (more than 50%) in the ride share towards the end of the year, coupled with decrease in the ride share by casual members.  Max was recorded in January (80%).
2)	Average ride length of casual riders is more than double of that of annual riders.
3)	Annual members recorded more number of rides in one year than casual riders.
4)	Saturday has the highest number of rides and average ride length, followed by Saturday and Friday. The weekend shows very high business.
5)	Classic bikes are most preferred type amongst both category of riders. Docked bike is the least preferred. Also, casual members opt for classic bike for long rides.
6)	Casual Members usually prefer weekends over weekdays. Contrary was observed for annual riders, who recorded high numbers on all days, with significant drop on Sunday.

#### Year-view Analysis using R

For analysis using R, I've used data from 4 quarters - Q2, Q3, Q4 from 2019 and Q1 from 2020. The script to clean, merge, analyse and visualise can be found here [R_script.R](https://github.com/shivani-nadkarni/BikeShareCaseStudy/blob/master/Rscript.R ).

### Share

This phase is to visualise important and relevant information to be shown to the stakeholders.

One of the most striking difference between annual members and casual riders is their pattern of operation over the weekdays.

![alt text](https://github.com/shivani-nadkarni/BikeShareCaseStudy/blob/master/images/weeklyRides_bar.png)
Annual members are active on all weekdays and casual riders are more active on weekends.

One explanation for this behaviour is that working people opt for annual membership which is in contrast too casual riders who only opt to ride on the go during weekend.

### Authors

Shivani Nadkarni
