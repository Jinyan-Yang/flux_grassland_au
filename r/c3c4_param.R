# jmax vcmax from Zhou et al., 2018. 
# 10.1073/pnas.1718988115

# c4#########
change_par_func(paste0(model.path,'par.cfg'),
                'vcmax','39.0')

change_par_func(paste0(model.path,'par.cfg'),
                'vcmax','176.0')
change_par_func(paste0(model.path,'par.cfg'),
                'sla','13.1')
change_par_func(paste0(model.path,'par.cfg'),
                'g1','1.62')

# c3###########
change_par_func(paste0(model.path,'par.cfg'),
                'vcmax','69.0')

change_par_func(paste0(model.path,'par.cfg'),
                'vcmax','145.0')

change_par_func(paste0(model.path,'par.cfg'),
                'sla','9.8')

change_par_func(paste0(model.path,'par.cfg'),
                'g1','5.25')


