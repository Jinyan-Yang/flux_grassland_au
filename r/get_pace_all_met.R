# 
getVPD <- function(RH,TAIR){
  
  VPD <- (1-RH)*0.61375*exp(17.502*TAIR/(240.97+TAIR))
  
  return(VPD)
}

pace.df <- readRDS('data/gcc.met.pace.df.rds')
library(doBy)
pace.df <- summaryBy(Tair + rh + PAR.ros + WS_ms_Avg + irrig.tot ~ Date + Species + Precipitation,
                     data = pace.df,FUN=mean,na.rm=T,keep.names =T)
pace.df$vpd <- getVPD(pace.df$rh/100,pace.df$Tair)

library(lubridate)
mumol_j = 4.56
par_fraction <- 0.368
# 

am.pm.format.df <- data.frame(Date = pace.df$Date,
                              Species = pace.df$Species,
                              Precipitation = pace.df$Precipitation,
                              tam = pace.df$Tair,
                              vpd_am = pace.df$vpd,
                              par_am = pace.df$PAR.ros/2,
                              wind_am = pace.df$WS_ms_Avg,
                              tpm = pace.df$Tair,
                              vpd_pm = pace.df$vpd,
                              par_pm = pace.df$PAR.ros/2,
                              wind_pm = pace.df$WS_ms_Avg,
                              rain = pace.df$irrig.tot)

# get daily mean/sum
daily.df <- summaryBy(Tair + WS_ms_Avg~Date ,data = pace.df,
                      FUN = c(mean,max,min),na.rm=T)

daily.df.format <- daily.df[,c('Date','Tair.mean','Tair.max','Tair.min','WS_ms_Avg.mean')]

names(daily.df.format) <- c('Date','tair','tmax','tmin','wind')

# get daytime mean
daytime.df <- summaryBy(Tair~Date ,data = pace.df[pace.df$PAR.ros>0,],
                        FUN = c(mean),na.rm=T)
daytime.df$tday <- daytime.df$Tair.mean

daytime.df <- daytime.df[,c('Date','tday')]
# merge all data
tmp.1 <- merge(am.pm.format.df,daily.df.format)
ros.met.df <- merge(tmp.1,daytime.df)

# add missing pars
ros.met.df$tsoil <- ros.met.df$tair
ros.met.df$ndep = 0
ros.met.df$nfix = 0
ros.met.df$pres <- 101
ros.met.df$co2 <- 400

ros.met.df$year <- year(ros.met.df$Date)
ros.met.df$doy <- yday(ros.met.df$Date)
# order the pars so that gday can read correctly
ros.met.df <- ros.met.df[,c('year','doy','Species','Precipitation',
                            'tair','rain','tsoil',
                            'tam','tpm','tmin','tmax','tday',
                            'vpd_am','vpd_pm',
                            'co2','ndep','nfix',
                            'wind','pres','wind_am','wind_pm',
                            'par_am','par_pm')]


# apply filer to avoid gday crash
ros.met.df$vpd_am[ros.met.df$vpd_am<0.05] <- 0.051
ros.met.df$vpd_pm[ros.met.df$vpd_pm<0.05] <- 0.051
ros.met.df$wind[ros.met.df$wind<=0] <- 0.051
ros.met.df$wind_am[ros.met.df$wind_am<=0] <- 0.051
ros.met.df$wind_pm[ros.met.df$wind_pm<=0] <- 0.051
# # 
# names(ros.met.df) <- c('#year','doy',
#                        'tair','rain','tsoil',
#                        'tam','tpm','tmin','tmax','tday',
#                        'vpd_am','vpd_pm',
#                        'co2','ndep','nfix',
#                        'wind','pres','wind_am','wind_pm',
#                        'par_am','par_pm')

saveRDS(ros.met.df,'cache/pace.met.rds')
