#!/usr/bin/ruby
#####################################################
# Author:  David Kirwan <davidkirwanirl@gmail.com>
# Github:  https://github.com/davidkirwan
# Licence: GPL 3.0
# Working with the COVID-19 data
######################################################
require "csv"


CSV.open("covid-19.csv", "wb") do |csv|
  # Write the CSV report titles
  csv << ["date", "total_confirmed", "total_deaths", "total_recovered", "total_infected", "mortality_rate", "recovery_rate"]

  # Read in the data
  # https://github.com/CSSEGISandData/COVID-19
  data_dir = "/home/dkirwan/files/git_repos/github/COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/"

  csv_files = Dir[data_dir+"*.csv"].sort
  csv_files.each do |csv_file|
    results = Array.new
    CSV.foreach(csv_file) do |row|
      results << row
    end

    # Headings
    # Province/State,Country/Region,Last Update,Confirmed,Deaths,Recovered,Latitude,Longitude
    confirmed = results[0].find_index("Confirmed")
    deaths = results[0].find_index("Deaths")
    recovered = results[0].find_index("Recovered")

    total_confirmed = 0
    total_deaths = 0
    total_recovered = 0

    results.each do |i|
      total_confirmed += i[confirmed].to_i
      total_deaths += i[deaths].to_i
      total_recovered += i[recovered].to_i
    end
    total_infected = total_confirmed - total_recovered
    mortality_rate = (total_deaths.to_f / total_confirmed * 100).round(2)
    recovery_rate = (total_recovered.to_f / total_confirmed * 100).round(2)

    date = File.basename(csv_file, ".*")
    puts "Data for day: #{date}"
    puts "Total Confirmed: #{total_confirmed}"
    puts "Total Deaths: #{total_deaths}"
    puts "Total Recovered: #{total_recovered}"
    puts "Total Infected: #{total_infected}"
    puts "Mortality Rate: #{mortality_rate}%"
    puts "Recovery Rate: #{recovery_rate}%"
    csv << [date, total_confirmed, total_deaths, total_recovered, total_infected, mortality_rate, recovery_rate]
  end
end
