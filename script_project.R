library(dplyr)
library(tidyverse)
library(lubridate)
tinytex::install_tinytex()
library(tinytex)
library(gridExtra)

####TABLE OF PREVALENCE, MORTALITY AND FULL VACCINATION FOR ALL REGIONS 20TH APRIL 2024####
#Import data
covid_data_europe <- read_csv("./covid_data_europe_full.csv")

#Extract necessary columns from the table
cases_deaths_vacc_data <- covid_data_europe[c("location", "new_cases", "new_deaths", "new_vaccinations", "population")]


#Replace all NA with zero
cases_deaths_vacc_data[is.na(cases_deaths_vacc_data)] <- 0

#Sum up the data per location
total_cases_deaths_vacc <- cases_deaths_vacc_data %>%
  group_by(location, population) %>%
  summarize(total_cases = sum(new_cases), total_deaths = sum(new_deaths), total_vaccine_doses = sum(new_vaccinations))

#Since England, Wales, Scotland, Northern Ireland make up the United Kingdom, remove their rows
total_cases_deaths_vacc <- total_cases_deaths_vacc %>%
  subset(!location %in% c("England", "Wales", "Scotland", "Northern Ireland"))


#Make a table of the region and countries
# Define the data for regions and countries
regions <- c(
  "Northern Europe", "Northern Europe", "Northern Europe", "Northern Europe", "Northern Europe",
  "Northern Europe", "Northern Europe", "Northern Europe", "Northern Europe",
  "Western Europe", "Western Europe", "Western Europe", "Western Europe", "Western Europe",
  "Western Europe", "Western Europe", "Western Europe", "Western Europe", "Western Europe",
  "Southern Europe", "Southern Europe", "Southern Europe", "Southern Europe", "Southern Europe",
  "Southern Europe", "Southern Europe", "Southern Europe", "Southern Europe", "Southern Europe",
  "Southern Europe", "Southern Europe", "Southern Europe", "Southern Europe", "Southern Europe", "Southern Europe", "Southern Europe",
  "Eastern Europe", "Eastern Europe", "Eastern Europe", "Eastern Europe", "Eastern Europe",
  "Eastern Europe", "Eastern Europe", "Eastern Europe", "Eastern Europe", "Eastern Europe",
  "British Isles", "British Isles", "British Isles", "British Isles", "British Isles"
)

countries <- c(
  "Denmark", "Estonia", "Faeroe Islands", "Finland", "Iceland", "Latvia", "Lithuania", "Norway", "Sweden",
  "Andorra", "Austria", "Belgium", "France", "Germany", "Liechtenstein", "Luxembourg", "Monaco", "Netherlands", "Switzerland",
  "Albania", "Bosnia and Herzegovina", "Croatia", "Cyprus", "Gibraltar", "Greece", "Italy", "Kosovo", "Malta", "Montenegro", "North Macedonia", "Portugal", "San Marino", "Serbia", "Slovenia", "Spain", "Vatican",
  "Belarus", "Bulgaria", "Czechia", "Hungary", "Moldova", "Poland", "Romania", "Russia", "Slovakia", "Ukraine",
  "Guernsey", "Ireland", "Isle of Man", "Jersey", "United Kingdom"
)

# Create a data frame with the specified columns
regions <- data.frame(region = regions, country = countries)

#Join the region to to the table using country as the unique identifier
total_cases_deaths_vacc_region <- left_join(total_cases_deaths_vacc, regions, by = join_by(location == country)) %>% drop_na(region)


#Get the sum of cases, vaccination and deaths  per region
total_cases_deaths_vacc_region <- total_cases_deaths_vacc_region %>%
  group_by(region) %>%
  summarize(reg_population = sum(population), total_cases = sum(total_cases), total_deaths = sum(total_deaths),
            total_vaccine_doses = sum(total_vaccine_doses))

#Normalize data by calculating cases, deaths and vaccinations per 100 people
total_cases_deaths_vacc_region_per_100 <- total_cases_deaths_vacc_region %>%
  group_by(region) %>%
  summarize(
    total_cases_per_100_people = (total_cases / reg_population) * 100,
    total_deaths_per_100_people = (total_deaths / reg_population) * 100,
    total_vaccine_doses_per_100_people = (total_vaccine_doses / reg_population) * 100
  )

