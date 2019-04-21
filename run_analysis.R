## You should create one R script called run_analysis.R that does the following.

## 1. Merges the training and the test sets to create one data set.
library(tidyverse)
library(plyr)

# Load features file in order to label columns
features <- read.table("./UCI HAR Dataset/features.txt")
features <- t(features)

# Load files belonging to training dataset
training_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
training_data_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
training_data_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")

# Load files belonging to test dataset
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_data_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test_data_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")

# Combine datasets
colnames(training_data)[] <- (features[2,])
training_data <- bind_cols(training_data_subjects, training_data_labels, training_data)
names(training_data)[c(1,2)] <- c("subject", "label")

colnames(test_data)[] <- (features[2,])
test_data <- bind_cols(test_data_subjects, test_data_labels, test_data)
names(test_data)[c(1,2)] <- c("subject", "label")

merged <- bind_rows(training_data, test_data)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
merged_select <- merged %>% 
  select(matches('subject|label|mean|std'))

## 3. Uses descriptive activity names to name the activities in the data set
label_names <- read.table("./UCI HAR Dataset/activity_labels.txt")

merged_select$label <- as.factor(merged_select$label)
merged_select$label <- revalue(merged_select$label, c("1"="WALKING", "2"="WALKING_UPSTAIRS", "3"="WALKING_DOWNSTAIRS", "4"="SITTING", "5"="STANDING", "6"="LAYING"))


## 4. Appropriately labels the data set with descriptive variable names.
# Already done for Question 1, makes selecting the appropriate columns easier.

## 5. From the data set in step 4, creates a second, independent tidy data set with the average 
## of each variable for each activity and each subject.

merged_select$subject <- as.factor(merged_select$subject)

merged_tidy <- merged_select %>% 
  group_by(subject, label) %>%
  summarise_each(funs(mean))
  
# write to .txt file
write.table(merged_tidy, file = "merged_tidy.txt", row.names = FALSE)
