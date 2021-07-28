# read flux data
library(ncdf4)

flux.fn <- 'data/Yanco_2021_L3.nc'
nc.file <- nc_open(flux.fn)

start.time <- (nc.file$dim$time$units)
start.time <- gsub('days since ','',start.time)
as.POSIXlt( ncvar_get(nc.file,'time')*24*3600,
            origin = start.time,tz = 'GMT')

nc.file$dim$latitude
nc.file$dim$longitude
