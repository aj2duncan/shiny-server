# script to clean data for catch and turn it into an xts object

# load packages
library(readr)
library(dplyr)
library(tidyr)
library(xts)
library(dygraphs)

# load data
rod_catch = read_csv("data/rod_catch.csv", col_types = "cddcdcddddddddddddd")

# remove some columns and sort by year, month
rod_catch = select(rod_catch, -`Report Order`, -Region, -ID) %>%
  arrange(District_Name, Year, Month_Number)

# data_frame of all Districts, years, months
# I'm sure there is a faster way to do this but this works just fine
all_ym = data.frame(Year = c(), Month_Number = c())
for (Years in c(min(rod_catch$Year):max(rod_catch$Year))) {
  for (Districts in unique(rod_catch$District_Name)) {
    this_ym = data.frame(District_Name = rep(Districts, 12), 
                         Year = rep(Years, 12), 
                         Month_Number = c(1:12))
    all_ym = rbind(all_ym, this_ym)  
  }
}


all_ym = tbl_df(all_ym)

# join to produce complete time series
rod_catch_ts = full_join(all_ym, rod_catch) %>%
  arrange(District_Name, Year, Month_Number)

# create time series for Wild Salmon
wild_salmon_ts = rod_catch_ts %>%
  select(District_Name, Year, Month_Number, Wild_Salmon_Number) %>%
  spread(key = District_Name, value = Wild_Salmon_Number, fill = NA) %>%
  select(-Year, -Month_Number) %>%
  select(Clyde) %>%
  ts(start = c(1952, 1), end = c(2015, 12), frequency = 12) %>%
  as.xts()

# plot time series
dygraph(wild_salmon_ts) %>%
  dyRangeSelector(dateWindow = c("2010-01-01", "2015-12-31"))