#Format the numeric columns to two decimal places
total_cases_deaths_vacc_region_per_100 <- total_cases_deaths_vacc_region_per_100 %>%
  mutate(
    total_cases_per_100_people = format(round(total_cases_per_100_people, 2), nsmall = 2),
    total_deaths_per_100_people = format(round(total_deaths_per_100_people, 2), nsmall = 2),
    total_vaccine_doses_per_100_people = format(round(total_vaccine_doses_per_100_people, 2), nsmall = 2)
  )

#Rename the headers
colnames(total_cases_deaths_vacc_region_per_100) <- c("Region", "Total cases per hundred", "Total deaths per hundred",
                                                      "Total vaccinations per hundred")

####DETERMINE THE NEW CASES PER CAPITA FOR A PERIOD OF JAN 2020 TO DEC. 2023####
#Read the CSV file
covid_europe_wk_new_cases <- read_csv("covid_europe_wk_new_cases_dec2023.csv")

#Get the sum of all new cases per country
total_cases_country <- covid_europe_wk_new_cases %>%
  group_by(location, population) %>%
  summarize(sum_new_cases = sum(new_cases))

#Normalize by finding the ratio of the sum of new cases and the population of the countries
cases_per_capita <- total_cases_country %>%
  mutate(cases_per_capita = sum_new_cases / population)

#Make a plot of country against new cases per capita
cases_per_capita_plot <- ggplot(cases_per_capita, aes (x = cases_per_capita, y = reorder(location, +cases_per_capita), fill = location)) + 
  geom_bar(stat = "identity", width = 0.75) +
  theme(legend.position = "none") +
  labs(x = "New cases per capita",y = "Country") +
  theme(axis.text.y = element_text(size = 7.5))
print(cases_per_capita_plot)

ggsave("cases_per_capita_plot.png", width = 7, height = 7)


####CUMULATIVE VACCINE DOSE PER 100 PEOPLE IN SELECTED COUNTRIES JAN 2020 TO DEC 2023####

#Import the table
covid_data_europe <- read_csv("./covid_data_europe_dec2023.csv")

#Extract necessary columns from the table
vacc_data <- covid_data_europe[c("location", "date", "total_vaccinations", "population")]


countries <- c("Czechia", "Malta", "Portugal", "Sweden", "Bulgaria", "Belgium", "Finland", "Croatia", "Greece",
               "Italy", "Netherlands", "United Kingdom")


vacc_data_sel_countries <- vacc_data[vacc_data$location %in% countries, ]

#Remove rows with empty values in the vaccination column
vacc_data_sel_countries <- vacc_data_sel_countries[!is.na(vacc_data_sel_countries$total_vaccinations), ]


vacc_per_100_people_sel_countries <- vacc_data_sel_countries %>%
  mutate(vaccinations_per_100_people = (total_vaccinations/population) * 100)



# First, create a new data frame that contains only the last point for each line
last_points <- vacc_per_100_people_sel_countries %>%
  group_by(location) %>%
  filter(date == max(date)) %>%
  ungroup()

# Add the empty row to the end of the data frame to give room for legends on the plot
empty_row <- data.frame(location = NA, date = "2024-05-01", total_vaccinations = NA, population = NA,
                        vaccinations_per_100_people = NA)
vacc_per_100_people_sel_countries <- rbind(vacc_per_100_people_sel_countries, empty_row)


#Create the plot
cumulative_vaccinations_per_100_people_plot <- ggplot(vacc_per_100_people_sel_countries, aes(x = date, y = vaccinations_per_100_people, color = location)) +
  geom_line() +
  geom_text(data = last_points, aes(label = location, y = vaccinations_per_100_people), 
            nudge_x = 0.5, hjust = 0, check_overlap = FALSE, size = 3) +  
  theme(legend.position = "none") + labs(x = "Year", y = "Cumulative vaccinations per 100 people", color = "Region")
print(cumulative_vaccinations_per_100_people_plot)

