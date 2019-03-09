# GETTING THE DATA


telecom <- read.csv("telecom_modified.csv")
# colnames(telecom)[2]  <- "account_length"
# colnames(telecom)[3]  <- "area_code"
# colnames(telecom)[4]  <- "phone_number"
# colnames(telecom)[5]  <- "international_plan"
# colnames(telecom)[6]  <- "voice_mail_plan"
# colnames(telecom)[7]  <- "number_vmail_messages"
# colnames(telecom)[8]  <- "total_day_calls"
# colnames(telecom)[9]  <- "totaxxl_day_charge"
# colnames(telecom)[10] <- "total_eve_calls"
# colnames(telecom)[11] <- "total_eve_charge"
# colnames(telecom)[12] <- "total_night_calls"
# colnames(telecom)[13] <- "total_night_charge"
# colnames(telecom)[14] <- "total_intl_calls"
# colnames(telecom)[15] <- "total_intl_charge"
# colnames(telecom)[16] <- "customer_service_calls"
# write.csv(telecom, file = "telecom_modified.csv")












# MISSING DATA
summary(telecom)      # from summary, we can see 'NAs' in data, let's see a visual plot for that
library(naniar)
vis_miss(telecom)     # as from the graph, we can see that the missing observations are only for 
                      # 0.1% of the total data, it is assume that deleting NA's is a safe option
gg_miss_upset(telecom)

# DELETING ROWS OF MISSING OBSERVATIONS
telecom_2 <- na.omit(telecom) # 18 rows with missing observations deleted
# AND LET'S ALSO DELETE 'area_code' and 'phone_number' because
# they will make us mis-interpret correlation plots & also the numbers don't hold any value

































# VISULAISING THE DATA



# SUBSETTING THE DATA TO FIND PATTERNS
churn_true  <- subset(telecom_2, telecom_2$churn == "TRUE")
churn_false <- subset(telecom_2, telecom_2$churn == "FALSE")


# which state has the more churn
library(ggplot2)
# ggplot(data = telecom_2, aes(x = state, y = ..count..)) +
#  geom_bar(aes(fill = churn), position = "identity")

# distribution of 'churn'
ggplot(data = telecom_2, aes(x = "", fill = churn)) +
  geom_bar(width = 1) + coord_polar(theta = "y")

# state with churn true/false
ggplot(data = telecom_2, aes(x = state, y = ..count..)) +
  geom_bar(aes(fill = churn), position = "dodge")

# state with more churn
ggplot(data = telecom_2, aes(x = state, y = ..count..)) +
  geom_bar(aes(fill = churn), position = "dodge")
ggplot(data = churn_true, aes(x = state, y = ..count..)) +
  geom_bar(aes(fill = churn), position = "dodge")

# customers that had 'international_plan' and churned
ggplot(data = telecom_2, aes(x = international_plan, y = ..count.., fill = churn)) +
  geom_bar(position = "dodge")
ggplot(data = churn_true, aes(x = international_plan, y = ..count.., fill = churn)) +
  geom_bar(position = "dodge")

# customers that called customer service and churned
# are calls to cusomter service and churn_rate related ?
ggplot(data = churn_true, aes(x = customer_service_calls, y = ..count.., fill = churn)) +
  geom_bar(position = "dodge")
ggplot(data = churn_true, aes(x = customer_service_calls, y = ..count.., fill = churn)) +
  geom_bar(position = "dodge")

# did old customers churn
ggplot(data = churn_true, aes(x = account_length, y = customer_service_calls)) +
  geom_smooth(method = 'lm', se = FALSE, formula = y ~ log(x))
ggplot(data = churn_false, aes(x = account_length, y = customer_service_calls)) +
  geom_smooth(method = 'lm', se = FALSE, formula = y ~ log(x))

plot_ly(telecom_2, x = ~account_length, y = ~customer_service_calls, color = ~churn) %>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'account_length'),
                      yaxis = list(title = 'num of calls to customer service')))

# relationship between total_night_calls & total_night_charge & customer_service_calls
library(plotly)
plot_ly(telecom_2, x = ~total_night_calls, y = ~total_night_charge, z = ~customer_service_calls,
        color = ~churn) %>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'total_night_calls'),
                      yaxis = list(title = 'total_night_charge'),
                      zaxis = list(title = 'customer_service_calls')))


# the customers that had calls all day along and did contact customer care and churned/not
# did the customers that had been charged more contacted customer care
plot_ly(telecom_2, x = ~total_day_calls, y = ~total_day_charge, z = ~customer_service_calls,
        color = ~churn) %>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'total_day_calls'),
                      yaxis = list(title = 'total_day_charge'),
                      zaxis = list(title = 'customer_service_calls')))





# did customers that have international_plans churn
# ggplot(data = telecom_2) +
#   geom_point(mapping = aes(x = total_intl_calls, y = total_intl_charge, fill = international_plan, color = churn))

# did customers that have calls all day along and had been charged and did contact customer care and churned
ggplot(data = churn_true, aes(x = total_intl_calls, y = ..count..)) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE)


# did customers that didn't have international_plan had international_minutes
ggplot(data = telecom_2, aes(x = total_intl_calls, y = total_intl_charge, col = international_plan)) +
  geom_point() +
  labs(title="relationship between ", x ="charge on international calls", y = "num of international calls made")
plot_ly(telecom_2, x = ~total_intl_calls, y = ~total_intl_charge, z = ~as.factor(international_plan),
        color = ~churn) %>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'total_intl_calls'),
                      yaxis = list(title = 'total_intl_charge'),
                      zaxis = list(title = 'international_plan')))
plot_ly(telecom_2, x = ~total_intl_calls, y = ~total_intl_charge,
        color = ~churn) %>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'total_intl_calls'),
                      yaxis = list(title = 'total_intl_charge')))


# did customers that didn't have voice_mail_plan had voicemail_minutes and churned
ggplot(data = telecom_2, aes(x = as.factor(voice_mail_plan), y = number.vmail.messages)) +
  geom_point() +
  labs(title="relationship between ", x ="voice mail plan(yes/no)", y = "num of voicemail messages")

plot_ly(telecom_2, x = ~as.factor(voice_mail_plan), y = ~number.vmail.messages,
        color = ~churn) %>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'voice mail plan(yes/no)'),
                      yaxis = list(title = 'total_intl_charge')))




















# MODEL BUIDLING


# AND LET'S ALSO DELETE 'area_code' and 'phone_number' because
# they will make us mis-interpret correlation plots & also the numbers don't hold any value
telecom_2$area_code <- NULL
telecom_2$phone_number <- NULL





# LOGISTIC REGRESSION
# Depending on the package in R that you are using to analyze the data, the outcome needs to
# be numeric, which is 0 or 1 
# So, re-naming factors to "0" and "1"
telecom_2$international_plan <- ifelse(telecom_2$international_plan == "yes", 1, 0)
telecom_2$international_plan <- as.factor(telecom_2$international_plan)
telecom_2$voice_mail_plan <- ifelse(telecom_2$voice_mail_plan== "yes", 1, 0)
telecom_2$voice_mail_plan <- as.factor(telecom_2$voice_mail_plan)
telecom_2$churn <- ifelse(telecom_2$churn == "TRUE", 1, 0)
telecom_2$churn <- as.factor(telecom_2$churn)











# CHECK VARIABLE CORRELATION AND VARIABLE IMPORTANCE

