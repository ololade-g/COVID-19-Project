In this report, I analyzed COVID-19 data "covid_data.csv" while focusing on European countries. Data was downloaded from Our World in Data (https://github.com/owid/covid-19-data/tree/master/public/data), a daily updated and open-source data for everyone. The data used in this project was updated till 19th April, 2023. The data was further filtered to desired forms to answer some research questions. This project was focused on Europe. With a shell script, the global dataset was filtered by continent to output only European countries.The European COVID-19 data was furher filtered and analyzed to present the weekly incidence of COVID-19. Further analysis and and visualization were done in R.

A shell script was created to output the data from Europe up to date and also data from Europe stopping on 31st December 2023. The December 2023 data was used for a few analyses because some countries stopped reporting data at that time. The shell script will also produce a file named 'covid_europe_wk_new_cases_dec2023.csv'. This data contains the weekly number of COVID-19 cases up till December 2023. Run `script_project [path to COVID-19 data file]` in bash to get these output files.