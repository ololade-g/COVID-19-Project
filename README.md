<h1>Revisiting COVID-19 Data in Europe: Incidence, Mortality and Vaccination</h1>

The goal of this study was to determine COVID-19 incidence, mortality, and vaccination rates in Europe. Data was downloaded from Our World in Data (https://github.com/owid/covid-19-data/tree/master/public/data) and saved as `covid-data.csv`, a daily updated and open-source data for everyone. The data used in this project was updated till 19th April, 2024. The data was further filtered to desired forms to answer some research questions. This project was focused on Europe. With a shell script, the global dataset was filtered by continent to output only European countries. The European COVID-19 data was further filtered and analyzed to present the weekly incidence of COVID-19. Further analysis and visualization were done in R.

A shell script was created to output the data from Europe up to date and also data from Europe stopping on 31st December 2023. The December 2023 data was used for a few analyses because some countries stopped reporting data at that time. The shell script will also produce a file named 'covid_europe_wk_new_cases_dec2023.csv'. This data contains the weekly number of COVID-19 cases up till December 2023. Run `script_project.sh [path to COVID-19 data file]` in bash to get these output files. Further analyses and visualizations aimed at answering some research questions were done with R. The script `script_project.R` contains the code lines used for the analysis and visualizations. All visualizations were saved in the `plots/` folder.

<h2>Packages needed for the analysis and report</h2>

To complete and report this analysis, the following packages were installed; 
`library(dplyr)` 
`library(tidyverse)` 
`library(lubridate)` 
`library(ggExtra)`
`library(tinytex)`
`library(knitr)`
`library(moderndive)`

<h2>COVID-19 epidemiology and vaccination rates in European regions</h2>

Firstly, a table of prevalence, mortality, and full vaccination coverage for all the regions until 19th April 2024 was prepared. Necessary columns (location, new case, new vaccinations, and population) were filtered from the full data. Missing data were affecting the analysis. Because 3 variables were involved, a straightforward deletion was not feasible. Those missing data were replaced with zero. The raw dataset has the data for the United Kingdom and the constituent countries. To avoid replicating data, the constituent countries were removed. A table of European regions and countries was made and joined to the data table using location/country as the unique identifier. Cases, deaths, and vaccinations were summed up per region and the values per 100 people were calculated.

<h2>COVID-19 cases per capita in European countries</h2>

Aside from the region, a difference in incidence across countries may also be expected. To confirm this, the data was then analyzed to determine the number of cases per capita between January 1, 2020 and December 31, 2023. The data was capped at that time because, upon manual observation of the data, some countries were without data after December 2023. The cumulative number of cases per country was determined and divided by their respective populations. A bar chart was generated to visualize the differences.

<h2>Cumulative vaccination per 100 people in selected European countries</h2>

Moreover, the vaccination rates of the European countries were looked at. To avoid congestion in the plot, 12 countries were selected based on their high data reporting. Also, the analysis was stopped at December 2023 for uniformity. The location, date, population, and total_vaccinations columns were extracted from the `covid_data_europe_dec2023.csv` file. Total vaccination here is the cumulative number of vaccinations administered from the start of the vaccination exercise up to a day. These values were calculated as a percentage of the population of the selected countries. The trend was represented in a line curve. A linear regression analysis was conducted to establish the differences in the vaccination rates across the different countries.

<h2>Monthly vaccination trend</h2>

Furthermore, the trend of monthly vaccination in selected countries was determined. Portugal, Belgium, United Kingdom, Malta, Sweden, Italy, Finland, Netherlands, Greece, Czechia, Croatia, and Bulgaria were selected because they reported adequate vaccination data necessary for this analysis. The period under consideration for this analysis was January 2021 to December 2023. The daily vaccination data for each selected country was summed up per month through the years and taken as a percentage of the population of the countries. A linear regression analysis was also done to check for interactions between the month of the year, location, and vaccination rate. 

<h2>Percentage vaccinated population</h2>

Although vaccines have been widely distributed and have gained wide acceptance globally, it would be helpful to know the percentage of residents of countries who were vaccinated at least once or fully vaccinated. Fully vaccinated people have taken the first and second doses of the COVID-19 vaccine. In this analysis, the dataset up till April 2024 was used. Necessary columns for selected countries were extracted. The number of people vaccinated only once and fully vaccinated was taken as a percentage of the population. The plotted bars also bear the last data reporting date for each country.

<h2>Seasonal influence on incidence and mortality</h2>

Also, I attempted to answer the question of the impact of season on the incidence and mortality rates of COVID-19. Since the winter season cuts across two years, the season year was given the year it is starting. e.g. December 2021, January 2022 and February 2022 were classified as Winter 2022. Data was visualized with box plots containing multiple samples (years) per season. I conducted a linear regression analysis to explore the influence of seasonality on the number of COVID-19 cases and deaths.

In conclusion, this project considered the incidence, mortality, and vaccination rates of COVID-19. Data was analyzed using shell script and R, and visualized using the ggplot2 package in R.

# Introduction
This study analyzes COVID-19 incidence, mortality, and vaccination rates across Europe using data from Our World in Data. A shell script filters the global dataset for European countries, producing files like ‘covid_europe_wk_new_cases_dec2023.csv’ with weekly case numbers until December 2023. To execute, run script_project.sh [path to COVID-19 data file]. Subsequent analysis and visualization are conducted in R, with scripts available in script_project.R and outputs stored in the plots/ directory.

# Installation
To set up the project environment, you’ll need to install the following:
* Shell: Ensure you have access to a command-line interface (CLI) like Bash, which is commonly available on Linux and macOS systems. Windows users can use Git Bash or enable Windows Subsystem for Linux (WSL).
* RStudio: Download and install RStudio from the official RStudio website. Follow the installation instructions for your operating system.
Make sure you have R installed before setting up RStudio. You can download R from the Comprehensive R Archive Network (CRAN).

After installing both Shell and RStudio, you can clone the repository and follow the project-specific setup instructions to begin analysis

# Data Source
* The project utilizes covid-data.csv from Our World in Data, an open-source dataset updated daily.
* The current data reflects figures up to April 19, 2024, and is available here.
* Data can be downloaded from Our World in Data (https://github.com/owid/covid-19-data/tree/master/public/data) and saved as `covid-data.csv`.

# Data Processing
## Data Filtering by Continent:
A shell script was created to filter the global dataset by continent, outputting only European countries.
The European COVID-19 data was further filtered and analyzed to present the weekly incidence of COVID-19.
The resulting data was saved in a file named covid_europe_wk_new_cases_dec2023.csv.
## Packages Used for Analysis and Reporting:
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

# Key Analyses
Below are the key analyses conducted:
## European Regions Analysis:
* A table of prevalence, mortality, and full vaccination coverage for all regions until April 19, 2024, was prepared.
* Necessary columns (location, new cases, new vaccinations, and population) were filtered from the full data.
* Missing data were replaced with zeros.
* Cases, deaths, and vaccinations were summed up per region, and values per 100 people were calculated.
## COVID-19 Cases per Capita in European Countries:
* The cumulative number of cases per country was determined and divided by their respective populations.
* A bar chart visualizes the differences in incidence across countries.
## Cumulative Vaccination per 100 People in Selected European Countries:
* Twelve countries were selected based on high data reporting.
* Vaccination rates were calculated as a percentage of the population.
* A line curve shows the trend, and linear regression analyzes differences in vaccination rates.
## Monthly Vaccination Trend Analysis:
* Analyzed monthly vaccination trends from January 2021 to December 2023.
* Selected countries: Portugal, Belgium, UK, Malta, Sweden, Italy, Finland, Netherlands, Greece, Czechia, Croatia, and Bulgaria.
* Data aggregated monthly as a percentage of each country’s population.
* Performed linear regression to assess the relationship between time (month of the year), location, and vaccination rate.
## Percentage of Vaccinated Population:
* Evaluated vaccination acceptance by determining the percentage of the population vaccinated at least once or fully (both doses).
* Utilized data up to April 2024 for selected countries.
* Extracted relevant columns to calculate the percentage of partially and fully vaccinated individuals.
* Included the last reporting date for each country in the visual representation of the data.
## Seasonal Influence on Incidence and Mortality:
The impact of seasonality on COVID-19 incidence and mortality rates was investigated.
Data was visualized using box plots containing multiple samples (years) per season.
A linear regression analysis explored the influence of seasonality on the number of COVID-19 cases and deaths.

