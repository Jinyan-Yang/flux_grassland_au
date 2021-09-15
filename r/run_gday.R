# model path
model.path = 'model/stp_hufken/'
# change param values
change_par_func(paste0(model.path,'par.cfg'),
                'alloc_model','HUFKEN')
change_par_func(paste0(model.path,'par.cfg'),
                'c_alloc_fmax',0.05)
change_par_func(paste0(model.path,'par.cfg'),
                'fdecay',0.5)
# 
change_par_func(paste0(model.path,'par.cfg'),
                'q',0.6)
change_par_func(paste0(model.path,'par.cfg'),
                'q_s',2.0)
# this is the function that controls if growth depends on existing cover
# 1=yes 0=no
change_par_func(paste0(model.path,'par.cfg'),
                'use_cover',0)

# the rainfall threshold for growth to start
# set to <0 means growth can occur anytime
change_par_func(paste0(model.path,'par.cfg'),
                'green_sw_frac',-1)
# 
change_par_func(paste0(model.path,'par.cfg'),
                'vcmax',80)
change_par_func(paste0(model.path,'par.cfg'),
                'jmax',150)
# set initial pool size
# shoot (c ton/ha) can be converted to LAI via sla (g/m2)
change_par_func(paste0(model.path,'par.cfg'),
                'shoot',0.0)
# nsc storage pool
# either this or shoot need to be above 0 or there will never be any plant
change_par_func(paste0(model.path,'par.cfg'),
                'nsc',0.01)
# run gday in given folder
run_gday_func(model.path)