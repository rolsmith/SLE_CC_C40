##%######################################################%##
#                                                          #
####          GIZ C40 SLE Cable Car: Freetown           ####
####      climate data ~ Roland Smith ~ 15.ix.2023      ####
#                                                          #
##%######################################################%##

##%##########################################################################%##
#0: Framework ##################################################################

#### Initial sandpit to explore Sierra Leone climate data

## 0.1 Setting Workspace #######################################################

getwd()
setwd("/Users/rolsmith/Library/CloudStorage/OneDrive-SharedLibraries-HEATGmbH/GIZ C40 SLE Cable Car - GIZ C40 SLE Cable Car_expert team - GIZ C40 SLE Cable Car_expert team/WP2.4_Climate Proofing Study/SLE CC data analysis")
getwd()

## 0.2 Installing packages #####################################################
#### Basics 

if (!require('broom')) install.packages('broom'); library(broom)
if (!require('dplyr')) install.packages('dplyr'); library(dplyr)
if (!require('ggplot2')) install.packages('ggplot2'); library(ggplot2)
if (!require('RColorBrewer')) install.packages('RColorBrewer'); library(RColorBrewer)
if (!require('readxl')) install.packages('readxl'); library(readxl)
if (!require('tidyverse')) install.packages('tidyverse'); library(tidyverse)
if (!require('xlsx')) install.packages('xlsx'); library(xlsx)

#### others

if (!require('lubridate')) install.packages('lubridate'); library(lubridate)
if (!require('tidyquant')) install.packages('tidyquant'); library(tidyquant)

##%##########################################################################%##
#1: Uploading files ############################################################
# 1.1: Using function to unpack and reframe data sheet #########################
ft.clim.path <- "/Users/rolsmith/Library/CloudStorage/OneDrive-SharedLibraries-HEATGmbH/GIZ C40 SLE Cable Car - GIZ C40 SLE Cable Car_expert team - GIZ C40 SLE Cable Car_expert team/WP2.4_Climate Proofing Study/SLE CC data analysis/SLE_CC_raw_data/Format - Weather Data_Freetown(AutoRecovered).xlsx"

#### list of sheets
ft.clim.sheets <- excel_sheets(ft.clim.path)


#### holding dfs
ftown.clim.total <- as.data.frame(matrix(nrow=4018))
ftown.clim.total$date <- seq(as.Date("2010-01-01"), as.Date("2020-12-31"), by="days")
ftown.clim.total <- ftown.clim.total %>%
  dplyr::select(!V1)

#### function to load and reframe data of each climate variable

for (i in 1:length(ft.clim.sheets)) {
  
  (var <- ft.clim.sheets[i])
  
  ftown.clim.single <-  read.xlsx(ft.clim.path,
                 sheetName = var)
  
  ftown.clim.single.long <- ftown.clim.single %>%
  pivot_longer(cols = !c(Xmonth,Xdate),
               names_to="Xyear",
               values_to = var) %>%
  mutate(year = str_extract(Xyear, "\\d+"),
         month = recode(Xmonth,
                        January = 1,
                        February = 2,
                        March = 3,
                        April = 4,
                        May = 5,
                        June = 6,
                        July = 7,
                        August = 8,
                        September = 9,
                        October = 10,
                        November = 11,
                        December = 12),
         date = paste(year,
                      "/",
                      month,
                      "/",
                      Xdate,
                      sep = ""))
  
  ftown.clim.single.long$date = as.Date(ftown.clim.single.long$date,
                                      "%Y/%m/%d")
  
  ftown.clim.single.long <- ftown.clim.single.long %>%
  dplyr::select(date,
                Xdate,
                Xmonth,
                year,
                all_of(var)) %>%
  arrange(date)
  
  colnames(ftown.clim.single.long) <- c("date",
                                        "day",
                                        "month",
                                        "year",
                                        var)
  
  ftown.clim.total <- left_join(ftown.clim.total,
                              ftown.clim.single.long)
}

#### eye test of final dd
ftown.clim.total

#### setting factor levels to order months in anticipation of plot
ftown.clim.total$month <- factor(ftown.clim.total$month,
                                  levels=c("January",
                                           "February",
                                           "March",
                                           "April",
                                           "May",
                                           "June",
                                           "July",
                                           "August",
                                           "September",
                                           "October",
                                           "November",
                                           "December" ))


unique(ftown.clim.total$month)

##################

library(scales)

plot.ftown.clim.rainfall <- ggplot(ftown.clim.total,
                                   aes(x=year,
                                       y=Rainfall)) +
  facet_wrap(~month) +
  geom_point(shape=4, alpha = .5) +
  guides(color = 'legend') +
  scale_x_discrete() +
  theme_light() +
  theme(axis.title.y = element_text(hjust=0.5),
        axis.text.x=element_text(angle=70, hjust=1),
        legend.position="bottom") +
  labs(title="???",
       subtitle = "???",
       y="???",
       x="???")

plot.ftown.clim.rainfall

warnings()       

geom_ma(ma_fun = SMA, n = 30, color = "red") +                 # Plot 30-day SMA
  geom_ma(ma_fun = SMA, n = 365, color = "blue") +  # Plot 365-day SMA