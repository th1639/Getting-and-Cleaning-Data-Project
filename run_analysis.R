##  download data file from the web

fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="Dataset.zip")

##  unzip input data 

unzip("Dataset.zip")

## obtain reference data 

features <- read.table(".//UCI HAR Dataset//features.txt")
labels <- read.table(".//UCI HAR Dataset//activity_labels.txt")

## obtain test data set 

x_test <- read.table(".//UCI HAR Dataset//test//x_test.txt")
y_test <- read.table(".//UCI HAR Dataset//test//Y_test.txt")
subject_test <- read.table(".//UCI HAR Dataset//test//subject_test.txt")

## obtain training data set 

x_train <- read.table(".//UCI HAR Dataset//train//X_train.txt")
y_train <- read.table(".//UCI HAR Dataset//train//Y_train.txt")
subject_train <- read.table(".//UCI HAR Dataset//train//subject_train.txt")

## combine data into one file for analysis
## req#1 - Merges the training and the test sets to create one data set.

x_data <- rbind(x_train, x_test)

## add descriptions to the x data, matching the reference values from features.txt
## req #4 Appropriately labels the data set with descriptive variable names

colnames(x_data)<- features[,2]

## select only the mean & standard deviation from the x data  
## req#2 Extracts only the measurements on the mean and standard 
deviation for each measurement. 

sub_x_data <- x_data[ , grep("mean()|std()",colnames(x_data))]
sub_x_data <- sub_x_data[ , -grep("meanFreq()",colnames(sub_x_data))]

## combine data into one file for analysis
## req#1 - Merges the training and the test sets to create one data set.

y_data <- rbind(y_train, y_test)

## add descriptions to the y data, matching the reference values from features.txt
## req #4 Appropriately labels the data set with descriptive variable names
 
y_data$activity <- labels[match(y_data$V1,labels$V1), "V2"]
y_data <- subset(y_data, select = -c(V1))

## rename column 
## req#4 Appropriately labels the data set with descriptive 
variable names

subject_data <- rbind(subject_train, subject_test)
colnames(subject_data)<- "subject"

## combine data into one file for analysis
## req#1 - Merges the training and the test sets to create one data set.

df <- cbind(subject_data, y_data, sub_x_data)

## req #5 Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

mean_df <-aggregate(. ~df$subject+df$activity,data = df, FUN=mean, na.rm=TRUE)

mean_df <- subset(mean_df, select = -c(subject,activity))
colnames(mean_df)[1] <- "subject"
colnames(mean_df)[2] <- "activity"

write.table(mean_df, file = "assignment_output")
