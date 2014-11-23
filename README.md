coursera-getting-and-cleaning-data
==================================

## Reading the data 
1. Read the train data -- train/X_train.txt
2.  Read the test data -- test/X_test.txt
3. Combine the train data and the test data into one 10299x561 data.frame 
4 reads the subjects for the train data
5. reads the subjects for the test data
6. combine the subjects  -- training and subjects -- into a single a 10299x1 dataframe 

## Labels
1. reads the activity labels for the training data
2.  reads the activity labels for the test data
3.  combines the activity labels into a 10299x1 dataframe
4. names the activity labels and the subject labels with a descriptive variable name
5. Get the descriptive activity label names from the activity_labels.txt
6. changes the label names to camelCase format

## Columns 
1.  Read the features file and store it in a 561x2 dataframe
2. get the index of the variable labels that contains either "mean()" or "std()"
 from the feature to get the variables that contain measurements of the mean
 and standard deviation resulting in a numeric vector with 66 members.
3. subset the full data by the index to get a 10299x66 dataframe
4. Select the required labels from the features data.frame by
  subsetting the features dataframe by index
5. Cleans up the column names of the subset by removing the "()" and making the 
 first letter of "mean" and "std" a capital letter "M" and "S" respectively.
6. apply the headings as the variable names for the data

## The data
1. Combine the subset of fulldata "data.full.subset" with the 
   subject label "subject.full" and activity labels "labels.full"
2. Apply the activity labels to the activity column

## tidy data

1. generate a second, independent tidy data set with the average of each 
   variable for each activity and each subject.
