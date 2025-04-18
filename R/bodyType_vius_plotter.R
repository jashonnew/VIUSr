#' Plot Weighted Averages by Body Type
#'
#' This function calculates the weighted average of a given variable across vehicle body types
#' using `TABWEIGHT` for weights, and generates a horizontal bar chart. Each bar represents a
#' body type, colored individually, and sorted by the weighted average.
#'
#' @param vius1 A data frame containing at least the columns `TABWEIGHT`, `BTYPE`, and the variable of interest.
#' @param var The variable to plot, passed unquoted (e.g., `MPG`).
#' @param plot_title A character string for the plot title. Defaults to `"Title"`.
#' @param x_plot_label A character string for the x-axis label. Defaults to `"x axis"`.
#' @param y_plot_label A character string for the y-axis label. Defaults to `"y axis"`.
#'
#' @return A ggplot2 object representing the bar chart.
#'
#' @examples
#' \dontrun{
#'   get_btype_graphs(vius1, MPG, plot_title = "Average MPG by Body Type",
#'                    x_plot_label = "Body Type", y_plot_label = "Average MPG")
#' }
#'
#' @importFrom dplyr select filter mutate group_by summarize
#' @importFrom ggplot2 ggplot aes geom_bar coord_flip scale_fill_manual theme_minimal labs theme
#' @importFrom grDevices topo.colors
#' @importFrom stats reorder
#' @export
get_btype_graphs <- function(vius1, var, plot_title = "BAR CHART",
                             x_plot_label = "Variable Average", y_plot_label = "Variable of Interest") {
  var <- rlang::enquo(var)

  # Introduce tabweight to get estimate of real population
  custom_data <- vius1 |>
    dplyr::select(TABWEIGHT, BTYPE, {{ var }}) |>
    dplyr::filter({{ var }} != "X", BTYPE != "X", {{ var }} != "") |>
    dplyr::group_by(BTYPE) |>
    dplyr::summarize(total = round(sum(TABWEIGHT * {{ var }}) / sum(TABWEIGHT), 2),
                                              .groups = "drop")

  custom_data$BTYPE <- as.factor(custom_data$BTYPE)

  # Now make the plot
  ggplot2::ggplot(custom_data, ggplot2::aes(x = stats::reorder(BTYPE, total), y = total, fill = BTYPE)) +
    ggplot2::geom_bar(stat = "identity") +
    ggplot2::coord_flip()+
    ggplot2::scale_fill_manual(
      values = grDevices::
        topo.colors(length(custom_data$BTYPE))
    ) +
    ggplot2::labs(
      title = paste(rlang::as_name(var), plot_title),
      x = x_plot_label,
      y = y_plot_label,
      fill = x_plot_label
    )+
    ggplot2::theme_minimal(base_size = 13) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(color = "white"),
      axis.title = ggplot2::element_text(color = "white"),
      axis.text = ggplot2::element_text(color = "white", size = 9),
      legend.position = "none",
      panel.grid.major = ggplot2::element_line(color = "gray30"),
      panel.grid.minor = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "black"),
      plot.background = ggplot2::element_rect(fill = "black")
    )
}
