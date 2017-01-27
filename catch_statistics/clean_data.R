# script to clean data for catch and turn it into an xts object

# load packages
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)

# load data
rod_catch = read_csv("data/rod_catch.csv", 
                     col_types = "cddcdcddddddddddddd")

# remove some columns and sort by year, month
rod_catch = select(rod_catch, -`Report Order`, -Region, -ID,
                   -Month_Number, -Month_Name) %>%
  arrange(District_Name, Year) %>%
  select(District_Name, Year, contains("Number"))

# remove all data before 1960 and after 2014
rod_catch = filter(rod_catch, Year >= 1960, Year <= 2014)


# calculate totals
tot_rod_catch = rod_catch %>% 
  group_by(District_Name, Year) %>%
  summarise_all(sum) 

# construct long dataset
tot_rod_catch_long = tot_rod_catch %>%
  gather(key = Species, value = Catch, 
         Wild_Salmon_Number:Farmed_Grilse_Number)

# choose species
in_Species = "Wild_Salmon_Number"

# pick just that Species
tot_rod_catch_long = tot_rod_catch_long %>%
  filter(Species == in_Species)

# count the number of entries to ensure 
# the rivers have all the years
full_results = tot_rod_catch_long %>%
  count(District_Name) %>%
  filter(n == 55)

in_District = sample(full_results$District_Name, size = 4)

# remove the rivers without all years
# then pick chosen districts

ts_rod_catch = tot_rod_catch_long %>%
  filter(District_Name %in% full_results$District_Name) %>%
  filter(District_Name %in% in_District) %>%
  select(-Species) %>%
  ungroup()

p = ts_rod_catch %>%
  ggplot(aes(x = Year, y = Catch, colour = District_Name)) +
  geom_line() +
  geom_smooth(se = FALSE, linetype = "dashed") +
  scale_colour_discrete(name = "River")


ggplotly(p)
