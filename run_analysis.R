#Create tidy data set from UCI Machine Learning data available here:
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#Read test and training files into R
	testdata <- read.table("X_test.txt")
	traindata <- read.table("X_train.txt")
	testdatalabels <- read.table("y_test.txt")
	traindatalabels <- read.table("y_train.txt")
	testsubject <- read.table("subject_test.txt")
	trainsubject <- read.table("subject_train.txt")
	variablenames <- read.table("features.txt")

#Apply variable names from Features.txt to test and train data
	colnames(testdata)<-variablenames[,2]
	colnames(traindata)<-variablenames[,2]

#Add variable names to y and subject files
	colnames(testdatalabels) <- c("activity")
	colnames(traindatalabels) <- c("activity")
	colnames(testsubject) <- c("subject")
	colnames(trainsubject) <- c("subject")

#Subset only columns with mean or std in variable name
	testdatams <- testdata[,grep("mean|std", names(testdata))]
	traindatams <- traindata[,grep("mean|std", names(traindata))]

#Merge activity labels to data sets
	testdatams <- cbind(testdatalabels, testsubject, testdatams)
	traindatams <- cbind(traindatalabels, trainsubject, traindatams) 

#Merge test and train data subsets
	alldata <- merge(testdatams,traindatams,
		by=intersect(names(testdatams),names(traindatams)),
		all.x=TRUE,all.y=TRUE)

#Remove mean frequency columns
	datafinal <- alldata[,-grep("Freq", names(alldata))]

#Replace activity numbers with activity names
	datafinal$activity <- gsub("1","walking",datafinal$activity)
	datafinal$activity <- gsub("2","walking_upstairs",datafinal$activity)
	datafinal$activity <- gsub("3","walking_downstairs",datafinal$activity)
	datafinal$activity <- gsub("4","sitting",datafinal$activity)
	datafinal$activity <- gsub("5","standing",datafinal$activity)
	datafinal$activity <- gsub("6","laying",datafinal$activity)

#Create second data frame with average of each variable per activity and subject
	summary <- aggregate(datafinal[,3:ncol(datafinal)],
		by=list(subject = datafinal$subject,activity = datafinal$activity),
		mean)
	write.table(summary, "tidied_data.txt", row.name=FALSE)	
