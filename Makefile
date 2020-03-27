# Test

.DEFAULT_GOAL:=help

.PHONY: help
help: ## Show this help screen
	@echo 'Usage: make <OPTIONS> ... <TARGETS>'
	@echo ''
	@echo 'Available targets are:'
	@echo ''
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Fetch data

.PHONY: pull
pull: ## Pull down the latest raw data from  CSSEGISandData/COVID-19
	echo "/home/dkirwan/files/git_repos/github/COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/"
	cd /home/dkirwan/files/git_repos/github/COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/
	git pull origin master
	cd -


##@ Process data

.PHONY: process
process: ## Process the latest raw data from  CSSEGISandData/COVID-19 and generate CSV files
	ruby write_csv.rb
	ruby write_per_country_csv.rb

.PHONY: plot
plot: ## Plot the latest raw data from  CSSEGISandData/COVID-19 and generate plot images
	Rscript plot_data.r
	Rscript plot_data_per_country.r

##@ Push data

.PHONY: push
push: ## Push up the latest processed data and plots to davidkirwan/covid-19-plots
	git add .
	git commit -m "latest data"
	git push origin master
