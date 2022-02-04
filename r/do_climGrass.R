####################run Gday for climGrass experiemnt####################

# prepare enviroement####
source('r/make_climGrass_met.R')
source('r/function_update_par.R')
source('r/functions_gday.R')

# get the met for eahc treatment####
treat.vec <- list.files(path = 'data/climGrass/',full.names = T)
treat.nm <- gsub(pattern = 'data/climGrass/CG_',
                 replacement = '',
                 x = treat.vec )
treat.nm <- gsub(pattern = '_met.nc',
                 replacement = '',
                 x = treat.nm )

# loop through all treat to make met for gday
for(i in seq_along(treat.vec)){
  make.met.gday.climGrass.func(fn = treat.vec[i],
                               out.name = file.path('model',treat.nm[i]))
}
# read spin up result to update model pools with stable values####
spin.df <- read.csv('model/spin_up/spin_up_climGrass.csv')

# run gday through all treat ####
for(i in seq_along(treat.vec)){
  # define path of data
  model.path <- file.path('model',treat.nm[i])
  # make fresh par file
  make.par.cfg.func(file.path(model.path,'par.cfg'))
  # update par 
  update.par.func()
  # run gday in the folder of each treamt
  run_gday_func(model.path,
                exe.name = 'ClimGrass_gday.exe',
                gday.exe.path='model/gday_exe/ClimGrass_gday.exe')
  
}

# read out put and move data into output folder####
for(i in seq_along(treat.vec)){
  # define path of data
  model.path <- file.path('model',treat.nm[i])
  # read output
  CG_C0T0D0.df <- read.csv(file.path(model.path,'output.csv'),skip=0,header = T)
  CG_C0T0D0.df$Date <- as.Date(CG_C0T0D0.df$doy, origin = paste0(CG_C0T0D0.df$year,'-1-1'))
  
  # write only the needed bits
  write.csv(CG_C0T0D0.df[CG_C0T0D0.df$year>2013,],
            paste0('outputs/climGrass/',treat.nm[i],'_output.csv'),row.names = F)
  
}
















# #####not useful.....#####
# 
source('r/make_climGrass_met.R')

make.met.gday.climGrass.func(fn='data/climGrass/CG_C0T0D0_met.nc',
                             out.name = 'model/CG_C0T0D0/')

# update pool with spin output
spin.df <- read.csv('model/spin_up/spin_up_climGrass.csv')
# plot(spin.df$shoot)
# plot(spin.df$root)
model.path = 'model/CG_C0T0D0/'
# 
make.par.cfg.func(paste0(model.path,'par.cfg'))

change_par_func(paste0(model.path,'par.cfg'),
                'shoot',mean(spin.df$shoot,na.rm = T))
change_par_func(paste0(model.path,'par.cfg'),
                'shootn',mean(spin.df$shootn,na.rm = T))
change_par_func(paste0(model.path,'par.cfg'),
                'nsc',0.0)
change_par_func(paste0(model.path,'par.cfg'),
                'stem',0.0)
change_par_func(paste0(model.path,'par.cfg'),
                'branch',0.0)
change_par_func(paste0(model.path,'par.cfg'),
                'croot',0.0)
change_par_func(paste0(model.path,'par.cfg'),
                'cstore',mean(spin.df$cstore,na.rm = T))
change_par_func(paste0(model.path,'par.cfg'),
                'nstore',mean(spin.df$nstore,na.rm = T))
change_par_func(paste0(model.path,'par.cfg'),
                'crootn',0.0)
change_par_func(paste0(model.path,'par.cfg'),
                'root',mean(spin.df$root,na.rm = T))
change_par_func(paste0(model.path,'par.cfg'),
                'rootn',mean(spin.df$rootn,na.rm = T))
change_par_func(paste0(model.path,'par.cfg'),
                'inorgn',mean(spin.df$inorgn,na.rm = T))
# 
# change_par_func(paste0(model.path,'par.cfg'),
#                 'inorgn',mean(spin.df$inorgn,na.rm = T))
# change_par_func(paste0(model.path,'par.cfg'),
#                 'inorgn',mean(spin.df$inorgn,na.rm = T))
# change_par_func(paste0(model.path,'par.cfg'),
#                 'inorgn',mean(spin.df$inorgn,na.rm = T))
# change_par_func(paste0(model.path,'par.cfg'),
#                 'inorgn',mean(spin.df$inorgn,na.rm = T))
# change_par_func(paste0(model.path,'par.cfg'),
#                 'soiln',mean(spin.df$soiln,na.rm = T))
change_par_func(paste0(model.path,'par.cfg'),
                'deciduous_model','true')
