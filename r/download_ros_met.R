# library(HIEv)
# library(doBy)
# 
# startDate <- '2019-01-01'
# endDate <- '2020-12-31'
# 
# # get swc for each plot
# swc.ym.df <- downloadTOA5('DNET_AUTO_PM_SOILM_R_',topath = 'download/',
#                           startDate = startDate,
#                           endDate = endDate)
# 
# # get soil swc for top 75 cm profile
# swc.ym.profile.df <- downloadTOA5('DNET_AUTO_PM_SOILPROFILE_R',topath = 'download/',
#                                   startDate = startDate,
#                                   endDate = endDate)
# 
# 
# swc.ym.profile.sum.df <- summaryBy(VW_Avg.17.+VW_Avg.18.+VW_Avg.19.~Date,
#                                    FUN=mean,na.rm=F,keep.names = T,
#                                    data = swc.ym.profile.df)
# 
# names(swc.ym.profile.sum.df) <- c('Date','swc.5','swc.15.45','swc.45.75')
# 
# 
# swc.ym.day.df <- summaryBy(.~Date,data = subset(swc.ym.df,select = -c(DateTime,BattV_Avg,Source,RECORD)),
#                            FUN=mean,na.rm=T,keep.names = T)
# 
# library(tidyr)
# temp.df <- gather(swc.ym.day.df,'sensor.no','swc',names(swc.ym.day.df[,2:17]))
# swc.ym.df.long <- merge(temp.df,swc.ym.profile.sum.df,by='Date')
# 
# # give plot no info
# plot.info.df <- data.frame(sensor.no = unique(swc.ym.df.long$sensor.no),
#                            plot.no = c("5","8","11","12","14","15","18",
#                                        "22","27","30","33","36","37","38","40","45"),
#                            position = rep(c('H','L'),8))
# 
# swc.ym.all.df <- merge(swc.ym.df.long,plot.info.df,all.x=T)
# 
# # get ros met
# # get met from ros
# download.path <- file.path("download/")
# setToPath(download.path)
# 
# ros15 <- downloadTOA5("ROS_WS_Table15",
#                       startDate = startDate,
#                       endDate = endDate,
#                       maxnfiles = 500)
# ros.rain.day.df <- doBy::summaryBy(Rain_mm_Tot~Date,data = ros15,
#                                    FUN=sum,keep.names = T,na.rm=T)
# 
# ros05 <- downloadTOA5("ROS_WS_Table05",
#                       startDate = startDate,
#                       endDate = endDate,
#                       maxnfiles = 500)
# 
# ros05$PPFD[ros05$PPFD_Avg < 0] <- 0
# ros05$par <- 5*60 * ros05$PPFD_Avg * 10^-6 / 4.57
# 
# library(data.table)
# ros.day.1.df <- data.table(ros05)[,list(PAR = sum(par, na.rm=TRUE),
#                                         Tair=mean(AirTC_Avg, na.rm=TRUE),
#                                         Tmax = max(AirTC_Avg, na.rm=TRUE),
#                                         Tmin = min(AirTC_Avg, na.rm=TRUE),
#                                         RH=mean(RH, na.rm=TRUE),
#                                         RHmax=max(RH, na.rm=TRUE),
#                                         RHmin=min(RH, na.rm=TRUE),
#                                         u2 = mean(WS_ms_Avg,na.rm=TRUE)
#                                         
# ),by = 'Date']
# 
# ros.day.df <- merge(ros.day.1.df,ros.rain.day.df,all=T)
# 
# # ros.day.df$vpd <- (1-ros.day.df$RH/100)*0.61375*exp(17.502*ros.day.df$Tair/(240.97+ros.day.df$Tair))
# # write.csv(ros.day.df[,c('Date','Rain_mm_Tot','Tmin','Tmax','PAR','vpd','u2')],
# #           'ros.csv',row.names = F)
# 
# swc.ym.met.df <- merge(swc.ym.all.df,ros.day.df,
#                        by='Date',all = T)
# swc.ym.met.df$plot.no <- as.character(swc.ym.met.df$plot.no)
# 
# saveRDS(swc.ym.met.df,'cache/ym.met.rds')

library(HIEv)
library(doBy)

startDate <- '2019-01-01'
endDate <- '2020-12-31'

download.path <- file.path("download/")
setToPath(download.path)

ros15 <- downloadTOA5("ROS_WS_Table15",
                      startDate = startDate,
                      endDate = endDate,
                      maxnfiles = 500)
saveRDS(ros15,'data/ros15.rds')
ros05 <- downloadTOA5("ROS_WS_Table05",
                      startDate = startDate,
                      endDate = endDate,
                      maxnfiles = 500)
saveRDS(ros05,'data/ros05.rds')




