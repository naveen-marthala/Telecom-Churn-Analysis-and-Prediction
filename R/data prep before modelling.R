# we are now gonna build models with two different data
# 1. non-outlier treated
# 2. outlier treated


telecom_no_treat <- read.csv("telecom_modified.csv")
telecom_outlier_treated <- read.csv("telecom_no_outliers.csv")


telecom_no_treat$X <- NULL            # i have no idea why this has been added
telecom_no_treat$state <- NULL        # removing state, area_code, phone_number
telecom_no_treat$area_code <- NULL    # as they will aid nothing in
telecom_no_treat$phone_number <- NULL # modelling
telecom_outlier_treated$X <- NULL     






# FACTOR RE-NAMING
# Depending on the package in R that you are using to analyze the data, the outcome needs to be numeric, which is 0 or 1.
# In order to accommodate that requirement, create the variable y, where TRUE/YES is 1 and NO/FALSE 0,
# using the ifelse() function as shown here:

telecom_outlier_treated$international_plan <-
  ifelse(telecom_outlier_treated$international_plan == "yes", 1, 0)

telecom_outlier_treated$international_plan <- as.factor(telecom_outlier_treated$international_plan)

telecom_outlier_treated$voice_mail_plan <-
  ifelse(telecom_outlier_treated$voice_mail_plan == "yes", 1, 0)

telecom_outlier_treated$voice_mail_plan <- as.factor(telecom_outlier_treated$voice_mail_plan)

telecom_outlier_treated$churn <-
  ifelse(telecom_outlier_treated$churn == "TRUE", 1, 0)

telecom_outlier_treated$churn <- as.factor(telecom_outlier_treated$churn)
write.csv(telecom_outlier_treated, "telecom_outlier_treated.csv")
write.csv(telecom_no_treat, "telecom_no_treat.csv")













# out data is now ready to be fed into algorithm
# The final task in the data preparation will be the creation of
# our train and test datasets. The purpose of creating two different datasets from the original one
# is to improve our ability so as to accurately predict the previously unused or unseen data.



set.seed(123)
indices_out_yes <- sample(2, nrow(telecom_no_treat), replace = TRUE, prob = c(0.7, 0.3))
telecom_out_train <- telecom_no_treat[indices_out_yes==1, ] #the training data for data set with outliers
telecom_out_test  <- telecom_no_treat[indices_out_yes==2, ] #the test data set for data set with outliers

table(telecom_out_train$churn)  # there seem to be a fair distribution of 'churn' among 'test' & 'test'
table(telecom_out_test$churn)  # there seem to be a fair distribution of 'churn' among 'test' & 'test'
write.csv(telecom_out_train, "telecom_out_train.csv")
write.csv(telecom_out_test, "telecom_out_test.csv")


set.seed(123)
indices_out_no <- sample(2, nrow(telecom_outlier_treated), replace = TRUE, prob = c(0.7, 0.3))
tele_no_out_train <- telecom_outlier_treated[indices_out_no==1, ] #the training data for data set with no outliers
tele_no_out_test  <- telecom_outlier_treated[indices_out_no==2, ] #the test data set for data set with no outliers

table(tele_no_out_train$churn) # there seem to be a fair distribution of 'churn' among 'test' & 'test'
table(tele_no_out_test$churn)  # there seem to be a fair distribution of 'churn' among 'test' & 'test'


# save them for further using with different algorithms
write.csv(tele_no_out_train,"telecom_no_out_train.csv")
write.csv(tele_no_out_test,"telecom_no_out_test.csv")
