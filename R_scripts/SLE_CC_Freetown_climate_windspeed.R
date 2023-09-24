nc <- nc_open("/Users/rolsmith/Library/CloudStorage/OneDrive-SharedLibraries-HEATGmbH/GIZ C40 SLE Cable Car - GIZ C40 SLE Cable Car_expert team - GIZ C40 SLE Cable Car_expert team/WP2.4_Climate Proofing Study/SLE CC data analysis/SLE_CC_raw_data/SLE_CC_KNMI/iera5_maxwspd_daily_af_12_max_-13.234444E_8.484444N_n.nc")

names(nc$var)

attributes(nc)$names

print(paste("The file has",nc$nvars,"variables,",nc$ndims,"dimensions and",nc$natts,"NetCDF attributes"))

# Get a list of the nc variable names.
attributes(nc$var)$names

ncatt_get(nc, attributes(nc$var)$names[1])

chla_mean <- ncvar_get(nc, attributes(nc$var)$names[1])

attributes(nc$dim)$names

nc_time <- ncvar_get( nc, attributes(nc$dim)$names[1])

nc_atts <- ncatt_get(nc, 0)

date_start <- as.Date(nc_atts$time_coverage_start)
date_end <- as.Date(nc_atts$time_coverage_end)

nc_close(nc)

data

wnd_speed <- as_tibble(matrix(nrow=888))

wnd_speed$wind_speed <- data

dates <- seq(date_start, by="month", length.out = 888)

wnd_speed$dates <- dates

wnd_speed$month.n<- format(as.Date(wnd_speed$dates, format="%Y-%m-%d"),"%m")

wnd_speed$year<- format(as.Date(wnd_speed$dates, format="%Y-%m-%d"),"%Y")

wnd_speed <- wnd_speed %>%
  select(!V1) %>%
  filter(!is.na(wind_speed))

view(wnd_speed)

wnd_speed.summary <- wnd_speed %>%
  group_by(month.n) %>%
  summarise(mean = mean(wind_speed), n = n(),
            sd = sd(wind_speed),
            min = min(wind_speed),
            max = max(wind_speed))

str(wnd_speed)


plot.ftown.max_wnd_speed <- ggplot(wnd_speed,
                                   aes(x=dates,
                                       y=wind_speed)) +
  geom_point(shape=4, alpha = .5) +
  geom_line() +
  geom_smooth() +
  guides(color = 'legend') +
  theme_light() +
  theme(axis.title.y = element_text(hjust=0.5),
        axis.text.x=element_text(angle=70, hjust=1),
        legend.position="bottom") +
  labs(title="???",
       subtitle = "???",
       y="???",
       x="???")

plot.ftown.max_wnd_speed
