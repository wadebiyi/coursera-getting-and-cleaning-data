setwd("/home/users/Manjaro/wadebiyi/Dropbox/MyData/r-programming/getdata/project/UCI HAR Dataset/")
library(data.table)
library(dplyr)

## Read the train data -- train/X_train.txt
data.train <- read.table("train/X_train.txt")

## Read the test data -- test/X_test.txt
data.test <- read.table("test/X_test.txt")

## Combine the train data and the test data into one 10299x561 data.frame 
data.full <- rbind(data.train, data.test)

subjects.train <- read.table("train//subject_train.txt")
subjects.test <- read.table("test//subject_test.txt")

subjects.full <- rbind(subjects.train, subjects.test)



labels.train <- read.table("train/y_train.txt")
labels.test <- read.table("test/y_test.txt")

labels.full <- rbind(labels.train, labels.test)

names(labels.full) <- "activity.labels"
names(subjects.full) <- "subject.id"

##Read the features file and and store the 2nd column as headings
features <-read.table("features.txt")

index <- grep("mean\\(\\)|std\\(\\)", features$V2)

##subset the full data by index
data.full.subset <- data.full[,index]

## Select the required labels from the features data.frame
## subset the features by index
features.subset <- features[index,]

## Cleans up the column names of the subset
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


## Read the train/subjects_train.txt and the training labels train/y_train.txt and
## apply the "activity.labels" as the variable name for the training labels and "subject.id"
## as variable name for the subjects

labels.train <- read.table("train/y_train.txt")
names(labels.train) <- "activity.labels"
names(subjects.train) <- "subject.id"

## Combine the training data, subjects.id and training labels as train.data
train.data <- tbl_dt(cbind(subjects.train, labels.train[1], a))
setkey(train.data, subject.id)



names(b) <- headings

names(subjects.test) <- "subject.id"
labels.test <- read.table("test/y_test.txt")
names(labels.test) <- "activity.labels"
test.data <- tbl_dt(cbind(subjects.test, labels.test[1], b))
setkey(test.data, subject.id)

fulldata <- tbl_dt(rbind(test.data, train.data))
# fulldt <- tbl_dt(fulldata)
fulldata.part <-   fulldata%>%
  mutate(activity = factor(activity.labels, 
                           labels=as.character(unlist(labels[2]))))%>%
  select(subject.id, activity, 
         contains("mean()"), 
         contains("std()"))

fulldata.part%>%
  group_by(subject.id, activity) %>%
  print
tidy.data <- fulldata.part[, lapply(.SD, mean, na.rm=T), by=list(subject.id, activity)]
