#  Get unzipped data from working directory
getwd()

## Get components of test dataset
test.x <- read.table(paste(getwd(),"\\UCI HAR Dataset\\test\\X_test.txt",sep=""))
test.y <- read.table(paste(getwd(),"\\UCI HAR Dataset\\test\\y_test.txt",sep=""))
test.subj <- read.table(paste(getwd(),"\\UCI HAR Dataset\\test\\subject_test.txt",sep=""))

## Get components of training dataset
train.x <- read.table(paste(getwd(),"\\UCI HAR Dataset\\train\\X_train.txt",sep=""))
train.y <- read.table(paste(getwd(),"\\UCI HAR Dataset\\train\\y_train.txt",sep=""))
train.subj <- read.table(paste(getwd(),"UCI HAR Dataset\\train\\subject_train.txt",sep=""))

## Get other components needed to define labels and variables
features <- read.table(paste(getwd(),"\\UCI HAR Dataset\\features.txt",sep=""))
labels <- read.table(paste(getwd(),"\\UCI HAR Dataset\\activity_labels.txt",sep=""))
names(labels) <- c("CODE","ACTIVITY")
labels$ACTIVITY <- factor(labels$ACTIVITY)

# Merge data into one dataset
dta.all <- rbind(cbind(test.x,data.frame(CODE=unlist(test.y),ID=unlist(test.subj))),
                 cbind(train.x,data.frame(CODE=unlist(train.y),ID=unlist(train.subj)))) 

# Identify labels with "mean()" or "std()"
get.mean <- grep("mean()",features$V2,fixed=T)
names(get.mean) <- features$V2[grep("mean()",features$V2,fixed=T)]
get.std <- grep("std()",features$V2,fixed=T)
names(get.std) <- features$V2[grep("std()",features$V2,fixed=T)]

# Extract data columns based on identified labels with "mean()" or "std()"
dta.mean.std <- dta.all[,c(get.mean,get.std,ncol(dta.all),ncol(dta.all)-1)]

#  Add a column to define activity codes
dta.labeled <- merge(dta.mean.std,labels,by="CODE")
dta.labeled <- dta.labeled[,-1]
names(dta.labeled) <-c(names(c(get.mean,get.std)),"ID","ACTIVITY")
head(dta.labeled)

#  Summarize dataset by activity and subject id
dta.summary <- (aggregate(dta.labeled,list(ID=dta.labeled$ID,ACTIVITY=dta.labeled$ACTIVITY),mean))
dta.summary <- dta.summary[,1:(ncol(dta.summary)-2)]
write.table(dta.summary,paste(getwd(),"/tidy.txt",sep=""),row.names=F, quote=F)
