

get_btype_graphs <- function(vius1, var, plot_title = "Title",
                             x_plot_label = "x axis", y_plot_label = "y axis") {
  # Introduce tabweight to get estimate of real population
  custom_data <- vius1 |>
    dplyr::select(TABWEIGHT, BTYPE, {{ var }}) |>
    dplyr::filter({{ var }} != "X", BTYPE != "X", {{ var }} != "") |>
    dplyr::group_by(BTYPE) |>
    dplyr::mutate({{ var }} := as.numeric({{ var }})) |>
    dplyr::mutate(total = sum(TABWEIGHT * {{ var }}) / sum(TABWEIGHT)) |>
    dplyr::mutate(total = round(total, 2))
  ggplot2::ggplot(custom_data, ggplot2::aes(x = BTYPE, y = weighted_avg)) +
    ggplot2::geom_col(fill = "steelblue") +
    ggplot2::labs(title = plot_title,
         x = x_plot_label,
         y = y_plot_label) +
    ggplot2::theme_minimal()
}

#' @importFrom utils globalVariables
utils::globalVariables(c("TABWEIGHT", "BTYPE", "weighted_avg", "total"))
