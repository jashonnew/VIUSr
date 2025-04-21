#' Vehicle Inventory and Use Survey (VIUS) data
#'
#' A subset of the VIUS data set as published by the United States Census
#' Bureau. The VIUS data describes various use characteristics of trucks in the
#' United States. The survey is conducted every 5 years, with the most recent
#' being based off of use characteristics in 2021 and the next planned survey
#' being based off of use characteristics in 2026. This subset of the data set
#' contains only selected columns of the data set useful for comparison across
#' different states or vehicle types. It should be noted that the data set does
#' not contain any data for the state of New Hampshire, and thus no analysis of
#' vehicle use is possible at this time for New Hampshire.
#'
#' @format ## `vius`
#' A data frame with 67,952 rows and 17 columns
#' \describe{
#'   \item{ID}{The unique ID of each sampled vehicle}
#'   \item{TABWEIGHT}{Weight factor for each sampled vehicle}
#'   \item{REGSTATE}{US State in which the vehicle is registered}
#'   \item{ACQUIREYEAR}{The year in which the current owner acquired the
#'   vehicle - all vehicles acquired in 1999 or earlier are grouped together}
#'   \item{AVGWEIGHT}{The average weight of the vehicle in its most common
#'   trailer configuration, in pounds}
#'   \item{BTYPE}{The body type of the vehicle}
#'   \item{ER_COST}{The total cost of extensive vehicle repairs in 2021, in
#'   dollars}
#'   \item{FUELTYPE}{The type of fuel the vehicle consumes}
#'   \item{GM_COST}{The total cost of general vehicle maintenance in 2021, in
#'   dollars}
#'   \item{KINDOFBUS}{The kind of business activity that the vehicle is most
#'   often used for}
#'   \item{MILESANNL}{The number of miles driven in 2021}
#'   \item{MILESLIFE}{The number of miles driven since the vehicle was
#'   manufactured}
#'   \item{MODELYEAR}{Model year of the vehicle - all vehicles manufactured
#'   in 1999 or earlier are grouped together}
#'   \item{MPG}{The average miles per gallon}
#'   \item{PRIMCOMMACT}{The commercial activity that the vehicle is most often
#'   used for}
#'   \item{PRIMPROD}{The primary product carried by the vehicle}
#'   \item{TRIPOFFROAD}{Percent of annual miles driven off road}
#' }
#'
#' @source <https://www.census.gov/data/datasets/2021/econ/vius/
#' 2021-vius-puf.html>
"vius"

#' The first 100 rows of the VIUS set data with no cleaning done
#'
#' This is a subset of the VIUS data set with none of the package's data
#' cleaning functions applied to it. Only the first 100 rows of the data were
#' included to keep the size of the data frame small.
#'
#' @format ## `vius_raw_sample`
#' A data frame with 100 rows and 168 columns
#'
#' @source <https://www.census.gov/data/datasets/2021/econ/vius/
#' 2021-vius-puf.html>
"vius_raw_sample"
