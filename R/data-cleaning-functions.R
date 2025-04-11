#' Drop Bad Values from a Data Frame
#'
#' This function scans the provided data frame for values in vius data sets that
#' are not useful and removes them.
#'
#' @param df A vius dataframe to be cleaned
#'
#' @return The cleaned vius dataframe
#'
#' @export
drop_bad_values <- function(df){
  df <- df |>
    filter(
      !is.na(PRIMPROD),
      !is.na(REGSTATE),
      !is.na(TABWEIGHT),
      PRIMPROD != "X",
      PRIMPROD != "98",  # Remove 'Other unlisted products'
      PRIMPROD != "99",  # Remove 'Not reported'
      PRIMPROD != "49"   # NEW: Remove unknown or undefined PRIMPROD code
    )
}

#' Character to Numeric Data Frame
#'
#' Takes certain character columns in the vius data and transforms them into
#' numeric.
#'
#' @param df The vius data frame with the character columns to be transformed.
#'
#' @return The vius data with numeric vectors
#'
#' @export
charToNum <- function(df){
  df$MODELYEAR <- str_replace_all(df$MODELYEAR, "P", "") |>
    as.numeric()
  df <- df |>
    filter(AVGWEIGHT != "X") |>
    mutate(AVGWEIGHT = as.numeric(AVGWEIGHT)) |>
    mutate(AVGWEIGHT = case_when(
      AVGWEIGHT == 1 ~ 3000,
      AVGWEIGHT == 2 ~ 7250,
      AVGWEIGHT == 3 ~ 9250,
      AVGWEIGHT == 4 ~ 12000,
      AVGWEIGHT == 5 ~ 15000,
      AVGWEIGHT == 6 ~ 17750,
      AVGWEIGHT == 7 ~ 22750,
      AVGWEIGHT == 8 ~ 29500,
      AVGWEIGHT == 9 ~ 36500,
      AVGWEIGHT == 10 ~ 45000,
      AVGWEIGHT == 11 ~ 55000,
      AVGWEIGHT == 12 ~ 70000,
      AVGWEIGHT == 13 ~ 90000,
      AVGWEIGHT == 14 ~ 115000,
      TRUE ~ 130000
    ))

  df <- df |>
    filter(GM_COST != 'X' & GM_COST != '8') |>
    mutate(GM_COST = as.numeric(GM_COST)) |>
    mutate(GM_COST = case_when(
      GM_COST == 1 ~ 50,
      GM_COST == 2 ~ 250,
      GM_COST == 3 ~ 750,
      GM_COST == 4 ~ 1500,
      GM_COST == 5 ~ 3000,
      GM_COST == 6 ~ 7500,
      TRUE ~ 10000
    ))

  df <- df |>
    filter(ER_COST != '7') |>
    mutate(ER_COST = case_when(
      ER_COST == '1' ~ 750,
      ER_COST == '2' ~ 1500,
      ER_COST == '3' ~ 3000,
      ER_COST == '4' ~ 7500,
      ER_COST == '5' ~ 15000,
      ER_COST == '6' ~ 20000,
      TRUE ~ 0
    ))

}

#' Convert Codes to Names
#'
#' Converts the VIUS specific codes for certain categorical variables into user
#' understandably names.
#'
#' @param df The vius data frame with codes for variables, must not include NAs
#'
#' @return The vius data with useful columns
#'
#' @export
names <- function(df){
  # Define PRIMPROD labels (from data dictionary)
  primprod_labels <- c(
    "01" = "Animals and fish, live",
    "02" = "Animal feed and animal products",
    "03" = "Grains, cereal",
    "04" = "Other agricultural products",
    "05" = "Basic chemicals",
    "06" = "Fertilizers",
    "07" = "Pharmaceuticals",
    "08" = "Other chemical products",
    "09" = "Alcoholic beverages",
    "10" = "Bakery/grain products",
    "11" = "Meat and seafood",
    "12" = "Tobacco products",
    "13" = "Other prepared foodstuffs",
    "14" = "Logs and raw wood",
    "15" = "Paper articles",
    "16" = "Printed products",
    "17" = "Pulp and paper",
    "18" = "Wood products",
    "19" = "Articles of base metal",
    "20" = "Base metal forms",
    "21" = "Nonmetallic mineral products",
    "22" = "Electronics and electrical",
    "23" = "Furniture and lamps",
    "24" = "Machinery",
    "25" = "Miscellaneous manufactured",
    "26" = "Precision instruments",
    "27" = "Textiles and leather",
    "28" = "Vehicles and parts",
    "29" = "Other transportation equipment",
    "30" = "Coal",
    "31" = "Crude petroleum",
    "32" = "Gravel or stone",
    "33" = "Metallic ores",
    "34" = "Building stone",
    "35" = "Natural sands",
    "36" = "Other nonmetallic minerals",
    "37" = "Fuel oils",
    "38" = "Gasoline and blends",
    "39" = "Aviation fuel and kerosene",
    "40" = "Ethanol blends",
    "41" = "Plastics and rubber",
    "42" = "Other petroleum products",
    "43" = "Hazardous waste",
    "44" = "Other waste and scrap",
    "45" = "Recyclable products",
    "46" = "Mail and parcels",
    "47" = "Empty containers",
    "48" = "Mixed freight"
  )
  if (any(vius$PRIMPROD == "X")){
    stop("Must remove useless values first(run drop_bad_values)")
  }
  vius |>
    mutate(
      PRIMPROD = as.numeric(PRIMPROD),
      PRIMPROD_LABEL = factor(
        primprod_labels[as.character(PRIMPROD)],
        levels = unique(primprod_labels)
      )
    )
}
