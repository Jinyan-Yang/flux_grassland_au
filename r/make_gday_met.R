##############################################################################
# list of varibles needed in gday#############################################
# https://github.com/mdekauwe/GDAY############################################
##############################################################################

# Variable	Description	Units
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

library(lubridate)
mumol_j = 4.56
par_fraction <- 0.368
# 
flux.met.df <- readRDS('cache/flux_stp_processed.rds')
flux.met.df <- flux.met.df[flux.met.df$Site == 'AU-Stp',]
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

# # make 30min data #####
# # but gday does not have a 30min photo model
# met.fake.df <- data.frame(year = year(flux.met.df$Date),
#                           doy = yday(flux.met.df$Date),
#                           hod = flux.met.df$hour.day,
#                           
#                           rain = flux.met.df$rain_kg_m2_s,
#                           par = (flux.met.df$sw_w_m2) * mumol_j * par_fraction,
#                           tair = flux.met.df$Tair/10,
#                           tsoil = 20,
#                           vpd = flux.met.df$vpd,
#                           
#                           co2 = 400,
#                           ndep = 0,
#                           nfix = 0,
#                           wind = flux.met.df$windSpeed,
#                           press = 101)
# # apply filer to avoid gday crash
# met.fake.df$vpd[met.fake.df$vpd<0.05] <- 0.051
# met.fake.df$wind[met.fake.df$wind<=0] <- 0.01
# 
# # write.csv(met.fake.df,'met.stp.csv',col.names = NA,row.names = F)


# make daily met####
# separate am and pm data
library(doBy)
am.pm.df <- summaryBy(Tair + vpd + sw_w_m2 + windSpeed~Date + am.pm,data = flux.met.df,
                      FUN = mean,na.rm=T,keep.names=T)
# convert sw to par
j_s2mj_day <- 1e-6 * 3600 * 6
ppfd2sw <- 2.3
am.pm.df$par <- am.pm.df$sw_w_m2 * ppfd2sw / mumol_j *j_s2mj_day
am.pm.df$tair <- am.pm.df$Tair /10
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
daily.df <- summaryBy(rain_kg_m2_s + Tair + windSpeed~Date ,data = flux.met.df,
                      FUN = c(mean,max,min),na.rm=T)
daily.df$tair <- daily.df$Tair.mean /10
daily.df$rain <- daily.df$rain_kg_m2_s.mean *3600*24 #conver mm/s to mm/d
daily.df$tmax <- daily.df$Tair.max/10
daily.df$tmin <- daily.df$Tair.min/10

daily.df.format <- daily.df[,c('Date','tair','tmax','tmin','rain','windSpeed.mean')]

names(daily.df.format) <- c('Date','tair','tmax','tmin','rain','wind')

# get daytime mean
daytime.df <- summaryBy(Tair~Date ,data = flux.met.df[flux.met.df$sw_w_m2>0,],
                      FUN = c(mean),na.rm=T)
daytime.df$tday <- daytime.df$Tair.mean /10

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

# write to csv
write.csv(met.gday.df,'model/stp_grass/met.csv',row.names = F,quote=F)
write.csv(met.gday.df,'model/stp_hufken/met.csv',row.names = F,quote=F)
