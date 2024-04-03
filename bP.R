rm(list = ls())

# Read in R object
bloodPressure <- readRDS("bloodPressure.RDS")

# Extract all column names except person
bPNames <- colnames(bloodPressure)[2:63]

# Pivot data frame to longer format, systolic/diastolic information in one
# column instead of multiple
bP <- pivot_longer(bloodPressure, cols = all_of(bPNames),
                   names_to = 'systolic/diastolic', values_to = 'value')

# Initialize a date column. Currently dates are in systolic/diastolic, but will
# change
bP$date <- rep(NA, times = nrow(bP))
head(bP)

# Split systolic/diastolic date information into systolic/diastolic information
# and separate date information
sysDiaDate <- strsplit(bP$`systolic/diastolic`, split = ' ')

# Assign systolic/diastolic information and date information into existing
# appropriate columns of data frame
for(i in 1:length(sysDiaDate)){
   bP[i,]$`systolic/diastolic` <- sysDiaDate[[i]][1]
   bP[i,]$date <- sysDiaDate[[i]][2]
}

head(bP)

# Convert all character date strings into appropriate R Date object
# with lubridate
library(lubridate)
bP$date <- ymd(bP$date)

head(bP)

# Determine what day of the week each date was
bP$dayOfWeek <- wday(bP$date, label = TRUE)

head(bP)

# Aggregate blood pressure means by systolic/diastolic and day of the week
aggregate(value ~ `systolic/diastolic` + dayOfWeek, data = bP, FUN = mean)