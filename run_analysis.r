library(dplyr)
library(data.table)

## use read.table to read data and remove "" as NA
getCleanedData <- function(file_name){
        con <- file(file_name,"r") 
        d <- read.table(con, sep = "", header = F, na.strings = "", stringsAsFactor = F) 
        close(con)
        d
}

## 1.Merges the training and the test sets to create one data set.
## get test & traing data from files in sequence of y, subject X
test <- getCleanedData("./UCI HAR Dataset/test/y_test.txt") %>%
        cbind(getCleanedData("./UCI HAR Dataset/test/subject_test.txt")) %>% 
        cbind(getCleanedData("./UCI HAR Dataset/test/X_test.txt"))
train <-getCleanedData("./UCI HAR Dataset/train/y_train.txt") %>%
        cbind(getCleanedData("./UCI HAR Dataset/train/subject_train.txt")) %>% 
        cbind(getCleanedData("./UCI HAR Dataset/train/X_train.txt"))
all_data <- rbind(test,train)

##2.Extracts only the measurements on the mean and standard deviation for each measurement.
features <- getCleanedData("./UCI HAR Dataset/features.txt") ## get features
v1 <- grepl("mean|std", tolower(features$V2)) ##extract columns names similar to mean or std
v2 <- c(TRUE, TRUE) ## keep column 1 & 2
v <- c(v2,v1) ##all columns, TRUE to keep
selected_data <- all_data[,v]

## 3.Uses descriptive activity names to name the activities in the data set
## get activity_labels (1. WALKING 2 WALKING_UPSTAIRS...6)
activity_labels <- getCleanedData("./UCI HAR Dataset/activity_labels.txt")%>%
        rename("activity" = V1)
## merge activity names (assign 2 table the same column name for merge)
selected_data <- rename(selected_data,"activity" = V1)
merged_data <- merge(activity_labels,selected_data,by.x="activity", by.y="activity")

## 4.Appropriately labels the data set with descriptive variable names.
## assign column names for the first 3 columns
colnames(merged_data) <- c("activity","activit_name","subject")
## assign the rest from features extracted columns 
extract_colnames <- features[,2][v1]
for(i in 1: length(extract_colnames)){
       colnames(merged_data)[i+3] <- as.character(extract_colnames[i])
}

## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
new_data <- aggregate(merged_data[, 4:ncol(merged_data)],
        by = list(activity  = merged_data$activity,subject = merged_data$subject), mean)
write.table(new_data,"week4_output.txt", sep = " ", col.names = FALSE)
