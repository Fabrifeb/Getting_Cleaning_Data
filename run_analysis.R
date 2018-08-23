#create a folder and download files

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

TestData <- read.table ("./data/UCI HAR Dataset/test/X_test.txt") #read test data

TestSub <- read.table ("./data/UCI HAR Dataset/test/subject_test.txt") #read test subjects

feat <- read.table ("./data/UCI HAR Dataset/features.txt") #read features

feat_names <- as.character(feat$V2) #take features names vector

names(TestData) = feat_names #rename column names of TestData

TestData <- cbind(SubjectID = TestSub$V1, TestData) #add SubjectID column

Act_test <- read.table ("./data/UCI HAR Dataset/test/y_test.txt") #read test activities

Act_test<-as.character(Act_test$V1) #extract and make it character vector

#replace wit the right Activities names
Act_test <- gsub("1","WALKING", Act_test)
Act_test <- gsub("2","WALKING_UPSTAIRS", Act_test)
Act_test <- gsub("3","WALKING_DOWNSTAIRS", Act_test)
Act_test <- gsub("4","SITTING", Act_test)
Act_test <- gsub("5","STANDING
",Act_test)
Act_test <- gsub("6","LAYING
", Act_test)
Act_test <- gsub("\n","", Act_test) #remove /n character

TestData <- cbind(Activity = Act_test, TestData) #add Activity column


TrainData <- read.table ("./data/UCI HAR Dataset/train/X_train.txt") #read train data

TrainSub <- read.table ("./data/UCI HAR Dataset/train/subject_train.txt") #read train subjects

names(TrainData) = feat_names #rename column names of TrainData

TrainData <- cbind(SubjectID = TrainSub$V1, TrainData) #add SubjectID column

Act_train <- read.table ("./data/UCI HAR Dataset/train/y_train.txt") #read train activities

Act_train <-as.character(Act_train$V1) #extract and make it character vector
#rename activities
Act_train <- gsub("1","WALKING",Act_train)
Act_train <- gsub("2","WALKING_UPSTAIRS",Act_train)
Act_train <- gsub("3","WALnrowKING_DOWNSTAIRS",Act_train)
Act_train <- gsub("4","SITTING",Act_train)
Act_train <- gsub("5","STANDING
",Act_train)
Act_train <- gsub("6","LAYING
",Act_train)
Act_train <- gsub("\n","",Act_train) #remove /n character

TrainData <- cbind(Activity = Act_train, TrainData) #add Activity column

MergedData = rbind(TrainData,TestData) #merge the 2 datasets
MergedData = MergedData[order(MergedData[,2] , MergedData[,1]),] #order the merged dataset by subjectID and Activity

a=grep("mean",names(MergedData)) #find variables with mean
b=grep("std",names(MergedData)) #find variables with std
c=c(1,2,a,b) #merge the two vectors above
c=order(c) #order the merged vector

MergedData <- MergedData[,c] #subset the merged dataset with only std and mean columns



AverageData <- aggregate(x=MergedData, by=list(Activity=MergedData$Activity, SubjectID=MergedData$SubjectID), FUN=mean)

write.table(AverageData, file = "tidydata.txt",row.name=FALSE)
