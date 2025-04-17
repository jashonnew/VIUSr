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
get_state_graphs <- function(dataset, dbHeader, states = NULL, plotTitle = "State - ",
                             xPlotLabel = "x axis", yPlotLabel = "y axis",
                             sleepTime = 2) {
  # Convert column name from string to symbol
  db_header_sym <- rlang::sym(dbHeader)

  # Select only needed columns
  custom_data <- dplyr::select(dataset, tidyselect::all_of(c("TABWEIGHT", "REGSTATE", dbHeader)))

  # Determine which states to process
  selected_states <- if (is.null(states)) {
    sort(unique(custom_data$REGSTATE))
  } else {
    states
  }

  for (state in selected_states) {
    state_data <- dplyr::filter(
      custom_data, REGSTATE == state,
      !is.na(.data[[dbHeader]]),
      !is.na(TABWEIGHT)
    )

    summary_data <- state_data %>%
      dplyr::group_by(!!dbHeader_sym) %>%
      dplyr::summarise(estimated_vehicles = sum(TABWEIGHT), .groups = "drop") %>%
      dplyr::arrange(dplyr::desc(estimated_vehicles))

    # Convert to factor for categorical coloring
    summary_data[[dbHeader]] <- as.factor(summary_data[[dbHeader]])

    p <- ggplot2::ggplot(
      summary_data,
      ggplot2::aes(
        x = stats::reorder(!!dbHeader_sym, estimated_vehicles),
        y = estimated_vehicles,
        fill = !!dbHeader_sym
      )
    ) +
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

#' Create a heatmap of the Unites States
#'
#' This function creates an interactive map of the United States. The color of
#'   each state in the map will depend on a variable available in the VIUS
#'   dataset. The user can select which variable to map out across the United
#'   States and the label for the variable. Then, when the user hovers over a
#'   state with their cursor, the map will display the state and the
#'   corresponding value of the variable for that state.
#'
#' @param vius The VIUS dataset. This should be a reference to the cleaned VIUS
#'   dataset available within the VIUSr package.
#' @param var The column of the VIUS dataset. Must be a column of numeric
#'   values in the cleaned VIUS dataset available within the VIUSr package.
#'   Options are AVGWEIGHT (average vehicle weight), ER_COST (average cost of
#'   extensive vehicle repairs), GM_COST (average cost of general vehicle
#'   maintenance), MILESANNL (average miles traveled per vehicle in the year
#'   of the survey), MILESLIFE (average miles traveled per vehicle since the
#'   vehicle was manufactured), MPG (average miles per gallon), TRIPOFFROAD
#'   (The average percentage of miles driven off-road per vehicle)
#' @param var_label A string representing the label the user would like to see
#'   on the map for the value of the selected variable. If no value is entered,
#'   the label will simply say "value."
#' @param dollars A boolean value. Defaults to False. If true, will append a "$"
#'   character to the value when displayed on the map.
#' @returns A plotly map of the United States with darker states representing
#'   higher values of the selected variable.
#' @examples
#' getStateMaps(vius, var = MILESANNL, var_label = "Average annual miles")
#' getStateMaps(vius,
#'   var = GM_COST,
#'   var_label = "Average amount spent on general maintenance",
#'   dollars = TRUE
#' )
#' @export
get_state_maps <- function(vius, var, var_label = "Value", dollars = FALSE) {
  var <- rlang::enquo(var)

  # Set geographic projection data
  geo1 <- list(
    scope = "usa", projection = list(type = "albers usa"),
    showlakes = TRUE, lakecolor = plotly::toRGB("white")
  )

  custom_data <- vius |>
    dplyr::select(TABWEIGHT, REGSTATE, {{ var }}) |>
    dplyr::filter(is.numeric({{ var }})) |>
    dplyr::filter({{ var }} > 0) |>
    dplyr::group_by(REGSTATE) |>
    dplyr::mutate(total = sum(TABWEIGHT * {{ var }}) / sum(TABWEIGHT)) |>
    dplyr::mutate(total = round(total, 2))

  # Create the template for the map's hover box
  if (dollars) {
    custom_data$hover <- with(
      custom_data,
      paste("State: ", custom_data$REGSTATE,
        "<br>", var_label, ": $", custom_data$total,
        sep = ""
      )
    )
  } else {
    custom_data$hover <- with(
      custom_data,
      paste("State: ", custom_data$REGSTATE,
        "<br>", var_label, ": ", custom_data$total,
        sep = ""
      )
    )
  }

  # Create the map of the country with the specified variable
  state_map <- plotly::plot_geo(custom_data, locationmode = "USA-states") |>
    plotly::add_trace(
      z = ~total, text = ~hover, locations = ~REGSTATE,
      color = ~total, colors = "Blues", hoverinfo = "text"
    ) |>
    plotly::layout(geo = geo1)
  state_map
}
