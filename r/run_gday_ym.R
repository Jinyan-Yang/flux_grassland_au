# run gday for ym
# read spin up 
spin.last <- read.csv('model/ym_spinup/spin_up_ym.csv')

#update pools
make.gday.cfg.func(file.path('model/ym_grass','par.cfg'))
make.gday.cfg.func(file.path('model/ym_hufken','par.cfg'))

change_par_func(paste0('model/ym_grass/','par.cfg'),
                'shoot',mean(spin.last$shoot))
change_par_func(paste0('model/ym_grass/','par.cfg'),
                'root',mean(spin.last$root))

change_par_func(paste0('model/ym_hufken/','par.cfg'),
                'shoot',mean(spin.last$shoot))
change_par_func(paste0('model/ym_hufken/','par.cfg'),
                'root',mean(spin.last$root))

change_par_func(paste0('model/ym_hufken/','par.cfg'),
                'fdecay',0.24084294 *365.25)
change_par_func(paste0('model/ym_grass/','par.cfg'),
                'fdecay',0.24084294 *365.25)
change_par_func(paste0('model/ym_grass/','par.cfg'),
                'c_alloc_rmax','1.0')
change_par_func(paste0('model/ym_hufken/','par.cfg'),
                'c_alloc_rmax','1.0')
change_par_func(paste0('model/ym_hufken/','par.cfg'),
                'c_alloc_rmin','0.3')
change_par_func(paste0('model/ym_grass/','par.cfg'),
                'c_alloc_rmin','0.0')
change_par_func(paste0('model/ym_hufken/','par.cfg'),
                'q_s',3.1568422)
# 
# 
change_par_func(file.path('model/ym_hufken','par.cfg'),
                'vcmax','39.0')
change_par_func(file.path('model/ym_hufken','par.cfg'),
                'jmax','176.0')
change_par_func(file.path('model/ym_hufken','par.cfg'),
                'sla','13.1')
change_par_func(file.path('model/ym_hufken','par.cfg'),
                'g1','1.62')
# 
change_par_func(file.path('model/ym_grass','par.cfg'),
                'vcmax','39.0')
change_par_func(file.path('model/ym_grass','par.cfg'),
                'jmax','176.0')
change_par_func(file.path('model/ym_grass','par.cfg'),
                'sla','13.1')
change_par_func(file.path('model/ym_grass','par.cfg'),
                'g1','1.62')
change_par_func(file.path('model/ym_grass','par.cfg'),
                'q_s','0.0')

# 
change_par_func(file.path('model/ym_grass','par.cfg'),
                'fractup_soil','1.0')
change_par_func(file.path('model/ym_hufken','par.cfg'),
                'fractup_soil','1.0')
# 
r.depth = 10
top.depth = 1000
change_par_func(file.path('model/ym_grass','par.cfg'),
                'rooting_depth',r.depth)
change_par_func(file.path('model/ym_hufken','par.cfg'),
                'rooting_depth',r.depth)
change_par_func(file.path('model/ym_grass','par.cfg'),
                'topsoil_depth',top.depth)
change_par_func(file.path('model/ym_hufken','par.cfg'),
                'topsoil_depth',top.depth)

# 
change_par_func(file.path('model/ym_grass','par.cfg'),
                'theta_wp_topsoil',0.02)
change_par_func(file.path('model/ym_grass','par.cfg'),
                'theta_fc_topsoil',0.3)
change_par_func(file.path('model/ym_grass','par.cfg'),
                'theta_wp_root',0.02)
change_par_func(file.path('model/ym_grass','par.cfg'),
                'theta_fc_root',0.3)
change_par_func(file.path('model/ym_grass','par.cfg'),
                'wcapac_root',r.depth*(.3-0.02))
change_par_func(file.path('model/ym_grass','par.cfg'),
                'wcapac_topsoil',top.depth*(.3-0.02))
# 
change_par_func(file.path('model/ym_hufken','par.cfg'),
                'theta_wp_topsoil',0.02)
change_par_func(file.path('model/ym_hufken','par.cfg'),
                'theta_fc_topsoil',0.3)
change_par_func(file.path('model/ym_hufken','par.cfg'),
                'theta_wp_root',0.02)
change_par_func(file.path('model/ym_hufken','par.cfg'),
                'theta_fc_root',0.3)
change_par_func(file.path('model/ym_hufken','par.cfg'),
                'wcapac_root',r.depth*(.3-0.02))
change_par_func(file.path('model/ym_hufken','par.cfg'),
                'wcapac_topsoil',top.depth*(.3-0.02))
# 
run.gday.site.func('model/ym_grass/',alocation.model ='GRASSES')

run.gday.site.func('model/ym_hufken/',alocation.model ='GRASSES')


out.ym.grass.df <- read.csv('model/ym_grass/output.csv')

plot(out.ym.grass.df$wtfac_root)
plot(out.ym.grass.df$wtfac_topsoil)
plot(out.ym.grass.df$lai)

out.ym.hufken.df <- read.csv('model/ym_hufken/output.csv')
out.ym.hufken.df$Date <- as.Date(out.ym.hufken.df$doy, origin = paste0(out.ym.hufken.df$year,'-1-1'))
max(diff(out.Kan.hufken.df$lai),na.rm=T)

# 
ym.modis.lai.df <- read.csv('download/lai_ym.csv')
ym.modis.lai.df$lai <- ym.modis.lai.df$YM / 10
ym.modis.lai.df$Date <- as.Date(ym.modis.lai.df$system.time_start,'%B %d, %Y')

# 
plot(out.ym.hufken.df$wtfac_root)
plot(out.ym.hufken.df$wtfac_topsoil)
plot(out.ym.hufken.df$pawater_topsoil)

plot(lai~Date,data = out.ym.hufken.df)
points(lai~Date,data = ym.modis.lai.df,pch=16,col='red')
points(wtfac_root~Date,data = out.ym.hufken.df,type='l',col='blue')


plot(transpiration~Date,data = out.ym.hufken.df)
plot(soil_evap~Date,data = out.ym.hufken.df)
plot(pawater_topsoil~Date,data = out.ym.hufken.df)

sum(out.ym.hufken.df$transpiration[out.ym.hufken.df$Date >= as.Date('2019-11-1')&
                                     out.ym.hufken.df$Date <= as.Date('2019-11-30')])

sum(out.ym.hufken.df$transpiration[out.ym.hufken.df$Date >= as.Date('2019-7-1')&
                                     out.ym.hufken.df$Date <= as.Date('2019-12-30')])

sum(met.ym.df$rain[met.ym.df$Date >= as.Date('2019-7-1')&
                 met.ym.df$Date <= as.Date('2019-12-30')])
# 
met.ym.df <- read.csv('model/ym_hufken/met.csv')
met.ym.df$Date <-  as.Date(met.ym.df$doy, origin = paste0(met.ym.df$X.year,'-1-1'))
plot(met.ym.df$rain)
