####################################################################################################
# @author David Kirwan https://github.com/davidkirwan
# @description R script to create plots for COVID-19 data.
#
# @usage Rscript plot_data_per_country.r
#
# @date 2020-03-27
####################################################################################################

# Read the Countries names data in
# ["Country Name","key"]
countries <- read.table("covid-19_countries_list.csv", header=TRUE, sep=",", quote="")

# print(countries$Country.Name)
# print(countries$key)

for(i in 1:nrow(countries)){
  file_name <- paste("countries/covid-19_", countries$key[i], ".csv", sep="")
  print(file_name)
  # Read the data in
  # ["Date", "Total Confirmed", "Total Deaths", "Total Recovered", "Total Infected", "Mortality Rate", "Recovery Rate"]
  data <- read.table(file_name, header=TRUE, sep=",")

  # Create the plots
  png(filename=paste("countries/covid-19_", countries$key[i], ".png", sep=""))
  par(mar=c(6.1,6.1,4.1,2.1))
  colYMax <- max(data$total_confirmed, na.rm = TRUE)
  colXMax <- length(data$date)
  plot(1, type="n", main=paste("COVID-19", countries$Country.Name[i]), xlab="", axes=FALSE, ylab="", xlim=c(0, colXMax), ylim=c(0, colYMax), las=2)
  axis(1, at=1:colXMax, las=2, lab=data$date)
  axis(2, at=seq(0, colYMax, by=max(data$total_confirmed)/5), las=1)
  legend(1, colYMax, legend=c("Total Confirmed", "Total Infected", "Total Recovered", "Total Deaths"),
         col=c("blue", "orange", "green", "red"), lty=1:2, cex=0.8)
  lines(data$total_confirmed, col='blue', lwd=2)
  lines(data$total_infected, col='orange', lwd=2)
  lines(data$total_recovered, col='green', lwd=2)
  lines(data$total_deaths, col='red', lwd=2)
  dev.off()

  png(filename=paste("countries/covid-19_", countries$key[i], "_deaths.png", sep=""))
  par(mar=c(6.1,5.1,4.1,2.1))
  colYMax <- max(data$total_deaths, na.rm = TRUE)
  colXMax <- length(data$date)
  plot(1, type="n", main=paste("COVID-19", countries$Country.Name[i], "Deaths"), axes=FALSE, xlab="", ylab="", xlim=c(0, colXMax), ylim=c(0, colYMax), las=2)
  axis(1, at=1:colXMax, las=2, lab=data$date)
  axis(2, at=seq(0, colYMax, by=max(data$total_deaths)/5), las=1)
  legend(1, colYMax, legend=c("Total Deaths"),
         col=c("red"), lty=1:2, cex=0.8)
  lines(data$total_deaths, col='red', lwd=2)
  dev.off()

  png(filename=paste("countries/covid-19_", countries$key[i], "_mortality_rate.png", sep=""))
  par(mar=c(6.1,5.1,4.1,2.1))
  colYMin <- min(data$mortality_rate, na.rm = TRUE)
  colYMax <- max(data$mortality_rate, na.rm = TRUE)
  colXMax <- length(data$date)
  plot(1, type="n", main=paste("COVID-19", countries$Country.Name[i], "Mortality Rate %"), axes=FALSE, xlab="", ylab="", xlim=c(0, colXMax), ylim=c(colYMin, colYMax), las=2)
  axis(1, at=1:colXMax, las=2, lab=data$date)
  axis(2, at=seq(colYMin, colYMax, by=0.1), las=1)
  legend(1, colYMax, legend=c("Total Mortality Rate %"),
         col=c("red"), lty=1:2, cex=0.8)
  lines(data$mortality_rate, col='red', lwd=2)
  dev.off()

  png(filename=paste("countries/covid-19_", countries$key[i], "_daily_growth_rate.png", sep=""))
  par(mar=c(6.1,5.1,4.1,2.1))
  colYMin <- min(data$daily_growth_rate, na.rm = TRUE)*100-100
  colYMax <- max(data$daily_growth_rate, na.rm = TRUE)*100-100
  colXMax <- length(data$date)
  plot(1, type="n", main=paste("COVID-19", countries$Country.Name[i], "Daily Growth Rate %"), axes=FALSE, xlab="", ylab="", xlim=c(0, colXMax), ylim=c(colYMin, colYMax), las=2)
  axis(1, at=1:colXMax, las=2, lab=data$date)
  axis(2, at=seq(colYMin, colYMax, by=colYMax/5.0), las=1)
  legend(1, colYMax, legend=c("Daily Growth Rate %"),
         col=c("red"), lty=1:2, cex=0.8)
  lines((data$daily_growth_rate * 100-100), col='red', lwd=2)
  dev.off()

}



