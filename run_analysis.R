setwd("/home/users/Manjaro/wadebiyi/Dropbox/MyData/r-programming/getdata/project/UCI HAR Dataset/")

setwd("UCI HAR Dataset/")
library(data.table)
library(dplyr)

## Read the train data -- train/X_train.txt
data.train <- read.table("train/X_train.txt")

## Read the test data -- test/X_test.txt
data.test <- read.table("test/X_test.txt")

## Combine the train data and the test data into one 10299x561 data.frame 
data.full <- rbind(data.train, data.test)


## reads the subjects for the train data
subjects.train <- read.table("train//subject_train.txt")

## reads the subjects for the test data
subjects.test <- read.table("test//subject_test.txt")

## combine the subjects  -- training and subjects -- into a single
## 10299x1 dataframe 
subjects.full <- rbind(subjects.train, subjects.test)


## reads the activity labels for the training data
labels.train <- read.table("train/y_train.txt")

## reads the activity labels for the test data
labels.test <- read.table("test/y_test.txt")


## combines the activity labels into a 10299x1 dataframe
labels.full <- rbind(labels.train, labels.test)

## names the activity labels and the subject labels with a descriptive variable
## name
names(labels.full) <- "activity"
names(subjects.full) <- "subject.id"


## Get the descriptive activity label names from the activity_labels.txt
## changes the label names to camelCase format
activity.labels <- read.table("activity_labels.txt")
activity.labels <- as.data.frame(sapply(activity.labels, tolower))
activity.labels <- as.data.frame(
  sapply(activity.labels, gsub, pattern= "_(\\w)", replacement="\\U\\1", perl=T))
activity.labels <- as.character(unlist(activity.labels[2]))



##Read the features file and store it in a 561x2 dataframe
features <-read.table("features.txt")

## get the index of the variable labels that contains either "mean()" or "std()"
## from the feature to get the variables that contain measurements of the mean
## and standard deviation resulting in a numeric vector with 66 members.
index <- grep("mean\\(\\)|std\\(\\)", features$V2)

##subset the full data by the index to get a 10299x66 dataframe
data.full.subset <- data.full[,index]

## Select the required labels from the features data.frame by
## subsetting the features dataframe by index
features.subset <- features[index,]

## Cleans up the column names of the subset by removing the "()" and making the 
##  first letter of "mean" and "std" a capital letter "M" and "S" respectively.

f <- as.data.frame(sapply(features.subset, gsub, pattern="\\(\\)", replacement="",perl=T))
f <- as.data.frame(sapply(f, gsub,pattern="-mean", replacement="Mean",perl=T))
f <- as.data.frame(sapply(f, gsub, pattern="-std", replacement = "Std"))
headings <- as.vector(unlist(f[2]))

##apply the headings as the variable names for the data
names(data.full.subset) <- headings


## 

## Combine the subset of fulldata "data.full.subset" with the 
##subject label "subject.full" and activity labels "labels.full"
fulldata <- tbl_dt(cbind(subjects.full, labels.full, data.full.subset))

## Apply the activity labels to the activity column
fulldata$activity <- factor(fulldata$activity, labels = activity.labels)



## generate a second, independent tidy data set with the average of each 
## variable for each activity and each subject.
tidy.data <- fulldata[, lapply(.SD, mean, na.rm=T), by=list(subject.id, activity)]

write.table(tidy.data, file = "tidy_data.txt", row.names  = FALSE )
