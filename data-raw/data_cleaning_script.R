# This script is how one would take raw data from any future VIUS survey and
# transform it to work with the functions in this package.

vius <- read.csv("data-raw/vius_2021_puf.csv")

# Select only the variables we want to reduce the size of the data set while
# keeping all the observations
vius <- select_variables_vius(vius)

# Change certain character columns to numeric for dynamic plotting.
vius <- charToNum(vius)

# change the default VIUS codes for certain categorical variables to useful
# names
vius <- convert_names(vius)