#Save the plot
ggsave("cumulative_vaccinations_per_100_people_plot.png", width = 7, height = 7)



#Do the regression analysis
library(moderndive)
cum_vac_interaction <- lm(vaccinations_per_100_people ~ date * location, data = vacc_per_100_people_sel_countries)

get_regression_table(cum_vac_interaction)

cum_vac_stats <- lm(vaccinations_per_100_people ~ date * location, data = vacc_per_100_people_sel_countries) %>%
  summary()

tail(cum_vac_stats)


# Define a function to extract the overall p-value of the model
overall_p <- function(my_model) {
  f <- summary(my_model)$fstatistic
  p <- pf(f[1], f[2], f[3], lower.tail = FALSE)
  attributes(p) <- NULL
  return(p)
}

# Extract the overall p-value of your model
p_value_cum_vac <- overall_p(cum_vac_interaction) %>% format(round(., 2), nsmall = 5)


# Extract adjusted R-squared value of regression model
R_squared_cum_vac <- summary(cum_vac_interaction)$adj.r.squared %>% format(round(., 3), nsmall = 1)



####MONTHLY VACCINATION PER 100 PEOPLE JAN 2020 TO DEC 2023####

#Import the table
covid_data_europe <- read_csv("./covid_data_europe_dec2023.csv")

#Extract necessary columns from the table
daily_vacc_data <- covid_data_europe[c("location", "date", "new_vaccinations", "population")]

#Extract data of only selected countries. Countries that reported adequate vaccination data were selected.
countries <- c("Czechia", "Malta", "Bulgaria", "Belgium", "Croatia", "Greece",
               "Italy", "United Kingdom")


daily_vacc_data_sel_countries <- daily_vacc_data[daily_vacc_data$location %in% countries, ]


#Separate date into year, month and day
library(lubridate)
daily_vacc_data_sel_countries$year <- year(ymd(daily_vacc_data_sel_countries$date))
daily_vacc_data_sel_countries$month <- month(ymd(daily_vacc_data_sel_countries$date))
daily_vacc_data_sel_countries$day <- day(ymd(daily_vacc_data_sel_countries$date))



#Sum up the daily vaccinations for each month
monthly_vacc_data_sel_countries <- daily_vacc_data_sel_countries %>%
  group_by(location, month, year) %>%
  mutate(monthly_vaccination = sum(new_vaccinations))



#Since the monthly vaccination column has the same value for all the days of the month,
#select just the first day to represent the whole month
monthly_vacc_data_sel_countries <- monthly_vacc_data_sel_countries[format(monthly_vacc_data_sel_countries$date, "%d") == "01", ]



#Remove rows with empty values in the vaccination column
monthly_vacc_data_sel_countries <- monthly_vacc_data_sel_countries[!is.na(monthly_vacc_data_sel_countries$monthly_vaccination), ]


#Calculate the monthly vaccination doses per 100 people
monthly_vacc_per_100_people_sel_countries <- monthly_vacc_data_sel_countries %>%
  mutate(monthly_vaccinations_per_100_people = (monthly_vaccination/population) * 100)


# Extract the month and year from the date
monthly_vacc_per_100_people_sel_countries$month <- format(monthly_vacc_per_100_people_sel_countries$date, "%b")
monthly_vacc_per_100_people_sel_countries$year <- format(monthly_vacc_per_100_people_sel_countries$date, "%Y")

#Make the plot
monthly_vaccinations_per_100_people_plot <- ggplot(monthly_vacc_per_100_people_sel_countries, aes(x = date, y = monthly_vaccinations_per_100_people, color = location)) +
  geom_line() +
  labs(x = "Month", y = "Monthly vaccinations per 100 people", color = "Country") +
  scale_x_date(date_labels = "%b %Y", date_breaks = "2 months") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
print(monthly_vaccinations_per_100_people_plot)

#Save the plot
ggsave("monthly_vaccinations_per_100_people_plot.png", width = 7, height = 7)


#Conduct a regression analysis
library(moderndive)
mon_vac_interaction <- lm(monthly_vaccinations_per_100_people ~ date * location, data = monthly_vacc_per_100_people_sel_countries)

get_regression_table(mon_vac_interaction)

