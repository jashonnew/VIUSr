getBtypeGraphs <- function(vius1, var, plotTitle = "Title",
                           xPlotLabel = "x axis", yPlotLabel = "y axis") {
  #Introduce tabweight to get estimate of real population
  custom_data <- vius1 |>
    dplyr::select(TABWEIGHT, BTYPE, {{ var }}) |>
    dplyr::filter({{ var }} != "X", BTYPE != "X", {{ var }} != "")|>
    dplyr::group_by(BTYPE) |>
    dplyr::mutate({{ var }} := as.numeric({{ var }})) |>
    dplyr::mutate(total = sum(TABWEIGHT * {{ var }}) / sum(TABWEIGHT)) |>
    dplyr::mutate(total = round(total, 2))
  custom_data
}
