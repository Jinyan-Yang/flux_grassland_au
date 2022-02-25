#
met.real.df <- read.csv('model/stp_grass/met.csv')
met.real.df <- met.real.df[met.real.df$X.year < 2014,]
met.real.df$year <- met.real.df$X.year

met.ls <- list()

for(i in 1:100){
  met.temp <- met.real.df
  
  this.yr <-  met.temp$year + (i - 1) * 4
  
  met.temp$year <- this.yr
  
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
write.csv(met.out.df,'model/stp_spinup/met.csv',row.names = F,quote=F)

