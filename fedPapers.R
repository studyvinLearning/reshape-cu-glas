rm(list=ls())

# Load federalistPapers data set
library(syllogi)
data(federalistPapers, package='syllogi')

# set data frame values one at a time to respective value in paper metadata.
fedDF <- data.frame()
for(i in 1:length(federalistPapers)){
  tmpDF <- data.frame(number = federalistPapers[[i]]$meta$number,
                author = federalistPapers[[i]]$meta$author,
                journal = federalistPapers[[i]]$meta$journal,
                date = federalistPapers[[i]]$meta$date)
  fedDF <- rbind(fedDF, tmpDF)
}

# Remove duplicate of Federalist Paper no. 70
fedDF <- fedDF[-71,]

library(lubridate)

# Determine what day of the week each date is associated with
fedDF$dayOfWeek <- sapply(X = fedDF$date, FUN = wday, label = TRUE)

fedDF

# Table by author and day of week published
table(fedDF$author, fedDF$dayOfWeek)

# Create a data frame with columns of author names and dates as values
fedDFWide <- pivot_wider(fedDF, names_from = 'author', values_from = 'date')

fedDFWide
