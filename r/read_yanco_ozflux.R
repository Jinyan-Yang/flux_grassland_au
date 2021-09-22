##############################################################################
# list of varibles needed in gday#############################################
# https://github.com/mdekauwe/GDAY############################################
##############################################################################

# Variable	Description	Units######
# year		
# doy	day of year	[1-365/6]
# hod	hour of day	[0-47]
# rain	rainfall	mm 30 min-1
# par	photosynthetically active radiation	umol m-2 s-1
# tair	air temperature	deg C
# tsoil	soil temperature	deg C
# vpd	vapour pressure deficit	kPa
# co2	CO2 concentration	ppm
# ndep	nitrogen deposition	t ha-1 30 min-1
# nfix	biological nitrogen fixation	t ha-1 30 min-1
# wind	wind speed	m s-1
# press	atmospheric pressure	kPa

# prepare tghe environment$$####
library(ncdf4)
library(lubridate)
mumol_j = 4.56
par_fraction <- 0.368
s2d <- 24*3600
mumol2g <- 1e-6*12
j2g <- 2257 #j/g; energy needed to evaporate 1 g of water
g2mm <- 1e-3
# read files####
fn.vec <- list.files('data/','Yanco',full.names = T)
# 
flux.tmp.ls <- list()

for(fn.i in seq_along(fn.vec)){
  nc.file <- nc_open(fn.vec[fn.i])
  # get the start date of the time var
  start.time <- (nc.file$dim$time$units)
  start.time <- gsub('days since ','',start.time)
  
  # deal with inconsistent varible names
  if(fn.vec[fn.i] == "data/Yanco_2020_L3.nc"){
    co2_flux_nm <- 'Fco2'
    co2_qc_nm <- 'Fco2_QCFlag'
  }else{
    co2_flux_nm <- 'Fc'
    co2_qc_nm <- 'Fc_QCFlag'
  }
  # read all the needed var
  # a list of varible can be found
  # http://data.ozflux.org.au/portal/site/userguide.jspx
  # however, the file contains more than the list
  flux.tmp.ls[[fn.i]] <- data.frame(Site = 'ync',
                            DateTime = as.POSIXlt( ncvar_get(nc.file,'time')*24*3600,
                                                   origin = start.time,tz = 'GMT'),
                            le_w_m2 = ncvar_get(nc.file,'Fe'),
                            GPP_umol_m2_s = ncvar_get(nc.file,co2_flux_nm),
                            
                            GPP_qc= ncvar_get(nc.file,co2_qc_nm),
                            rain_mm_30min = ncvar_get(nc.file,'Precip'),
                            swc = ncvar_get(nc.file,'Sws'),
                            sw_w_m2 = ncvar_get(nc.file,'Fsd'),
                            tair = ncvar_get(nc.file,'Ta'),
                            tsoil = ncvar_get(nc.file,'Ts'),
                            rh = ncvar_get(nc.file,'RH'),
                            vpd = ncvar_get(nc.file,'VPD'),
                            wind = ncvar_get(nc.file,'Ws'),
                            
                            fn = fn.vec[fn.i]
  )
  nc.file$var$Fco2_QCFlag
}
yanco.flux.df <- do.call(rbind,flux.tmp.ls)
yanco.flux.df$Date <- as.Date(yanco.flux.df$DateTime)
# make time of day
yanco.flux.df$hour <- hour(yanco.flux.df$DateTime)
yanco.flux.df$minite <- format(yanco.flux.df$DateTime,'%M')
yanco.flux.df$hour.day<- NA
yanco.flux.df$hour.day[yanco.flux.df$minite == '00'] <- 2*yanco.flux.df$hour[yanco.flux.df$minite == '00'] 
yanco.flux.df$hour.day[yanco.flux.df$minite == '30'] <- 2*yanco.flux.df$hour[yanco.flux.df$minite == '30']+1
# 
yanco.flux.df$am.pm <- NA
yanco.flux.df$am.pm[yanco.flux.df$hour %in% 6:11] <- 'am'
yanco.flux.df$am.pm[yanco.flux.df$hour %in% 12:17] <- 'pm'

# make daily met####
# separate am and pm data
library(doBy)
am.pm.df <- summaryBy(tair + vpd + sw_w_m2 + wind~Date + am.pm,data = yanco.flux.df,
                      FUN = mean,na.rm=T,keep.names=T)
# convert sw to par
j_s2mj_day <- 1e-6 * 3600 * 6
ppfd2sw <- 2.3
am.pm.df$par <- am.pm.df$sw_w_m2 * ppfd2sw / mumol_j *j_s2mj_day

# get am
am.df <- am.pm.df[am.pm.df$am.pm == 'am',]
am.df <- am.df[!is.na(am.df$Date),]
am.df <- am.df[,c('Date','tair','vpd','par','wind')]
names(am.df) <- c('Date','tam','vpd_am','par_am','wind_am')
# get pm
pm.df <- am.pm.df[am.pm.df$am.pm == 'pm',]
pm.df <- pm.df[!is.na(pm.df$Date),]
pm.df <- pm.df[,c('Date','tair','vpd','par','wind')]
names(pm.df) <- c('Date','tpm','vpd_pm','par_pm','wind_pm')
# merge am and pm
am.pm.format.df <- merge(am.df,pm.df)

