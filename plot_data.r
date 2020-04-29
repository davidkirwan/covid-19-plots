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
lmMod <- lm(total_deaths ~ total_confirmed, data=data)  # build the model
summary (lmMod)

date = c("01-06-2020", "02-06-2020")
total_confirmed = c(5000000, 10000000)
df = data.frame(date, total_confirmed)

tdp <- predict(lmMod, df)  # predict death total at 1000000, 2000000
print(tdp)

# Create the plots
png(filename="covid-19.png")
par(mar=c(6.1,6.1,4.1,2.1))
colYMax <- max(data$total_confirmed, na.rm = TRUE)
colXMax <- length(data$date)
plot(1, type="n", main="COVID-19 Global", xlab="", axes=FALSE, ylab="", xlim=c(0, colXMax), ylim=c(0, colYMax), las=2)
axis(1, at=1:colXMax, las=2, lab=data$date)
axis(2, at=seq(0, max(data$total_confirmed), by=max(data$total_confirmed)/5), las=1)
legend(1, colYMax, legend=c("Total Confirmed", "Total Infected", "Total Recovered", "Total Deaths"),
       col=c("blue", "orange", "green", "red"), lty=1:2, cex=0.8)
lines(data$total_confirmed~data$date, col='blue', lwd=2)
lines(data$total_infected~data$date, col='orange', lwd=2)
lines(data$total_recovered~data$date, col='green', lwd=2)
lines(data$total_deaths~data$date, col='red', lwd=2)
dev.off()

png(filename="covid-19_deaths.png")
par(mar=c(6.1,5.1,4.1,2.1))
colYMax <- max(data$total_deaths, na.rm = TRUE)
colXMax <- length(data$date)
plot(1, type="n", main="COVID-19 Global Deaths", axes=FALSE, xlab="", ylab="", xlim=c(0, colXMax), ylim=c(0, colYMax), las=2)
axis(1, at=1:colXMax, las=2, lab=data$date)
axis(2, at=seq(0, max(data$total_deaths), by=max(data$total_deaths)/5), las=1)
legend(1, colYMax, legend=c("Total Deaths"),
       col=c("red"), lty=1:2, cex=0.8)
lines(data$total_deaths~data$date, col='red', lwd=2)
dev.off()

png(filename="covid-19_mortality_rate.png")
par(mar=c(6.1,5.1,4.1,2.1))
colYMax <- max(data$mortality_rate, na.rm = TRUE)
colXMax <- length(data$date)
plot(1, type="n", main="COVID-19 Global Mortality Rate %", axes=FALSE, xlab="", ylab="", xlim=c(0, colXMax), ylim=c(2, colYMax), las=2)
axis(1, at=1:colXMax, las=2, lab=data$date)
axis(2, at=seq(2, max(data$mortality_rate), by=0.1), las=1)
legend(1, colYMax, legend=c("Total Mortality Rate %"),
       col=c("red"), lty=1:2, cex=0.8)
lines(data$mortality_rate~data$date, col='red', lwd=2)
dev.off()

png(filename="covid-19_daily_growth_rate.png")
par(mar=c(6.1,5.1,4.1,2.1))
colYMax <- max(data$daily_growth_rate*100, na.rm = TRUE)
colXMax <- length(data$date)
plot(1, type="n", main="COVID-19 Global Daily Growth Rate %", axes=FALSE, xlab="", ylab="", xlim=c(0, colXMax), ylim=c(0, colYMax), las=2)
axis(1, at=1:colXMax, las=2, lab=data$date)
axis(2, at=seq(0, max(data$daily_growth_rate*100), by=colYMax/5), las=1)
legend(1, colYMax, legend=c("Growth Rate %"),
       col=c("red"), lty=1:2, cex=0.8)
lines((data$daily_growth_rate / 100)~data$date, col='red', lwd=2)
dev.off()
