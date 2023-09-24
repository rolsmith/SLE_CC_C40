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

#### Others

if (!require('ncdf4')) install.packages('ncdf4'); library(ncdf4)
if (!require('raster')) install.packages('raster'); library(raster)
if (!require('sf')) install.packages('sf'); library(sf)

##%##########################################################################%##

nc <- nc_open("SLE_CC_raw_data/SLE_CC_CCKP/Projection extremes/anomaly-rx5day-period-mean_cmip6_period_all-regridded-bct-ssp119-climatology_median_2010-2039.nc")

names(nc$var)

#### overview of nc file
print(nc)

#### checking attributes
attributes(nc)$names

# Get a list of the nc variable names.
attributes(nc$var)$names

# Take a look at the "anomaly-rx5day-period-mean" variable's nc attributes (units etc).
ncatt_get(nc, attributes(nc$var)$names[1])

# Retrieve a matrix of the "anomaly-rx5day-period-mean" data using the ncvar_get function:
anom_rx5day_mean <- ncvar_get(nc, attributes(nc$var)$names[1])


# Retrieve the latitude and longitude values.
attributes(nc$dim)$names



nc_close(nc)





pre1.brick = brick("SLE_CC_raw_data/SLE_CC_CCKP/Projection extremes/anomaly-rx5day-period-mean_cmip6_period_all-regridded-bct-ssp119-climatology_median_2010-2039.nc")

pre1.brick

extent(pre1.brick)


crs(pre1.brick)

#### downloading SL shapefile

#### admin 2 shp file

sle.adm2 <- sf::read_sf("SLE_CC_raw_data/SLE_CC_Humdata_Admin_shp/sle_admbnda_adm2_1m_gov_ocha/sle_admbnda_adm2_1m_gov_ocha_20161017.shp")

unique(sle.adm2$admin1Name)

sle.adm2 %>% 
  ggplot() +
  geom_sf()

sle.adm2.western <- sle.adm2 %>% filter(admin1Name == "Western")

sle.adm2.western %>% 
  ggplot() +
  geom_sf()

##%##########################################################################%##

sle.adm3 <- sf::read_sf("SLE_CC_raw_data/SLE_CC_Humdata_Admin_shp/sle_admbnda_adm3_1m_gov_ocha_20161017/sle_admbnda_adm3_1m_gov_ocha_20161017.shp")

unique(sle.adm3$admin2Name)
sle.adm3.west_urb <- sle.adm3 %>% filter(admin2Name == "Western Area Urban")

sle.adm3.west_urb %>% 
  ggplot() +
  geom_sf()

sf::st_write(sle.adm3.west_urb,
             "SLE_CC_raw_data/SLE_CC_Humdata_Admin_shp/sle_west_urban_sf/sle.adm3.west_urb.shp",
             driver = "ESRI Shapefile")

sle.west_urb <- sf::read_sf("SLE_CC_raw_data/SLE_CC_Humdata_Admin_shp/sle_west_urban_sf/sle.adm3.west_urb.shp")

sle.west_urb.bbox <- sle.west_urb %>% st_bbox()

crs(sle.west_urb)

str(sle.adm3.west_urb)

crs(pre1.brick)

pre1.mask = mask(pre1.brick, sle.adm3)

pre1.df = as.data.frame(pre1.mask, xy=TRUE)

pre1.df <- pre1.df %>%
  filter(!is.na(X2010.07.01))





