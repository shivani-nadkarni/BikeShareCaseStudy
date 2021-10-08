install.packages("tidyverse")
install.packages("lubridate")
install.packages("ggplot2")
install.packages("dplyr")
library(tidyverse)
library(lubridate)
library(ggplot2)

# set your working directory
setwd('C:/Users/s.vijay.nadkarni/Trainings/data_analysis/case-study/R-BikeShareCaseStudy/Quarter_csv')

# get your working directory
getwd()

# load data from csv files
q1_2020 <- read.csv(file="Divvy_Trips_2020_Q1.csv")
q2_2019 <- read.csv(file="Divvy_Trips_2019_Q2.csv")
q3_2019 <- read.csv(file="Divvy_Trips_2019_Q3.csv", header = TRUE)
q4_2019 <- read.csv(file="Divvy_Trips_2019_Q4.csv")


#will clear all objects includes hidden objects.
rm(list = ls())

#free up memrory and report the memory usage.
gc()

#To see what packages are installed
installed.packages()

# data wrangling
# compare column names of each file
colnames(q2_2019)
colnames(q3_2019)
colnames(q4_2019)
colnames(q1_2020)

# Rename the columns to make them consistent with q1_2020
q2_2019 <- rename(q2_2019
                  ,ride_id = X01...Rental.Details.Rental.ID
                  ,rideable_type = X01...Rental.Details.Bike.ID
                  ,started_at = X01...Rental.Details.Local.Start.Time
                  ,ended_at = X01...Rental.Details.Local.End.Time
                  ,start_station_name = X03...Rental.Start.Station.Name
                  ,start_station_id = X03...Rental.Start.Station.ID
                  ,end_station_name = X02...Rental.End.Station.Name
                  ,end_station_id = X02...Rental.End.Station.ID
                  ,member_casual = User.Type)
q3_2019 <- rename(q3_2019
                  ,ride_id = trip_id
                  ,rideable_type = bikeid
                  ,started_at = start_time
                  ,ended_at = end_time
                  ,start_station_name = from_station_name
                  ,start_station_id = from_station_id
                  ,end_station_name = to_station_name
                  ,end_station_id = to_station_id
                  ,member_casual = usertype)
q4_2019 <- rename(q4_2019
                  ,ride_id = trip_id
                  ,rideable_type = bikeid
                  ,started_at = start_time
                  ,ended_at = end_time
                  ,start_station_name = from_station_name
                  ,start_station_id = from_station_id
                  ,end_station_name = to_station_name
                  ,end_station_id = to_station_id
                  ,member_casual = usertype)


# view the column names now
colnames(q2_2019)
colnames(q3_2019)
colnames(q4_2019)
colnames(q1_2020)

# Inspect the dataframes and look for incongruencies
str(q1_2020)
str(q4_2019)
str(q3_2019)
str(q2_2019)

# ride_id datatype should be consistent ie char type
q2_2019 <- mutate(q2_2019, ride_id = as.character(ride_id))
q3_2019 <- mutate(q3_2019, ride_id = as.character(ride_id))
q4_2019 <- mutate(q4_2019, ride_id = as.character(ride_id))

# rideable_type have to be of char type.
q2_2019 <- mutate(q2_2019, rideable_type = as.character(rideable_type))
q3_2019 <- mutate(q3_2019, rideable_type = as.character(rideable_type))
q4_2019 <- mutate(q4_2019, rideable_type = as.character(rideable_type))

# Stack individual quarter's data frames into one big data frame
all_trips <- bind_rows(q2_2019, q3_2019, q4_2019, q1_2020)

# view all_trips
colnames(all_trips)

# Remove lat, long, birthyear, and gender fields as this data was dropped beginning in 2020
all_trips <- all_trips %>%
  select(-c(start_lat, start_lng, end_lat, end_lng, tripduration, gender, "X05...Member.Details.Member.Birthday.Year"
            ,"X01...Rental.Details.Duration.In.Seconds.Uncapped", birthyear))

# Inspect the new table all_trips
colnames(all_trips)
str(all_trips)

# Remove member.gender
all_trips <- select(all_trips,-"Member.Gender")

#List of column names
colnames(all_trips)  

#How many rows are in data frame?
nrow(all_trips)  

#Dimensions of the data frame?
dim(all_trips)  

#See the first 6 rows of data frame.  Also tail(all_trips)
head(all_trips)  

#See list of columns and data types (numeric, character, etc)
str(all_trips)  

#Statistical summary of data. Mainly for numerics
summary(all_trips)  

#Find categories in member_casual
unique(all_trips %>%
  select(member_casual))

table(all_trips$member_casual)

# find the class
class(all_trips$member_casual)

# we will want to make our dataframe consistent with their current nomenclature
# so let's change subscriber to member and customer to casual
all_trips <- all_trips %>%
  mutate(member_casual = recode(member_casual
                                ,"Subscriber" = "member"
                                ,"Customer" = "casual"))

table(all_trips$member_casual)

# lets format the date and create separate columnds for individual date attirbutes

all_trips$date <- as.Date(all_trips$started_at)
















