#!/usr/bin/ruby
#####################################################
# Author:  David Kirwan <davidkirwanirl@gmail.com>
# Github:  https://github.com/davidkirwan
# Licence: GPL 3.0
# Working with the COVID-19 data
######################################################
require "csv"
require "date"

data = []

# Read in the data
# https://github.com/CSSEGISandData/COVID-19
# ARGV[0] should contain path on disk to the location where this repo has been cloned to
puts ARGV[0]  
data_dir = ARGV[0]

# Get the list of CSV files in location
csv_files = Dir[data_dir+"*.csv"].sort! { |a,b|  DateTime.strptime(File.basename(a, ".*"), "%m-%d-%Y") <=> DateTime.strptime(File.basename(b, ".*"), "%m-%d-%Y") }

# Each file generate data per country
csv_files.each do |csv_file|
  countries = {}
  results = Array.new
  CSV.foreach(csv_file) do |row|
    results << row
  end

  # Headings
  # Province/State,Country/Region,Last Update,Confirmed,Deaths,Recovered,Latitude,Longitude
  state = results[0].find_index("Province/State") || results[0].find_index("Province_State")
  country = results[0].find_index("Country/Region") || results[0].find_index("Country_Region")
  last_update = results[0].find_index("Last Update") || results[0].find_index("Last_Update")
  confirmed = results[0].find_index("Confirmed")
  deaths = results[0].find_index("Deaths")
  recovered = results[0].find_index("Recovered")
  latitude = results[0].find_index("Latitude") || results[0].find_index("Lat")
  longitude = results[0].find_index("Longitude") || results[0].find_index("Long_")

  results[1..results.size].each do |i|
    c = i[country]
    if c == "Mainland China"
      c = "China"
    end
    if c == "Korea, South"
      c = "South Korea"
    end
    if countries[c].nil?
      total_confirmed = i[confirmed].to_i
      total_deaths = i[deaths].to_f
      if total_deaths > total_confirmed
        total_confirmed = total_deaths
      end
      countries[c] = {
        "date" => File.basename(csv_file, ".*"),
        "total_confirmed" => total_confirmed,
        "total_deaths" => i[deaths].to_i,
        "total_recovered" => i[recovered].to_i,
        "total_infected" => i[confirmed].to_i - i[recovered].to_i,
        "mortality_rate" => (i[deaths].to_f / total_confirmed * 100).round(2),
        "recovery_rate" => (i[recovered].to_f / total_confirmed * 100).round(2)
      }
    else
      countries[c]["date"] = File.basename(csv_file, ".*")
      countries[c]["total_confirmed"] += i[confirmed].to_i
      countries[c]["total_deaths"] += i[deaths].to_i
      countries[c]["total_recovered"] += i[recovered].to_i
      countries[c]["total_infected"] = countries[c]["total_confirmed"] - countries[c]["total_recovered"]
      countries[c]["mortality_rate"] = (countries[c]["total_deaths"].to_f / countries[c]["total_confirmed"] * 100).round(2).to_f
      countries[c]["recovery_rate"] = (countries[c]["total_recovered"].to_f / countries[c]["total_confirmed"] * 100).round(2).to_f
    end
  end

  data << countries
end

countries_list = data.last.keys

CSV.open("covid-19_countries_list.csv", "wb") do |csx|
  # Write the CSV report titles
  csx << ["Country Name", "key"]

  countries_list.each do |c|
    if c.nil? then next end
    c_name = c.downcase.strip.tr(" ", "_").tr("(", "").tr(")","").tr("*","").tr("'","").tr(",", "")
    # puts c_name
    csx << [c, c_name]
    CSV.open("countries/covid-19_#{c_name}.csv", "wb") do |csv|
      # Write the CSV report titles
      csv << ["date", "total_confirmed", "total_deaths", "total_recovered", "total_infected", "mortality_rate", "recovery_rate", "daily_growth_rate"]
      data.each_with_index do |d, i|
        unless d[c].nil?
          date = d[c]["date"]
          total_confirmed = d[c]["total_confirmed"]
          total_deaths = d[c]["total_deaths"]
          total_recovered = d[c]["total_recovered"]
          total_infected = d[c]["total_infected"]
          mortality_rate = d[c]["mortality_rate"]
          recovery_rate = d[c]["recovery_rate"]
          
          if i == 0
            d[c]["previous_total_confirmed"] = 0
            d[c]["mortality_rate"] = 0.0
            d[c]["recovery_rate"] = 0.0
            d[c]["daily_growth_rate"] = 1
          else
            if data[i-1][c].nil?
              d[c]["previous_total_confirmed"] = 0
              d[c]["mortality_rate"] = 0.0
              d[c]["recovery_rate"] = 0.0
              d[c]["daily_growth_rate"] = 1
            else
              d[c]["previous_total_confirmed"] = data[i-1][c]["total_confirmed"]
              if d[c]["previous_total_confirmed"] == 0
                d[c]["daily_growth_rate"] = 1
              else
                d[c]["daily_growth_rate"] = (1+ ((d[c]["total_confirmed"] - d[c]["previous_total_confirmed"]).abs.to_f / d[c]["previous_total_confirmed"]))
              end
            end
          end
          
          daily_growth_rate = d[c]["daily_growth_rate"]
          previous_total_confirmed = d[c]["previous_total_confirmed"]

          csv << [date, total_confirmed, total_deaths, total_recovered, total_infected, mortality_rate, recovery_rate, daily_growth_rate]
       end
      end
    end
  end
end
