# read all output####
folder.vec <- list.files('model/')
folder.vec <- folder.vec[!folder.vec %in% c("test", "gday_exe")]
folder.vec <- folder.vec[!folder.vec %in% folder.vec[grep('spinup',folder.vec)]]
# 
out.ls <- list()
for (fld.i in seq_along(folder.vec)) {
  tmp.df <- read.csv(file.path('model',folder.vec[fld.i],'output.csv'),skip=0,header = T)
  tmp.df$Date <- as.Date(tmp.df$doy, origin = paste0(tmp.df$year,'-1-1'))
  out.ls[[fld.i]] <- tmp.df
}
names(out.ls) <- folder.vec
saveRDS(out.ls,'cache/gday.out.rds')
# read all cover data ####
pace.df <- readRDS('cache/gcc.met.pace.df.rds')
ym.df <- readRDS('cache/ym.con.gcc.df.rds')
flux.df <- readRDS('cache/flux.con.gcc.df.rds')
yanco.df <- readRDS('cache/flux_OZflux_yanco.rds')
yanco.modis.lai.df <- read.csv('cache/modis_lai_stp_ync.csv')
yanco.modis.lai.df$lai.yanco <- yanco.modis.lai.df$Yanco / 10
yanco.modis.lai.df$Date <- as.Date(yanco.modis.lai.df$system.time_start,'%B %d, %Y')
stp.df <- readRDS('cache/flux_stp_processed.rds')

# plot lai####
pdf('figures/model_lai_evaluation.pdf',width = 8,height = 8*.618)

# 
species.vec <- c('Bis','Dig','Luc','Fes','Rye','Kan','Rho','Pha')
# 
par(mar = c(5,5,1,5))
for (plot.i in seq_along(names(out.ls))) {
  
  site.nm <- substr(names(out.ls)[plot.i],1,3)
  
  if(site.nm == 'flu')site.nm = 'flux'
  if(site.nm == 'ym_')site.nm = 'ym'
  
  if(site.nm %in% species.vec){
    pace.df.sub <- pace.df[pace.df$Species == site.nm & 
                             pace.df$Precipitation == 'Control' &
                             pace.df$Temperature =='Ambient',]
    
    plot(GCC~Date,data = pace.df.sub,type='p',pch=16,col='grey',
         xlim=range(out.ls[[plot.i]]$Date),
         xlab='',ylab=' ',ann=F,axes=F)
    axis(4,at = seq(0.3,0.45,by=0.05),labels = seq(0.3,0.45,by=0.05))
    mtext('GCC',side = 4,line = 3)
  }else if(site.nm == 'ym'){
    pace.df.sub <- ym.df
    
    plot(GCC~Date,data = pace.df.sub,type='p',pch=16,col='grey',
         xlim=range(out.ls[[plot.i]]$Date),
         xlab='',ylab=' ',ann=F,axes=F)
    axis(4,at = seq(0.3,0.45,by=0.05),labels = seq(0.3,0.45,by=0.05))
    mtext('GCC',side = 4,line = 3)
  }else if(site.nm == 'flux'){
    pace.df.sub <- flux.df
    
    plot(GCC~Date,data = pace.df.sub,type='p',pch=16,col='grey',
         xlim=range(out.ls[[plot.i]]$Date),
         xlab='',ylab=' ',ann=F,axes=F)
    axis(4,at = seq(0.3,0.45,by=0.05),labels = seq(0.3,0.45,by=0.05))
    mtext('GCC',side = 4,line = 3)
  }else if(site.nm == 'stp'){
    
    pace.df.sub <- stp.df
    plot(LAI_modis~Date,data = pace.df.sub,type='p',pch=16,col='grey',
         xlim=range(out.ls[[plot.i]]$Date),
         xlab='',ylab=' ',ann=F,axes=F)
    axis(4,at = seq(0,2,by=0.5),labels = seq(0,2,by=0.5))
    mtext('LAI_MODIS',side = 4,line = 3)
  }else if(site.nm == 'yan'){
    pace.df.sub <- yanco.modis.lai.df
    plot(lai.yanco~Date,data = pace.df.sub,type='p',pch=16,col='grey',
         xlim=range(out.ls[[plot.i]]$Date),
         xlab='',ylab=' ',ann=F,axes=F)
    axis(4,at = seq(0,2,by=0.5),labels = seq(0,2,by=0.5))
    mtext('LAI_MODIS',side = 4,line = 3)
  }else{
    stop('check site name')
  }

  

  par(new=T)
  plot(lai~Date,data = out.ls[[plot.i]],type='l',lwd=3,col='darkseagreen',
       xlim=range(out.ls[[plot.i]]$Date),
       xlab='',ylab='LAI')
  legend('topleft',legend = names(out.ls)[plot.i],bty='n')

  
}



