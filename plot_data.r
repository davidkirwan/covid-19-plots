####################################################################################################
# @author David Kirwan https://github.com/davidkirwan
# @description R script to create plots for COVID-19 data.
#
# @usage Rscript plot_data.r
#
# @date 2020-03-03
####################################################################################################

# Read the data in
# ["Date", "Total Confirmed", "Total Deaths", "Total Recovered", "Total Infected", "Mortality Rate", "Recovery Rate"]
data <- read.table("covid-19.csv", header=TRUE, sep=",")

# Correlation total confirmed vs total deaths
print(cor(data$total_confirmed, data$total_deaths))
lmMod <- lm(mortality_rate ~ total_deaths, data=data)  # build the model
summary (lmMod)
distPred <- predict(lmMod, c(160000))  # predict distance
print(distPred)



# Create the plots
png(filename="covid-19.png")
plot(data$date, data$total_confirmed, type="l", main="COVID-19", xlab = "Date", ylab = "Number")
legend(1, 90000, legend=c("Total Confirmed", "Total Infected", "Total Recovered", "Total Deaths"),
       col=c("blue", "orange", "green", "red"), lty=1:2, cex=0.8)
lines(data$total_confirmed~data$date, col='blue', lwd=2)
lines(data$total_infected~data$date, col='orange', lwd=2)
lines(data$total_recovered~data$date, col='green', lwd=2)
lines(data$total_deaths~data$date, col='red', lwd=2)
dev.off()

png(filename="covid-19_deaths.png")
plot(data$date, data$total_deaths, type="l", main="COVID-19 Deaths", xlab = "Date", ylab = "Number")
colMax <- max(data$total_deaths, na.rm = TRUE)
legend(1, colMax, legend=c("Total Deaths"),
       col=c("red"), lty=1:2, cex=0.8)
lines(data$total_deaths~data$date, col='red', lwd=2)
dev.off()

png(filename="covid-19_mortality_rate.png")
plot(data$date, data$mortality_rate, type="l", main="COVID-19 Mortality Rate %", xlab = "Date", ylab = "Number")
colMax <- max(data$mortality_rate, na.rm = TRUE)
legend(1, colMax, legend=c("Mortality Rate"),
       col=c("red"), lty=1:2, cex=0.8)
lines(data$mortality_rate~data$date, col='red', lwd=2)
dev.off()
