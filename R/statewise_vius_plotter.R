getStateGraphs <- function(dbHeader, states = NULL, plotTitle, xPlotLabel, yPlotLabel, sleepTime = 2) {
  library(dplyr)
  library(ggplot2)
  
  dataset <- read.csv("../data-raw/vius_2021_puf.csv")
  
  # Select relevant columns
  custom_data <- dataset %>%
    select(TABWEIGHT, REGSTATE, {{ dbHeader }})
  
  # Determine states to plot
  selected_states <- if (is.null(states)) {
    sort(unique(custom_data$REGSTATE))
  } else {
    states
  }
  
  for (state in selected_states) {
    state_data <- custom_data %>%
      filter(REGSTATE == state, !is.na({{ dbHeader }}), !is.na(TABWEIGHT))
    
    summary_data <- state_data %>%
      group_by({{ dbHeader }}) %>%
      summarise(estimated_vehicles = sum(TABWEIGHT), .groups = "drop") %>%
      arrange(desc(estimated_vehicles))
    
    p <- ggplot(summary_data, aes(x = reorder({{ dbHeader }}, estimated_vehicles), y = estimated_vehicles, fill = {{ dbHeader }})) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(
        title = paste(plotTitle, state),
        x = xPlotLabel,
        y = yPlotLabel,
        fill = xPlotLabel
      ) +
      theme_minimal(base_size = 13) +
      theme(
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