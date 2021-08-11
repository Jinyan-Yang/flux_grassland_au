
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
flux.met.df.daily$et <- flux.met.df.daily$le_w_m2.mean * s2d /j2g *g2mm

# function to make plots####
plot.compare.func <- function(hufkens.df,flux.met.df.daily){
  par(mfrow=c(3,1),
      mar=c(5,5,1,1))
  # LAI
  plot(lai~Date,data = hufkens.df,type='l',lwd=3,ylim=c(0,2))
  points(LAI_sentinel~Date,data = flux.met.df.daily[flux.met.df.daily$Site == 'AU-Stp',],pch=16,col='green')
  points(LAI_modis~Date,data = flux.met.df.daily[flux.met.df.daily$Site == 'AU-Stp',],pch=16,col='coral')
  par(new=T)
  plot(wtfac_root~Date,data = hufkens.df,col='navy',ann=F,axes=F,type='s')
  
  # et
  plot(et~Date,data = hufkens.df,type='l',lwd=3,ylim=c(0,10))
  points(et~Date,data =  flux.met.df.daily[flux.met.df.daily$Site == 'AU-Stp',],pch=16,col='green')
  # gpp
  plot((gpp*1e6*1e-4)~Date,data = hufkens.df,type='l',lwd=3,ylim=c(0,10),ylab='GPP g C m-2 d-1')
  points(GPP_g_m2_d~Date,data =  flux.met.df.daily[flux.met.df.daily$Site == 'AU-Stp',],pch=16,col='green')
}

# 
# get model outputs grass(hufkens)
hufkens.df.grass <- read.csv('S:/storage/repo/Mofy/Mofy-master/stp_grass/output.csv',skip=0,header = T)
hufkens.df.grass$Date <- as.Date(hufkens.df.grass$doy, origin = paste0(hufkens.df.grass$year,'-1-1'))
# get model outputs sgs
hufkens.df.sgs <- read.csv('S:/storage/repo/Mofy/Mofy-master/stp_sgs/output.csv',skip=0,header = T)
hufkens.df.sgs$Date <- as.Date(hufkens.df.sgs$doy, origin = paste0(hufkens.df.sgs$year,'-1-1'))
# get model outputs original
hufkens.df.ori <- read.csv('S:/storage/repo/Mofy/Mofy-master/stp_original/output.csv',skip=0,header = T)
hufkens.df.ori$Date <- as.Date(hufkens.df.ori$doy, origin = paste0(hufkens.df.ori$year,'-1-1'))
plot.compare.func(hufkens.df.ori,flux.met.df.daily)

pdf('model_evaluation.pdf',width = 8,height = 8*.618*3)
plot.compare.func(hufkens.df.grass,flux.met.df.daily)
plot.compare.func(hufkens.df.sgs,flux.met.df.daily)
dev.off()
