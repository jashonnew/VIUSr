# This script is how one would take raw data from the VIUS survey and transform
# it to work with the functions in this package.

vius <- read.csv("data-raw/vius_2021_puf.csv")

# Change certain character columns to numeric for dynamic plotting.
vius <- charToNum(vius)

# change the default VIUS codes for certain categorical variables to useful
# names
vius <- names(vius)
