# The analysis is done for the Ride data from May 2019 to April 2020

# Install the required packages
install.packages("tidyverse")
install.packages("lubridate")
install.packages("ggplot2")
install.packages("dplyr")
library(tidyverse)
library(lubridate)
library(ggplot2)
library(dplyr)

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

#free up memory and report the memory usage.
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

# List of column names
colnames(all_trips)  

# How many rows are in data frame?
nrow(all_trips)  

# Dimensions of the data frame?
dim(all_trips)  

# See the first 6 rows of data frame.  Also tail(all_trips)
head(all_trips)  

#See list of columns and data types (numeric, character, etc)
str(all_trips)  

# Statistical summary of data. Mainly for numerics
summary(all_trips)  

# Find categories in member_casual
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

all_trips$year <- format(as.Date(all_trips$started_at), "%Y")
all_trips$month <- format(as.Date(all_trips$started_at), "%m")
all_trips$day <- format(as.Date(all_trips$started_at), "%d")
all_trips$day_of_week <- format(as.Date(all_trips$started_at), "%A")

# Inspect the data
colnames(all_trips)
str(all_trips)

# we can remove single columns this way
all_trips <- select(all_trips, -"week")

# Compute duration for each ride
all_trips$ride_length <- difftime(all_trips$ended_at, all_trips$started_at)

# Inspect the data
colnames(all_trips)
str(all_trips)

#convert the ride length to numeric values
all_trips$ride_length <- as.numeric(as.character(all_trips$ride_length))
is.numeric(all_trips$ride_length)

# clean the data, remove the records when bikes were take for repair and also records with negative ride-length
all_trips_v2 <- all_trips[!(all_trips$start_station_name == "HQ QR" | all_trips$ride_length<0),]

# let's remove unused variables
rm(q4_2019)
rm(q1_2020)
rm(q2_2019)
rm(q3_2019)

# Now we will begin with descriptive analysis
# lets analyse ride length
mean(all_trips_v2$ride_length)
max(all_trips_v2$ride_length)
min(all_trips_v2$ride_length)
median(all_trips_v2$ride_length)

# You can condense the four lines above to one line using summary() on the specific attribute
summary(all_trips_v2$ride_length)

# Compare members and casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = mean)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = median)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = max)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = min)

# See the average ride time by each day for members vs casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

# Notice that the days of the week are out of order. Let's fix that.
all_trips_v2$day_of_week <- ordered(all_trips_v2$day_of_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

# Now, let's run the average ride time by each day for members vs casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

# Remove unused variables
rm(all_trips)

# creating table 1 for descriptive analysis of casual and annual members
table1 <- all_trips_v2 %>%
  group_by(member_casual, day_of_week) %>%
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)/60
            ,max_duration = max(ride_length)/60) %>%
  arrange(member_casual, day_of_week)

# Inspect the data
colnames(table1)
str(table1)

# package scales is required to format axis labels
library(scales)

# rides on each weekday for casual and annual members
ggplot(table1) +
  geom_col(position="dodge", mapping = aes(x=day_of_week, y=number_of_rides,
                         fill = member_casual)) +
  theme(axis.text.x = element_text(angle=45, hjust=1)) +
  scale_x_discrete(name="Day of Week") +
  scale_y_continuous(name="Number of Rides", labels=comma)

# save the image of the plot
ggsave("images/weeklyRides_bar.png", height=4,width=6.75)

# rides share of casual and annual members on each weekday
ggplot(table1) +
  geom_col(mapping = aes(x=day_of_week, y=number_of_rides,
                         fill = member_casual)) +
  theme(axis.text.x = element_text(angle=45, hjust=1)) +
  scale_x_discrete(name="Day of Week") +
  scale_y_continuous(name="Number of Rides", labels=comma)

ggsave("images/weeklyTotalRideShare_stacked.png", height=4,width=6.75)

# average ride-length for casual and annual members on each weekday
ggplot(table1) +
  geom_col(mapping = aes(x=day_of_week, y=average_duration,
                         fill = member_casual)) +
  facet_wrap(~member_casual) +
  theme(axis.text.x = element_text(angle=45, hjust=1)) +
  scale_x_discrete(name="Day of Week") +
  scale_y_continuous(name="Average Duration (Minutes)", labels=comma)

ggsave("images/weeklyAverageRideDuration.png", height=4,width=6.75)

# creating table 2 for monthly descriptive analysis of casual and annual member
table2 <- all_trips_v2 %>%
  group_by(year_month=as.factor(paste(year,month,sep='/')), member_casual) %>%
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)/60
            ,max_duration = max(ride_length)/60) %>%
  arrange(year,month, member_casual)

# Inspect table2
colnames(table2)
str(table2)

# rides in each month for casual and annual members
ggplot(table2) +
  geom_col(position="dodge", mapping=aes(x=year_month, y=number_of_rides,fill=member_casual)) +
  theme(axis.text.x = element_text(size=7, angle=60, hjust=1)) +
  scale_x_discrete(name="Year Month", ) +
  scale_y_continuous(name="Ride Count", labels=comma)

