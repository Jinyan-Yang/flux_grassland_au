# run gday for flux site
# read spin up 
spin.last <- read.csv('model/ym_spinup/spin_up_ym.csv')

#update pools
make.gday.cfg.func(file.path('model/flux_grass','par.cfg'))
make.gday.cfg.func(file.path('model/flux_hufken','par.cfg'))

change_par_func(paste0('model/flux_grass/','par.cfg'),
                'shoot',mean(spin.last$shoot))
change_par_func(paste0('model/flux_grass/','par.cfg'),
                'root',mean(spin.last$root))

change_par_func(paste0('model/flux_hufken/','par.cfg'),
                'shoot',mean(spin.last$shoot))
change_par_func(paste0('model/flux_hufken/','par.cfg'),
                'root',mean(spin.last$root))

# change fitted q and senescen rates to fitted values
change_par_func(paste0('model/flux_hufken/','par.cfg'),
                'fdecay',0.05515898*365.25)
change_par_func(paste0('model/flux_grass/','par.cfg'),
                'fdecay',0.05515898*365.25)
change_par_func(paste0('model/flux_hufken/','par.cfg'),
                'q_s',0.6830652)
# 
change_par_func(file.path('model/flux_hufken','par.cfg'),
                'vcmax','39.0')
change_par_func(file.path('model/flux_hufken','par.cfg'),
                'jmax','176.0')
change_par_func(file.path('model/flux_hufken','par.cfg'),
                'sla','13.1')
change_par_func(file.path('model/flux_hufken','par.cfg'),
                'g1','1.62')
# 
change_par_func(file.path('model/flux_grass','par.cfg'),
                'vcmax','39.0')
change_par_func(file.path('model/flux_grass','par.cfg'),
                'jmax','176.0')
change_par_func(file.path('model/flux_grass','par.cfg'),
                'sla','13.1')
change_par_func(file.path('model/flux_grass','par.cfg'),
                'g1','1.62')
change_par_func(paste0('model/flux_grass/','par.cfg'),
                'q_s',0)
# 
run.gday.site.func('model/flux_grass/',alocation.model ='GRASSES')

run.gday.site.func('model/flux_hufken/',alocation.model ='GRASSES')
