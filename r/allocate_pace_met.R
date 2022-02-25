library(zoo)
# read spc names####
species.vec <- c('Bis','Dig','Luc','Fes','Rye','Kan','Rho','Pha')
# create folders#########
folder.nm.vec.a <- paste0('model/',species.vec)
folder.nm.vec <- paste0((folder.nm.vec.a),rep(c('_hufken','_grass'),each=8))

for (i in seq_along(folder.nm.vec)) {
  
  if(!dir.exists(folder.nm.vec[i])){
    dir.create(folder.nm.vec[i])
  }
  
}

# make met for each species####
pace.met.df <- readRDS('cache/pace.met.rds')

pace.met.df <- pace.met.df[pace.met.df$Precipitation == 'Control',]


for (spc.i in seq_along(species.vec)) {
  
    tmp.df <- pace.met.df[pace.met.df$Species == species.vec[spc.i],]

    
    tmp.df <- tmp.df[,c('year','doy',
                                'tair','rain','tsoil',
                                'tam','tpm','tmin','tmax','tday',
                                'vpd_am','vpd_pm',
                                'co2','ndep','nfix',
                                'wind','pres','wind_am','wind_pm',
                                'par_am','par_pm')]
    tmp.df <- tmp.df[!is.na(tmp.df$doy),]
    # fill na
    tmp.df$tair <- na.fill(tmp.df$tair,"extend")
    tmp.df$tsoil <- na.fill(tmp.df$tsoil,"extend")
    tmp.df$tam <- na.fill(tmp.df$tam,"extend")
    tmp.df$tpm <- na.fill(tmp.df$tpm,"extend")
    tmp.df$tmin <- na.fill(tmp.df$tmin,"extend")
    tmp.df$tmax <- na.fill(tmp.df$tmax,"extend")
    tmp.df$tday <- na.fill(tmp.df$tday,"extend")
    tmp.df$vpd_am <- na.fill(tmp.df$vpd_am,"extend")
    tmp.df$vpd_pm <- na.fill(tmp.df$vpd_pm,"extend")
    tmp.df$wind <- na.fill(tmp.df$wind,"extend")
    tmp.df$pres <- na.fill(tmp.df$pres,"extend")
    tmp.df$wind_am <- na.fill(tmp.df$wind_am,"extend")
    tmp.df$wind_pm <- na.fill(tmp.df$wind_pm,"extend")
    tmp.df$par_am <- na.fill(tmp.df$par_am,"extend")
    tmp.df$par_pm <- na.fill(tmp.df$par_pm,"extend")
    tmp.df$rain[is.na(tmp.df$rain)] <- 0
    
    # 
    names(tmp.df) <- c('#year','doy',
                       'tair','rain','tsoil',
                       'tam','tpm','tmin','tmax','tday',
                       'vpd_am','vpd_pm',
                       'co2','ndep','nfix',
                       'wind','pres','wind_am','wind_pm',
                       'par_am','par_pm')
    
    # 
    
    met.name.a <- paste0('model/',species.vec[spc.i],'_grass/met.csv')
    met.name.b <- paste0('model/',species.vec[spc.i],'_hufken/met.csv')
    # 
    write.csv(tmp.df,met.name.a,row.names = F,quote=F)
    write.csv(tmp.df,met.name.b,row.names = F,quote=F)
}


