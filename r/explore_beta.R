x = seq(0.05,0.3,by=0.01)

y = ((x - 0.05)/0.25)^0.2
plot(y~x)


paw <- seq(0,75)
depth <- 300
theta = paw / depth
fc = 0.3
wp = 0.05
exponent = 0.5

beta = (theta / (fc - wp))^ exponent
beta.s = (1 -theta / (fc - wp))^ exponent
plot(beta~theta)
plot(beta.s~theta)


x <- seq(0,6,by=0.1)

y <- 1 - exp(-0.1 * x)

plot(y~x)
