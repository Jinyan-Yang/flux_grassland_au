library(ncdf4)

creat.nc.func <- function(in.nm,out.nm){
  
  filename=in.nm#"test.nc"
  in.df <- read.csv('outputs/climGrass/CG_C0T0D0.csv')
  # gpd
  xvals <- 14.1008
  yvals <- 47.4939
  nx <- length(xvals)
  ny <- length(yvals)
  lon1 <- ncdim_def("longitude", "degrees_east", xvals)
  lat2 <- ncdim_def("latitude", "degrees_north", yvals)
  # time
  year.day.vec <- seq(as.Date('2014-1-1'),
                      as.Date('2019-12-31'),by='day')
  
  num.vec <- year.day.vec - as.Date('1900-1-1')
  
  time <- ncdim_def("time","days", as.numeric(num.vec), unlim=TRUE,longname = 'days since 1900-1-1')
  # day <- ncdim_def("doy","day", 1:365, unlim=TRUE)
  
  # real data#####
  mv <- -999 #missing value to use
  # flux
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
  
  #c pool
  cLeaf <- ncvar_def("cLeaf", "g C m-2", 
                         list(lon1, lat2, time), 
                         longname="Leaf carbon", mv) 
  cRoot <- ncvar_def("cRoot", "g C m-2", 
                      list(lon1, lat2, time), 
                      longname="Fine root carbon", mv) 
  cStore <- ncvar_def("cStore", "g C m-2", 
                     list(lon1, lat2, time), 
                     longname="Storage, non-structural carbon", mv) 
  # n pool
  nLeaf <- ncvar_def("nLeaf", "g N m-2", 
                     list(lon1, lat2, time), 
                     longname="Leaf nitrogen", mv) 
  nRoot <- ncvar_def("nRoot", "g N m-2", 
                     list(lon1, lat2, time), 
                     longname="Fine root nitrogen", mv) 
  nStore <- ncvar_def("nStore", "g N m-2", 
                      list(lon1, lat2, time), 
                      longname="Storage, non-structural nitrogen", mv)
  
  # litter
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
  # water
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
 
  # soil 
  
  
  SoilMoistTop <- ncvar_def("SoilMoistTop", "kg H20 m-2", 
                            list(lon1, lat2, time), 
                            longname="Soil moisture 0-30 cm", mv)
  
  SoilMoistBottom <- ncvar_def("SoilMoistBottom", "kg H20", 
                               list(lon1, lat2, time), 
                               longname="Soil moisture 30-100 cm", mv)
  
  
  cSoilTotTop <- ncvar_def("cSoilTotTop", "g C m-2", 
                            list(lon1, lat2, time), 
                            longname="Total soil carbon 0-30 cm", mv)
  
  cSoilTotBottom <- ncvar_def("cSoilTotTop", "g C m-2", 
                               list(lon1, lat2, time), 
                               longname="Total soil carbon 30-100 cm", mv)
  
  nSoilTotTop <- ncvar_def("nSoilTotTop", "g N m-2", 
                           list(lon1, lat2, time), 
                           longname="Total soil nitrogen 0-30 cm", mv)
  
  nSoillTotBottom <- ncvar_def("nSoillTotBottom", "g N m-2", 
                              list(lon1, lat2, time), 
                              longname="Total soil nitrogen 30-100 cm", mv)
  
  # nSoilTotTop	Total soil nitrogen 0-30 cm	g N m-2
  # nSoillTotBottom	Total soil nitrogen 30-100 cm	g N m-2
  # nSoilMinTop	Mineral soil nitrogen 0-30 cm	g N m-2
  # nSoilMinBottom	Miineral soil nitrogen 30-100 cm	g N m-2
  # nSoilOrgTop	Organic soil nitrogen 0-30 cm	g N m-2
  # nSoilOrgBottom	Organic soil nitrogen 30-100 cm	g N m-2
  # nSoilLeach	Nitrogen leachign from the soil	g N m-2 day-1
  # nSoilGas	Nitrogen gas emissions from the soil	g N m-2 day-1
  # nNetMin	Nitrogen net minerlaisation	g N m-2 day-1
  # BNF	Biological nitrogen fixation	g N m-2 day-1
  
  
  
  ncnew <- nc_create(filename, list(var_temp,var_shoot))
  
  print(paste("The file has", ncnew$nvars,"variables"))
  #[1] "The file has 1 variables"
  print(paste("The file has", ncnew$ndim,"dimensions"))
  #[1] "The file has 3 dimensions"
  
  # Some fake dataset based on latitude, to check whether the data are
  # written in the correct order
  data <- rnorm(time$len ,mean = 25,sd=5)
  
  # Add random -999 value to check whether missing values are correctly
  # written
  # data[sample(1:(nx*ny), 100, replace = FALSE)] <- -999
  ncvar_put(ncnew, var_temp, data, start=c(1,1,1), count=c(1,1,time$len))
  
  # Don't forget to close the file
  nc_close(ncnew)
  
  # teast <- nc_open('test.nc')
  # ncvar_get(teast,'temperature') 
}


teast <- nc_open('data/climGrass/CG_C0T0D0_met.nc')
ncvar_get(teast,'longitude')


# 
# 
# # Verification
# library(rasterVis)
# out <- raster("time.nc")
# levelplot(out, margin=FALSE)