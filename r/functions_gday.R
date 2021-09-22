# function to change parameter value for GDAY
change_par_func <- function(file.name,par.name,par.value){
  
  # read the file
  par.file <- readLines(file.name)
  # find line with the param
  par.find <- paste0(par.name,' =')
  nl_start <- grep(par.find, par.file, fixed=T)
  
  # give the param the new value
  new.line <- paste0(par.find,' ',par.value)
  
  # see if only one param was found
  if(length(nl_start)==1){

    # report to make things clearer
    print(paste0(par.file[nl_start],' changed to ',new.line))
    
    par.file[nl_start] <- new.line
    #save the new file  
    write.table(par.file,file.name,row.names = F,quote = F,col.names = F)
  }else if(length(nl_start)>1){
    print('Multiple parameters found with the name. Consider a more accurate name.')
    print(par.file[nl_start])
    nl_user <- as.numeric(readline(prompt="Enter which one: "))

    par.file[nl_start[nl_user]] <- new.line
    
    #save the new file  
    write.table(par.file,file.name,row.names = F,quote = F,col.names = F)
    
    print(paste0(par.file[nl_start[nl_user]],' changed to ',new.line))
    
  }else{
    stop('no parameter found with the name')
  }
  
}

# change_par_func('par.cfg','sla',11)


# run gday in given foler
run_gday_func <- function(met.folder,exe.name = 'PTP.exe',gday.exe.path='model/gday_exe/PTP.exe'){
  
  # met.folder <- 'model/stp_hufken/'
  # exe.name <- 'PTP.exe'
  
  # figure out repo
  currunt.wd <- getwd()
  on.exit(setwd(currunt.wd))
  
   #get exe from a comon repo 
  exe.path <- paste0(met.folder,exe.name)
  file.copy(gday.exe.path,exe.path,overwrite =T)
  # run the model in the environment
  target.wd <- setwd(met.folder)
  system(exe.name)
  
  print(paste0("gday finished in ",met.folder))
}

# 
run.gday.site.func <- function(model.path,
                               alocation.model ='HUFKEN',
                               q =1,
                               q_s =1,
                               green.frac = -1,
                               af = 0.025,
                               decay.rate = 0.03*365
){
  
  # test Hufkens####
  # model path
  # model.path = 'model/test_hufken/'
  # change param values
  change_par_func(paste0(model.path,'par.cfg'),
                  'alloc_model',alocation.model)
  change_par_func(paste0(model.path,'par.cfg'),
                  'c_alloc_fmax',af)
  change_par_func(paste0(model.path,'par.cfg'),
                  'c_alloc_rmax',0.0001)
  change_par_func(paste0(model.path,'par.cfg'),
                  'fdecay',decay.rate)
  change_par_func(paste0(model.path,'par.cfg'),
                  'fracteaten',0)
  # 
  change_par_func(paste0(model.path,'par.cfg'),
                  'q',q)
  change_par_func(paste0(model.path,'par.cfg'),
                  'q_s',q_s)
  # this is the function that controls if growth depends on existing cover
  # 1=yes 0=no
  change_par_func(paste0(model.path,'par.cfg'),
                  'use_cover',0)
  
  # the rainfall threshold for growth to start
  # set to <0 means growth can occur anytime
  change_par_func(paste0(model.path,'par.cfg'),
                  'green_sw_frac',green.frac)
  # 
  change_par_func(paste0(model.path,'par.cfg'),
                  'vcmax',30)
  change_par_func(paste0(model.path,'par.cfg'),
                  'jmax',30*1.6)
  change_par_func(paste0(model.path,'par.cfg'),
                  'ps_pathway','C3')

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
  # # # # set water storage to 0
  # change_par_func(paste0(model.path,'par.cfg'),
  #                 'pawater_root',0.25*0.1*root.depth)
  # change_par_func(paste0(model.path,'par.cfg'),
  #                 'pawater_topsoil',0)
  
  # run gday in given folder
  run_gday_func(model.path)
}
