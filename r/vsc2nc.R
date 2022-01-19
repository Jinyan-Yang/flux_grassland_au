source('r/creat_netCDF.R')
out.vec <- list.files('outputs/climGrass/',full.names = T,pattern = '.csv')
for (i in seq_along(out.vec)) {
  
  creat.nc.func(in.nm=out.vec[i],
                out.nm=gsub('output.csv','gday.nc',out.vec[i]))


}


# nc.file <- nc_open('outputs/climGrass/C0T0D0_output.nc')
# nc(nc.file,'time')
