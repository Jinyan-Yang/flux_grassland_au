
# test Hufkens####
# model path
model.path = 'model/test_hufken/'
# change param values
change_par_func(paste0(model.path,'par.cfg'),
                'alloc_model','HUFKEN')
change_par_func(paste0(model.path,'par.cfg'),
                'c_alloc_fmax',0.2)
change_par_func(paste0(model.path,'par.cfg'),
                'c_alloc_rmax',0)
change_par_func(paste0(model.path,'par.cfg'),
                'fdecay',0.03*365)
change_par_func(paste0(model.path,'par.cfg'),
                'fracteaten',0)
# 
change_par_func(paste0(model.path,'par.cfg'),
                'q',0.6)
change_par_func(paste0(model.path,'par.cfg'),
                'q_s',1.5)
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
# # # set initial pool size
# # # shoot (c ton/ha) can be converted to LAI via sla (g/m2)
# #lai shoot *sla /10 *biomass.c.fraction
# change_par_func(paste0(model.path,'par.cfg'),
#                 'shoot',0.0)
# # nsc storage pool
# # either this or shoot need to be above 0 or there will never be any plant
# #
change_par_func(paste0(model.path,'par.cfg'),
                'nsc',0.5)
change_par_func(paste0(model.path,'par.cfg'),
                'sla',10.0)
# add soil water conditions
soil.depth <- 300 #mm
root.depth <- 700
fc <- 0.3
wp <- 0.05
change_par_func(paste0(model.path,'par.cfg'),
                'topsoil_depth',soil.depth)
change_par_func(paste0(model.path,'par.cfg'),
                'theta_wp_topsoil',wp )
change_par_func(paste0(model.path,'par.cfg'),
                'theta_fc_topsoil',fc )
change_par_func(paste0(model.path,'par.cfg'),
                'sw_stress_model',0)
change_par_func(paste0(model.path,'par.cfg'),
                'calc_sw_params','false')
change_par_func(paste0(model.path,'par.cfg'),
                'wcapac_topsoil',soil.depth * (fc - wp))
change_par_func(paste0(model.path,'par.cfg'),
                'wcapac_root',root.depth * (fc - wp))
change_par_func(paste0(model.path,'par.cfg'),
                'rooting_depth',root.depth)
change_par_func(paste0(model.path,'par.cfg'),
                'qs','1.0')

# # set water storage to 0
# change_par_func(paste0(model.path,'par.cfg'),
#                 'pawater_root',0)
# change_par_func(paste0(model.path,'par.cfg'),
#                 'pawater_topsoil',0)
# run gday in given folder
run_gday_func(model.path)


# test sgs####
# model path
model.path = 'model/test_sgs/'
# change param values
change_par_func(paste0(model.path,'par.cfg'),
                'alloc_model','SGS')
change_par_func(paste0(model.path,'par.cfg'),
                'c_alloc_fmax',0.2)
change_par_func(paste0(model.path,'par.cfg'),
                'c_alloc_rmax',0)
change_par_func(paste0(model.path,'par.cfg'),
                'fdecay',0.03*365)
change_par_func(paste0(model.path,'par.cfg'),
                'fracteaten',0)
# 
change_par_func(paste0(model.path,'par.cfg'),
                'q',1)
change_par_func(paste0(model.path,'par.cfg'),
                'q_s',0)
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
# # # set initial pool size
# # # shoot (c ton/ha) can be converted to LAI via sla (g/m2)
# change_par_func(paste0(model.path,'par.cfg'),
#                 'shoot',0.0)
# # nsc storage pool
# # either this or shoot need to be above 0 or there will never be any plant
change_par_func(paste0(model.path,'par.cfg'),
                'nsc',0.5)
change_par_func(paste0(model.path,'par.cfg'),
                'sla',10.0)
# add soil water conditions
soil.depth <- 300 #mm
root.depth <- 700
fc <- 0.3
wp <- 0.05
change_par_func(paste0(model.path,'par.cfg'),
                'topsoil_depth',soil.depth)
change_par_func(paste0(model.path,'par.cfg'),
                'theta_wp_topsoil',wp )
