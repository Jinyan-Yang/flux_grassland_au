# this functions updates the default par.cfg file with grass parameters
# note that this function wa made NOT independent to avoid potential mistakes
update.par.func <- function(){
  
  change_par_func(file.path(model.path,'par.cfg'),
                  'shoot',mean(spin.df$shoot,na.rm = T))
  change_par_func(file.path(model.path,'par.cfg'),
                  'shootn',mean(spin.df$shootn,na.rm = T))
  change_par_func(file.path(model.path,'par.cfg'),
                  'nsc',0.0)
  change_par_func(file.path(model.path,'par.cfg'),
                  'stem',0.0)
  change_par_func(file.path(model.path,'par.cfg'),
                  'branch',0.0)
  change_par_func(file.path(model.path,'par.cfg'),
                  'croot',0.0)
  change_par_func(file.path(model.path,'par.cfg'),
                  'cstore',mean(spin.df$cstore,na.rm = T))
  change_par_func(file.path(model.path,'par.cfg'),
                  'nstore',mean(spin.df$nstore,na.rm = T))
  change_par_func(file.path(model.path,'par.cfg'),
                  'crootn',0.0)
  change_par_func(file.path(model.path,'par.cfg'),
                  'root',mean(spin.df$root,na.rm = T))
  change_par_func(file.path(model.path,'par.cfg'),
                  'rootn',mean(spin.df$rootn,na.rm = T))
  change_par_func(file.path(model.path,'par.cfg'),
                  'inorgn',mean(spin.df$inorgn,na.rm = T))

  change_par_func(file.path(model.path,'par.cfg'),
                  'deciduous_model','true')
  change_par_func(file.path(model.path,'par.cfg'),
                  'nuptake_model',1)
  change_par_func(file.path(model.path,'par.cfg'),
                  'grazing',1)
  
  change_par_func(file.path(model.path,'par.cfg'),
                  'rateuptake',0.4)
  change_par_func(file.path(model.path,'par.cfg'),
                  'rateloss',0.6)
}