spin.up.func <- function(folder.nm,source.nm){
  # 
  dir.create(folder.nm)
  # from
  met.nm.from <- paste0(source.nm,'met.csv')
  par.nm.from <- paste0(source.nm,'par.cfg')
  exe.nm.from <- 'model/gday_exe/PTP.exe'
  # to
  met.nm.to <- paste0(folder.nm,'met.csv')
  par.nm.to <- paste0(folder.nm,'par.cfg')
  exe.nm.to <- paste0(folder.nm,'PTP.exe')
  
  file.copy(met.nm.from,met.nm.to)
  file.copy(par.nm.from,par.nm.to)
  file.copy(exe.nm.from,exe.nm.to)
  print(par.nm.to)
  met.real.df <- read.csv(met.nm.to)
  met.1st.df <- met.real.df[1:365,]
  
  met.ls <- list()
  year.in <- 2000
  for(i in 1:20){
    met.temp <- met.1st.df
    
    met.temp$year <- year.in + i
    
    met.temp$doy <- 1:365
    
    met.temp.sub <- subset(met.temp, select = -c(X.year) )
    
    met.ls[[i]] <- met.temp.sub
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
  write.csv(met.out.df,met.nm.to,row.names = F,quote=F) 

  # run.gday.site.func('model/spin_up/',alocation.model ='GRASSES',
  #                    q = 0,q_s = 0,af = 0.9999,decay.rate = 0.03*365)
  run.gday.site.func(folder.nm,
                     alocation.model ='HUFKEN',
                     q = 0,q_s = 0.616,
                     af = 1,
                     decay.rate = 0.03*365,
                     cover.impact = 0)
  # 
  output <- read.csv(paste0(folder.nm,"output.csv"))
  plot(output$lai)
  return(output)
}

spin.df <- spin.up.func('model/spin_up/','model/ym_hufken/')


# dir.create('model/spin_up/')
# 
# file.copy('model/ym_hufken/met.csv','model/spin_up/met.csv')
# file.copy('model/ym_hufken/par.cfg','model/spin_up/par.cfg')
# file.copy('model/gday_exe/PTP.exe','model/spin_up/PTP.exe')
# 
# met.real.df <- read.csv('model/spin_up/met.csv',row.names = F)
# met.1st.df <- met.real.df[1:365,]
# 
# met.ls <- list()
# year.in <- 2000
# for(i in 1:20){
#   met.temp <- met.1st.df
#   
#   met.temp$year <- year.in+i
#   met.temp$doy <- 1:365
#   
#   met.temp.sub <- subset(met.temp, select = -c(X.year) )
#   
#   met.ls[[i]] <- met.temp.sub
# }
# met.out.df <- do.call(rbind,met.ls)
# names(met.out.df)[names(met.out.df) == 'year'] <- '#year'
# 
# met.out.df <- met.out.df[,c('#year','doy',
#                             'tair','rain','tsoil',
#                             'tam','tpm','tmin','tmax','tday',
#                             'vpd_am','vpd_pm',
#                             'co2','ndep','nfix',
#                             'wind','pres','wind_am','wind_pm',
#                             'par_am','par_pm')]
# write.csv(met.out.df,'model/spin_up/met.csv',row.names = F,quote=F) 
# 
# 
# # run.gday.site.func('model/spin_up/',alocation.model ='GRASSES',
# #                    q = 0,q_s = 0,af = 0.9999,decay.rate = 0.03*365)
# run.gday.site.func('model/spin_up/',
#                    alocation.model ='HUFKEN',
#                    q = 0,q_s = 0.616,
#                    af = 1,
#                    decay.rate = 0.04*365,cover.impact = 1)
# 
# output <- read.csv("model/spin_up/output.csv")

plot(output$lai)
plot(output$nsc)
plot(output$shoot)
