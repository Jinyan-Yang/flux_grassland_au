# get met for pace#################################################################
# note that the code assumes pace has the same met as ros except for rainfall
# thus need to run r/get_ros_met.r first
###################################################################################

 # read ros met
ros.met.df <- read.csv('met.ros.daily.csv')

# read pace rainfall
