# Revisiting COVID-19 Data in Europe: Incidence, Mortality and Vaccination
## Table of Contents
[Introduction](https://github.com/ololade-g/covid-19-project/blob/main/README.md#introduction)
[Installation](https://github.com/ololade-g/covid-19-project/blob/main/README.md#intallation)
[Data Source](https://github.com/ololade-g/covid-19-project/blob/main/README.md#Data-Source)



## Introduction
This study analyzes COVID-19 incidence, mortality, and vaccination rates across Europe using data from Our World in Data. A shell script filters the global dataset for European countries, producing files like ‘covid_europe_wk_new_cases_dec2023.csv’ with weekly case numbers until December 2023. To execute, run script_project.sh [path to COVID-19 data file]. Subsequent analysis and visualization are conducted in R, with scripts available in script_project.R and outputs stored in the plots/ directory.

## Installation
To set up the project environment, you’ll need to install the following:
* Shell: Ensure you have access to a command-line interface (CLI) like Bash, which is commonly available on Linux and macOS systems. Windows users can use Git Bash or enable Windows Subsystem for Linux (WSL).
* RStudio: Download and install RStudio from the official RStudio website. Follow the installation instructions for your operating system.
Make sure you have R installed before setting up RStudio. You can download R from the Comprehensive R Archive Network (CRAN).

After installing both Shell and RStudio, you can clone the repository and follow the project-specific setup instructions to begin analysis

## Data Source
* The project utilizes covid-data.csv from Our World in Data, an open-source dataset updated daily.
* The current data reflects figures up to April 19, 2024, and is available here.
* Data can be downloaded from Our World in Data (https://github.com/owid/covid-19-data/tree/master/public/data) and saved as `covid-data.csv`.

## Data Processing
### Data Filtering by Continent:
A shell script was created to filter the global dataset by continent, outputting only European countries.
The European COVID-19 data was further filtered and analyzed to present the weekly incidence of COVID-19.
The resulting data was saved in a file named covid_europe_wk_new_cases_dec2023.csv.
```
bash script_project.sh [path to COVID-19 data file]
```
### Packages Used for Analysis and Reporting:
The following R packages were installed for analysis and reporting:
```
library(dplyr)
library(tidyverse)
library(lubridate)
library(ggExtra)
library(tinytex)
library(knitr)
library(moderndive)
```
## Key Analyses
Below are the key analyses conducted:
### European Regions Analysis:
* A table of prevalence, mortality, and full vaccination coverage for all regions until April 19, 2024, was prepared.
* Necessary columns (location, new cases, new vaccinations, and population) were filtered from the full data.
* Missing data were replaced with zeros.
* Cases, deaths, and vaccinations were summed up per region, and values per 100 people were calculated.
### COVID-19 Cases per Capita in European Countries:
* The cumulative number of cases per country was determined and divided by their respective populations.
* A bar chart visualizes the differences in incidence across countries.
### Cumulative Vaccination per 100 People in Selected European Countries:
* Twelve countries were selected based on high data reporting.
* Vaccination rates were calculated as a percentage of the population.
* A line curve shows the trend, and linear regression analyzes differences in vaccination rates.
### Monthly Vaccination Trend Analysis:
* Analyzed monthly vaccination trends from January 2021 to December 2023.
* Selected countries: Portugal, Belgium, UK, Malta, Sweden, Italy, Finland, Netherlands, Greece, Czechia, Croatia, and Bulgaria.
* Data aggregated monthly as a percentage of each country’s population.
* Performed linear regression to assess the relationship between time (month of the year), location, and vaccination rate.
### Percentage of Vaccinated Population:
* Evaluated vaccination acceptance by determining the percentage of the population vaccinated at least once or fully (both doses).
* Utilized data up to April 2024 for selected countries.
* Extracted relevant columns to calculate the percentage of partially and fully vaccinated individuals.
* Included the last reporting date for each country in the visual representation of the data.
### Seasonal Influence on Incidence and Mortality:
The impact of seasonality on COVID-19 incidence and mortality rates was investigated.
Data was visualized using box plots containing multiple samples (years) per season.
A linear regression analysis explored the influence of seasonality on the number of COVID-19 cases and deaths.
## Conclusion 
In conclusion, this project considered the incidence, mortality, and vaccination rates of COVID-19. Data was analyzed using shell script and R, and visualized using the ggplot2 package in R.
## License
This project is licensed under the MIT License.
