# GETTING THE TRAIN AND TEST DATA


# data with outliers

# train data
telecom_out_train <- read.csv("telecom_out_train.csv")
telecom_out_train$X <- NULL
telecom_out_train$international_plan <- as.factor(telecom_out_train$international_plan)
telecom_out_train$voice_mail_plan    <- as.factor(telecom_out_train$voice_mail_plan)
telecom_out_train$churn              <- as.logical(telecom_out_train$churn)
str(telecom_out_train)

# test data
telecom_out_test  <- read.csv("telecom_out_test.csv")
telecom_out_test$X <- NULL
telecom_out_test$international_plan <- as.factor(telecom_out_test$international_plan)
telecom_out_test$voice_mail_plan    <- as.factor(telecom_out_test$voice_mail_plan)
telecom_out_test$churn              <- as.logical(telecom_out_test$churn)
str(telecom_out_test)











# develop the model now, for data with outliers

full_fit_out <- glm(churn~., data = telecom_out_train, family = binomial)
summary(full_fit_out) # AIC: 1507.2
full_fit_out_2 <- glm(churn~total_day_charge+total_eve_charge+total_night_charge+
                        total_intl_calls+total_intl_charge+customer_service_calls+
                        international_plan+voice_mail_plan, data = telecom_out_train, family = binomial)
summary(full_fit_out_2) # AIC: 1499.1
# full_fit_out_3 <- glm(churn~total_day_charge+total_eve_charge+
#                         total_intl_calls+total_intl_charge+customer_service_calls+
#                         international_plan+voice_mail_plan, data = telecom_out_train, family = binomial)
# summary(full_fit_out_3) # AIC: 1501.8
# this model had more AIC compared to the previous model


# confidence intervals
# These confidence intervals (CI) are ranges of values that are likely
# to contain the true value of the coefficient for each term in the model.
confint(full_fit_out_2)

# 

# let's check VIF statistics
library(car)
vif(full_fit_out_2)
# None of the values are greater than the VIF rule of thumb statistic of five,
# so collinearity does not seem to be a problem

# for now, let's produce some code to look at how well this model does on 
# both the train and test sets.
train_probs <- predict(full_fit_out_2, type = "response")
train_probss <- ifelse(train_probs > 0.5, 1 , 0)
train_probss_fact <- as.factor(train_probss)
# probs of data
data_probs <- ifelse(telecom_out_train$churn == "TRUE", 1 , 0)
data_probs_fact <- as.factor(data_probs)
# let's produce confusion matrix now
library(caret)
confusionMatrix(data = train_probss_fact, reference = data_probs_fact)
# Accuracy for train data: 0.8672


test_probs <- predict(full_fit_out_2, type = "response", newdata = telecom_out_test)
test_probss <- ifelse(test_probs > 0.5, 1 , 0)
# test_probss <- ifelse(test_probs > 0.4, 1 , 0)
test_probss_fact <- as.factor(test_probss)
# probs of data
data_probs_test <- ifelse(telecom_out_test$churn == "TRUE", 1 , 0)
data_probs_test_fact <- as.factor(data_probs_test)
# let's produce confusion matrix now
library(caret)
confusionMatrix(data = test_probss_fact, reference = data_probs_test_fact)
# Accuracy with new data: 0.8593


# plotting Area Under Curve(AUC)
library(ROCR)
library(Metrics)
pr <- prediction(test_probss, data_probs_test)
perf <- performance(pr,measure = "tpr",x.measure = "fpr")
plot(perf)
auc(data_probs_test,test_probss) 
#0.59 with 1, if prob > 0.5 (normal)
#0.61 with 1, if prob > 0.4





















# data without outliers

# train data
telecom_no_out_train <- read.csv("telecom_no_out_train.csv")
telecom_no_out_train$X <- NULL
telecom_no_out_train$international_plan <- as.factor(telecom_no_out_train$international_plan)
telecom_no_out_train$voice_mail_plan    <- as.factor(telecom_no_out_train$voice_mail_plan)
telecom_no_out_train$churn              <- as.logical(telecom_no_out_train$churn)
str(telecom_no_out_train)

# test data
telecom_no_out_test  <- read.csv("telecom_no_out_test.csv")
telecom_no_out_test$X <- NULL
telecom_no_out_test$international_plan <- as.factor(telecom_no_out_test$international_plan)
telecom_no_out_test$voice_mail_plan    <- as.factor(telecom_no_out_test$voice_mail_plan)
telecom_no_out_test$churn              <- as.logical(telecom_no_out_test$churn)
str(telecom_no_out_test)





# logit model for data with no outliers
full_fit_no_out <- glm(churn~., data = telecom_no_out_train, family = binomial)
summary(full_fit_no_out)    # AIC: 1574.2
full_fit_no_out_2 <- glm(churn~total_day_charge+total_eve_charge+total_night_charge+
                        total_intl_calls+total_intl_charge+customer_service_calls+
                        international_plan+voice_mail_plan, data = telecom_no_out_train, family = binomial)
summary(full_fit_no_out_2)  # AIC: 1567.7
# full_fit_no_out_3 <- glm(churn~total_day_charge+total_eve_charge+
#                            total_intl_calls+total_intl_charge+customer_service_calls+
#                            international_plan+voice_mail_plan, data = telecom_no_out_train, family = binomial)
# summary(full_fit_no_out_3)  # AIC: 1571.3
# this model has more AIC compared to last model


# let's check VIF statistics
library(car)
vif(full_fit_no_out_2)
# None of the values are greater than the VIF rule of thumb statistic of five,
# so collinearity does not seem to be a problem

# for now, let's produce some code to look at how well this model does on 
# both the train and test sets.
train_no_probs <- predict(full_fit_no_out_2, type = "response")
train_no_probss <- ifelse(train_no_probs > 0.5, 1 , 0)
train_no_probss_fact <- as.factor(train_no_probss)
# probs of data
data_no_probs <- ifelse(telecom_no_out_train$churn == "TRUE", 1 , 0)
data_no_probs_fact <- as.factor(data_no_probs)
# let's produce confusion matrix now
library(caret)
confusionMatrix(data = train_no_probss_fact, reference = data_no_probs_fact)
# Accuracy for train data: 0.8659



test_no_probs <- predict(full_fit_no_out_2, type = "response", newdata = telecom_no_out_test)
test_no_probss <- ifelse(test_no_probs > 0.5, 1 , 0)
test_no_probss_fact <- as.factor(test_no_probss)
# probs of data
data_no_probs_test <- ifelse(telecom_no_out_test$churn == "TRUE", 1 , 0)
data_no_probs_test_fact <- as.factor(data_no_probs_test)
# let's produce confusion matrix now
library(caret)
confusionMatrix(data = test_no_probss_fact, reference = data_no_probs_test_fact)
# Accuracy with new data: 0.8655 (86.55%)




# Accuracy reports for test data using logistic regression
# data with no outliers had 86.55%
# data with outliers    had 85.93%