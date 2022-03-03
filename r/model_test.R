source('r/functions_gday.R')
# # run tests
# # run.gday.site.func('model/test_original/' ,alocation.model ='SGS',q = 1,q_s = 0)
# run.gday.site.func('model/test_sgs/',alocation.model ='SGS',q = 1,q_s = 0)
# run.gday.site.func('model/test_hufken/',alocation.model ='HUFKEN',q = 1.5,q_s = 0.8)
# run.gday.site.func('model/test_original/',alocation.model ='GRASSES',q = 0,q_s = 0,af = 0.9999,decay.rate = 0.03*365)

run.gday.site.func('test/grass/',alocation.model = 'GRASSES')
run.gday.site.func('test/hufken/',alocation.model = 'GRASSES')
# plot test #######
plot.gday.func <- function(hufkens.df,hypo = ''){
  par(mar=c(3,5,1,5))
  plot(lai~Date,data = hufkens.df,type='l',lwd=3,#ylim=c(0,3),
       xlab='',ylab='LAI',col='darkseagreen')
  legend('topright',legend = hypo,bty='n')
  # legend('topright',legend = c('LAI'),bty='n')
  # points(LAI_sentinel~Date,data = flux.met.df.daily[flux.met.df.daily$Site == 'AU-Stp',],pch=16,col='green')
  # points(LAI_modis~Date,data = flux.met.df.daily,pch=16,col='coral')
  par(new=T)
  plot(wtfac_topsoil~Date,data = hufkens.df,col='navy',ann=F,axes=F,type='s')
  axis(4,at = seq(0,1,by=0.25),labels = seq(0,1,by=0.25))
  mtext('Plant available water fraction',4,3)
}
# 
test.hufken.df <- read.csv('test/hufken/output.csv',skip=0,header = T)
test.hufken.df$Date <- as.Date(test.hufken.df$doy, 
                               origin = paste0(test.hufken.df$year,'-1-1'))
# 
  test.sgs.df <- read.csv('test/grass/output.csv',skip=0,header = T)
test.sgs.df$Date <- as.Date(test.sgs.df$doy, 
                            origin = paste0(test.sgs.df$year,'-1-1'))
# 
# test.ori.df <- read.csv('model/test_original/output.csv',skip=0,header = T)
# test.ori.df$Date <- as.Date(test.ori.df$doy, 
#                             origin = paste0(test.ori.df$year,'-1-1'))

pdf('figures/model_test.pdf',width = 8,height = 8*.618*3)
par(mfrow=c(2,1))
# plot.gday.func(test.ori.df,'Pulse')
plot.gday.func(test.sgs.df,'GRASS')
plot.gday.func(test.hufken.df,'CH')
# plot.gday.func(test.ori.df,'Original')
dev.off()
