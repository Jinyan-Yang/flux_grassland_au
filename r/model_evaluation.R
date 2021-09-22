plot.compare.func <- function(hufkens.df,flux.met.df.daily,mode.nm = ''){
  par(mfrow=c(3,1),
      mar=c(5,5,1,1))
  
  flux.met.df.daily$Date <- as.Date(flux.met.df.daily$Date)
  # LAI
  plot(lai~Date,data = hufkens.df,type='l',lwd=3,ylim=c(0,3))
  # points(LAI_sentinel~Date,data = flux.met.df.daily[flux.met.df.daily$Site == 'AU-Stp',],pch=16,col='green')
  points(LAI_modis~Date,data = flux.met.df.daily,pch=16,col='coral')
  legend('topleft',legend = c('MODIS','Model','Water'),lty='solid',col=c('coral','black','navy'),bty='n')
  legend('topright',legend = mode.nm,bty='n')
  par(new=T)
  plot(wtfac_topsoil~Date,data = hufkens.df,col='navy',ann=F,axes=F,type='s')
  
  # et
  plot(et~Date,data = hufkens.df,type='l',lwd=3,ylim=c(0,10),ylab='ET (mm d-1)')
  points(et_mm_d~Date,data =  flux.met.df.daily,pch=16,col='green')
  # gpp
  plot((gpp*1e6*1e-4)~Date,data = hufkens.df,type='l',lwd=3,ylim=c(0,10),ylab='GPP g C m-2 d-1')
  points(GPP_g_m2_d~Date,data =  flux.met.df.daily,pch=16,col='green')
}

# get flux data #####
flux.met.df <- readRDS('cache/flux_stp_ync_processed.rds')
# get daily values
library(doBy)
flux.met.df.daily <- summaryBy(LAI_sentinel + LAI_modis + GPP_umol_m2_s + le_w_m2 ~Date + Site,
                               data = flux.met.df,FUN=c(mean,sum),na.rm=T)

# conver units
flux.met.df.daily$LAI_sentinel <- flux.met.df.daily$LAI_sentinel.mean
flux.met.df.daily$LAI_modis <- flux.met.df.daily$LAI_modis.mean
umol2g = 12* 1e-6
s2d <- 3600*24 
flux.met.df.daily$GPP_g_m2_d <- flux.met.df.daily$GPP_umol_m2_s.mean * umol2g *s2d
j2g <- 2257 #j/g; energy needed to evaporate 1 g of water
g2mm <- 1e-3
flux.met.df.daily$et_mm_d <- flux.met.df.daily$le_w_m2.mean * s2d /j2g *g2mm

# read outputs####
# get model outputs grass(hufkens)
hufkens.df.stp <- read.csv('model/stp_hufken/output.csv',skip=0,header = T)
hufkens.df.stp$Date <- as.Date(hufkens.df.stp$doy, origin = paste0(hufkens.df.stp$year,'-1-1'))
# get model outputs sgs
hufkens.df.sgs <- read.csv('model/stp_sgs/output.csv',skip=0,header = T)
hufkens.df.sgs$Date <- as.Date(hufkens.df.sgs$doy, origin = paste0(hufkens.df.sgs$year,'-1-1'))

# get model outputs original
sgs.df.yan <- read.csv('model/yan_sgs/output.csv',skip=0,header = T)
sgs.df.yan$Date <- as.Date(sgs.df.yan$doy, origin = paste0(sgs.df.yan$year,'-1-1'))
# plot.compare.func(hufkens.df.ori,flux.met.df.daily[flux.met.df.daily$Site == 'AU-Stp',])
# get hufkens yanco
hufkens.df.hufken.yanco <- read.csv('model/yan_hufken/output.csv',skip=0,header = T)
hufkens.df.hufken.yanco$Date <- as.Date(hufkens.df.hufken.yanco$doy, 
                                        origin = paste0(hufkens.df.hufken.yanco$year,'-1-1'))
flux.met.df.daily.yanco <- read.csv('data/flux.yanco.daily.csv')
# plot.compare.func(hufkens.df.hufken.yanco,flux.met.df.daily.yanco)


# get hufkens ym
hufkens.df.hufken.ym <- read.csv('model/ym_hufken/output.csv',skip=0,header = T)
hufkens.df.hufken.ym$Date <- as.Date(hufkens.df.hufken.ym$doy, 
                                        origin = paste0(hufkens.df.hufken.ym$year,'-1-1'))
hufkens.df.hufken.ym <- hufkens.df.hufken.ym[hufkens.df.hufken.ym$year>2018,]
# get sgs ym
sgs.df.ym <- read.csv('model/ym_hufken/output.csv',skip=0,header = T)
sgs.df.ym$Date <- as.Date(sgs.df.ym$doy, 
                                     origin = paste0(sgs.df.ym$year,'-1-1'))
sgs.df.ym <- sgs.df.ym[sgs.df.ym$year>2018,]
# 
ym.obs.df <- readRDS('d:/repo/PhenoMods/tmp/pred.smv13.2qchain.ym.Control.Ambient.rds')

# # 
plot(lai~Date,data = hufkens.df.hufken.ym)
# 
points(cover~Date,data = ym.obs.df,pch=16,col='red')
# # plot(hufkens.df.hufken.ym,ym.obs.df)
plot(wtfac_topsoil~Date,data = hufkens.df.hufken.ym)
# 
points(swc~Date,data = ym.obs.df,pch=16,col='red')
points(Rain_mm_Tot~Date,data = ym.obs.df,type='s',col='navy')

#make plots######
pdf('figures/model_evaluation.pdf',width = 10,height = 8*.618*3)
plot.compare.func(hufkens.df.stp,flux.met.df.daily[flux.met.df.daily$Site == 'AU-Stp',],mode.nm = 'CH-STP')
plot.compare.func(hufkens.df.sgs,flux.met.df.daily[flux.met.df.daily$Site == 'AU-Stp',],mode.nm = 'SGS-STP')

plot.compare.func(hufkens.df.hufken.yanco,flux.met.df.daily.yanco,mode.nm = 'CH-YAN')
plot.compare.func(sgs.df.yan,flux.met.df.daily.yanco,mode.nm = 'SGS-YAN')

dev.off()

# 
# check <- read.csv('model/ym_hufken/met.csv')
modis.yanco <- read.csv('data/yanco_modis_check.csv')
modis.yanco$Date <- as.Date(strptime(modis.yanco$system.time_start,'%B %d, %Y'))
modis.yanco$lai.modis <- modis.yanco$Yanco*0.1
# 
flux.met.df.daily.yanco$Date <- as.Date(flux.met.df.daily.yanco$Date)
# LAI
plot(lai~Date,data = hufkens.df.hufken.yanco,type='l',lwd=3,ylim=c(0,3))
# points(LAI_sentinel~Date,data = flux.met.df.daily[flux.met.df.daily$Site == 'AU-Stp',],pch=16,col='green')
points(lai.modis~Date,data = modis.yanco,pch=16,col='coral')
legend('topleft',legend = c('MODIS','Model','Water'),lty='solid',col=c('coral','black','navy'),bty='n')
legend('topright',legend = 'YAN-CH',bty='n')
par(new=T)
plot(wtfac_topsoil~Date,data = hufkens.df.hufken.yanco,col='navy',ann=F,axes=F,type='s')

