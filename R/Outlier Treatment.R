# my objective now is to create a dataframe with treated outliers for modelling purposes


# load the original data first
telecom <- read.csv("telecom_modified.csv")
telecom_2 <- na.omit(telecom)
# let's also remove variables that don't hold any value in modelling
telecom_2$state <- NULL
telecom_2$area_code <- NULL
telecom_2$phone_number <- NULL


# let's just check the boxplots of variables to
# visually inspect outliers
# par(mfrow = c(6,6))
# Error in plot.new() : figure margins too large



library(plotly)

plot_ly(telecom_2, y = ~account_length, color = I("black"), 
             alpha = 0.1, boxpoints = "suspectedoutliers") %>%
  add_boxplot(x = "Overall")
# has more above

plot_ly(telecom_2, y = ~number.vmail.messages, color = I("black"), 
        alpha = 0.1, boxpoints = "suspectedoutliers") %>%
  add_boxplot(x = "Overall")
# has one on top

plot_ly(telecom_2, y = ~total_day_calls, color = I("black"), 
        alpha = 0.1, boxpoints = "suspectedoutliers") %>%
  add_boxplot(x = "Overall")
# has more on both sides

plot_ly(telecom_2, y = ~total_day_charge, color = I("black"), 
        alpha = 0.1, boxpoints = "suspectedoutliers") %>%
  add_boxplot(x = "Overall")
# has more on both sides

plot_ly(telecom_2, y = ~total_eve_calls, color = I("black"), 
        alpha = 0.1, boxpoints = "suspectedoutliers") %>%
  add_boxplot(x = "Overall")
# has more on both sides

plot_ly(telecom_2, y = ~total_eve_charge, color = I("black"), 
        alpha = 0.1, boxpoints = "suspectedoutliers") %>%
  add_boxplot(x = "Overall")
# has more on both sides

plot_ly(telecom_2, y = ~total_night_calls, color = I("black"), 
        alpha = 0.1, boxpoints = "suspectedoutliers") %>%
  add_boxplot(x = "Overall")
# has more on both sides

plot_ly(telecom_2, y = ~total_night_charge, color = I("black"), 
        alpha = 0.1, boxpoints = "suspectedoutliers") %>%
  add_boxplot(x = "Overall")
# has more on both sides

plot_ly(telecom_2, y = ~total_intl_calls, color = I("black"), 
        alpha = 0.1, boxpoints = "suspectedoutliers") %>%
  add_boxplot(x = "Overall")
# has more above

plot_ly(telecom_2, y = ~total_intl_charge, color = I("black"), 
        alpha = 0.1, boxpoints = "suspectedoutliers") %>%
  add_boxplot(x = "Overall")
# has more on both sides

plot_ly(telecom_2, y = ~customer_service_calls, color = I("black"), 
        alpha = 0.1, boxpoints = "suspectedoutliers") %>%
  add_boxplot(x = "Overall")
# has more above

























# OUTLIER TREATMENT
# I have planeed to perfoem "Capping" on variables that have outliers. 
# Capping :
# For missing values that lie outside the (1.5*IQR) limits,
# we could cap it by replacing those observations outside
# the lower limit with the value of 5th %ile and
# those that lie above the upper limit, with the value of 95th %ile.
# Below is a function that achieves this.
treat_outliers <- function(x){
  qnt <- quantile(x, probs=c(.25, .75), na.rm = T)
  caps <- quantile(x, probs=c(.05, .95), na.rm = T)
  H <- 1.5 * IQR(x, na.rm = T)
  x[x < (qnt[1] - H)] <- caps[1]
  x[x > (qnt[2] + H)] <- caps[2]
  return(x)
}






# let's make a copy of original dataframe and treat it.
telecom_no_outliers <- telecom_2




















# let's test it for a sample case
boxplot(telecom_no_outliers$account_length)  # before treatment
telecom_no_outliers$account_length <- treat_outliers(telecom_no_outliers$account_length)
boxplot(telecom_no_outliers$account_length)  # after treatment

telecom_no_outliers$account_length <- 
  treat_outliers(telecom_no_outliers$account_length)

telecom_no_outliers$number.vmail.messages <- 
  treat_outliers(telecom_no_outliers$number.vmail.messages)

telecom_no_outliers$total_day_calls <- 
  treat_outliers(telecom_no_outliers$total_day_calls)

telecom_no_outliers$total_day_charge <- 
  treat_outliers(telecom_no_outliers$total_day_charge)

telecom_no_outliers$total_eve_calls <- 
  treat_outliers(telecom_no_outliers$total_eve_calls)

telecom_no_outliers$total_eve_charge <- 
  treat_outliers(telecom_no_outliers$total_eve_charge)

telecom_no_outliers$total_night_calls <- 
  treat_outliers(telecom_no_outliers$total_night_calls)

telecom_no_outliers$total_night_charge <- 
  treat_outliers(telecom_no_outliers$total_night_charge)

telecom_no_outliers$total_intl_calls <- 
  treat_outliers(telecom_no_outliers$total_intl_calls)

telecom_no_outliers$total_intl_charge <- 
  treat_outliers(telecom_no_outliers$total_intl_charge)

telecom_no_outliers$customer_service_calls <- 
  treat_outliers(telecom_no_outliers$customer_service_calls)


boxplot(telecom_2$total_day_calls)
boxplot(telecom_no_outliers$total_day_calls)






# as we can see from the boxplots, that the new dataframe is void of outliers
# let's save it to use it for modelling purposes
write.csv(telecom_no_outliers, file = "telecom_no_outliers.csv")

