##%######################################################%##
#                                                          #
####         GIZ C40 SLE Cable Car: Freetown ~          ####
####   CCKP climate data ~ Roland Smith ~ 21.ix.2023    ####
#                                                          #
##%######################################################%##

##%##########################################################################%##
#0: Framework ##################################################################

#### Drawing together current climate data from CCKP downloads

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

##%##########################################################################%##
# 1: Uploading data from CCKP downloads ########################################

cckp_hist_dir <- list.files('SLE_CC_raw_data/SLE_CC_CCKP/CCKP Hist Min Mean Max Prec')

historic_df <- as.data.frame(matrix(ncol = 6))

colnames(historic_df) <- c("Range",
                           "Category",
                           "Min.Temperature",
                           "Mean.Temperature",
                           "Max.Temperature",
                           "Precipitation")

cckp_hist_dir <- list.files('SLE_CC_raw_data/SLE_CC_CCKP/CCKP Hist Min Mean Max Prec')

for (i in 1:length(cckp_hist_dir)) {
  
  #### identify specific file
  hist_file <- cckp_hist_dir[i]
  
  #### construct filepath
  file_path <- paste("SLE_CC_raw_data/SLE_CC_CCKP/CCKP Hist Min Mean Max Prec/",
                     cckp_hist_dir[i],
                     sep = "")
  
  #### load file
  df <- read.csv(file_path)
  
  #### extract year range from filename
  year_range <-substr(hist_file,39,47)
  
  #### add 'Range' column to df
  df$Range <- year_range
  
  
  #### bind range to df
  historic_df <- rbind(historic_df,
                       df)
  
  #### clear rogue NA rows
  historic_df <- historic_df[complete.cases(historic_df), ]
  
  #### reset df
  df <- tibble()
  
  
}

historic_df

historic_df$Category <- factor(historic_df$Category,
                               levels=c("Jan",
                                        "Feb",
                                        "Mar",
                                        "Apr",
                                        "May",
                                        "Jun",
                                        "Jul",
                                        "Aug",
                                        "Sep",
                                        "Oct",
                                        "Nov",
                                        "Dec"))

historic_df.long <- historic_df %>%
  pivot_longer(cols = !c(Range,Category),
               names_to = "Observation",
               values_to = "Values")

view(historic_df.long)

str(historic_df.long)


plot.mean_temp.df <- ggplot(data = historic_df,
                            aes(x = Category,
                                y = Mean.Temperature,
                                group = Range,
                                colour = Range)) +
  geom_path() +
  scale_color_brewer(palette = "Set1", direction=-1) +
  theme_light() +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_text(hjust=0.5),
        axis.text.x=element_text(hjust=1),
        legend.position="right") +
  labs(title="Monthly mean temperature - Sierra Leon, Western District",
       subtitle = "Labels: Number of households",
       y="%",
       fill="Household type")

plot.historic_df
