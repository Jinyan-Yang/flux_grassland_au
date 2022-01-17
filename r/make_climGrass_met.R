library(ncdf4)
getVPD <- function(RH,TAIR){
  
  VPD <- (1-RH)*0.61375*exp(17.502*TAIR/(240.97+TAIR))
  
  return(VPD)
}

# nc.file <- nc_open('data/CG_C0T0D0_met.nc')
# print(nc.file)

get.flux.nc.func <- function(flux.fn){
  nc.file <- nc_open(flux.fn)
  
  start.time <- (nc.file$dim$time$units)
  start.time <- gsub('seconds since ','',start.time)
  
  met.df <- data.frame(DateTime = as.POSIXlt(ncvar_get(nc.file,'time'),
                                             origin = start.time,tz = 'GMT'),
                       # LAI_sentinel = ncvar_get(nc.file,'LAI'),
                       # LAI_modis = ncvar_get(nc.file,'LAI_alternative'),
                       windSpeed= ncvar_get(nc.file,'Wind'),
                       # vpd = ncvar_get(nc.file,'VPD'),
                       Tair = ncvar_get(nc.file,'Tair')-272.15,
                       RH = ncvar_get(nc.file,'RH'),
                       rain_kg_m2_s = ncvar_get(nc.file,'Precip'),
                       sw_w_m2 = ncvar_get(nc.file,'SWdown'),
                       lw_w_m2 = ncvar_get(nc.file,'LWdown'),
                       Ndep_nhx = ncvar_get(nc.file,'Ndep_nhx'),
                       Ndep_noy = ncvar_get(nc.file,'Ndep_noy'),
                       co2 = ncvar_get(nc.file,'CO2air'),
                       fn = flux.fn)
  return(met.df)
}

# 
make.met.gday.climGrass.func <- function(fn,out.name){
  # fn='data/climGrass/CG_C0T0D0_met.nc'
  met.df <- get.flux.nc.func(flux.fn = fn)
  
  met.df$vpd <- getVPD((met.df$RH)/100,met.df$Tair)
  
  library(lubridate)
  mumol_j = 4.56
  par_fraction <- 0.368
  
  flux.met.df <- met.df
  # gday need ndep in ton/ha/day
  # data is in mg/m2/day
  mg2ton <-  1e-3 * 1e-6
  m2ha <- 1e4
  flux.met.df$ndep <- (flux.met.df$Ndep_nhx * 14/(14+4) + flux.met.df$Ndep_noy * 14/(14+16*3)) * mg2ton * m2ha
  flux.met.df$Date <- as.Date(flux.met.df$DateTime)
  # plot(ndep~Date,data = flux.met.df)
  # hist(flux.met.df$ndep,xlim=c(0,0.1))
  # range(flux.met.df$ndep)
  # make time of day
  flux.met.df$hour <- hour(flux.met.df$DateTime)
  flux.met.df$minite <- format(flux.met.df$DateTime,'%M')
  flux.met.df$hour.day<- NA
  flux.met.df$hour.day[flux.met.df$minite == '00'] <- 2*flux.met.df$hour[flux.met.df$minite == '00'] 
  flux.met.df$hour.day[flux.met.df$minite == '30'] <- 2*flux.met.df$hour[flux.met.df$minite == '30']+1
  # 
  flux.met.df$am.pm <- NA
  flux.met.df$am.pm[flux.met.df$hour %in% 6:11] <- 'am'
  flux.met.df$am.pm[flux.met.df$hour %in% 12:17] <- 'pm'
  
  # make daily met####
  # separate am and pm data
  library(doBy)
  am.pm.df <- summaryBy(Tair + vpd + sw_w_m2 + windSpeed~Date + am.pm,data = flux.met.df,
                        FUN = mean,na.rm=T,keep.names=T)
  # convert sw to par
  j_s2mj_day <- 1e-6 * 3600 * 6
  ppfd2sw <- 2.3
  am.pm.df$par <- am.pm.df$sw_w_m2 * ppfd2sw / mumol_j *j_s2mj_day
  am.pm.df$tair <- am.pm.df$Tair 
  # get am
  am.df <- am.pm.df[am.pm.df$am.pm == 'am',]
  am.df <- am.df[!is.na(am.df$Date),]
  am.df <- am.df[,c('Date','tair','vpd','par','windSpeed')]
  names(am.df) <- c('Date','tam','vpd_am','par_am','wind_am')
  # get pm
  pm.df <- am.pm.df[am.pm.df$am.pm == 'pm',]
  pm.df <- pm.df[!is.na(pm.df$Date),]
  pm.df <- pm.df[,c('Date','tair','vpd','par','windSpeed')]
  names(pm.df) <- c('Date','tpm','vpd_pm','par_pm','wind_pm')
  # merge am and pm
  am.pm.format.df <- merge(am.df,pm.df)
  
  # get daily mean/sum
  daily.df <- summaryBy(rain_kg_m2_s + Tair + windSpeed + ndep~Date ,data = flux.met.df,
                        FUN = c(mean,max,min),na.rm=T)
  daily.df$tair <- daily.df$Tair.mean 
  daily.df$rain <- daily.df$rain_kg_m2_s.mean * 3600 * 24 #conver mm/s to mm/d
  daily.df$tmax <- daily.df$Tair.max
  daily.df$tmin <- daily.df$Tair.min
  daily.df$ndep <- daily.df$ndep.mean
  
  daily.df.format <- daily.df[,c('Date','tair','tmax','tmin','rain','windSpeed.mean','ndep')]
  
  names(daily.df.format) <- c('Date','tair','tmax','tmin','rain','wind','ndep')
  
  # get daytime mean
  daytime.df <- summaryBy(Tair+co2~Date ,data = flux.met.df[flux.met.df$sw_w_m2>0,],
                          FUN = c(mean),na.rm=T,keep.names = T)
  daytime.df$tday <- daytime.df$Tair
  
  daytime.df <- daytime.df[,c('Date','tday','co2')]
  # merge all data
  tmp.1 <- merge(am.pm.format.df,daily.df.format)
  met.gday.df <- merge(tmp.1,daytime.df)
  # add missing pars
  met.gday.df$tsoil <- met.gday.df$tair
  # met.gday.df$ndep = 0
  met.gday.df$nfix = 0
  met.gday.df$pres <- 101
  # met.gday.df$co2 <- daytime.df$co2.mean
  
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
  
  # write to csv
  dir.create(out.name)
  out.fn <- paste0(out.name,'/met.csv')
  # out.name = 'met.stp.daily.csv'
  write.csv(met.gday.df,out.fn,row.names = F,quote=F)
}

