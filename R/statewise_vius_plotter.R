#' Generate State-Level Bar Graphs from VIUS Data
#'
#' This function reads the VIUS survey files, filters and summarizes the data
#' by state and a user-specified column, then creates horizontal bar plots of
#' estimated vehicle counts for each state.
#'
#' @param dbHeader A column from the dataset used for grouping.
#' @param states A vector of state abbreviations or FIPS codes to include in
#'    the plots. If `NULL` (default), plots will be generated for all available
#'    states in the dataset.
#' @param plotTitle A character string used as the title prefix for each
#'    state-level plot.
#' @param xPlotLabel A character string specifying the label for the x-axis
#'    (which will appear vertically due to `coord_flip`).
#' @param yPlotLabel A character string specifying the label for the y-axis.
#' @param sleepTime Time in seconds to pause between plots. Default is 2
#'    seconds.
#'
#'
#' @return No return value. The function produces plots
#' @export
getStateGraphs <- function(dataset, dbHeader, states = NULL, plotTitle = "title",
                           xPlotLabel = "x axis", yPlotLabel = "y axis",
                           sleepTime = 2) {
  # Select relevant columns
  custom_data <- dataset %>%
    dplyr::select(TABWEIGHT, REGSTATE, dbHeader)

  # Determine states to plot
  selected_states <- if (is.null(states)) {
    sort(unique(custom_data$REGSTATE))
  } else {
    states
  }

  for (state in selected_states) {
    state_data <- custom_data %>%
      dplyr::filter(REGSTATE == state, !is.na({{ dbHeader }}), !is.na(TABWEIGHT))

    summary_data <- state_data %>%
      dplyr::group_by({{ dbHeader }}) %>%
      dplyr::summarise(estimated_vehicles = sum(TABWEIGHT), .groups = "drop") %>%
      dplyr::arrange(desc(estimated_vehicles))

    p <- ggplot2::ggplot(summary_data, aes(x = reorder({{ dbHeader }}, estimated_vehicles), y = estimated_vehicles, fill = {{ dbHeader }})) +
      ggplot2::geom_bar(stat = "identity") +
      ggplot2::coord_flip() +
      ggplot2::labs(
        title = paste(plotTitle, state),
        x = xPlotLabel,
        y = yPlotLabel,
        fill = xPlotLabel
      ) +
      ggplot2::theme_minimal(base_size = 13) +
      ggplot2::theme(
        plot.title = element_text(color = "white"),
        axis.title = element_text(color = "white"),
        axis.text = element_text(color = "white"),
        legend.position = "none",
        panel.grid.major = element_line(color = "gray30"),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "black"),
        plot.background = element_rect(fill = "black")
      )

    print(p)
    Sys.sleep(sleepTime)
  }
}
