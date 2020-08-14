library(dplyr)
library(bitops)
library(RCurl)
# First We download the dataset to a local directory if it does not already exist.
if(!dir.exists("./UCI HAR Dataset"))
{
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  dir.create("./UCI HAR Dataset")
  download.file(fileUrl, "Data-to-tidy.zip")
  unzip("./Data-to-tidy.zip")
}

#Next We read all the tables from the directory into data frames.
my_train_x <- read.table(file = "./UCI HAR Dataset/train/X_train.txt")
my_test_x <- read.table(file = "./UCI HAR Dataset/test/X_test.txt")

my_train_y <- read.table(file = "./UCI HAR Dataset/train/Y_train.txt")
my_test_y <- read.table(file = "./UCI HAR Dataset/test/Y_test.txt")

my_train_sub <- read.table(file = "./UCI HAR Dataset/train/subject_train.txt")
my_test_sub <- read.table(file = "./UCI HAR Dataset/test/subject_test.txt")

# Now weread data description
variable_names <- read.table("./UCI HAR Dataset/features.txt")

# We also read activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# 1. Merges the training and the test sets to create one data set.
total_x <- rbind(my_train_x, my_test_x)
total_y <- rbind(my_train_y, my_test_y)
total_sub <- rbind(my_train_sub, my_test_sub)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
total_x <- total_x[,selected_var[,1]]

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
total_x <- total_x[,selected_var[,1]]

# 3. Uses descriptive activity names to name the activities in the data set
colnames(Y_total) <- "activity"
Y_total$activitylabel <- factor(Y_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_total[,-1]

# 4. Appropriately labels the data set with descriptive variable names.
colnames(X_total) <- variable_names[selected_var[,1],2]

# 5. From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
colnames(Sub_total) <- "subject"
total <- cbind(X_total, activitylabel, Sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)

