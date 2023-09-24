


if (!require('ncdf4')) install.packages('ncdf4'); library(ncdf4)
if (!require('raster')) install.packages('raster'); library(raster)
library(lubridate)

save.path <- "SLE_CC_raw_data/cru_ts4.07.1901.1910.pre.dat.nc"

(nc.file <- nc_open(save.path))

#### extract data from raster nc file
(ras.nc.file <- raster(save.path, varname = "pre"))
ras.nc.file

(proj4string(ras.nc.file)=CRS("+init=EPSG:4326"))

nc_close(nc.file)

#### raster to df
ras.nc.file.df <- raster::as.data.frame(ras.nc.file, xy = TRUE, na=F)
ras.nc.file.df


ras.nc.file.df <- ras.nc.file.df %>%
  filter(!is.na(precipitation))
