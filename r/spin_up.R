source('r/creat_cfg_climGrassRun.R')
source('r/run_gday_climGrass.R')
spin.up.func <- function(folder.nm,source.nm,sin.yr = 100){
  # 
  dir.create(folder.nm)
  # from
  met.nm.from <- paste0(source.nm,'met.csv')
  par.nm.from <- paste0(source.nm,'par.cfg')
  exe.nm.from <- 'model/gday_exe/ClimGrass_gday.exe'
  # to
  met.nm.to <- paste0(folder.nm,'met.csv')
  par.nm.to <- paste0(folder.nm,'par.cfg')
  exe.nm.to <- paste0(folder.nm,'ClimGrass_gday.exe')
  
  file.copy(met.nm.from,met.nm.to)
  # file.copy(par.nm.from,par.nm.to)
  # make par file
  make.par.cfg.func(paste0(folder.nm,'par.cfg'))
  file.copy(exe.nm.from,exe.nm.to)
  print(par.nm.to)
  met.real.df <- read.csv(met.nm.to)
  met.1st.df <- met.real.df[1:365,]
  
  met.ls <- list()
  year.in <- 1901
  for(i in 1:sin.yr){
    met.temp <- met.1st.df
    
    # this.yr <- year.in + i
    
    met.temp$year <- year.in + i
    
    # if(this.yr %% 400 == 0 || (this.yr %% 100 != 0 && this.yr %% 4 == 0)){
      # met.temp$doy <- 1:366
    # }else{
      met.temp$doy <- 1:365
    # }

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
  # run.gday.site.func(folder.nm,
  #                    alocation.model ='HUFKEN',
  #                    q = 0,q_s = 0.616,
  #                    af = 1,
  #                    decay.rate = 0.03*365,
  #                    cover.impact = 0)
 
  # # # # # set initial pool size#################################
  # # # # # shoot (c ton/ha) can be converted to LAI via sla (g/m2)
  # # # # #lai shoot *sla /10 *biomass.c.fraction
  # change_par_func(paste0(folder.nm,'par.cfg'),
  #                 'shoot','0.001')
  # change_par_func(paste0(folder.nm,'par.cfg'),
  #                 'shootn','0.00004')
  # 
  # change_par_func(paste0(folder.nm,'par.cfg'),
  #                 'nsc',0.0)
  # change_par_func(paste0(folder.nm,'par.cfg'),
  #                 'stem',0.0)
  # change_par_func(paste0(folder.nm,'par.cfg'),
  #                 'branch',0.0)
  # change_par_func(paste0(folder.nm,'par.cfg'),
  #                 'croot',0.0)
  # change_par_func(paste0(folder.nm,'par.cfg'),
  #                 'crootn',0.0)
  # change_par_func(paste0(folder.nm,'par.cfg'),
  #                 'root','1.0')
  # change_par_func(paste0(folder.nm,'par.cfg'),
  #                 'rootn','0.00004')
  # change_par_func(paste0(folder.nm,'par.cfg'),
  #                 'inorgn','0.00004')
  # change_par_func(paste0(folder.nm,'par.cfg'),
  #                 'prev_sma','1.0')
  # 
  # change_par_func(paste0(folder.nm,'par.cfg'),
  #                 'deciduous_model','true')
  # 
  # change_par_func(paste0(folder.nm,'par.cfg'),
  #                 'grazing',0)

  # ######
  # run.gday.climGrass.func(model.path = folder.nm,do.graze = 0)
  run_gday_func('model/spin_up/',exe.name = 'ClimGrass_gday.exe',
                gday.exe.path='model/gday_exe/ClimGrass_gday.exe')

  output <- read.csv(paste0(folder.nm,"output.csv"))
  # plot(output$lai)
  return(output)
}

spin.df <- spin.up.func('model/spin_up/','model/CG_C0T0D0/',sin.yr = 400)
# # make.par.cfg.func('model/spin_up/par.cfg')
# 
# run_gday_func('model/spin_up/',exe.name = 'ClimGrass_gday.exe',
#               gday.exe.path='model/gday_exe/ClimGrass_gday.exe')
# run.gday.climGrass.func(model.path = 'model/spin_up/',do.graze = 0,root.decay.dry = 1.3)


# met.df <-  read.csv(paste0('model/spin_up/',"met.csv"))
spin.df <- read.csv(paste0('model/spin_up/',"output.csv"))
years.vec <- unique(spin.df$year)
# plot(spin.df$inorgn[100000:120000])
# plot(spin.df$shoot[1:(365*100)])
years.last <- years.vec[(length(years.vec)-21):(length(years.vec)-1)]

spin.last <- spin.df[spin.df$year %in% years.last,]

# years.sub <- years.vec[(length(years.vec)-100):(length(years.vec))]
# spin.df.sub <- spin.df[spin.df$year %in% years.sub,]
# plot(spin.df.sub$shoot)
# plot(spin.df.sub$root)

plot(spin.last$shoot)
plot(spin.last$root)
plot(spin.last$inorgn)
plot(spin.last$lai)

plot(spin.df$inorgn)
plot(spin.df$shoot)
plot(spin.df$root)
# plot(spin.df$rootn[(1*365):(19*365)])
# plot(spin.df$root[(1*365):(19*365)]/spin.df$rootn[(1*365):(19*365)])
# plot(spin.df$root[(400*365):(600*365)])
# plot(spin.df$shoot[(190*365):(200*365)])
# 
# plot(spin.df$inorgn)
# # 
# plot(spin.df$rootn[(1*365):(20*365)])
# plot(spin.df$nuptake[(190*365):(200*365)])
# plot(met.df$ndep[(1*365):(200*365)])
# plot(spin.df$nuptake[(1*365):(20*365)])
# plot(spin.df$inorgn[(1*365):(20*365)])
# plot(spin.df$nstore[(50*365):(91*365)])
# plot(spin.df$cstore[(50*365):(51*365)])
# plot(spin.df$npp[(50*365):(51*365)])
# plot(spin.df$branch[(50*365):(51*365)])
# plot(spin.df$nmineralisation[(190*365):(200*365)])
# # plot(spin.df$root[spin.df$year=='2010'])

write.csv(spin.last,'model/spin_up/spin_up_climGrass.csv')

# plot(spin.df$root[spin.df$year>2709])
# range(spin.df$root,na.rm=T)
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

# plot(output$lai)
# plot(output$nsc)
# plot(output$shoot)
