u <- 'http://dapds00.nci.org.au/thredds/fileServer/ks32/CLEX_Data/PLUMBER2/v1-0/Flux/AU-How_2003-2017_OzFlux_Flux.nc'

download.file(u,destfile = 'how_2003_2017.nc')

u.met <- 'http://dapds00.nci.org.au/thredds/fileServer/ks32/CLEX_Data/PLUMBER2/v1-0/Met/AU-How_2003-2017_OzFlux_Met.nc'
download.file(u.met,destfile = 'met_how_2003_2017.nc')


how.df <- get.nc.func(data.frame(flux.nm = 'how_2003_2017.nc',
                       met.nm = 'met_how_2003_2017.nc'))

nc.file <- nc_open(flux.fn)
start.time <- (nc.file$dim$time$units)
start.time <- gsub('seconds since ','',start.time)
flux.df <- data.frame(Site = substr(flux.fn,6,11),
                      DateTime = as.POSIXlt( ncvar_get(nc.file,'time'),
                                             origin = start.time,tz = 'GMT'),
                      le_w_m2 = ncvar_get(nc.file,'Qle'),
                      GPP_umol_m2_s = ncvar_get(nc.file,'GPP'),
                      GPP_qc= ncvar_get(nc.file,'GPP_qc'),
                      fn = flux.fn
)