# Loading the features names
featuresFile = "./UCI HAR Dataset/features.txt"
featuresNames = read.table(featuresFile, col.names=c("feature_id", "feature_name"))

# Loading the activity labels
activitiesFile = "./UCI HAR Dataset/activity_labels.txt"
activities = read.table(activitiesFile, col.names = c("activity_id", "activity_name"))

# Make the feature filter
featureFilter <- grep("(.*mean[(][)])|(.*std[(][)])", featuresNames$feature_name)

# Loading the training set
trainFile.X = "./UCI HAR Dataset/train/X_train.txt"
train.X = read.table(trainFile.X, col.names = featuresNames[,2])[, featureFilter]

trainFile.y = "./UCI HAR Dataset/train/y_train.txt"
train.y = read.table(trainFile.y, col.names = c("activity_id"))

trainFile.subject = "./UCI HAR Dataset/train/subject_train.txt"
train.subject = read.table(trainFile.subject, col.names = c("subject_id"))

# Merging the training set
train = cbind(train.X, train.subject, train.y)

# Loading the test set
testFile.X = "./UCI HAR Dataset/test/X_test.txt"
test.X = read.table(testFile.X, col.names = featuresNames[,2])[, featureFilter]

testFile.y = "./UCI HAR Dataset/test/y_test.txt"
test.y = read.table(testFile.y, col.names = c("activity_id"))

testFile.subject = "./UCI HAR Dataset/test/subject_test.txt"
test.subject = read.table(testFile.subject, col.names = c("subject_id"))

# Merging the test set
test = cbind(test.X, test.subject, test.y)

# Merge data
data.with.codes = rbind(train, test)
data = merge(data.with.codes, activities, by.x = "activity_id", by.y = "activity_id", all = TRUE)
data$activity_id = NULL
names(data) <- gsub("[.][.]", "", names(data))

# Summarize data
tidy <- aggregate(data[,1:66], by=list(data$subject_id, data$activity_name), FUN="mean")
tidy_names <- names(tidy)
tidy_names[1] <- "subject_id"
tidy_names[2] <- "activity"
names(tidy) <- tidy_names

# Write tidy data
tidyFile = "./tidy.txt"
write.table(tidy, file = tidyFile, row.name=FALSE, )