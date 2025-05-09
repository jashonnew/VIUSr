#' Drop columns not used in the VIUSr package
#'
#' This function takes the raw vius data and drops all columns in the data set
#' that are not used by the VIUSr package.
#'
#' @param df The vius data frame
#' @returns The vius data frame with only the desired columns
#' @export
drop_cols <- function(df) {
  suppressWarnings({
    df <- df |>
      dplyr::select(
        ID, TABWEIGHT, REGSTATE, ACQUIREYEAR, AVGWEIGHT, BTYPE,
        ER_COST, FUELTYPE, GM_COST, KINDOFBUS, MILESANNL,
        MILESLIFE, MODELYEAR, MPG, PRIMCOMMACT, PRIMPROD,
        TRIPOFFROAD
      )
  })
  df
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
char_to_num <- function(df) {
  suppressWarnings({
    df$MODELYEAR <- stringr::str_replace_all(df$MODELYEAR, "P", "") |>
      as.numeric()
    df$ACQUIREYEAR <- stringr::str_replace_all(df$ACQUIREYEAR, "P", "") |>
      as.numeric()

    df <- df |>
      dplyr::mutate(AVGWEIGHT = as.numeric(AVGWEIGHT)) |>
      dplyr::mutate(AVGWEIGHT = dplyr::case_when(
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
      dplyr::mutate(GM_COST = as.numeric(GM_COST)) |>
      dplyr::mutate(GM_COST = dplyr::case_when(
        GM_COST == 1 ~ 50,
        GM_COST == 2 ~ 250,
        GM_COST == 3 ~ 750,
        GM_COST == 4 ~ 1500,
        GM_COST == 5 ~ 3000,
        GM_COST == 6 ~ 7500,
        TRUE ~ 10000
      ))

    df <- df |>
      dplyr::mutate(ER_COST = dplyr::case_when(
        ER_COST == "1" ~ 750,
        ER_COST == "2" ~ 1500,
        ER_COST == "3" ~ 3000,
        ER_COST == "4" ~ 7500,
        ER_COST == "5" ~ 15000,
        ER_COST == "6" ~ 20000,
        TRUE ~ 0
      ))

    df <- df |>
      dplyr::mutate(MPG = as.numeric(MPG)) |>
      dplyr::mutate(MILESANNL = as.numeric(MILESANNL)) |>
      dplyr::mutate(MILESLIFE = as.numeric(MILESLIFE)) |>
      dplyr::mutate(TRIPOFFROAD = as.numeric(TRIPOFFROAD))
  })
  df
}

#' Convert Codes to correct charater values
#'
#' Converts the VIUS specific codes for certain categorical variables into user
#' understandable characters.
#'
#' @param df The vius data frame with codes for variables, must not include NAs
#'
#' @return The vius data with useful columns
#'
#' @export
convert_names <- function(df) {
  suppressWarnings({
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

    df <- dplyr::mutate(df, PRIMPROD =
                          factor(primprod_labels[as.character(df$PRIMPROD)],
                                 levels = primprod_labels))

    df <- df |>
      dplyr::mutate(BTYPE = dplyr::case_when(
        BTYPE == "01" ~ "Pickup",
        BTYPE == "02" ~ "Minvan",
        BTYPE == "03" ~ "Other light van",
        BTYPE == "04" ~ "Sport utility vehicle",
        BTYPE == "05" ~ "Armored",
        BTYPE == "06" ~ "Beverage or bay",
        BTYPE == "07" ~ "Box truck",
        BTYPE == "08" ~ "Concrete mixer",
        BTYPE == "09" ~ "Concrete pumper",
        BTYPE == "10" ~ "Conveyor bed",
        BTYPE == "11" ~ "Crane",
        BTYPE == "12" ~ "Dump",
        BTYPE == "13" ~ "Flatbed, stake, or platform",
        BTYPE == "14" ~ "Hooklift/roll-off",
        BTYPE == "15" ~ "Logging",
        BTYPE == "16" ~ "Service, utility",
        BTYPE == "17" ~ "Service, other",
        BTYPE == "18" ~ "Street sweeper",
        BTYPE == "19" ~ "Tank, liquid or gases",
        BTYPE == "20" ~ "Tow/wrecker",
        BTYPE == "21" ~ "Trash, garbage, or recycling",
        BTYPE == "22" ~ "Vacuum",
        BTYPE == "23" ~ "Van, walk-in",
        BTYPE == "24" ~ "Van, other",
        BTYPE == "25" ~ "Wood chipper",
        BTYPE == "26" ~ "Other",
        BTYPE == "27" ~ "Not reported",
        TRUE ~ NA_character_
      ))

    df <- df |>
      dplyr::mutate(FUELTYPE = dplyr::case_when(
        FUELTYPE == "10" ~ "Gasoline",
        FUELTYPE == "20" ~ "Diesel",
        FUELTYPE == "31" ~ "Compressed natural gas",
        FUELTYPE == "32" ~ "Liquified natural gas",
        FUELTYPE == "33" ~ "Propane",
        FUELTYPE == "34" ~ "Alcohol fuels",
        FUELTYPE == "35" ~ "Electricity",
        FUELTYPE == "36" ~ "Combination",
        FUELTYPE == "40" ~ "Not reported",
        TRUE ~ NA_character_
      ))

    df <- df |>
      dplyr::mutate(KINDOFBUS = dplyr::case_when(
        KINDOFBUS == "01" ~ "Accommodation and food services (for immediate consumption)",
        KINDOFBUS == "02" ~ "Waste management and remediation",
        KINDOFBUS == "03" ~ "Landscaping",
        KINDOFBUS == "04" ~ "Other administrative and support and waste management and remediation services",
        KINDOFBUS == "05" ~ "Agriculture (crop and animal production)",
        KINDOFBUS == "06" ~ "Fishing, hunting, trapping",
        KINDOFBUS == "07" ~ "Forestry and logging",
        KINDOFBUS == "08" ~ "Other agriculture, forestry, fishing, and hunting",
        KINDOFBUS == "09" ~ "Arts, entertainment, or recreation services",
        KINDOFBUS == "10" ~ "Construction - residential",
        KINDOFBUS == "11" ~ "Construction - non-residential",
        KINDOFBUS == "12" ~ "Other construction",
        KINDOFBUS == "13" ~ "Fuel wholesale or distribution",
        KINDOFBUS == "14" ~ "Information services (includes telephone and television)",
        KINDOFBUS == "15" ~ "Manufacturing",
        KINDOFBUS == "16" ~ "Mining (includes quarrying, well operations, and beneficiating)",
        KINDOFBUS == "17" ~ "Retail trade",
        KINDOFBUS == "18" ~ "For-hire transportation (of goods or people)",
        KINDOFBUS == "19" ~ "Warehousing and storage",
        KINDOFBUS == "20" ~ "Other transportation and warehousing",
        KINDOFBUS == "21" ~ "Utilities (includes electric power, natural gas, steam supply, water supply, and sewage removal)",
        KINDOFBUS == "22" ~ "Vehicle leasing or rental (includes short-term rentals)",
        KINDOFBUS == "23" ~ "Wholesale trade",
        KINDOFBUS == "24" ~ "Other services, including advertising, real estate, nonvehicle leasing or rental, educational, health care, social assistance, finance, insurance, professional, scientific, or technical services",
        KINDOFBUS == "25" ~ "Other business type",
        KINDOFBUS == "26" ~ "Not reported",
        TRUE ~ NA_character_
      ))

    df <- df |>
      dplyr::mutate(PRIMCOMMACT = dplyr::case_when(
        PRIMCOMMACT == "11" ~ "Transporting goods/products belonging to owner or owner's company",
        PRIMCOMMACT == "12" ~ "Transporting goods/products belonging to another person/company",
        PRIMCOMMACT == "13" ~ "Transporting online local goods/products",
        PRIMCOMMACT == "20" ~ "Transporting tools related to owner's business",
        PRIMCOMMACT == "30" ~ "Transporting paying passengers",
        PRIMCOMMACT == "40" ~ "Transporting non-paying passengers",
        PRIMCOMMACT == "50" ~ "Rental (daily and other short term)",
        PRIMCOMMACT == "60" ~ "Other commercial activity",
        PRIMCOMMACT == "65" ~ "Non-commercial use",
        PRIMCOMMACT == "70" ~ "Not reported",
        TRUE ~ NA_character_
      ))
  })
  df
}

#' @importFrom utils globalVariables
utils::globalVariables(c("AVGWEIGHT",
                         "GM_COST",
                         "ID",
                         "ACQUIREYEAR",
                         "ER_COST",
                         "FUELTYPE",
                         "KINDOFBUS",
                         "MILESANNL",
                         "MODELYEAR",
                         "MPG",
                         "PRIMCOMMACT",
                         "PRIMPROD",
                         "TRIPOFFROAD",
                         "MPG",
                         "MILESANNL",
                         "TRIPOFFROAD",
                         "MILESLIFE"))
