# prepare functions
source('r/functions.R')
# download met data
download.ros.met.func(startDate = '2015-1-1',
                      endDate = '2018-12-31')

# put met into gday format######
# read ym 5min data
ym.05min.df <- readRDS('data/ros05_spinup.rds')

library(lubridate)
mumol_j = 4.56
par_fraction <- 0.368
# 
flux.met.df <- ym.05min.df
# make time of day
flux.met.df$hour <- hour(flux.met.df$DateTime)

# 
flux.met.df$am.pm <- NA
flux.met.df$am.pm[flux.met.df$hour %in% 6:11] <- 'am'
flux.met.df$am.pm[flux.met.df$hour %in% 12:17] <- 'pm'
flux.met.df$vpd <- getVPD(flux.met.df$RH/100,flux.met.df$AirTC_Avg)
flux.met.df$windSpeed <- flux.met.df$WS_ms_Avg
flux.met.df$Tair <- flux.met.df$AirTC_Avg

# make daily met####
# separate am and pm data
library(doBy)
am.pm.df <- summaryBy(Tair + vpd + par + windSpeed~Date + am.pm,data = flux.met.df,
                      FUN = mean,na.rm=T,keep.names=T)

am.pm.df$par <- am.pm.df$par * 6 * 12
# # # convert sw to par
# j_s2mj_day <- 1e-6 * 3600 * 6
# ppfd2sw <- 2.3
# am.pm.df$par <- am.pm.df$sw_w_m2 * ppfd2sw / mumol_j *j_s2mj_day
# am.pm.df$tair <- am.pm.df$Tair /10

# get am
am.df <- am.pm.df[am.pm.df$am.pm == 'am',]
am.df <- am.df[!is.na(am.df$Date),]
am.df <- am.df[,c('Date','Tair','vpd','par','windSpeed')]
names(am.df) <- c('Date','tam','vpd_am','par_am','wind_am')
# get pm
pm.df <- am.pm.df[am.pm.df$am.pm == 'pm',]
pm.df <- pm.df[!is.na(pm.df$Date),]
pm.df <- pm.df[,c('Date','Tair','vpd','par','windSpeed')]
names(pm.df) <- c('Date','tpm','vpd_pm','par_pm','wind_pm')
# merge am and pm
am.pm.format.df <- merge(am.df,pm.df)

# get daily mean/sum
daily.df <- summaryBy(Tair + windSpeed~Date ,data = flux.met.df,
                      FUN = c(mean,max,min),na.rm=T)

daily.df.format <- daily.df[,c('Date','Tair.mean','Tair.max','Tair.min','windSpeed.mean')]

names(daily.df.format) <- c('Date','tair','tmax','tmin','wind')

# get daytime mean
daytime.df <- summaryBy(Tair~Date ,data = flux.met.df[flux.met.df$par>0,],
                        FUN = c(mean),na.rm=T)
daytime.df$tday <- daytime.df$Tair.mean

daytime.df <- daytime.df[,c('Date','tday')]
# merge all data
tmp.1 <- merge(am.pm.format.df,daily.df.format)
tmp.2 <- merge(tmp.1,daytime.df)

# read rainfall
rain.ym.df <- readRDS('data/ros15_spinup.rds')
ros.rain.day.df <- doBy::summaryBy(Rain_mm_Tot~Date,data = rain.ym.df,
                                   FUN=sum,keep.names = T,na.rm=T)
names(ros.rain.day.df) <- c('Date','rain')
ros.met.df <- merge(tmp.2,ros.rain.day.df,all.x=T,all.y = F)

# add missing pars
ros.met.df$tsoil <- ros.met.df$tair
ros.met.df$ndep = 0
ros.met.df$nfix = 0
ros.met.df$pres <- 101
ros.met.df$co2 <- 400

ros.met.df$year <- year(ros.met.df$Date)
ros.met.df$doy <- yday(ros.met.df$Date)
# order the pars so that gday can read correctly
ros.met.df <- ros.met.df[,c('year','doy',
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
# 

# write to csv
# write.csv(ros.met.df,'model/ym_spinup/met.csv',row.names = F,quote=F)
# write.csv(ros.met.df,'model/ym_sgs/met.csv',row.names = F,quote=F)
# make par file

#
met.real.df <- ros.met.df
# met.1st.df <- met.real.df[1:365,]

met.ls <- list()
# year.in <- 1901
for(i in 1:100){
  met.temp <- met.real.df

  this.yr <-  met.temp$year + (i - 1) * 4

  met.temp$year <- this.yr

  # if(this.yr %% 400 == 0 || (this.yr %% 100 != 0 && this.yr %% 4 == 0)){
  # met.temp$doy <- 1:366
  # }else{
  # met.temp$doy <- 1:365
  # }

  # met.temp.sub <- subset(met.temp, select = -c(year) )

  met.ls[[i]] <- met.temp
}
met.out.df <- do.call(rbind,met.ls)
names(met.out.df)[names(met.out.df) == 'year'] <- '#year'

met.out.df <- met.out.df[,c('#year','doy',
                            'tair','rain','tsoil',
                            'tam','tpm','tmin','tmax','tday',
                            'vpd_am','vpd_pm',
                            'co2','ndep','nfix',
                            'wind','pres','wind_am','wind_pm',
                            'par_am','par_pm')]
# ros.met.df <- read.csv('model/ym_spinup/met.csv')
write.csv(met.out.df,'model/ym_spinup/met.csv',row.names = F,quote=F)
