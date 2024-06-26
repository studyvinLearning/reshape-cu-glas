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

## ALTERNATIVELY: Just grab the pre-existing meta data frame, and delete the
## paper title at the end. Can use lapply by making use of the [[]] function
## on the data set using the parameter meta
metaList <- lapply(federalistPapers, FUN = '[[', 'meta')

# Same as doing this:
federalistPapers[[1]][['meta']]

# Then simplify:
fedDF <- do.call(rbind, metaList)

# Can do in one line:
fedDF <- do.call(rbind, lapply(federalistPapers, FUN = '[[', 'meta'))

# Remove title
fedDF$title <- NULL

# Remove duplicate of Federalist Paper no. 70
fedDF <- fedDF[-71,]

library(lubridate)

# Determine what day of the week each date is associated with
fedDF$dayOfWeek <- sapply(X = fedDF$date, FUN = wday, label = TRUE)

fedDF

# Table by author and day of week published
table(fedDF$author, fedDF$dayOfWeek)

################################ IGNORE ########################################

# Create a data frame with columns of author names and dates as values
library(tidyr)

fedDFWide <- pivot_wider(fedDF, names_from = 'author', values_from = 'date')

fedDFWide

############################ TOTALLY SUCKS #####################################

# Paper number can't be used as an ID, as the first entry for MADISON won't be 
# the first paper written. He didn't write it! Here's how to do it:
fedDF2 <- fedDF[order(fedDF$date), c('author', 'date')]

# We want to loop over the unique authors to gather the information on papers
# they wrote.
for(a in unique(fedDF2$author)){
  # ask where the author is the ath unique author
  # fedDF2$author == a
   
  # how many papers did the ath author write? Create ids for all.
  # 1:sum(fedDF2$author == a)
  
  # all in one functional line
  fedDF2[fedDF2$author == a, 'id'] <- 1:sum(fedDF2$author == a)
}

# Now we've created our id column, and we can rotate.
head(fedDF2)

# as data frame, because tibbles fucking suck
fedDFWide <- as.data.frame(pivot_wider(fedDF2, names_from = 'author',
                                       values_from = 'date'))

head(fedDFWide)

# Can remove missing values (for Hamilton papers with no dates)
# Makes it so the longest column only has dates, rather than ugly NAs.
fedDFWide <- subset(fedDFWide, !is.na(HAMILTON))
