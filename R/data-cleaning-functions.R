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
chatToNum <- function(df){
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
