setwd("D:/yschangd/MyDocuments/Work_EBO/MDID/52. DataScientist/trainingPath/03_Getting and Cleaning Data/week4/programming")

library(dplyr) ## try to use dplyr grammer as much as possible
## use read.csv to read data
getData <- function(file_name, header = FALSE, sep = " "){
        con <- file(file_name,"r") 
        d <- read.csv(con, header, sep) 
        close(con)
        d
}

## 1.Merges the training and the test sets to create one data set.


## get test data for X, y, subject data
y <- getData("./UCI HAR Dataset/test/y_test.txt")
subject <- getData("./UCI HAR Dataset/test/subject_test.txt")

con <- file("./UCI HAR Dataset/test/X_test.txt","r")
X <- read.table(con, sep = "", header = F, na.strings = "", stringsAsFactor = F)
close(con)

## combine into one test table
test <-cbind(subject,y) %>%
        cbind(X)
ncol(test)

## get train data for X, y, subject data
y2 <- getData("./UCI HAR Dataset/train/y_train.txt")
subject2 <- getData("./UCI HAR Dataset/train/subject_train.txt")
        
con <- file("./UCI HAR Dataset/train/X_train.txt","r")
X2 <- read.table(con, sep = "", header = F, na.strings = "", stringsAsFactor = F)
close(con)

## combine into one table = train + test
train <-cbind(subject2,y2) %>%
        cbind(X2) 
ncol(train)

all_data <- rbind(test,train)
head(str(all_data)        )

##2.Extracts only the measurements on the mean and standard deviation for each measurement.
## get features (561 rows of column name)
features <- getData("./UCI HAR Dataset/features.txt")
## assign column names
colnames(all_data) <- c("subject","activity")
for(i in 1: nrow(features)){
       colnames(all_data)[i+2] <- as.character(features[i,2])
}
head(colnames(all_data),10)

v <- grep("subject|activity|mean|std", tolower(names(all_data)))
selected_data <- all_data[,v]
colnames(selected_data)

## 3.Uses descriptive activity names to name the activities in the data set
## get activity_labels (1. WALKING 2 WALKING_UPSTAIRS...6)
activity_labels <- getData("./UCI HAR Dataset/activity_labels.txt") %>%
        rename("activity" = V1,"activity_name" = V2)
selected_data <- merge(activity_labels,selected_data,by.x="activity", by.y="activity")
head(colnames(selected_data))

## 4.Appropriately labels the data set with descriptive variable names.
# column names are already assigned

## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
new_data <- aggregate(selected_data[, 4:ncol(selected_data)],
        by = list(activity  = selected_data$activity
        ,subject = selected_data$subject), mean)

write.table(new_data,"4_output.txt", sep = " ", col.names = FALSE)




## 1.1 get activity_labels (1. WALKING 2 WALKING_UPSTAIRS...6)
con <- file("./UCI HAR Dataset/activity_labels.txt","r") 
activity_labels <- read.csv(con, header = FALSE, sep = " ") %>%
        rename("Activity_id"=V1, "Activity_name"=V2)
close(con)

## 1.2 get features (561 rows of column name)
con <- file("./UCI HAR Dataset/features.txt","r") 
features <- read.csv(con, header = FALSE, sep = " ") %>%
        rename("Col_ID"=V1, "Col_name"=V2)
close(con)

##1.3 get X, y, subject data
getData <- function(file_name, header = FALSE, sep = " "){
        con <- file(file_name,"r") 
        d <- read.csv2(con, header, sep) 
        close(con)
        d
}


