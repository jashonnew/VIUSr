getBtypeGraphs <- function(dataset, dbHeader, plotTitle = "Title",
                           xPlotLabel = "x axis", yPlotLabel = "y axis") {
  # Select only needed columns
  custom_data <- dplyr::select(dataset, tidyselect::all_of(c("TABWEIGHT",
                                                             "BTYPE",
                                                             dbHeader)))
  dbHeader_sym <- rlang::sym(dbHeader)
  #Include tabweight to get estimates of total vehicles of certain types
  summary_data <- custom_data |>
    dplyr::summarise(estimated_vehicles = sum(TABWEIGHT), .groups = "drop") |>
    dplyr::arrange(dplyr::desc(estimated_vehicles))
  # Convert to factor for categorical coloring
  summary_data[[dbHeader]] <- as.factor(summary_data[[dbHeader]])
  head(summary_data)

  p <- ggplot2::ggplot(summary_data,
                       ggplot2::aes(x = ,
                                    y = dbHeader_sym,
                                    fill = !!dbHeader_sym)) +
    ggplot2::geom_bar(stat = "identity") +
    ggplot2::coord_flip() +
    ggplot2::labs(
      title = plotTitle,
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
  p
}
