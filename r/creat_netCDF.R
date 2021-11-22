library(ncdf4)

filename="test.nc"

xvals <- 150
yvals <- -33
nx <- length(xvals)
ny <- length(yvals)
lon1 <- ncdim_def("longitude", "degrees_east", xvals)
lat2 <- ncdim_def("latitude", "degrees_north", yvals)

year.day.vec <- seq(as.Date('1900-1-1'),
                    as.Date('2021-12-31'),by='day')

num.vec <- year.day.vec - as.Date('1900-1-1')

time <- ncdim_def("time","days", as.numeric(num.vec), unlim=TRUE,longname = 'days since 1900-1-1')
# day <- ncdim_def("doy","day", 1:365, unlim=TRUE)
mv <- -999 #missing value to use
var_temp <- ncvar_def("temperature", "celsius", 
                      list(lon1, lat2, time), 
                      longname="airT", mv) 

var_shoot <- ncvar_def("shoot", "g/m2", 
                      list(lon1, lat2, time), 
                      longname="shoot biomass", mv) 

ncnew <- nc_create(filename, list(var_temp,var_shoot))

print(paste("The file has", ncnew$nvars,"variables"))
#[1] "The file has 1 variables"
print(paste("The file has", ncnew$ndim,"dimensions"))
#[1] "The file has 3 dimensions"

# Some fake dataset based on latitude, to check whether the data are
# written in the correct order
data <- rnorm(time$len ,mean = 25,sd=5)

# Add random -999 value to check whether missing values are correctly
# written
# data[sample(1:(nx*ny), 100, replace = FALSE)] <- -999
ncvar_put(ncnew, var_temp, data, start=c(1,1,1), count=c(1,1,time$len))

# Don't forget to close the file
nc_close(ncnew)

teast <- nc_open('test.nc')
ncvar_get(teast,'temperature')




# 
# 
# # Verification
# library(rasterVis)
# out <- raster("time.nc")
# levelplot(out, margin=FALSE)