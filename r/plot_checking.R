out.vec <- list.files('outputs/climGrass/',full.names = T)
# 
par(mfrow=c(4,3))
for (i in seq_along(out.vec)) {
  
  df <- read.csv(out.vec[i])
  
  plot(df$lai,main = out.vec[i])
}

# 
par(mfrow=c(4,3))
for (i in seq_along(out.vec)) {
  
  df <- read.csv(out.vec[i])
  
  plot(df$shootn,main = out.vec[i])

}

# 
par(mfrow=c(4,3))
for (i in seq_along(out.vec)) {
  
  df <- read.csv(out.vec[i])
  
  plot(df$soiln,main = out.vec[i])
  
}
# 
# 
par(mfrow=c(4,3))
for (i in seq_along(out.vec)) {
  
  df <- read.csv(out.vec[i])
  
  plot(df$wtfac_root,main = out.vec[i])
  
}