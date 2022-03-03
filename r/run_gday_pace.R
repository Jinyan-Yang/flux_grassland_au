# read spc names####
species.vec <- c('Bis','Dig','Luc','Fes','Rye','Kan','Rho','Pha')
# create folders#########
folder.nm.vec.a <- paste0('model/',species.vec)
folder.nm.vec <- paste0((folder.nm.vec.a),rep(c('_hufken','_grass'),each=8))

# read fitted par
par.df <- read.csv('cache/fittedParValue.csv')

# read pace harveat date
pace.df <- readRDS('data/gcc.met.pace.df.rds')
pace.df <- pace.df[pace.df$harvest==1 & 
                     pace.df$Precipitation == 'Control'&
                     pace.df$Temperature == 'Ambient',]

pace.harvest.date.df <- summaryBy(harvest~Date + Species,
                                  data  = pace.df,FUN=mean,na.rm=T)
pace.harvest.date.df$yr <- year(pace.harvest.date.df$Date)
pace.harvest.date.df$doy <- yday(pace.harvest.date.df$Date)
# 
for (i in seq_along(folder.nm.vec)) {
  
  # get spc nm
  spc.nm <- gsub(pattern = 'model/',replacement = '',x=folder.nm.vec[i])
  spc.nm <- gsub(pattern = '_hufken',replacement = '',x=spc.nm)
  spc.nm <- gsub(pattern = '_grass',replacement = '',x=spc.nm)
 
  if(spc.nm %in% c('Kan','Rho','Dig')){
    is.c4=TRUE
  }else{
    is.c4=FALSE
  }
  
  # get par for spc
  par.spc.df <- par.df[par.df$site == spc.nm,]
  # get harvest date
  pace.harvest.date.df.spc <- pace.harvest.date.df[pace.harvest.date.df$Species == spc.nm,]
  
  #update pools
  make.gday.cfg.func(file.path(folder.nm.vec[i],'par.cfg'))
  
  # change initial pool size
  change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                  'shoot',0.01)
  change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                  'root',0.01)
  # update param value
  
  change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                  'q_s',par.spc.df$q.s)
  change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                  'fdecay',par.spc.df$f.sec *365.25)
  change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                  'fdecay',par.spc.df$f.sec *365.25)
  # 
  change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                  'theta_wp_topsoil',0.05)
  change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                  'theta_fc_topsoil',0.13)
  change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                  'theta_wp_root',0.05)
  change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                  'theta_fc_root',0.13)
  change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                  'wcapac_root',1000*(.13-0.05))
  change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                  'wcapac_topsoil',300*(.13-0.05))
  
  change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                  'fractup_soil','1.0')
  
    # add havest date
  change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                  'year_harvest',paste0(pace.harvest.date.df.spc$yr,pace.harvest.date.df.spc$doy,',',collapse = ''))
  # change c3 c4 param
  if(is.c4){
    # c4#########
    change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                    'vcmax','39.0')
    
    change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                    'jmax','176.0')
    change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                    'sla','13.1')
    change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                    'g1','1.62')
    change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                    'ps_pathway','C4')
  }else{

    # c3###########
    change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                    'vcmax','69.0')
    
    change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                    'jmax','145.0')
    
    change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                    'sla','9.8')
    
    change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                    'g1','5.25')
    
    change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                    'ps_pathway','C3')
    
  }
  
  # check what model to run
  is.hufken <- grep('hufken', folder.nm.vec[i])
  is.grass <- grep('grass', folder.nm.vec[i])
  if(length(is.grass)>0 & length(is.hufken)>0) stop('folder name error')
  
  if(length(is.grass)>0){
    change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                    'q_s',0)
    run.gday.site.func(folder.nm.vec[i],alocation.model ='GRASSES')
  }
  
  if( length(is.hufken)>0){
    change_par_func(file.path(folder.nm.vec[i],'par.cfg'),
                    'q_s',par.spc.df$q.s)
    run.gday.site.func(folder.nm.vec[i],alocation.model ='GRASSES')
  }
  Sys.sleep(2)
}


# 

out.Kan.grass.df <- read.csv('model/Kan_grass/output.csv')
plot(out.Kan.grass.df$wtfac_root)

out.Kan.hufken.df <- read.csv('model/Kan_hufken/output.csv')
max(diff(out.Kan.hufken.df$lai),na.rm=T)

# 


