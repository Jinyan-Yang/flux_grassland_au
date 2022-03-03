library(lubridate)

date.vec <- seq(as.Date('2001-1-1'),as.Date('2006-12-31'),by='day')
# make 30min data #####
# but gday does not have a 30min photo model
met.fake.df <- data.frame(year = year(date.vec),
                          doy = yday(date.vec),
                      
                          tair = 20,
                          
                          rain = 0,
                          tsoil = 20,
                          tam = 19,
                          tpm = 21,
                          tmax = 23,
                          tmin = 18,
                          tday = 22,
                          
                          vpd_am = 1,
                          vpd_pm = 2,
                          
                          co2 = 400,
                          ndep = 0,
                          nfix = 0,
                          wind = 0.5,
                          pres = 101,
                          wind_am = 0.5,
                          wind_pm = 0.5,
                          
                          par_am = 2,
                          par_pm=2)

met.fake.df$rain[1:365] <- 3

met.fake.df$rain[(365*2+10):(365*2+15)] <- 150.

met.fake.df$rain[(365*3+10):(365*3+15)] <- 150.

met.fake.df$rain[(365*4+10):(365*4+15)] <- 150.

names(met.fake.df) <- c('#year','doy',
                        'tair','rain','tsoil',
                        'tam','tpm','tmin','tmax','tday',
                        'vpd_am','vpd_pm',
                        'co2','ndep','nfix',
                        'wind','pres','wind_am','wind_pm',
                        'par_am','par_pm')

write.csv(met.fake.df,'test/hufken/met.csv',row.names = F,quote=F)
# write.csv(met.fake.df,'test/test_sgs/met.csv',row.names = F,quote=F)
write.csv(met.fake.df,'test/grass/met.csv',row.names = F,quote=F)