ggsave("images/MonthlyRides.png", height=4,width=6.75)

# Average ride duration of casual and annual members per month month
ggplot(table2) +
  geom_col(position="dodge", mapping=aes(x=year_month, y=average_duration, fill=member_casual)) +
  theme(axis.text.x = element_text(size=7, angle=60, hjust=1)) +
  scale_x_discrete(name="Year Month") +
  scale_y_continuous(name="Average Ride Duration", labels=comma)

ggsave(plot=last_plot(), "images/monthlyAverageDuration.png", height=4,width=6.75)

# lets save the data in files
write.csv(table1, file = 'C:/Users/s.vijay.nadkarni/Trainings/data_analysis/case-study/R-BikeShareCaseStudy/data/weeklyRides.csv')
write.csv(table2, file = 'C:/Users/s.vijay.nadkarni/Trainings/data_analysis/case-study/R-BikeShareCaseStudy/data/monthlyRides.csv')

# Now, I will use the data-set that contained ride-able type information
# the data was analysed in SQL and a summary was exported in a csv file.
# the above dataset belongs from September 2020 to August 2021. 

# set your working directory
setwd('C:/Users/s.vijay.nadkarni/Trainings/data_analysis/case-study')

# Let's import the csv file
data <- read.csv("MonthlyRideableTypeData.csv", header=TRUE)

# Inspect the data
colnames(data)
str(data)

# Lets rename the columns properly
data <- rename(data, year=ï..year)

# combine year and month into single column
install.packages("tidyr")
library(tidyr)

# create a new year-month column
data <- unite(data, 'year_month', year, month, sep="/")

# convert avg-ride-length to seconds
data$avg_ride_length <- as.numeric(as.period(hms(data$avg_ride_length), unit="sec"))
colnames(data)

# set you working directory
setwd('C:/Users/s.vijay.nadkarni/Trainings/data_analysis/case-study/R-BikeShareCaseStudy')

# visualising preferred bikes by annual members across the year 
# using stacked bar chart
data %>%
  filter(member_casual=="member") %>%
  ggplot() +
  geom_col(mapping = aes(x=year_month, y=count_members, fill=rideable_type)) +
  theme(axis.text.x = element_text(angle=45, hjust=1)) +
  scale_x_discrete(name="Year Month") +
  scale_y_continuous(name="Ride count", labels=comma)

ggsave("images/YearlyRideCountAnnual_stacked.png", height=3,width=6.75)

# visualising preferred bikes by casual riders across the year 
# using stacked bar chart
data %>%
  filter(member_casual=="casual") %>%
  ggplot() +
  geom_col(mapping = aes(x=year_month, y=count_members, fill=rideable_type)) +
  theme(axis.text.x = element_text(angle=45, hjust=1)) +
  scale_x_discrete(name="Year Month") +
  scale_y_continuous(name="Ride count", labels=comma)

ggsave("images/YearlyRideCountCasual_stacked.png", height=3,width=6.75)

# ride length pattern for annual riders across the year
data %>%
  filter(member_casual=="member") %>%
  ggplot() +
  geom_col(mapping = aes(x=year_month, y=avg_ride_length/60, fill=rideable_type)) +
  facet_wrap(~rideable_type) +
  theme(axis.text.x = element_text(angle=90, hjust=1)) +
  scale_x_discrete(name="Year Month") +
  scale_y_continuous(name="Average ride duration (Minutes)")

ggsave("images/YearlyRideCountAnnual.png", height=3,width=6.75)

# ride length pattern for casual riders across the year
data %>%
  filter(member_casual=="casual") %>%
  ggplot() +
  geom_col(mapping = aes(x=year_month, y=avg_ride_length/60, fill=rideable_type)) +
  facet_wrap(~rideable_type) +
  theme(axis.text.x = element_text(angle=90, hjust=1)) +
  scale_x_discrete(name="Year Month") +
  scale_y_continuous(name="Average ride duration (Minutes)")

ggsave("images/YearlyRideCountCasual.png", height=3,width=6.75)

# ride count pattern for annual and casual riders across the year
data %>%
  ggplot() +
  geom_col(mapping = aes(x=year_month, y=count_members, fill=rideable_type)) +
  facet_grid(rideable_type~member_casual) +
  theme(axis.text.x = element_text(angle=90, hjust=1)) +
  scale_x_discrete(name="Year Month",) +
  scale_y_continuous(name="Ride Count", labels=comma)

ggsave("images/YearlyBikeRides.png", height=10,width=6.75)

# average ride duration for casual and annual riders 
#with different bike types across the year
data %>%
  ggplot() +
  geom_col(position="dodge", mapping = aes(x=year_month, y=avg_ride_length/60, fill=rideable_type)) +
  facet_grid(rideable_type~member_casual) +
  theme(axis.text.x = element_text(angle=90, hjust=1)) +
  scale_x_discrete(name="Year Month") +
  scale_y_continuous(name="Average ride duration (Minutes)", labels=comma)

ggsave("images/YearlyAverageRideLength.png", height=8,width=6.75)
