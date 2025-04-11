getAllStates <- function(dbHeader, labelMap, plotTitle, xPlotLabel, yPlotLabel) {
  library(dplyr)
  library(ggplot2)

  dataset <- read.csv("../data-raw/vius_2021_puf.csv")

  labels <- labelMap

  custom_data_clean <- dataset %>%
    select(TABWEIGHT, REGSTATE, {{ dbHeader }}) %>%
    filter(
      !is.na({{ dbHeader }}),
      !is.na(REGSTATE),
      !is.na(TABWEIGHT),
      {{ dbHeader }} != "X"
    ) %>%
    mutate(
      CATEGORY = as.numeric({{ dbHeader }}),
      CATEGORY_LABEL = factor(
        labels[as.character(CATEGORY)],
        levels = unique(labels)
      )
    )

  states <- sort(unique(custom_data_clean$REGSTATE))

  for (state in states) {
    state_data <- custom_data_clean %>%
      filter(REGSTATE == state, !is.na(CATEGORY_LABEL))

    summary_data <- state_data %>%
      group_by(CATEGORY_LABEL) %>%
      summarise(estimated_vehicles = sum(TABWEIGHT), .groups = "drop") %>%
      arrange(desc(estimated_vehicles))

    p <- ggplot(summary_data, aes(x = reorder(CATEGORY_LABEL, estimated_vehicles), y = estimated_vehicles, fill = CATEGORY_LABEL)) +
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
    Sys.sleep(2)
  }
}

getState <- function(dbHeader, state, labelMap, plotTitle, xPlotLabel, yPlotLabel){
  library(dplyr)
  library(ggplot2)

  dataset <- read.csv("../data-raw/vius_2021_puf.csv")

  labels <- labelMap

  custom_data_clean <- dataset %>%
    select(TABWEIGHT, REGSTATE, {{ dbHeader }}) %>%
    filter(
      !is.na({{ dbHeader }}),
      !is.na(REGSTATE),
      !is.na(TABWEIGHT),
      {{ dbHeader }} != "X"
    ) %>%
    mutate(
      CATEGORY = as.numeric({{ dbHeader }}),
      CATEGORY_LABEL = factor(
        labels[as.character(CATEGORY)],
        levels = unique(labels)
      )
    )

    state_data <- custom_data_clean %>%
      filter(REGSTATE == state, !is.na(CATEGORY_LABEL))

    summary_data <- state_data %>%
      group_by(CATEGORY_LABEL) %>%
      summarise(estimated_vehicles = sum(TABWEIGHT), .groups = "drop") %>%
      arrange(desc(estimated_vehicles))

    p <- ggplot(summary_data, aes(x = reorder(CATEGORY_LABEL, estimated_vehicles), y = estimated_vehicles, fill = CATEGORY_LABEL)) +
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
}







