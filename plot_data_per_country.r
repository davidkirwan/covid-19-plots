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
countries <- read.table("covid-19_countries_list.csv", header=TRUE, sep=",")

print(countries$country_name)
print(countries$key)
