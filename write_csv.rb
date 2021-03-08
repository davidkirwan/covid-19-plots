#!/usr/bin/ruby
#####################################################
# Author:  David Kirwan <davidkirwanirl@gmail.com>
# Github:  https://github.com/davidkirwan
# Licence: GPL 3.0
# Working with the COVID-19 data
######################################################
require "csv"
require "date"

previous_total_infected = 0

CSV.open("covid-19.csv", "wb") do |csv|
  # Write the CSV report titles
  csv << ["date", "total_confirmed", "total_deaths", "total_recovered", "total_infected", "mortality_rate", "recovery_rate", "daily_growth_rate"]

  # Read in the data
  # https://github.com/CSSEGISandData/COVID-19
  # ARGV[0] should contain path on disk to the location where this repo has been cloned to
  puts ARGV[0]
  data_dir = ARGV[0]

  csv_files = Dir[data_dir+"*.csv"].sort! { |a,b|  DateTime.strptime(File.basename(a, ".*"), "%m-%d-%Y") <=> DateTime.strptime(File.basename(b, ".*"), "%m-%d-%Y") }
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

    if previous_total_infected == 0
      daily_growth_rate = 1
    else
      daily_growth_rate = '%.2f' % (1 + ((total_infected - previous_total_infected).abs.to_f / previous_total_infected))
    end

    previous_total_infected = total_infected

    date = File.basename(csv_file, ".*")
    puts "Data for day: #{date}"
    puts "Total Confirmed: #{total_confirmed}"
    puts "Total Deaths: #{total_deaths}"
    puts "Total Recovered: #{total_recovered}"
    puts "Total Infected: #{total_infected}"
    puts "Mortality Rate: #{mortality_rate}%"
    puts "Recovery Rate: #{recovery_rate}%"
    puts "Daily Growth Rate: #{daily_growth_rate}"
    csv << [date, total_confirmed, total_deaths, total_recovered, total_infected, mortality_rate, recovery_rate, daily_growth_rate]
  end
end
