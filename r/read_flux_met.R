# read flux data
library(ncdf4)
get.nc.func <- function(fn.df){
  # read flux data
  # flux.fn <- list.files('data/',pattern = '_Flux',full.names = T)
  flux.fn <- fn.df$flux.nm
  met.fn <- fn.df$met.nm
  # 
  nc.file <- nc_open(flux.fn)
  start.time <- (nc.file$dim$time$units)
  start.time <- gsub('seconds since ','',start.time)
  flux.df <- data.frame(Site = substr(flux.fn,6,11),
                        DateTime = as.POSIXlt( ncvar_get(nc.file,'time'),
                                               origin = start.time,tz = 'GMT'),
                        le_w_m2 = ncvar_get(nc.file,'Qle_cor'),
                        GPP_umol_m2_s = ncvar_get(nc.file,'GPP'),
                        GPP_qc= ncvar_get(nc.file,'GPP_qc'),
                        fn = flux.fn
                        )
  
  # range(flux.df$GPP_umol_m2_s)
  
  
  # read met 
  # met.fn <- list.files('data/',pattern = '_Met',full.names = T)
  nc.file.met <- nc_open(met.fn)
  start.time <- (nc.file.met$dim$time$units)
  start.time <- gsub('seconds since ','',start.time)
  met.df <- data.frame(DateTime = as.POSIXlt(ncvar_get(nc.file.met,'time'),
                                             origin = start.time,tz = 'GMT'),
                       LAI_sentinel = ncvar_get(nc.file.met,'LAI'),
                       LAI_modis = ncvar_get(nc.file.met,'LAI_alternative'),
                       windSpeed= ncvar_get(nc.file.met,'Wind'),
                       vpd = ncvar_get(nc.file.met,'VPD'),
                       Tair = ncvar_get(nc.file.met,'Tair'),
                       RH = ncvar_get(nc.file.met,'RH'),
                       rain_kg_m2_s = ncvar_get(nc.file.met,'Precip'),
                       fn.met = met.fn)
  # merge flux and met
  flux.met.df <- merge(flux.df,met.df,by='DateTime',all=T)
  return(flux.met.df)
}
# creat a vector of file names
flux.fn.vec <- list.files('data/',pattern = '_Flux',full.names = T)
met.fn.vec <- list.files('data/',pattern = '_Met',full.names = T)

fn.ls <- list()
fn.ls[[1]] <- data.frame(flux.nm = flux.fn.vec[1],
                         met.nm = met.fn.vec[1])
fn.ls[[2]] <- data.frame(flux.nm = flux.fn.vec[2],
                         met.nm = met.fn.vec[2])
# read files
flux.met.ls <- lapply(fn.ls,get.nc.func)
flux.met.df <- do.call(rbind,flux.met.ls)
flux.met.df$Date <- as.Date(flux.met.df$DateTime)

# get daily values
library(doBy)

flux.met.df.daily <- summaryBy(.~ Date + Site, data = flux.met.df,
                               FUN=mean,na.rm=T,keep.names =T,id = c('fn.met','fn'))
