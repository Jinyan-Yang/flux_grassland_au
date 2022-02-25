# run gday for flux site#####
# spin up
make.gday.cfg.func(file.path('model/stp_spinup','par.cfg'))
# 
change_par_func(file.path('model/stp_spinup','par.cfg'),
                'vcmax','39.0')
change_par_func(file.path('model/stp_spinup','par.cfg'),
                'sla','13.1')
change_par_func(file.path('model/stp_spinup','par.cfg'),
                'g1','1.62')
change_par_func(file.path('model/stp_spinup','par.cfg'),
                'alloc_model','HUFKEN')
# 

run_gday_func('model/stp_spinup/',exe.name = 'PTP.exe',
              gday.exe.path='model/gday_exe/PTP.exe')

# 
spin.df <- read.csv(paste0('model/stp_spinup/',"output.csv"))
years.vec <- unique(spin.df$year)

years.last <- years.vec[(length(years.vec)-21):(length(years.vec)-1)]

spin.last <- spin.df[spin.df$year %in% years.last,]

plot(spin.last$shoot)
plot(spin.last$root)
plot(spin.last$wtfac_root)
plot(spin.last$inorgn)
plot(spin.last$lai)

plot(spin.df$inorgn)
plot(spin.df$shoot)
plot(spin.df$root[1:(365*4)])
plot(spin.df$npp[1:(365*4)])
plot(spin.df$lai[1:(365*4)])
plot(spin.df$wtfac_top[1:(365*4)])
abline(h=0.5)
plot(spin.df$wtfac_root[1:(365*4)])

write.csv(spin.last,'model/stp_spinup/spin_up_stp.csv')


# run sim#######
# read spin up 
spin.last <- read.csv('model/stp_spinup/spin_up_stp.csv')

#update pools
make.gday.cfg.func(file.path('model/stp_grass','par.cfg'))
make.gday.cfg.func(file.path('model/stp_hufken','par.cfg'))

change_par_func(paste0('model/stp_grass/','par.cfg'),
                'shoot',mean(spin.last$shoot))
change_par_func(paste0('model/stp_grass/','par.cfg'),
                'root',mean(spin.last$root))

change_par_func(paste0('model/stp_hufken/','par.cfg'),
                'shoot',mean(spin.last$shoot))
change_par_func(paste0('model/stp_hufken/','par.cfg'),
                'root',mean(spin.last$root))

# change fitted q and senescen rates to fitted values
# 
change_par_func(file.path('model/stp_hufken','par.cfg'),
                'vcmax','39.0')

change_par_func(file.path('model/stp_hufken','par.cfg'),
                'jmax','176.0')
change_par_func(file.path('model/stp_hufken','par.cfg'),
                'sla','13.1')
change_par_func(file.path('model/stp_hufken','par.cfg'),
                'g1','1.62')
# 
change_par_func(file.path('model/stp_grass','par.cfg'),
                'vcmax','39.0')

change_par_func(file.path('model/stp_grass','par.cfg'),
                'jmax','176.0')
change_par_func(file.path('model/stp_grass','par.cfg'),
                'sla','13.1')
change_par_func(file.path('model/stp_grass','par.cfg'),
                'g1','1.62')
change_par_func(file.path('model/stp_grass','par.cfg'),
                'q_s',0)



# 
run.gday.site.func('model/stp_grass/',alocation.model ='GRASSES')

run.gday.site.func('model/stp_hufken/',alocation.model ='GRASSES')

