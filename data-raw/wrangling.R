#This script is how one would take raw data from the VIUS survey and transform
#it to work with the functions in this package.

vius <- read.csv("data-raw/vius_2021_puf.csv")

#Remove values for vehicles that do not apply to the variables of interest.
vius <- drop_bad_values(vius)

#Change certain character columns to numeric for dynamic plotting.
vius <- charToNum(vius)

#change the default VIUS codes for certain categorical variables to useful names
vius <- names(vius)
