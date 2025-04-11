library(dplyr)
library(ggplot2)

# Load dataset
dataset <- read.csv("../data-raw/vius_2021_puf.csv")

# Load only necessary columns
custom_data <- dataset %>%
  select(TABWEIGHT, PRIMCOMMACT, REGSTATE)

# Define PRIMCOMMACT labels (from VIUS data dictionary)
primcommact_labels <- c(
  "01" = "For-hire transportation",
  "02" = "Private transportation support",
  "03" = "Construction",
  "04" = "Agriculture",
  "05" = "Forestry",
  "06" = "Fishing",
  "07" = "Mining",
  "08" = "Utilities",
  "09" = "Manufacturing",
  "10" = "Retail trade",
  "11" = "Wholesale trade",
  "12" = "Services",
  "13" = "Government",
  "14" = "Household",
  "15" = "Not reported"
)

# Clean and prepare data
custom_data_clean <- custom_data %>%
  filter(
    !is.na(PRIMCOMMACT),
    !is.na(REGSTATE),
    !is.na(TABWEIGHT),
    PRIMCOMMACT != "X",
    PRIMCOMMACT %in% names(primcommact_labels)
  ) %>%
  mutate(
    PRIMCOMMACT = as.numeric(PRIMCOMMACT),
    PRIMCOMMACT_LABEL = factor(
      primcommact_labels[as.character(PRIMCOMMACT)],
      levels = primcommact_labels
    )
  )

# Summarize: weighted vehicle counts by state and PRIMCOMMACT
primcommact_counts <- custom_data_clean %>%
  group_by(REGSTATE, PRIMCOMMACT_LABEL) %>%
  summarise(estimated_vehicles = sum(TABWEIGHT, na.rm = TRUE), .groups = "drop")

# Get list of all states
states <- sort(unique(custom_data_clean$REGSTATE))

# Loop through each state and plot
for (state in states) {
  state_data <- custom_data_clean %>%
    filter(REGSTATE == state, !is.na(PRIMCOMMACT_LABEL))

  summary_data <- state_data %>%
    group_by(PRIMCOMMACT_LABEL) %>%
    summarise(estimated_vehicles = sum(TABWEIGHT), .groups = "drop") %>%
    arrange(desc(estimated_vehicles))

  p <- ggplot(summary_data, aes(x = reorder(PRIMCOMMACT_LABEL, estimated_vehicles), y = estimated_vehicles, fill = PRIMCOMMACT_LABEL)) +
    geom_bar(stat = "identity") +
    coord_flip() +
    labs(
      title = paste("Estimated Vehicles by Primary Commodity Activity -", state),
      x = "Primary Commodity Activity",
      y = "Estimated Vehicles",
      fill = "Commodity Activity"
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
