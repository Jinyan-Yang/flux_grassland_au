source('r/functions_gday.R')
# 
run.gday.climGrass.func <- function(model.path,
                                    alocation.model ='GRASSES',
                                    q = 0,
                                    q_s = 0,
                                    # green.frac = -1,
                                    # af = 1,
                                    decay.rate = 1,#0.03*365,
                                    af.max = 0.67,
                                    af.min = 0.33,
                                    # 
                                    ar.max = 0.67,
                                    ar.min = 0.33,
                                    root.decay = 0.172,
                                    root.decay.dry = 0.67,
                                    # 
                                    # cover.impact = 1,
                                    do.graze = 'true'
                                    
){
  file.copy('model/gday_exe/par.cfg',paste0(model.path,'par.cfg'),overwrite =F)
  # test Hufkens####
  # model path
  # model.path = 'model/test_hufken/'
  # change param values
  change_par_func(paste0(model.path,'par.cfg'),
                  'alloc_model',alocation.model)
  # par from gday phace
  change_par_func(paste0(model.path,'par.cfg'),
                  'c_alloc_fmax',af.max)
  change_par_func(paste0(model.path,'par.cfg'),
                  'c_alloc_fmin',af.min)
  # 
  change_par_func(paste0(model.path,'par.cfg'),
                  'c_alloc_rmax',ar.max)
  change_par_func(paste0(model.path,'par.cfg'),
                  'c_alloc_rmin',ar.min)
  # 
  change_par_func(paste0(model.path,'par.cfg'),
                  'fdecay',decay.rate)
  change_par_func(paste0(model.path,'par.cfg'),
                  'rdecay',root.decay)
  change_par_func(paste0(model.path,'par.cfg'),
                  'rdecaydry',root.decay.dry)
  # 
  change_par_func(paste0(model.path,'par.cfg'),
                  'c_alloc_cmax',0.0)

 
  # 
  change_par_func(paste0(model.path,'par.cfg'),
                  'rateuptake',1.9)
 
  # control#######################################
  change_par_func(paste0(model.path,'par.cfg'),
                  'ncycle',
                  'true')
  change_par_func(paste0(model.path,'par.cfg'),
                  'nuptake_model',
                  1)
  change_par_func(paste0(model.path,'par.cfg'),
                  'fixleafnc',
                  'false')
  
  # change_par_func(paste0(model.path,'par.cfg'),
  #                 'spin_up',
  #                 'false')
  # 
  # change_par_func(paste0(model.path,'par.cfg'),
  #                 'spinup_method',
  #                 'BRUTE')
  
  change_par_func(paste0(model.path,'par.cfg'),
                  'grazing',
                  do.graze)
  # water#################################################################
  change_par_func(paste0(model.path,'par.cfg'),
                  'q',q)
  change_par_func(paste0(model.path,'par.cfg'),
                  'q_s',q_s)
  # # this is the function that controls if growth depends on existing cover
  # # 1=yes 0=no
  # change_par_func(paste0(model.path,'par.cfg'),
  #                 'use_cover',cover.impact)
  
  # # the rainfall threshold for growth to start
  # # set to <0 means growth can occur anytime
  # change_par_func(paste0(model.path,'par.cfg'),
  #                 'green_sw_frac',green.frac)
  
  # photosyn###################################################################
  change_par_func(paste0(model.path,'par.cfg'),
                  'vcmax',58.349)
  change_par_func(paste0(model.path,'par.cfg'),
                  'jmax',133.82)
  change_par_func(paste0(model.path,'par.cfg'),
                  'ps_pathway','C3')
  change_par_func(paste0(model.path,'par.cfg'),
                  'g1',4.16)#from Lin 2015
  

# soil and traits###################################################################
  change_par_func(paste0(model.path,'par.cfg'),
                  'sla',9.8
                  # 9.8 is what martin used for c3
                  )#AK has 50 g m-2 for TT; model need m2 kg
  # add soil water conditions
  soil.depth <- 300 #mm
  root.depth <- 1000
  fc <- 0.37
  wp <- 0.1
  change_par_func(paste0(model.path,'par.cfg'),
                  'topsoil_depth',soil.depth)
  change_par_func(paste0(model.path,'par.cfg'),
                  'theta_wp_topsoil',wp )
  change_par_func(paste0(model.path,'par.cfg'),
                  'theta_fc_topsoil',fc )
  
  change_par_func(paste0(model.path,'par.cfg'),
                  'theta_fc_root',fc )
  change_par_func(paste0(model.path,'par.cfg'),
                  'theta_wp_root',wp )
  
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
  
  # 
  change_par_func(paste0(model.path,'par.cfg'),
                  'latitude',47.4939)
  change_par_func(paste0(model.path,'par.cfg'),
                  'albedo',0.2)
  change_par_func(paste0(model.path,'par.cfg'),
                  'max_intercep_lai',2)

  # 
  # # # # set water storage to 0
  # change_par_func(paste0(model.path,'par.cfg'),
  #                 'pawater_root',0.25*0.1*root.depth)
  # change_par_func(paste0(model.path,'par.cfg'),
  #                 'pawater_topsoil',0)
  
  # run gday in given folder
 
  run_gday_func(model.path,exe.name = 'ClimGrass_gday.exe',gday.exe.path='model/gday_exe/ClimGrass_gday.exe')
  
}