# get daily mean/sum
daily.df <- summaryBy(rain_mm_30min + tair + wind~Date ,data = yanco.flux.df,
                      FUN = c(mean,max,min),na.rm=T)
daily.df$tair <- daily.df$tair.mean 
daily.df$rain <- daily.df$rain_mm_30min.mean * 48 #conver mm/30min to mm/d
daily.df$tmax <- daily.df$tair.max
daily.df$tmin <- daily.df$tair.min

daily.df.format <- daily.df[,c('Date','tair','tmax','tmin','rain','wind.mean')]

names(daily.df.format) <- c('Date','tair','tmax','tmin','rain','wind')

# get daytime mean
daytime.df <- summaryBy(tair~Date ,data = yanco.flux.df[yanco.flux.df$sw_w_m2>0,],
                        FUN = c(mean),na.rm=T)
daytime.df$tday <- daytime.df$tair.mean

daytime.df <- daytime.df[,c('Date','tday')]
# merge all data
tmp.1 <- merge(am.pm.format.df,daily.df.format)
met.gday.df <- merge(tmp.1,daytime.df)
# add missing pars
met.gday.df$tsoil <- met.gday.df$tair
met.gday.df$ndep = 0
met.gday.df$nfix = 0
met.gday.df$pres <- 101
met.gday.df$co2 <- 400

met.gday.df$year <- year(met.gday.df$Date)
met.gday.df$doy <- yday(met.gday.df$Date)
# order the pars so that gday can read correctly
met.gday.df <- met.gday.df[,c('year','doy',
                              'tair','rain','tsoil',
                              'tam','tpm','tmin','tmax','tday',
                              'vpd_am','vpd_pm',
                              'co2','ndep','nfix',
                              'wind','pres','wind_am','wind_pm',
                              'par_am','par_pm')]


# apply filer to avoid gday crash
met.gday.df$vpd_am[met.gday.df$vpd_am<0.05] <- 0.051
met.gday.df$vpd_pm[met.gday.df$vpd_pm<0.05] <- 0.051
met.gday.df$wind[met.gday.df$wind<=0] <- 0.01
met.gday.df$wind_am[met.gday.df$wind_am<=0] <- 0.01
met.gday.df$wind_pm[met.gday.df$wind_pm<=0] <- 0.01
# 
names(met.gday.df) <- c('#year','doy',
                        'tair','rain','tsoil',
                        'tam','tpm','tmin','tmax','tday',
                        'vpd_am','vpd_pm',
                        'co2','ndep','nfix',
                        'wind','pres','wind_am','wind_pm',
                        'par_am','par_pm')

# fill missing data
library(zoo)
met.gday.df$tair <- na.fill(met.gday.df$tair,'extend')
met.gday.df$tam <- na.fill(met.gday.df$tam,'extend')
met.gday.df$tpm <- na.fill(met.gday.df$tpm,'extend')
met.gday.df$tmin <- na.fill(met.gday.df$tmin,'extend')
met.gday.df$tmax <- na.fill(met.gday.df$tmax,'extend')
met.gday.df$tday <- na.fill(met.gday.df$tday,'extend')
met.gday.df$vpd_am <- na.fill(met.gday.df$vpd_am,'extend')
met.gday.df$vpd_pm <- na.fill(met.gday.df$vpd_pm,'extend')
met.gday.df$wind <- na.fill(met.gday.df$wind,'extend')
met.gday.df$wind_am <- na.fill(met.gday.df$wind_am,'extend')
met.gday.df$wind_pm <- na.fill(met.gday.df$wind_pm,'extend')
met.gday.df$par_am <- na.fill(met.gday.df$par_am,'extend')
met.gday.df$par_pm <- na.fill(met.gday.df$par_pm,'extend')
# write to csv
write.csv(met.gday.df,'met.yanco.daily.csv',row.names = F,quote=F)

# get daily flux#####
flux.daily.df <- summaryBy(le_w_m2 + GPP_umol_m2_s + swc~Date ,data = yanco.flux.df,
                      FUN = mean,na.rm=T)
# convert to proper units

flux.daily.df$GPP_g_m2_d <- flux.daily.df$GPP_umol_m2_s *s2d * mumol2g
flux.daily.df$et_mm_d <- flux.daily.df$le_w_m2 * s2d /j2g *g2mm

# merg with met
yanco.flux.met.df <- merge(daily.df,flux.daily.df)
# get lai
lai.df <- read.csv('data/yanco_modis_check.csv')
lai.df$Date <- strptime(lai.df$system.time_start,'%B %d, %Y',tz = 'GMT')
lai.df$Date <- as.Date(lai.df$Date)
lai.df$LAI_modis <- lai.df$Yanco*0.1
lai.df <- lai.df[,c('Date','LAI_modis')]


yanco.complete.df <- merge(yanco.flux.met.df,lai.df,all.x = T)
write.csv(yanco.complete.df,'data/flux.yanco.daily.csv',row.names = F)

