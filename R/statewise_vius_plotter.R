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
getStateGraphs <- function(dataset, dbHeader, states = NULL, plotTitle = "State - ",
                           xPlotLabel = "x axis", yPlotLabel = "y axis",
                           sleepTime = 2) {
  # Convert column name from string to symbol
  dbHeader_sym <- rlang::sym(dbHeader)
  
  # Select only needed columns
  custom_data <- dplyr::select(dataset, tidyselect::all_of(c("TABWEIGHT", "REGSTATE", dbHeader)))
  
  # Determine which states to process
  selected_states <- if (is.null(states)) {
    sort(unique(custom_data$REGSTATE))
  } else {
    states
  }
  
  for (state in selected_states) {
    state_data <- dplyr::filter(custom_data, REGSTATE == state,
                                !is.na(.data[[dbHeader]]),
                                !is.na(TABWEIGHT))
    
    summary_data <- state_data %>%
      dplyr::group_by(!!dbHeader_sym) %>%
      dplyr::summarise(estimated_vehicles = sum(TABWEIGHT), .groups = "drop") %>%
      dplyr::arrange(dplyr::desc(estimated_vehicles))
    
    # Convert to factor for categorical coloring
    summary_data[[dbHeader]] <- as.factor(summary_data[[dbHeader]])
    
    p <- ggplot2::ggplot(summary_data,
                         ggplot2::aes(x = stats::reorder(!!dbHeader_sym, estimated_vehicles),
                                      y = estimated_vehicles,
                                      fill = !!dbHeader_sym)) +
      ggplot2::geom_bar(stat = "identity") +
      ggplot2::coord_flip() +
      ggplot2::labs(
        title = paste(plotTitle, state),
        x = xPlotLabel,
        y = yPlotLabel,
        fill = xPlotLabel
      ) +
      ggplot2::scale_fill_manual(
        values = grDevices::topo.colors(length(unique(summary_data[[dbHeader]])))
      ) +
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
    
    print(p)
    base::Sys.sleep(sleepTime)
  }
}
