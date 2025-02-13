#Load required packages
library(tidyverse)
library(downloader)
library(data.table)

#Download and unzip the files
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download(url, dest="dataset.zip", mode="wb") 
unzip ("dataset.zip", exdir = "./")

#Create vector of column labels
col_labels<-fread("UCI HAR Dataset/features.txt")

#Read training data set, set column names, add column for activity and subject
train<-fread("UCI HAR Dataset/train/X_train.txt")
colnames(train)<-col_labels$V2
train_activity<-fread("UCI HAR Dataset/train/Y_train.txt")
train<-cbind(train_activity,train)
colnames(train)[1]<-"activity"
train_subject<-fread("UCI HAR Dataset/train/subject_train.txt")
train<-cbind(train_subject,train)
colnames(train)[1]<-"subject"

#Read test data set, set column names, add column for activity and subject
test<-fread("UCI HAR Dataset/test/X_test.txt")
colnames(test)<-col_labels$V2
test_activity<-fread("UCI HAR Dataset/test/Y_test.txt")
test<-cbind(test_activity,test)
colnames(test)[1]<-"activity"
test_subject<-fread("UCI HAR Dataset/test/subject_test.txt")
test<-cbind(test_subject,test)
colnames(test)[1]<-"subject"

#Merge datasets
dat<-rbind(train,test) 

#Select only mean and sd measures
dat<- dat%>% select(subject,activity,matches("mean|std"),-matches("Freq|angle"))

#Renaming Activities
dat <- dat %>% mutate(activity=case_match(activity,
                                          1~"WALKING",
                                          2~"WALKING_UPSTAIRS",
                                          3~"WALKING_DOWNSTAIRS",
                                          4~"SITTING",
                                          5~"STANDING",
                                          6~"LAYING"))
#Save data
write.csv("dat","clean_data.csv")

#Create data set of averages
avs<- dat %>% group_by(subject,activity) %>% summarize_all(mean)

#Save data
write.csv("dat","clean_data.csv")
write.csv("avs","clean_avs.csv")



