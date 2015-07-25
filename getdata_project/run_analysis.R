library(dplyr)

# read in the feature names and activity levels
feature <- read.table("UCI_HAR_Dataset/features.txt",colClasses=c("integer","character"))
activity_labels <- read.table("UCI_HAR_Dataset/activity_labels.txt",colClasses=c("integer","character"))

# identify columns to be selected: all columns with a name ends in mean() or std()
selectfield <- feature[grepl("mean()",feature[,2],fixed=TRUE)|grepl("std()",feature[,2],fixed=TRUE),1]

# load the test data set
test_subject <- read.table("UCI_HAR_Dataset/test/subject_test.txt")
test_activity <- read.table("UCI_HAR_Dataset/test/y_test.txt")
test_vector <- read.table("UCI_HAR_Dataset/test/X_test.txt")

#select the columns in test data
test_vector <- select(test_vector,selectfield)

#put everything in the test data set together
test_data <- cbind(test_subject,test_activity,test_vector)

# load the train data set
train_subject <- read.table("UCI_HAR_Dataset/train/subject_train.txt")
train_activity <- read.table("UCI_HAR_Dataset/train/y_train.txt")
train_vector <- read.table("UCI_HAR_Dataset/train/X_train.txt")

# select the columns in train data
train_vector <- select(train_vector,selectfield)

#put everything in the train data set together
train_data <- cbind(train_subject,train_activity,train_vector)

#combine the test and train data set
combined_data <- rbind(test_data,train_data)

#add the column names to the combined data set
names(combined_data)<-c("subject","activity_level",feature[selectfield,2])

#change the activity level column as a factor and give it corresponding label names
activity<-factor(as.factor(combined_data[,2]),levels=activity_labels[,1],labels=activity_labels[,2])

#put activity label names in the data set
combined_data$activity_label <- activity

#remove the activity level data set
combined_data <- select(combined_data,-activity_level)


# group and compute the mean of each column given the subject and the activity type
grp_cols <- c("subject","activity_label")
dots <- lapply(grp_cols,as.symbol)
grouped_data <- group_by_(combined_data,.dots=dots)
tidydata <- summarise_each(grouped_data,funs(mean))

#write data to disk
write.table(tidydata,file="cleaned_exercise_data.txt",row.names=FALSE)