mon_vac_stats <- lm(monthly_vaccinations_per_100_people ~ date * location, data = monthly_vacc_per_100_people_sel_countries) %>%
  summary()

tail(mon_vac_stats)


# Define a function to extract the overall p-value of the model
overall_p <- function(my_model) {
  f <- summary(my_model)$fstatistic
  p <- pf(f[1], f[2], f[3], lower.tail = FALSE)
  attributes(p) <- NULL
  return(p)
}

# Extract the overall p-value of your model
p_value_mon_vac <- overall_p(mon_vac_interaction) %>% format(round(., 2), nsmall = 5)


# Extract adjusted R-squared value of regression model
R_squared_mon_vac <- summary(mon_vac_interaction)$adj.r.squared %>% format(round(., 3), nsmall = 1)

####PERCENTAGE OF PEOPLE VACCINATED AT LEAST ONCE IN SELECTED COUNTRIES####

#Load the data
covid_data_europe <- read_csv("covid_data_europe_full.csv")

#Extract necessary columns from the table
vacc_data <- covid_data_europe[c("location", "date", "people_vaccinated", "population")]

#Select countries
countries <- c("Czechia", "Malta", "Portugal", "Sweden", "Bulgaria", "Belgium", "Finland", "Croatia", "Greece",
               "Italy", "Netherlands", "United Kingdom")


vacc_data <- vacc_data[vacc_data$location %in% countries, ]

#Remove rows with empty values in the vaccination column
vacc_data <- vacc_data[!is.na(vacc_data$people_vaccinated), ]


#Extract rows for the last occurrence of each unique location
vacc_data_last_day <- vacc_data %>%
  group_by(location) %>%
  filter(date == max(date)) %>%
  ungroup()


#Calculate percentage share of people vaccinated at least once
vacc_data_last_day_percent <- vacc_data_last_day %>%
  mutate(percentage_people_vaccinated = (people_vaccinated/population) * 100)

#Change the format of the date
vacc_data_last_day_percent$date <- format(as.Date(vacc_data_last_day_percent$date), "%b %e, %Y")


#Make a plot of country against percentage people vaccinated
percentage_people_vaccinated_plot <- ggplot(vacc_data_last_day_percent, aes (x = percentage_people_vaccinated, y = reorder(location, + percentage_people_vaccinated), fill = location)) + 
  geom_bar(stat = "identity", width = 0.75) +
  labs(x = "", y = "Country") +
  theme(legend.position = "none") + 
  geom_text(aes(label = date), hjust = 1, vjust = 0.5, size = 3, color = "black") +
  scale_x_continuous(labels = scales::percent_format(scale = 1))
print(percentage_people_vaccinated_plot)

#Save the plot
ggsave("percentage_people_vaccinated_plot.png", width = 7, height = 7)


####PERCENTAGE OF PEOPLE FULLY VACCINATED IN SELECTED COUNTRIES####

#Load the data
covid_data_europe <- read_csv("./covid_data_europe_full.csv")

#Extract necessary columns from the table
full_vacc_data <- covid_data_europe[c("location", "date", "people_fully_vaccinated", "population")]

#Select countries
countries <- c("Czechia", "Malta", "Portugal", "Sweden", "Bulgaria", "Belgium", "Finland", "Croatia", "Greece",
               "Italy", "Netherlands", "United Kingdom")


full_vacc_data <- full_vacc_data[full_vacc_data$location %in% countries, ]

#Remove rows with empty values in the vaccination column
full_vacc_data <- full_vacc_data[!is.na(full_vacc_data$people_fully_vaccinated), ]


#Extract rows for the last occurrence of each unique location
full_vacc_data_last_day <- full_vacc_data %>%
  group_by(location) %>%
  filter(date == max(date)) %>%
  ungroup()


#Calculate percentage share of people vaccinated at least once
full_vacc_data_last_day_percent <- full_vacc_data_last_day %>%
  mutate(percentage_people_fully_vaccinated = (people_fully_vaccinated/population) * 100)

#Change the format of the date
full_vacc_data_last_day_percent$date <- format(as.Date(full_vacc_data_last_day_percent$date), "%b %e, %Y")


