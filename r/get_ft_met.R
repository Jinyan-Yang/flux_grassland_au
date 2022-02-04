##############################################################################
# list of varibles needed in gday#############################################
# https://github.com/mdekauwe/GDAY############################################
##############################################################################

# Variable	Description	Units
# year		
# doy	day of year	[1-365/6]
# hod	hour of day	[0-47]
# rain	rainfall	mm 30 min-1
# par	photosynthetically active radiation	umol m-2 s-1
# tair	air temperature	deg C
# tsoil	soil temperature	deg C
# vpd	vapour pressure deficit	kPa
# co2	CO2 concentration	ppm
# ndep	nitrogen deposition	t ha-1 30 min-1
# nfix	biological nitrogen fixation	t ha-1 30 min-1
# wind	wind speed	m s-1
# press	atmospheric pressure	kPa

# prepare
# funtion to calculate vpd frim Tair and rh
source('r/functions.R')

# ####
# download.ros.met.func(startDate = '2019-1-1',
#                       endDate = '2020-12-31',
#                       met05.nm = 'data/ros05_flux.rds',
#                       met15.nm = 'data/ros15_flux.rds')
# read ym 5min data####
ros.met.df <- put.met2gday.format.func(met.05.nm = 'data/ros05.rds',
                                       met.15.nm = 'data/ros15.rds')

# write to csv
write.csv(ros.met.df,'model/flux_hufkens/met.csv',row.names = F,quote=F)
# write.csv(ros.met.df,'model/ym_sgs/met.csv',row.names = F,quote=F)
