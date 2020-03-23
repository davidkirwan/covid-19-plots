#!/usr/bin/ruby
#####################################################
# Author:  David Kirwan <davidkirwanirl@gmail.com>
# Github:  https://github.com/davidkirwan
# Licence: GPL 3.0
# Working with the COVID-19 data
######################################################
require "csv"

data = []
# Read in the data
# https://github.com/CSSEGISandData/COVID-19
data_dir = "/home/dkirwan/files/git_repos/github/COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/"

# Get the list of CSV files in location
csv_files = Dir[data_dir+"*.csv"].sort

# Each file generate data per country
csv_files.each do |csv_file|
  countries = {}
  results = Array.new
  CSV.foreach(csv_file) do |row|
    results << row
  end

  # Headings
  # Province/State,Country/Region,Last Update,Confirmed,Deaths,Recovered,Latitude,Longitude
  state = results[0].find_index("Province/State")
  country = results[0].find_index("Country/Region")
  last_update = results[0].find_index("Last Update")
  confirmed = results[0].find_index("Confirmed")
  deaths = results[0].find_index("Deaths")
  recovered = results[0].find_index("Recovered")
  latitude = results[0].find_index("Latitude")
  longitude = results[0].find_index("Longitude")

  results[1..results.size].each do |i|
    c = i[country]
    if c == "Mainland China"
      c = "China"
    end
    if countries[c].nil?
      countries[c] = {
        "total_confirmed" => i[confirmed].to_i,
        "total_deaths" => i[deaths].to_i,
        "total_recovered" => i[recovered].to_i,
        "total_infected" => i[confirmed].to_i - i[recovered].to_i,
        "mortality_rate" => (i[deaths].to_f / i[confirmed].to_i * 100).round(2),
        "recovery_rate" => (i[recovered].to_f / i[confirmed].to_i * 100).round(2)
      }
    else
      countries[c]["total_confirmed"] += i[confirmed].to_i
      countries[c]["total_deaths"] += i[deaths].to_i
      countries[c]["total_recovered"] += i[recovered].to_i
      countries[c]["total_infected"] = countries[c]["total_confirmed"] - countries[c]["total_recovered"]
      countries[c]["mortality_rate"] = (countries[c]["total_deaths"].to_f / countries[c]["total_confirmed"] * 100).round(2)
      countries[c]["recovery_rate"] = (countries[c]["total_recovered"].to_f / countries[c]["total_confirmed"] * 100).round(2)
    end
  end

  data << countries
end

puts data.size
puts data.first
puts data.last
puts data.last.keys

=begin
CSV.open("covid-19.csv", "wb") do |csv|
  # Write the CSV report titles
  csv << ["date", "total_confirmed", "total_deaths", "total_recovered", "total_infected", "mortality_rate", "recovery_rate"]

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
=end