#Make a plot of country against percentage people vaccinated
percentage_people_fully_vaccinated_plot <- ggplot(full_vacc_data_last_day_percent, aes (x = percentage_people_fully_vaccinated, y = reorder(location, + percentage_people_fully_vaccinated), fill = location)) + 
  geom_bar(stat = "identity", width = 0.75) +
  labs(x = "", y = "Country") +
  theme(legend.position = "none") + 
  geom_text(aes(label = date), hjust = 1, vjust = 0.5, size = 3, color = "black") +
  scale_x_continuous(labels = scales::percent_format(scale = 1))
print(percentage_people_fully_vaccinated_plot)
#Save the plot
ggsave("percentage_people_fully_vaccinated_plot.png", width = 7, height = 7)


####NEW COVID 19 CASES BY SEASONS OF THE YEAR MARCH 2020 TO FEB 2024####

#Import the CSV file
covid_data_europe <- read_csv("covid_data_europe_full.csv")

#Filter the date and new cases columns
covid_europe_new_cases <- covid_data_europe[c("date", "new_cases")]


#The time period under study is 1st March 2021 and 29th Feb. 2024. Filter the table. This was done so all the 
#seasons of the year will have the same number of data points for the three years.

# First, convert the date_column to a Date object
covid_europe_new_cases$date <- as.Date(covid_europe_new_cases$date)

# Filter dates between 1st March 2020 and 29th February 2024
covid_europe_new_cases <- covid_europe_new_cases %>%
  filter(date >= as.Date("2020-03-01") & date <= as.Date("2024-02-29"))

#Delete the rows with empty values in the "new cases" column if there is any
covid_europe_new_cases <- covid_europe_new_cases[!is.na(covid_europe_new_cases$new_cases), ]

# Separate the 'date' column into 'year', 'month', and 'day'
covid_europe_new_cases <- separate(covid_europe_new_cases, date, into = c("year", "month", "day"), sep = "-")

#Add up the number of cases my months of each year

covid_europe_new_cases_sum <- covid_europe_new_cases %>%
  group_by(month, year) %>%
  summarize(sum_new_cases = sum(new_cases))

#Assign seasons of the year to months. 

covid_europe_new_cases_season <- covid_europe_new_cases_sum %>%
  mutate(season = case_when(
    month %in% c(12, "01", "02") ~ "Winter",
    month %in% c("03", "04", "05") ~ "Spring",
    month %in% c("06", "07", "08") ~ "Summer",
    month %in% c("09", 10, 11) ~ "Fall"
  ))

#Jan and Feb will bear the previous year's winter. e.g. Jan and Feb 2023 are classified under Winter 2022
# Subtract 1 from the year for months 1 (Jan) and 2 (Feb)
covid_europe_new_cases_season$year <- as.numeric(covid_europe_new_cases_season$year) - ifelse(covid_europe_new_cases_season$month %in% c("01", "02"), 1, 0)

#Sum up the number of deaths by season of the years
covid_europe_new_cases_season_grouped <- covid_europe_new_cases_season %>%
  group_by(year, season) %>%
  summarize(sum_new_cases_grouped = sum (sum_new_cases))


#Make a boxplot
seasonal_cases_plot <- ggplot(covid_europe_new_cases_season_grouped, aes(x = season, y = sum_new_cases_grouped)) + geom_boxplot() + 
  labs(x = "Season", y = "Number of Cases")
print(seasonal_cases_plot)

#Save the plot
ggsave("seasonal_cases_plot.png", width = 7, height = 7)



#Do the regression analysis
library(moderndive)
cases_interaction <- lm(sum_new_cases_grouped ~ season * year, data = covid_europe_new_cases_season_grouped)

get_regression_table(cases_interaction)

cases_stats <- lm(sum_new_cases_grouped ~ season * year, data = covid_europe_new_cases_season_grouped) %>%
  summary()

tail(cases_stats)


# Define a function to extract the overall p-value of the model
overall_p <- function(my_model) {
  f <- summary(my_model)$fstatistic
  p <- pf(f[1], f[2], f[3], lower.tail = FALSE)
  attributes(p) <- NULL
  return(p)
}