change_par_func(paste0(model.path,'par.cfg'),
                'nuptake_model',1)
change_par_func(paste0(model.path,'par.cfg'),
                'grazing',1)

change_par_func(paste0(model.path,'par.cfg'),
                'rateuptake',0.4)
change_par_func(paste0(model.path,'par.cfg'),
                'rateloss',0.6)
# change_par_func(paste0(model.path,'par.cfg'),
#                 'avg_alleaf','0.2')
# change_par_func(paste0(model.path,'par.cfg'),
#                 'avg_alroot','0.1')
# run.gday.climGrass.func(model.path = model.path,do.graze = 1)
run_gday_func(model.path,
              exe.name = 'ClimGrass_gday.exe',
              gday.exe.path='model/gday_exe/ClimGrass_gday.exe')
# avg_alleaf = 0.0000000000
# avg_alroot = 0.0000000000


# 
# change_par_func(paste0(model.path,'par.cfg'),
#                 'ncycle',
#                 'true')
# change_par_func(paste0(model.path,'par.cfg'),
#                 'deciduous_model','true')
# 
# run_gday_func(model.path,
#               exe.name = 'ClimGrass_gday.exe',
#               gday.exe.path='model/gday_exe/ClimGrass_gday.exe')

# 

CG_C0T0D0.df <- read.csv('model/CG_C0T0D0/output.csv',skip=0,header = T)
CG_C0T0D0.df$Date <- as.Date(CG_C0T0D0.df$doy, origin = paste0(CG_C0T0D0.df$year,'-1-1'))


write.csv(CG_C0T0D0.df[CG_C0T0D0.df$year>2013,],
          'outputs/climGrass/CG_C0T0D0.csv',row.names = F)

# met.df <- read.csv('model/CG_C0T0D0/met.csv')
# met.df$Date <- as.Date(met.df$doy, origin = paste0(met.df$X.year,'-1-1'))
# # check.net.df <- read.csv('model/CG_C0T0D0/met.csv')
# 
# library(doBy)
# rain.yr.df <- summaryBy(rain~X.year,data = check.net.df,FUN=sum,keep.names = T)

# CG_C0T0D0.df <- read.csv('outputs/climGrass/CG_C0T0D0.csv')

# range(CG_C0T0D0.df$cstore)
# # plot(growing_days~Date,data = CG_C0T0D0.df)
# # plot(lai~Date,data = CG_C0T0D0.df)
# # plot(lai~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year==1902,])
# plot(lai~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year>2006,])
# plot(root~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year>2006,])
# plot(rootn~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year>2006,])
# plot(cstore~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year>2006,])
# plot(inorgn~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year>2006,])
# plot(nstore~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year>2006,])
# plot(nmineralisation~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year>2006,])
# plot(ngross~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year>1990,])
# plot(soiln~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year>1990,])
# 
# plot(shootn~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year>2006,])
# plot(deadleafn~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year>2006,])
# plot(shoot~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year>2006,])
# 
# CG_C0T0D0.df$deadleafn
# 
# 
# plot(ndep~Date,data = met.df[met.df$X.year>2006,])
# plot(par_am~Date,data = met.df[met.df$X.year>2006,])
# met.df$par_am



plot(nuptake~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year>2005&CG_C0T0D0.df$year<2008,],
     ylim=c(0,1e50))

plot(inorgn~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year>2005&CG_C0T0D0.df$year<2007,])
plot(lai~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year>2005&CG_C0T0D0.df$year<2008,])

plot(inorgn~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year>1902&CG_C0T0D0.df$year<1904,])

unique(CG_C0T0D0.df$year)

plot(inorgn~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year>2000,])
plot(inorgn~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year>2013,])
plot(root~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year>2013,])
plot(gpp~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year>2013,])
plot(shootn~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year>2013,])
plot(root~Date,data = CG_C0T0D0.df)
# plot(croot~Date,data = CG_C0T0D0.df[CG_C0T0D0.df$year>1910,])

x.df <- CG_C0T0D0.df[CG_C0T0D0.df$year <= 1905,]
plot(lai~Date,data = x.df)
plot(inorgn~Date,data = x.df)
plot(nuptake~Date,data = x.df)

plot(nproot~Date,data = x.df)

x.df$nproot



