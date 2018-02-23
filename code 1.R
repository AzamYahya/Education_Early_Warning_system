library(foreign)
#Import section from PSLM 2012-13
education <- read.dta("Z:/Ferguson 13 march/other assignment/DS/Development sector/HIES 2012-2013/DATA/sec_c.dta")
family <-  read.dta("Z:/Ferguson 13 march/other assignment/DS/Development sector/HIES 2012-2013/DATA/sec_g.dta")

education <- education[,c(-15,-17)]
family <- family[,c(1,6,7,10,13,19)]
#column names of the family data set

family_names <- c("hhcode","resid_stat", "rooms", "source_water", "source_ligth",
                  "reach_transport")

colnames(family) <- family_names 

#change the names of the features
names <- c("hhcode", "province", "region", "district","sec",
           "idc", "read_and_write","math_solve", "attend_edu_insti",
           "highest_educ", "undergoing_educ", "undergoing_edu_level",
           "undergoing_educ_insti", "problems_insti", "reason_for_no_education")

colnames(education) <- names

education <- education[complete.cases(education$highest_educ),]


# class three is most important class to determined the future education
#https://dssg.uchicago.edu/project/predicting-students-that-will-struggle-academically-by-third-grade/

#convert them till to "less than 3" and to "more than two"

education$highest_educ <-  ifelse(education$highest_educ == "less than 1" | 
                                    education$highest_educ == "class 1" |
                                    education$highest_educ == "class 2" ,"Drop Out",
                                  "Continue")

#Remove district
education <- education[,c(-4)]


#join family and education dataset by hhcode

library(dplyr)
education_family <- right_join(education, family, by = "hhcode")

#remove duplicated

education_family <- education_family[!duplicated(education_family$hhcode),]


#Impute missing values in read_and_write,math_solve, problems_inst and reason_for_no_education
library(missForest)
education_family2 <- missForest(education_family[,c(6,7,13,14)])
education_family2 <-  education_family2$ximp
education_family <- cbind.data.frame(education_family[,1:5],education_family2[,1:2],
                           education_family[,8:12],education_family2[,3:4],
                           education_family[,15:19])
#Our dependent variable is highest_educ and not undergoing_edu_level 

dependent <- as.data.frame(education_family[,c(9)])

#chane colname to highest_educ

colnames(dependent)[1] <- "highest_educ"

#the list of independent variables are

features <- education_family[, c(2,3,6,7,13,14,15,16,17,18,19)]


# create a basic machine learning algo

library(caret)
library(nnet)

#upsample the response variable because of the class imbalance
up_train <- upSample(x = features,
                         y = dependent$highest_educ)


#chagen Class response variable name to highest_educ

colnames(up_train)[12] <- "highest_educ"


fitControl <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number = 10,
  ## repeated ten times
  repeats = 10)

library(doParallel)
registerDoParallel(4)


model <- train(highest_educ~province+region+read_and_write+math_solve+
                 problems_insti+reason_for_no_education+resid_stat+
                 rooms+source_water+source_ligth+reach_transport,data = up_train,
               method = "nnet",
               trControl = fitControl, na.action  = na.omit)


setwd("Z:/Ferguson 13 march/other assignment/DS/Early Warning system education/shiny")
#use model2 that is trained uses nnet
saveRDS(model, "model2.rda")
saveRDS(features, "features.rda")