# Extract the overall p-value of your model
p_value_cases <- overall_p(cases_interaction) %>% format(round(., 2), nsmall = 5)


# Extract adjusted R-squared value of regression model
R_squared_cases <- summary(cases_interaction)$adj.r.squared %>% format(round(., 3), nsmall = 1)




####COVID 19 DEATHS BY SEASONS OF THE YEAR FROM MARCH 2020 TO FEB 2024####

#Import the CSV file
covid_data_europe <- read_csv("covid_data_europe_full.csv")

#Filter the date and new cases columns
covid_europe_new_deaths <- covid_data_europe[c("date", "new_deaths")]


#The time period under study is 1st March 2021 and 29th Feb. 2024. Filter the table. This was done so all the 
#seasons of the year will have the same number of data points for the three years.

# First, convert the date_column to a Date object
covid_europe_new_deaths$date <- as.Date(covid_europe_new_deaths$date)

# Filter dates between 1st March 2020 and 29th February 2024
covid_europe_new_deaths <- covid_europe_new_deaths %>%
  filter(date >= as.Date("2020-03-01") & date <= as.Date("2024-02-29"))

#Delete the rows with empty values in the "new cases" column if there is any
covid_europe_new_deaths <- covid_europe_new_deaths[!is.na(covid_europe_new_deaths$new_deaths), ]

# Separate the 'date' column into 'year', 'month', and 'day'
covid_europe_new_deaths <- separate(covid_europe_new_deaths, date, into = c("year", "month", "day"), sep = "-")

#Add up the number of cases my months of each year

covid_europe_new_deaths_sum <- covid_europe_new_deaths %>%
  group_by(month, year) %>%
  summarize(sum_new_deaths = sum(new_deaths))

#Assign seasons of the year to months. 

covid_europe_new_deaths_season <- covid_europe_new_deaths_sum %>%
  mutate(season = case_when(
    month %in% c(12, "01", "02") ~ "Winter",
    month %in% c("03", "04", "05") ~ "Spring",
    month %in% c("06", "07", "08") ~ "Summer",
    month %in% c("09", 10, 11) ~ "Fall"
  ))

#Jan and Feb will bear the previous year's winter. e.g. Jan and Feb 2023 are classified under Winter 2022
# Subtract 1 from the year for months 1 (Jan) and 2 (Feb)
covid_europe_new_deaths_season$year <- as.numeric(covid_europe_new_deaths_season$year) - ifelse(covid_europe_new_deaths_season$month %in% c("01", "02"), 1, 0)

#Sum up the number of deaths by season of the years
covid_europe_new_deaths_season_grouped <- covid_europe_new_deaths_season %>%
  group_by(year, season) %>%
  summarize(sum_new_deaths_grouped = sum (sum_new_deaths))

#Make a boxplot
seasonal_deaths_plot <- ggplot(covid_europe_new_deaths_season_grouped, aes(x = season, y = sum_new_deaths_grouped)) + geom_boxplot() + 
  labs(x = "Season", y = "Number of Deaths")
print(seasonal_deaths_plot)

#Save the plot 
ggsave("seasonal_deaths_plot.png", width = 7, height = 7)

#Do the regression analysis
library(moderndive)
deaths_interaction <- lm(sum_new_deaths_grouped ~ season * year, data = covid_europe_new_deaths_season_grouped)

get_regression_table(deaths_interaction)

deaths_stats <- lm(sum_new_deaths_grouped ~ season * year, data = covid_europe_new_deaths_season_grouped) %>%
  summary()

tail(deaths_stats)


# Define a function to extract the overall p-value of the model
overall_p <- function(my_model) {
  f <- summary(my_model)$fstatistic
  p <- pf(f[1], f[2], f[3], lower.tail = FALSE)
  attributes(p) <- NULL
  return(p)
}

# Extract the overall p-value of your model
p_value_deaths <- overall_p(deaths_interaction) %>% format(round(., 2), nsmall = 5)


# Extract adjusted R-squared value of regression model
R_squared_deaths <- summary(deaths_interaction)$adj.r.squared %>% format(round(., 3), nsmall = 1)




