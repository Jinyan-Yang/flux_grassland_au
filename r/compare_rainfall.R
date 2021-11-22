flux.met.df.daily.yanco <- read.csv('data/flux.yanco.daily.csv')

flux.anna.yanco.df <- flux.met.df.daily[flux.met.df.daily$Site == 'AU-Ync',]
# 
rain.ws.df <- read.csv('data/IDCJAC0009_074162_1800_Data.csv')
rain.ws.df$Date <- as.Date(strptime(paste0(rain.ws.df$Year,'-',
                                   rain.ws.df$Month,'-',
                                   rain.ws.df$Day),'%Y-%m-%d'))
rain.ws.df$rain <- rain.ws.df$Rainfall.amount..millimetres.

# 
modis.yanco <- read.csv('data/yanco_modis_check.csv')
modis.yanco$Date <- as.Date(strptime(modis.yanco$system.time_start,'%B %d, %Y'))
modis.yanco$lai.modis <- modis.yanco$Yanco*0.1
# 

plot((rain_mm_30min.mean*48)~Date,data = flux.met.df.daily.yanco,type='s',
     ylab='Rainfall (mm/d)')
# points(rain~Date,data = rain.ws.df,type='s',col='red')
points((lai*100)~Date,hufkens.df.hufken.yanco,pch=16,col='grey',type='l',lwd=3,ylab='LAI',xlab='')
points((lai.modis*100)~Date,modis.yanco,pch=16,col='green',type='l')



# 
plot((lai)~Date,hufkens.df.hufken.yanco,pch=16,col='grey',type='l',lwd=3,ylab='LAI',xlab='')
points((lai.modis)~Date,modis.yanco,pch=16,col='green',type='l')

par(new=T)
plot((rain_mm_30min.mean*48)~Date,data = flux.met.df.daily.yanco,type='s',
     ylab='Rainfall (mm/d)',ann=F,axes=F)

# 
par(mar=c(5,5,1,5))
plot(lai.modis~Date,data = modis.yanco,ylim=c(0,3),
     xlab='',ylab='MODIS LAI',col='grey',pch=16)
points(c(rain/100)~Date,data = rain.ws.df,type='s',col='navy')
mtext('Rainfall (mm/d)',side = 4,line = 3)
axis(4,at = seq(0,1,by=0.2),labels = seq(0,1,by=0.2) *100)