# convert to proper units
s2d <- 24*3600
mumol2g <- 1e-6*12
j2g <- 2257 #j/g; energy needed to evaporate 1 g of water
g2mm <- 1e-3
flux.met.df.daily$GPP_g_m2_d <- flux.met.df.daily$GPP_umol_m2_s *s2d * mumol2g
flux.met.df.daily$et_mm_d <- flux.met.df.daily$le_w_m2 * s2d /j2g *g2mm
flux.met.df.daily$rain_mm_d <- flux.met.df.daily$rain_kg_m2_s *s2d
# flux.met.df.daily$LAI_sentinel[flux.met.df.daily$Site =='AU-Ync'] <- 
#   flux.met.df.daily$LAI_sentinel[flux.met.df.daily$Site =='AU-Ync']
# make plots####
# # GPP and lai
# par(mar = c(5,5,1,5),mfrow=c(4,1))
# plot.df <- flux.met.df.daily[flux.met.df.daily$Site=='AU-Ync',]
# plot(GPP_g_m2_d~Date,data = plot.df,
#      type='l',
#      xlab='',ylab=expression(GPP~(g~C~m^-2~d^-1)),main = 'AU-Stp')
# abline(h=0,lty='dotted',col='grey',lwd=3)
# par(new=T)
# plot(LAI_sentinel~Date,data = plot.df,
#      type='l',col='darkseagreen',
#      ann=F,axes=F,lwd=2)
# 
# points(LAI_modis~Date,data = plot.df,
#        type='l',col='darkseagreen',lty='dashed',lwd=2)
# 
# legend('topright',legend = c('GPP',"Sentinel",'MODIS'),lty=c('solid','solid','dashed'),
#        col=c('black','darkseagreen','darkseagreen'),bty='n')
# axis(4,at = seq(0,3,0.5),labels = seq(0,3,0.5))
# mtext('LAI',side = 4,line=2)
# # scatter gpp lai
# plot(GPP_g_m2_d~LAI_sentinel,data = plot.df)
# 
# # et and LAI
# # par(mar = c(5,5,1,5))
# plot(et_mm_d~Date,data = plot.df,
#      type='l',
#      xlab='',ylab=expression(ET~(mm~d^-1)))
# abline(h=0,lty='dotted',col='grey',lwd=3)
# par(new=T)
# plot(LAI_sentinel~Date,data = plot.df,
#      type='l',col='darkseagreen',
#      ann=F,axes=F,lwd=2)
# 
# points(LAI_modis~Date,data = plot.df,
#        type='l',col='darkseagreen',lty='dashed',lwd=2)
# par(new=T)
# plot(rain_mm_d~Date,data = plot.df,
#      type='s',col='blue',
#      ann=F,axes=F,lwd=2)
# 
# 
# legend('topright',legend = c('ET',"Sentinel",'MODIS'),lty=c('solid','solid','dashed'),
#        col=c('black','darkseagreen','darkseagreen'),bty='n')
# axis(4,at = seq(0,3,0.5),labels = seq(0,3,0.5))
# mtext('LAI',side = 4,line=2)
# # 
# plot(et_mm_d~LAI_sentinel,data = plot.df)
# # plot(GPP_g_m2_d~LAI_modis,data = plot.df)
# # abline(a=0,b=1)

# 
plot.fulx.func <- function(site.nm){
  # GPP and lai
  plot.df <- flux.met.df.daily[flux.met.df.daily$Site == site.nm,]
  par(mar = c(5,5,1,5),mfrow=c(4,1))
  plot(GPP_g_m2_d~Date,data = plot.df,
       type='l',
       xlab='',ylab=expression(GPP~(g~C~m^-2~d^-1)),main = site.nm)
  abline(h=0,lty='dotted',col='grey',lwd=3)
  par(new=T)
  # if(site.nm =='AU-Ync'){
  #   plot.df$LAI_sentinel[1:180] <- NA
  #   plot.df$LAI_modis[1:180] <- NA
  # }
  plot(LAI_sentinel~Date,data = plot.df[!is.na(plot.df$LAI_sentinel),],
       type='l',col='darkseagreen',
       ann=F,axes=F,lwd=2)
  
  points(LAI_modis~Date,data = plot.df[!is.na(plot.df$LAI_modis),],
         type='l',col='darkseagreen',lty='dashed',lwd=2)
  
  legend('topright',legend = c('GPP',"Sentinel",'MODIS'),lty=c('solid','solid','dashed'),
         col=c('black','darkseagreen','darkseagreen'),bty='n')
  axis(4,at = seq(0,3,0.5),labels = seq(0,3,0.5))
  mtext('LAI',side = 4,line=2)
  # scatter gpp lai
  plot(GPP_g_m2_d~LAI_sentinel,data = plot.df)
  
  # et and LAI
  # par(mar = c(5,5,1,5))
  plot(et_mm_d~Date,data = plot.df,
       type='l',
       xlab='',ylab=expression(ET~(mm~d^-1)))
  abline(h=0,lty='dotted',col='grey',lwd=3)
  par(new=T)
  plot(LAI_sentinel~Date,data = plot.df,
       type='l',col='darkseagreen',
       ann=F,axes=F,lwd=2)
  
  points(LAI_modis~Date,data = plot.df,
         type='l',col='darkseagreen',lty='dashed',lwd=2)
  par(new=T)
  plot(rain_mm_d~Date,data = plot.df,
       type='s',col='blue',
       ann=F,axes=F,lwd=2)
  
  
  legend('topright',legend = c('ET',"Sentinel",'MODIS'),lty=c('solid','solid','dashed'),
         col=c('black','darkseagreen','darkseagreen'),bty='n')
  axis(4,at = seq(0,3,0.5),labels = seq(0,3,0.5))
  mtext('LAI',side = 4,line=2)
  # 
  plot(et_mm_d~LAI_sentinel,data = plot.df)
}

# plot.fulx.func('AU-Stp')
pdf('stp_ync_flux.pdf',width = 8,height = 8*4*.618)
plot.fulx.func('AU-Stp')
plot.fulx.func('AU-Ync')
dev.off()

