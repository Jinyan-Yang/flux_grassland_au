# read flux data
library(ncdf4)
library(doBy)
# 
# flux.fn <- 
# read the nc files from ozflux####
get.flux.nc.func <- function(flux.fn){
  nc.file <- nc_open(flux.fn)
  
  start.time <- (nc.file$dim$time$units)
  start.time <- gsub('days since ','',start.time)

  # nc.file$dim$latitude
  # nc.file$dim$longitude
  flux.df <- data.frame(dateTime = as.POSIXlt( ncvar_get(nc.file,'time')*24*3600,
                                               origin = start.time,tz = 'GMT'),
                        nep =  ncvar_get(nc.file,'Fc'),
                        et = ncvar_get(nc.file,'Fe'),
                        rain = ncvar_get(nc.file,'Precip'),
                        # 
                        vpd = ncvar_get(nc.file,'VPD'),
                        Tair = ncvar_get(nc.file,'Ta'),
                        Tsoil = ncvar_get(nc.file,'Ts'),
                        RH = ncvar_get(nc.file,'RH'),
                        sw_w_m2 = ncvar_get(nc.file,'Fsd'),
                        lw_w_m2 = ncvar_get(nc.file,'Fld'),
                        windSpeed = ncvar_get(nc.file,'u'),
                        swc = ncvar_get(nc.file,'Sws'))
  return(flux.df)
}

flx.vec <- sprintf('data/Yanco_%s_L3.nc',2014:2017)

fulx.df.ls <- lapply(flx.vec,get.flux.nc.func)

flux.df.yanco <- do.call(rbind,fulx.df.ls)
flux.df.yanco$nep[flux.df.yanco$nep< -100] <- NA
flux.df.yanco$et[flux.df.yanco$et< -100] <- NA
flux.df.yanco$vpd[flux.df.yanco$vpd< 0] <- 0
flux.df.yanco$windSpeed[flux.df.yanco$windSpeed< 0.05] <- 0.05

flux.df.yanco$Date <- as.Date(flux.df.yanco$dateTime)

saveRDS(flux.df.yanco,'cache/flux_OZflux_yanco.rds')



# 
library(doBy)
flux.df.yanco.daily <- summaryBy(.~ Date, data = flux.df.yanco,
                               FUN=mean,na.rm=T,keep.names =T)


# read the file from anna###
nc.anna.nm <- 'data/AU-Ync_2011-2017_OzFlux_Flux.nc'
nc.anna.nm.met <- 'data/AU-Ync_2011-2017_OzFlux_met.nc'
nc.anna <- nc_open(nc.anna.nm)
nc.anna.met <- nc_open(nc.anna.nm.met)
nc.anna$var$NEE
start.time <- (nc.anna$dim$time$units)
start.time <- gsub('seconds since ','',start.time)

flux.yanco.anna.df <- data.frame(dateTime = as.POSIXlt( ncvar_get(nc.anna,'time'),
                                                        origin = start.time,tz = 'GMT'),
                                 nep = ncvar_get(nc.anna,'NEE'),
                                 et = ncvar_get(nc.anna,'Qle'),
                                 rain = ncvar_get(nc.anna.met,'Precip'),
                                 LAI_modis = ncvar_get(nc.anna.met,'LAI_alternative'),
                                 LAI_sentinel = ncvar_get(nc.anna.met,'LAI'))
library(lubridate)
flux.yanco.anna.df <- flux.yanco.anna.df[year(flux.yanco.anna.df$dateTime)>2013,]

flux.yanco.anna.df$Date <- as.Date(flux.df.yanco$dateTime)

flux.yanco.anna.daily <- summaryBy(.~ Date, data = flux.yanco.anna.df,
                                 FUN=mean,na.rm=T,keep.names =T)


# unit convert
s2d <- 24*3600
mumol2g <- 1e-6*12
j2g <- 2257 #j/g; energy needed to evaporate 1 g of water
g2mm <- 1e-3
# 
flux.yanco.anna.daily$nee_g_m2_d <- flux.yanco.anna.daily$nep *s2d * mumol2g
flux.yanco.anna.daily$et_mm_d <- flux.yanco.anna.daily$et * s2d /j2g *g2mm
flux.yanco.anna.daily$rain_mm_d <- flux.yanco.anna.daily$rain *s2d
# 
flux.df.yanco.daily$nee_g_m2_d <- flux.df.yanco.daily$nep *s2d * mumol2g
flux.df.yanco.daily$et_mm_d <- flux.df.yanco.daily$et * s2d /j2g *g2mm
flux.df.yanco.daily$rain_mm_d <- flux.df.yanco.daily$rain * 48

# read yanco station rainfall
rain.df <- read.csv('data/IDCJAC0009_074162_1800_Data.csv')
rain.df$Date <- strptime(paste0(rain.df$Year,'-',
                                rain.df$Month,'-',
                                rain.df$Day),'%Y-%m-%d')
rain.df$Date <- as.Date(rain.df$Date)
rain.df <- rain.df[rain.df$Year>2013 &
                     rain.df$Year<2018,]



pdf('compare_yanco.pdf',width = 8,height = 8*.618*3)
# 
par(mfrow=c(3,1),
    mar=c(5,5,1,4))

plot(nee_g_m2_d~Date,data = flux.yanco.anna.daily,
     type='l')
points(nee_g_m2_d~Date,data = flux.df.yanco.daily,type='l',col='red')


plot(et_mm_d~Date,data = flux.yanco.anna.daily,type='l')
points(et_mm_d~Date,data = flux.df.yanco.daily,type='l',col='red')

plot(rain_mm_d~Date,data = flux.yanco.anna.daily,type='l')
points(rain_mm_d~Date,data = flux.df.yanco.daily,type='l',col='red')

par(new=T)
plot(LAI_modis~Date,data = flux.yanco.anna.daily,type='l',col='green',ann=F,axes=F)
axis(4,at = seq(0,1.5,0.3),labels = seq(0,1.5,0.3))
mtext('LAI',side = 4,line=3,col='green')
# 
par(mfrow=c(3,1),
    mar=c(5,5,1,4))
plot(rain_mm_d~Date,data = flux.yanco.anna.daily,type='l')
plot(rain_mm_d~Date,data = flux.df.yanco.daily,type='l',col='red')
plot(Rainfall.amount..millimetres.~Date,data = rain.df,type='s',col='grey')
dev.off()
# 
