# lesson3_week4_programming

## 1.Merges the training and the test sets to create one data set.
## get test & traing data from files in sequence of y, subject X
- UCI HAR Dataset\test\: merge 3 files of subject_test.txt, X_test.txt, y_test.txt
- UCI HAR Dataset\train\: merge 3 files of subject_train.txt, X_train.txt, y_train.txt
- label and activity under UCI HAR Dataset\activity_labels.txt, features.txt

##2.Extracts only the measurements on the mean and standard deviation for each measurement.

## 3.Uses descriptive activity names to name the activities in the data set
## get activity_labels (1. WALKING 2 WALKING_UPSTAIRS...6)

## merge activity names (assign 2 table the same column name for merge)

## 4.Appropriately labels the data set with descriptive variable names.
## assign column names for the first 3 columns
## assign the rest from features extracted columns 

## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

