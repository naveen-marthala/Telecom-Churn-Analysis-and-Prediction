# GETTING THE TRAIN AND TEST DATA


# data with outliers

# train data
telecom_out_train <- read.csv("telecom_out_train.csv")
telecom_out_train$X <- NULL
telecom_out_train$international_plan <- as.factor(telecom_out_train$international_plan)
telecom_out_train$voice_mail_plan    <- as.factor(telecom_out_train$voice_mail_plan)
telecom_out_train$churn              <- as.factor(telecom_out_train$churn)
str(telecom_out_train)

# test data
telecom_out_test  <- read.csv("telecom_out_test.csv")
telecom_out_test$X <- NULL
telecom_out_test$international_plan <- as.factor(telecom_out_test$international_plan)
telecom_out_test$voice_mail_plan    <- as.factor(telecom_out_test$voice_mail_plan)
telecom_out_test$churn              <- as.factor(telecom_out_test$churn)
str(telecom_out_test)



# Random Forests model on raw data

set.seed(321)
library(randomForest)
random_forest_out_train <- randomForest(churn ~ ., data = telecom_out_train)
random_forest_out_train
# The OOB error rate is 5.21%
# Again, this is with all the 500 trees factored into the analysis.
# Let's plot the Error by trees:
# plot(random_forest_out_train)
# which.min(random_forest_out_train$err.rate[,1]) # returns 398
# So, let's use only 340 tress now
# random_forest_out_train_2 <- randomForest(churn ~ ., data = telecom_out_train, ntree = 217)
# random_forest_out_train_2  # error rate 5.54%
# now that we have our model, let's generate variable importance plot
varImpPlot(random_forest_out_train)


# It's prediction time
rf_out_pred <- predict(random_forest_out_train, newdata = telecom_out_test, type = "response")
# let's get confusion matrix
library(caret)
confusionMatrix(rf_out_pred, telecom_out_test$churn)
# Accuracy : 0.9446 (94.46%)




















# data without outliers

# train data
telecom_no_out_train <- read.csv("telecom_no_out_train.csv")
telecom_no_out_train$X <- NULL
telecom_no_out_train$international_plan <- as.factor(telecom_no_out_train$international_plan)
telecom_no_out_train$voice_mail_plan    <- as.factor(telecom_no_out_train$voice_mail_plan)
telecom_no_out_train$churn              <- as.factor(telecom_no_out_train$churn)
str(telecom_no_out_train)

# test data
telecom_no_out_test  <- read.csv("telecom_no_out_test.csv")
telecom_no_out_test$X <- NULL
telecom_no_out_test$international_plan <- as.factor(telecom_no_out_test$international_plan)
telecom_no_out_test$voice_mail_plan    <- as.factor(telecom_no_out_test$voice_mail_plan)
telecom_no_out_test$churn              <- as.factor(telecom_no_out_test$churn)
str(telecom_no_out_test)





# Random Forests model outlier treated data

set.seed(321)
library(randomForest)
random_forest_no_out_train <- randomForest(churn ~ ., data = telecom_no_out_train)
random_forest_no_out_train
# The OOB error rate is 5.56%
# Again, this is with all the 500 trees factored into the analysis.
# Let's plot the Error by trees:
plot(random_forest_no_out_train)
which.min(random_forest_no_out_train$err.rate[,1]) # returns 106
# So, let's use only 340 tress now
# random_forest_no_out_train_2 <- randomForest(churn ~ ., data = telecom_no_out_train, ntree = 106)
# random_forest_no_out_train_2  # error rate 5.91%
# now that we have our model, let's generate variable importance plot
varImpPlot(random_forest_no_out_train)


# It's prediction time
rf_no_out_pred <- predict(random_forest_no_out_train, newdata = telecom_no_out_test, type = "response")
# let's get confusion matrix
library(caret)
confusionMatrix(rf_no_out_pred, telecom_no_out_test$churn)
# Accuracy : 0.9448 (94.48%)