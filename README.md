#  Tidy dataset
The dataset contains the mean value of the response variable (defined in Tidy Dataset Variables section) grouped by activity (defined in Experimental Design section) and subject

##  Experimental design
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

#  Tidy dataset Variables

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

* mean(): Mean value
* std(): Standard deviation

#  R code for generating tidy dataset
##  Get unzipped data from working directory
getwd()

### Get components of test dataset
* test.x <- read.table(paste(getwd(),"\\UCI HAR Dataset\\test\\X_test.txt",sep=""))
* test.y <- read.table(paste(getwd(),"\\UCI HAR Dataset\\test\\y_test.txt",sep=""))
* test.subj <- read.table(paste(getwd(),"\\UCI HAR Dataset\\test\\subject_test.txt",sep=""))

## Get components of training dataset
* train.x <- read.table(paste(getwd(),"\\UCI HAR Dataset\\train\\X_train.txt",sep=""))
* train.y <- read.table(paste(getwd(),"\\UCI HAR Dataset\\train\\y_train.txt",sep=""))
* train.subj <- read.table(paste(getwd(),"UCI HAR Dataset\\train\\subject_train.txt",sep=""))

## Get other components needed to define labels and variables
* features <- read.table(paste(getwd(),"\\UCI HAR Dataset\\features.txt",sep=""))
* labels <- read.table(paste(getwd(),"\\UCI HAR Dataset\\activity_labels.txt",sep=""))
* names(labels) <- c("CODE","ACTIVITY")
* labels$ACTIVITY <- factor(labels$ACTIVITY)

## Merge data into one dataset
dta.all <- rbind(cbind(test.x,data.frame(CODE=unlist(test.y),ID=unlist(test.subj))),
                 cbind(train.x,data.frame(CODE=unlist(train.y),ID=unlist(train.subj)))) 

## Identify labels with "mean()" or "std()"
* get.mean <- grep("mean()",features$V2,fixed=T)
* names(get.mean) <- features$V2[grep("mean()",features$V2,fixed=T)]
* get.std <- grep("std()",features$V2,fixed=T)
* names(get.std) <- features$V2[grep("std()",features$V2,fixed=T)]

## Extract data columns based on identified labels with "mean()" or "std()"
dta.mean.std <- dta.all[,c(get.mean,get.std,ncol(dta.all),ncol(dta.all)-1)]

##  Add a column to define activity codes
* dta.labeled <- merge(dta.mean.std,labels,by="CODE")
* dta.labeled <- dta.labeled[,-1]
* names(dta.labeled) <-c(names(c(get.mean,get.std)),"ID","ACTIVITY")
* head(dta.labeled)

##  Summarize dataset by activity and subject id
* dta.summary <- (aggregate(dta.labeled,list(ID=dta.labeled$ID,ACTIVITY=dta.labeled$ACTIVITY),mean))
* dta.summary <- dta.summary[,1:(ncol(dta.summary)-2)]
* write.table(dta.summary,paste(getwd(),"/tidy.txt",sep=""),row.names=F,quote=F)