dev.off()

# compare growth from gday and emprical fitting######
empircal.spc.vec <- c('Bis','Dig','Luc','Fes','Rye','Kan','Rho','Pha','ym','flux')
# 
par.df <- read.csv('cache/fittedParValue.csv')
out.growth.ls <- list()
for (fld.i in seq_along(out.ls)) {
  
  site.nm <- substr(names(out.ls)[plot.i],1,3)
  # senec rate
  if(site.nm == 'flu')site.nm = 'flux'
  if(site.nm == 'ym_')site.nm = 'ym'
  
  if(site.nm %in% empircal.spc.vec){
  r.sec <- par.df$f.sec[par.df$site == site.nm]
}else if(site.nm%in% c('stp','yan')){
  r.sec <- 0.05823409
  }else{
    stop('check site name')
  }
  
  # 
  model.type <- grep('grass',names(out.ls)[fld.i])
  
  if(length(model.type)>0){
    lai.all = max(diff(out.ls[[fld.i]]$lai),na.rm=T)
  }else{
    lai.all = max(diff(out.ls[[fld.i]]$lai),na.rm=T)
  }
  tmp.df <- out.ls[[fld.i]]
  tmp.df <- tmp.df[tmp.df$shoot>0,]
  senesce.rate <- max(c(tmp.df$deadleaves / tmp.df$shoot),na.rm=T)

  out.growth.ls[[fld.i]] <- data.frame(
    spc = names(out.ls)[fld.i],
    r.growth.gday.lai =  lai.all,
    r.sec.gday.frac = senesce.rate
    
  )
 
}
out.growth.df <- do.call(rbind,out.growth.ls)
saveRDS(out.growth.df,'cache/growth.gday.rds')






























# plot(lai~Date,data = out.ls[['Kan_hufken']],type='l',lwd=3)
# plot(lai~Date,data = out.ls[['ym_grass']],type='l',lwd=3)
# plot(lai~Date,data = out.ls[['ym_hufken']],type='l',lwd=3)
plot(wtfac_topsoil~Date,data = out.ls[['ym_hufken']],type='l',lwd=3)
plot(wtfac_topsoil~Date,data = out.ls[['Luc_hufken']],type='l',lwd=3)


plot(lai~Date,data = out.ls[['yan_hufken']],type='l',lwd=3,col='darkseagreen',
     xlim=range(out.ls[['yan_hufken']]$Date),
     xlab='',ylab='LAI')
plot(lai~Date,data = out.ls[['yan_grass']],type='l',lwd=3,col='darkseagreen',
     xlim=range(out.ls[['yan_hufken']]$Date),
     xlab='',ylab='LAI')

plot(lai~Date,data = out.ls[['stp_hufken']],type='l',lwd=3,col='darkseagreen',
     xlim=range(out.ls[['stp_hufken']]$Date),
     xlab='',ylab='LAI')

plot(lai~Date,data = out.ls[['stp_grass']],type='l',lwd=3,col='darkseagreen',
     xlim=range(out.ls[['stp_grass']]$Date),
     xlab='',ylab='LAI')


plot(wtfac_root~Date,data = out.ls[['stp_hufken']],type='l',lwd=3,col='darkseagreen',
     xlim=range(out.ls[['stp_hufken']]$Date),
     xlab='',ylab='w frac')

plot(et~Date,data = out.ls[['stp_hufken']],type='l',lwd=3,col='darkseagreen',
     xlim=range(out.ls[['stp_hufken']]$Date),
     xlab='',ylab='w et')

plot((c(0,diff(pawater_root)) + et)~Date,data = out.ls[['stp_hufken']],type='l',lwd=3,col='darkseagreen',
     xlim=range(out.ls[['stp_hufken']]$Date),
     xlab='',ylab='w frac',ylim=c(-10,10))

out.ls[['stp_hufken']]$wtfac_root
out.ls[['stp_hufken']]$et
(out.ls[['stp_hufken']]$pawater_root / 1000-0.05) / (0.15-0.05)

out.ls[['Rho_hufken']]$pawater_root
# 
# plot(lai~Date,data = out.ls[['stp_hufken']],type='l',lwd=3)
# plot(lai~Date,data = out.ls[['stp_grass']],type='l',lwd=3)
# 
# 
# plot(lai~Date,data = out.ls[['yan_grass']],type='l',lwd=3)
# plot(wtfac_topsoil~Date,data = out.ls[['yan_grass']],type='l',lwd=3)
# plot(lai~Date,data = out.ls[['yan_hufken']],type='l',lwd=3)
