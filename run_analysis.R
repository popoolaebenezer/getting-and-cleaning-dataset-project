library(reshape2)

#Define the filename for the data to be downloaded

dataFileName <- "dataset.zip" # the extension is ".zip" because the file to be downloaded is zipped

# Check if the filename exists before downloading the file:
if (!file.exists(dataFileName)){
  urlOfFile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(urlOfFile, dataFileName, method="curl")
}

# create a folder if not exist and unzip into it   
if (!file.exists("UCI HAR Dataset")) { 
  unzip(dataFileName) 
}

# Read the features labels into tables
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Read the activities labels into tables
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])


# Use grep to extract features containing the string "mean" or "std"
selectedFeatures <- grep(".*mean.*|.*std.*", features[,2]) # This gets the line numbers
namesOfSelectedFeatures <- features[selectedFeatures,2] # This gets the actual names of the lines
# Use gsub to finetune the names of selected features
namesOfSelectedFeatures = gsub('-mean', 'Mean', namesOfSelectedFeatures)
namesOfSelectedFeatures = gsub('-std', 'Std', namesOfSelectedFeatures)
namesOfSelectedFeatures <- gsub('[-()]', '', namesOfSelectedFeatures)


# Loading the training datasets and subjects
train <- read.table("UCI HAR Dataset/train/X_train.txt")[selectedFeatures]
trainActivities <- read.table("UCI HAR Dataset/train/y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

# Loading the testing datasets and subjects
test <- read.table("UCI HAR Dataset/test/X_test.txt")[selectedFeatures]
testActivities <- read.table("UCI HAR Dataset/test/y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merging the training and test datasets by row
totalDataset <- rbind(train, test)
# Adding labels and column names
colnames(totalDataset) <- c("subject", "activity", namesOfSelectedFeatures)

# convert activities & subjects into factors
totalDataset$activity <- factor(totalDataset$activity, levels = activityLabels[,1], labels = activityLabels[,2])
totalDataset$subject <- as.factor(totalDataset$subject)

# tidy the dataset
totalDataset.melted <- melt(totalDataset, id = c("subject", "activity"))
totalDataset.mean <- dcast(totalDataset.melted, subject + activity ~ variable, mean)


#write.csv(totalDataset.mean, file = "tidyDataset.csv")
# Write output to file
write.table(totalDataset.mean, file = "tidyDataset.txt", row.name=FALSE)
