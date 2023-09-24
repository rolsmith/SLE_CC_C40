if (!require('chron')) install.packages('chron'); library(chron)
if (!require('lattice')) install.packages('lattice'); library(lattice)



# set path and filename
ncpath <- "SLE_CC_raw_data/SLE_CC_CCKP/Projection extremes/"
ncname <- "anomaly-rx5day-period-mean_cmip6_period_all-regridded-bct-ssp119-climatology_median_2010-2039"  
ncfname <- paste(ncpath, ncname, ".nc", sep="")
dname <- "anomaly-rx5day-period-mean"

# open a netCDF file
ncin <- nc_open(ncfname)
print(ncin)

# Get a list of the nc variable names
attributes(ncin$var)$names

# get longitude and latitude
lon <- ncvar_get(ncin,"lon")
nlon <- dim(lon)
head(lon)

lat <- ncvar_get(ncin,"lat")
nlat <- dim(lat)
head(lat)

print(c(nlon,nlat))

# get time
time <- ncvar_get(ncin,"time")
time

tunits <- ncatt_get(ncin,"time","units")
nt <- dim(time)
nt

tunits

# get anomaly-rx5day-period-mean
anomaly_rx5day_array <- ncvar_get(ncin,dname)
dlname <- ncatt_get(ncin,dname,"long_name")
dunits <- ncatt_get(ncin,dname,"units")
fillvalue <- ncatt_get(ncin,dname,"_FillValue")
dim(anomaly_rx5day_array)

# get global attributes
title <- ncatt_get(ncin,0,"title")
institution <- ncatt_get(ncin,0,"institution")
datasource <- ncatt_get(ncin,0,"source")
references <- ncatt_get(ncin,0,"references")
history <- ncatt_get(ncin,0,"history")
Conventions <- ncatt_get(ncin,0,"Conventions")

nc_close(ncin)

ls()

# replace netCDF fill values with NA's
anomaly_rx5day_array[anomaly_rx5day_array==fillvalue$value] <- NA

length(na.omit(as.vector(anomaly_rx5day_array[,1])))

# quick map
image(lon,lat,anomaly_rx5day_array, col=rev(brewer.pal(10,"RdBu")))

# levelplot of the slice
grid <- expand.grid(lon=lon, lat=lat)
cutpts <- c(-50,-40,-30,-20,-10,0,10,20,30,40,50)
levelplot(anomaly_rx5day_array ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
          col.regions=(rev(brewer.pal(10,"RdBu"))))

# create dataframe -- reshape data
# matrix (nlon*nlat rows by 2 cols) of lons and lats
lonlat <- as.matrix(expand.grid(lon,lat))
dim(lonlat)

# vector of `anomaly_rx5day` values
anomaly_rx5day_vec <- as.vector(anomaly_rx5day_array)
length(anomaly_rx5day_vec)

# create dataframe and add names
anomaly_rx5day_df01 <- data.frame(cbind(lonlat,anomaly_rx5day_vec))
names(anomaly_rx5day_df01) <- c("lon","lat","anomaly_rx5day")
head(na.omit(anomaly_rx5day_df01), 10)

anomaly_rx5day_freetown <- anomaly_rx5day_df01 %>%
  filter(lat >= 8 & lat <= 8.5 & lon >= -13.5 & lon <= -13)


anomaly_rx5day_freetown

nc_close()