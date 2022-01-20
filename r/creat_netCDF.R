library(ncdf4)

creat.nc.func <- function(in.nm,out.nm){
  
  # read output feom gday
  # in.df <- read.csv('outputs/climGrass/C0T0D0_output.csv')
  in.df <- read.csv(in.nm)
  in.df$Date  <- as.Date(in.df$doy,
                        origin = paste0(in.df$year,'-1-1'))
  # source('r/gday_climGrass_unit.R')
  # conver unit####
  # define constants
  t_ha_2g_m2 <- 1e6 *1e-4
  
  # convert unit
  NEP.gday <- in.df$nep * t_ha_2g_m2
  
  gpp.gday <- in.df$gpp * t_ha_2g_m2
  
  auto.resp.gday <- in.df$auto_resp * t_ha_2g_m2
  
  Hetero.Resp.gday <- in.df$hetero_resp * t_ha_2g_m2
  
  NUP.gday <- in.df$nuptake * t_ha_2g_m2
  # 
  cLeaf.gday <- in.df$shoot * t_ha_2g_m2
  
  cRoot.gday <- in.df$root * t_ha_2g_m2
  
  cStore.gday <- in.df$cstore * t_ha_2g_m2
  
  nLeaf.gday <- in.df$shootn * t_ha_2g_m2
  
  nRoot.gday <- in.df$rootn * t_ha_2g_m2
  
  nStore.gday <- in.df$nstore * t_ha_2g_m2
  # 
  cLitterLeaf.gday <- in.df$deadleaves * t_ha_2g_m2
  
  cLitterRoot.gday <- in.df$deadroots  * t_ha_2g_m2
  
  cLitterLeafn.gday <- in.df$deadleafn * t_ha_2g_m2
  
  cLitterRootn.gday <- in.df$deadrootn  * t_ha_2g_m2
  
  # 
  ET.gday <- in.df$et
  T.gday <- in.df$transpiration
  
  ESoil.gday <- in.df$soil_evap
  Ecan.gday <- in.df$canopy_evap
  # 
  SoilMoistTop.gday <- in.df$wtfac_topsoil * 300 *.37
  
  SoilMoistroot.gday <- in.df$wtfac_root *700*.37
  # 
  
  cSoilTotBottom.gday <- (in.df$activesoil +in.df$passivesoil) * t_ha_2g_m2
  
  nSoilTotBottom.gday <- (in.df$activesoiln +in.df$passivesoiln) * t_ha_2g_m2
  
  nSoilMinBottom.gday <- in.df$activesoil * t_ha_2g_m2
  
  nSoilOrgBottom.gday <- in.df$passivesoiln * t_ha_2g_m2
  
  nSoilLeach.gday <- in.df$nloss * t_ha_2g_m2
  
  nNetMin.gday <- in.df$nmineralisation * t_ha_2g_m2
  
  
  
  # define demensions####
  # gpd
  xvals <- 14.1008
  yvals <- 47.4939
  nx <- length(xvals)
  ny <- length(yvals)
  lon1 <- ncdim_def("longitude", "degrees_east", xvals)
  lat2 <- ncdim_def("latitude", "degrees_north", yvals)
  
  # time
  # year.day.vec <- seq(as.Date('2014-1-1'),
  #                     as.Date('2019-12-31'),by='day')
  
  num.vec <-  in.df$Date - as.Date('1900-1-1')
  
  time <- ncdim_def("time","days", as.numeric(num.vec), unlim=TRUE,longname = 'days since 1900-1-1')
  # day <- ncdim_def("doy","day", 1:365, unlim=TRUE)
  
  # define real output#####
  mv <- -999 #missing value to use
  # flux####
  NEP <- ncvar_def("NEP", "gC m-2 day-1", 
                        list(lon1, lat2, time), 
                        longname="Net ecosystem productivity", mv) 
  GPP <- ncvar_def("GPP", "gC m-2 day-1", 
                   list(lon1, lat2, time), 
                   longname="Gross primary proudctivity", mv) 
  
  AutoResp <- ncvar_def("AutoResp", "gC m-2 day-1", 
                   list(lon1, lat2, time), 
                   longname="Autotrophic respiration", mv) 
  
  HeteroResp <- ncvar_def("HeteroResp", "gC m-2 day-1", 
                        list(lon1, lat2, time), 
                        longname="Heterotrophic  respiration", mv) 
  
  MaintResp <- ncvar_def("MaintResp", "gC m-2 day-1", 
                          list(lon1, lat2, time), 
                          longname="Maintenance respiration", mv)
  
  GrowthResp <- ncvar_def("GrowthResp", "gC m-2 day-1", 
                         list(lon1, lat2, time), 
                         longname="Growth respiration", mv)
  
  NUP <- ncvar_def("NUP", "gN m-2 day-1", 
                          list(lon1, lat2, time), 
                          longname="Plant nitrogen uptake", mv)
  
  #c pool####
  cLeaf <- ncvar_def("cLeaf", "g C m-2", 
                         list(lon1, lat2, time), 
                         longname="Leaf carbon", mv) 
  cRoot <- ncvar_def("cRoot", "g C m-2", 
                      list(lon1, lat2, time), 
                      longname="Fine root carbon", mv) 
  cStore <- ncvar_def("cStore", "g C m-2", 
                     list(lon1, lat2, time), 
                     longname="Storage, non-structural carbon", mv) 
  # n pool####
  nLeaf <- ncvar_def("nLeaf", "g N m-2", 
                     list(lon1, lat2, time), 
                     longname="Leaf nitrogen", mv) 
  nRoot <- ncvar_def("nRoot", "g N m-2", 
                     list(lon1, lat2, time), 
                     longname="Fine root nitrogen", mv) 
  nStore <- ncvar_def("nStore", "g N m-2", 
                      list(lon1, lat2, time), 
                      longname="Storage, non-structural nitrogen", mv)
  
  # litter####
  cLitterLeaf <- ncvar_def("cLitterLeaf", "g C day-1", 
                      list(lon1, lat2, time), 
                      longname="Leaf litter carbon flux", mv)
  
  cLitterRoot <- ncvar_def("cLitterRoot", "g C day-1", 
                           list(lon1, lat2, time), 
                           longname="Root litter carbon flux", mv)
  
  nLitterLeaf <- ncvar_def("nLitterLeaf", "g N day-1", 
                           list(lon1, lat2, time), 
                           longname="Leaf litter nitrogen flux", mv)
  nLitterRoot <- ncvar_def("nLitterRoot", "g C day-1", 
                           list(lon1, lat2, time), 
                           longname="Root litter nitrogen flux", mv)
  # water####
  ET <- ncvar_def("ET", "kg H20 m-2 day-1", 
                          list(lon1, lat2, time), 
                          longname="Evapotranspiration", mv)
  
  TVeg <- ncvar_def("TVeg", "kg H20 m-2 day-1", 
                  list(lon1, lat2, time), 
                  longname="Transpiration", mv)
  
  ESoil <- ncvar_def("ESoil", "kg H20 m-2 day-1", 
                    list(lon1, lat2, time), 
                    longname="Soil evaporation", mv)
  
  EVeg <- ncvar_def("EVeg", "kg H20 m-2 day-1", 
                     list(lon1, lat2, time), 
                     longname="Canopy evaporation", mv)
 
  # soil ####
    SoilMoistTop <- ncvar_def("SoilMoistTop", "kg H20 m-2", 
                            list(lon1, lat2, time), 
                            longname="Soil moisture 0-30 cm", mv)
  
  SoilMoistBottom <- ncvar_def("SoilMoistBottom", "kg H20", 
                               list(lon1, lat2, time), 
                               longname="Soil moisture 30-100 cm", mv)
  # 
  cSoilTotTop <- ncvar_def("cSoilTotTop", "g C m-2", 
                            list(lon1, lat2, time), 
                            longname="Total soil carbon 0-30 cm", mv)
  
  cSoilTotBottom <- ncvar_def("cSoilTotBottom", "g C m-2", 
                               list(lon1, lat2, time), 
                               longname="Total soil carbon 30-100 cm", mv)
  # 
  nSoilTotTop <- ncvar_def("nSoilTotTop", "g N m-2", 
                           list(lon1, lat2, time), 
                           longname="Total soil nitrogen 0-30 cm", mv)
  
  nSoilTotBottom <- ncvar_def("nSoillTotBottom", "g N m-2", 
                              list(lon1, lat2, time), 
                              longname="Total soil nitrogen 30-100 cm", mv)
  # 
  nSoilMinTop <- ncvar_def("nSoilMinTop", "g N m-2", 
                               list(lon1, lat2, time), 
                               longname="Mineral soil nitrogen 0-30 cm", mv)
  
  nSoilMinBottom <- ncvar_def("nSoilMinBottom", "g N m-2", 
                           list(lon1, lat2, time), 
                           longname="Mineral soil nitrogen", mv)
  # 
  nSoilOrgTop <- ncvar_def("nSoilOrgTop", "g N m-2", 
                              list(lon1, lat2, time), 
                              longname="Organic soil nitrogen 0-30 cm", mv)
  
  nSoilOrgBottom <- ncvar_def("nSoilOrgBottom", "g N m-2", 
                           list(lon1, lat2, time), 
                           longname="Organic soil nitrogen 30-100 cm", mv)
  # 
  nSoilLeach <- ncvar_def("nSoilLeach", "g N m-2 day-1", 
                              list(lon1, lat2, time), 
                              longname="Nitrogen leachign from the soil", mv)
  
  nSoilGas <- ncvar_def("nSoilGas", "g N m-2 day-1", 
                          list(lon1, lat2, time), 
                          longname="Nitrogen gas emissions from the soil", mv)
  
  nNetMin <- ncvar_def("nNetMin", "g N m-2 day-1", 
                        list(lon1, lat2, time), 
                        longname="Nitrogen net minerlaisation", mv)
  
  BNF <- ncvar_def("BNF", "g N m-2 day-1", 
                       list(lon1, lat2, time), 
                       longname="Biological nitrogen fixation", mv)

  
  # creat nc file####
  ncnew <- nc_create(out.nm,  vars= list(NEP,GPP,AutoResp,HeteroResp,MaintResp,GrowthResp,NUP,
                                     cLeaf,cRoot,cStore,
                                     nLeaf,nRoot,nStore,
                                     cLitterLeaf,cLitterRoot,nLitterLeaf,nLitterRoot,
                                     ET,TVeg,ESoil,EVeg,
                                     SoilMoistTop,SoilMoistBottom,
                                     cSoilTotTop,cSoilTotBottom,nSoilTotTop,nSoilTotBottom,
                                     nSoilMinTop,nSoilMinBottom,nSoilOrgTop,nSoilOrgBottom,
                                     nSoilLeach,nSoilGas,nNetMin,BNF))

  
  print(paste("The file has", ncnew$nvars,"variables"))
  #[1] "The file has 1 variables"
  print(paste("The file has", ncnew$ndim,"dimensions"))
  #[1] "The file has 3 dimensions"
  
  # 
  # Some fake dataset based on latitude, to check whether the data are
  # written in the correct order
  # data <- rnorm(time$len ,mean = 25,sd=5)

  
  # Add random -999 value to check whether missing values are correctly
  # written######
  # data[sample(1:(nx*ny), 100, replace = FALSE)] <- -999
  ncvar_put(ncnew, NEP, NEP.gday, start=c(1,1,1), count=c(1,1,time$len))
  ncvar_put(ncnew, GPP, gpp.gday, start=c(1,1,1), count=c(1,1,time$len))
  ncvar_put(ncnew, AutoResp, auto.resp.gday, start=c(1,1,1), count=c(1,1,time$len))
  ncvar_put(ncnew, HeteroResp, Hetero.Resp.gday, start=c(1,1,1), count=c(1,1,time$len))
  ncvar_put(ncnew, NUP, NUP.gday, start=c(1,1,1), count=c(1,1,time$len))
  # 
  ncvar_put(ncnew, cLeaf, cLeaf.gday, start=c(1,1,1), count=c(1,1,time$len))
  ncvar_put(ncnew, cRoot, cRoot.gday, start=c(1,1,1), count=c(1,1,time$len))
  ncvar_put(ncnew, cStore, cStore.gday, start=c(1,1,1), count=c(1,1,time$len))
  # 
  ncvar_put(ncnew, nLeaf, nLeaf.gday, start=c(1,1,1), count=c(1,1,time$len))
  ncvar_put(ncnew, nRoot, nRoot.gday, start=c(1,1,1), count=c(1,1,time$len))
  ncvar_put(ncnew, nStore, nStore.gday, start=c(1,1,1), count=c(1,1,time$len))
  # 
  ncvar_put(ncnew, cLitterLeaf, cLitterLeaf.gday, start=c(1,1,1), count=c(1,1,time$len))
  ncvar_put(ncnew, cLitterRoot, cLitterRoot.gday, start=c(1,1,1), count=c(1,1,time$len))
  ncvar_put(ncnew, nLitterLeaf, cLitterLeafn.gday, start=c(1,1,1), count=c(1,1,time$len))
  ncvar_put(ncnew, nLitterRoot, cLitterRootn.gday, start=c(1,1,1), count=c(1,1,time$len))
  # 
  ncvar_put(ncnew, ET, ET.gday, start=c(1,1,1), count=c(1,1,time$len))
  ncvar_put(ncnew, TVeg, T.gday, start=c(1,1,1), count=c(1,1,time$len))
  ncvar_put(ncnew, ESoil, ESoil.gday, start=c(1,1,1), count=c(1,1,time$len))
  ncvar_put(ncnew, EVeg, Ecan.gday, start=c(1,1,1), count=c(1,1,time$len))
  # 
  ncvar_put(ncnew, SoilMoistTop, SoilMoistTop.gday, start=c(1,1,1), count=c(1,1,time$len))
  ncvar_put(ncnew, SoilMoistBottom, SoilMoistroot.gday, start=c(1,1,1), count=c(1,1,time$len))
  
  ncvar_put(ncnew, cSoilTotBottom, cSoilTotBottom.gday, start=c(1,1,1), count=c(1,1,time$len))
  ncvar_put(ncnew, nSoilTotBottom, nSoilTotBottom.gday, start=c(1,1,1), count=c(1,1,time$len))
  
  ncvar_put(ncnew, nSoilMinBottom, nSoilMinBottom.gday, start=c(1,1,1), count=c(1,1,time$len))
  ncvar_put(ncnew, nSoilOrgBottom, nSoilOrgBottom.gday, start=c(1,1,1), count=c(1,1,time$len))
  
  ncvar_put(ncnew, nSoilLeach, nSoilLeach.gday, start=c(1,1,1), count=c(1,1,time$len))
  ncvar_put(ncnew, nNetMin, nNetMin.gday, start=c(1,1,1), count=c(1,1,time$len))
  ncvar_put(ncnew, BNF, rep(0,time$len), start=c(1,1,1), count=c(1,1,time$len))
  # Don't forget to close the file
  nc_close(ncnew)
  
  # teast <- nc_open('test.nc')
  # ncvar_get(teast,'temperature') 
}


# teast <- nc_open('data/climGrass/CG_C0T0D0_met.nc')
# ncvar_get(teast,'longitude')C


# 
# 
# # Verification
# library(rasterVis)
# out <- raster("time.nc")
# levelplot(out, margin=FALSE)