change_par_func(paste0(model.path,'par.cfg'),
                'theta_fc_topsoil',fc )
change_par_func(paste0(model.path,'par.cfg'),
                'sw_stress_model',0)
change_par_func(paste0(model.path,'par.cfg'),
                'calc_sw_params','false')
change_par_func(paste0(model.path,'par.cfg'),
                'wcapac_topsoil',soil.depth * (fc - wp))
change_par_func(paste0(model.path,'par.cfg'),
                'wcapac_root',root.depth * (fc - wp))
change_par_func(paste0(model.path,'par.cfg'),
                'rooting_depth',root.depth)
change_par_func(paste0(model.path,'par.cfg'),
                'qs','1.0')
# # set water storage to 0
# change_par_func(paste0(model.path,'par.cfg'),
#                 'pawater_root',0)
# change_par_func(paste0(model.path,'par.cfg'),
#                 'pawater_topsoil',0)
# run gday in given folder
run_gday_func(model.path)
 

# test original####
# model path
model.path = 'model/test_original/'
# change param values
change_par_func(paste0(model.path,'par.cfg'),
                'alloc_model','HUFKEN')
change_par_func(paste0(model.path,'par.cfg'),
                'c_alloc_fmax',0.2)
change_par_func(paste0(model.path,'par.cfg'),
                'c_alloc_rmax',0)
change_par_func(paste0(model.path,'par.cfg'),
                'fdecay',0.03*365)
change_par_func(paste0(model.path,'par.cfg'),
                'fracteaten',0)
 
# 
change_par_func(paste0(model.path,'par.cfg'),
                'q',1)
change_par_func(paste0(model.path,'par.cfg'),
                'q_s',0)
# this is the function that controls if growth depends on existing cover
# 1=yes 0=no
change_par_func(paste0(model.path,'par.cfg'),
                'use_cover',0)

# the rainfall threshold for growth to start
# set to <0 means growth can occur anytime
change_par_func(paste0(model.path,'par.cfg'),
                'green_sw_frac',1)
change_par_func(paste0(model.path,'par.cfg'),
                'days_rain',16)
# 
change_par_func(paste0(model.path,'par.cfg'),
                'vcmax',80)
change_par_func(paste0(model.path,'par.cfg'),
                'jmax',150)
# # # set initial pool size
# # # shoot (c ton/ha) can be converted to LAI via sla (g/m2)
# change_par_func(paste0(model.path,'par.cfg'),
#                 'shoot',0.0)
# # nsc storage pool
# # either this or shoot need to be above 0 or there will never be any plant
change_par_func(paste0(model.path,'par.cfg'),
                'nsc',0.5)
change_par_func(paste0(model.path,'par.cfg'),
                'sla',10.0)
# add soil water conditions
soil.depth <- 300 #mm
root.depth <- 700
fc <- 0.3
wp <- 0.05
change_par_func(paste0(model.path,'par.cfg'),
                'topsoil_depth',soil.depth)
change_par_func(paste0(model.path,'par.cfg'),
                'theta_wp_topsoil',wp )
change_par_func(paste0(model.path,'par.cfg'),
                'theta_fc_topsoil',fc )
change_par_func(paste0(model.path,'par.cfg'),
                'sw_stress_model',0)
change_par_func(paste0(model.path,'par.cfg'),
                'calc_sw_params','false')
change_par_func(paste0(model.path,'par.cfg'),
                'wcapac_topsoil',soil.depth * (fc - wp))
change_par_func(paste0(model.path,'par.cfg'),
                'wcapac_root',root.depth * (fc - wp))
change_par_func(paste0(model.path,'par.cfg'),
                'rooting_depth',root.depth)
change_par_func(paste0(model.path,'par.cfg'),
                'qs','1.0')
# # 
# # set water storage to 0
# change_par_func(paste0(model.path,'par.cfg'),
#                 'pawater_root',0)
# change_par_func(paste0(model.path,'par.cfg'),
#                 'pawater_topsoil',0)

# run gday in given folder
run_gday_func(model.path)

