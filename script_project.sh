#!/usr/bin/bash

#Filter out the whole data to retain the one with "Europe" as a value in the continent column
# Check if a directory path argument is provided
if [ "$#" -ne 1 ]; then
    exit 1
fi

# Assign the provided argument to a variable
directory_path="$1"

head -n 1 "${directory_path}" > "covid_data_europe_full.csv"
awk -F ',' 'NR>1 && $2 == "Europe"' "${directory_path}" >> "covid_data_europe_full.csv"

#Some countries stopped reporting in Decmber 2023. So for some plots, the time period under study will be Jan. 2020 to Dec. 2023. 
#Create a separate table for this, removing rows with date later than Dec 31, 2023.
awk -F ',' 'NR==1 || ($4 <= "2023-12-31")' covid_data_europe_full.csv >> covid_data_europe_dec2023.csv

#Create a table extracting just the location($3), date($4), new cases($6), and population($63) columns.
cut -d',' -f3,4,6,63 covid_data_europe_dec2023.csv > covid_europe_new_cases_dec2023.csv

#New cases data were entered weekly. Remove rows with zero number of new cases.
awk -F ',' '$3 != 0' covid_europe_new_cases_dec2023.csv > covid_europe_wk_new_cases_dec2023_0.csv

#Countries making up the United Kingdom have cumulative values. There are no individual values for them therefore remove them.
awk -F ',' '$3 != ""' covid_europe_wk_new_cases_dec2023_0.csv > covid_europe_wk_new_cases_dec2023.csv

rm -f covid_europe_wk_new_cases_dec2023_0.csv
rm -f covid_europe_new_cases_dec2023.csv


#Proceed to R for further analyses and Visualizations