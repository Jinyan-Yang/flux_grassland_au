# unit.func <- function(){
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
  
#   return()
# }








