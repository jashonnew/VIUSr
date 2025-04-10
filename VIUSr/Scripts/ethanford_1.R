
library(dplyr)
library(ggplot2)

# Load dataset
dataset <- read.csv("../data-raw/vius_2021_puf.csv")

# Load only necessary columns
custom_data <- dataset %>%
  select(TABWEIGHT, PRIMPROD, REGSTATE)

# Define PRIMPROD labels (from data dictionary)
primprod_labels <- c(
  "01" = "Animals and fish, live",
  "02" = "Animal feed and animal products",
  "03" = "Grains, cereal",
  "04" = "Other agricultural products",
  "05" = "Basic chemicals",
  "06" = "Fertilizers",
  "07" = "Pharmaceuticals",
  "08" = "Other chemical products",
  "09" = "Alcoholic beverages",
  "10" = "Bakery/grain products",
  "11" = "Meat and seafood",
  "12" = "Tobacco products",
  "13" = "Other prepared foodstuffs",
  "14" = "Logs and raw wood",
  "15" = "Paper articles",
  "16" = "Printed products",
  "17" = "Pulp and paper",
  "18" = "Wood products",
  "19" = "Articles of base metal",
  "20" = "Base metal forms",
  "21" = "Nonmetallic mineral products",
  "22" = "Electronics and electrical",
  "23" = "Furniture and lamps",
  "24" = "Machinery",
  "25" = "Miscellaneous manufactured",
  "26" = "Precision instruments",
  "27" = "Textiles and leather",
  "28" = "Vehicles and parts",
  "29" = "Other transportation equipment",
  "30" = "Coal",
  "31" = "Crude petroleum",
  "32" = "Gravel or stone",
  "33" = "Metallic ores",
  "34" = "Building stone",
  "35" = "Natural sands",
  "36" = "Other nonmetallic minerals",
  "37" = "Fuel oils",
  "38" = "Gasoline and blends",
  "39" = "Aviation fuel and kerosene",
  "40" = "Ethanol blends",
  "41" = "Plastics and rubber",
  "42" = "Other petroleum products",
  "43" = "Hazardous waste",
  "44" = "Other waste and scrap",
  "45" = "Recyclable products",
  "46" = "Mail and parcels",
  "47" = "Empty containers",
  "48" = "Mixed freight"
)

custom_data_clean <- custom_data %>%
  filter(
    !is.na(PRIMPROD),
    !is.na(REGSTATE),
    !is.na(TABWEIGHT),
    PRIMPROD != "X",
    PRIMPROD != "98",  # Remove 'Other unlisted products'
    PRIMPROD != "99",  # Remove 'Not reported'
    PRIMPROD != "49"   # NEW: Remove unknown or undefined PRIMPROD code
  ) %>%
  mutate(
    PRIMPROD = as.numeric(PRIMPROD),
    PRIMPROD_LABEL = factor(
      primprod_labels[as.character(PRIMPROD)],
      levels = unique(primprod_labels)
    )
  )




# Summarize: weighted vehicle counts by state and product
primprod_counts <- custom_data_clean %>%
  group_by(REGSTATE, PRIMPROD_LABEL) %>%
  summarise(estimated_vehicles = sum(TABWEIGHT, na.rm = TRUE), .groups = "drop")

# Set state to California
states <- sort(unique(custom_data_clean$REGSTATE))


for (state in states) {
  state_data <- custom_data_clean %>%
    filter(REGSTATE == state, !is.na(PRIMPROD_LABEL))

  # Summarize by product label (not raw data rows)
  summary_data <- state_data %>%
    group_by(PRIMPROD_LABEL) %>%
    summarise(estimated_vehicles = sum(TABWEIGHT), .groups = "drop") %>%
    arrange(desc(estimated_vehicles))

  p <- ggplot(summary_data, aes(x = reorder(PRIMPROD_LABEL, estimated_vehicles), y = estimated_vehicles, fill = PRIMPROD_LABEL)) +
    geom_bar(stat = "identity") +
    coord_flip() +
    labs(
      title = paste("Estimated Vehicles by Primary Product -", state),
      x = "Primary Product",
      y = "Estimated Vehicles",
      fill = "Primary Product"
    ) +
    theme_minimal(base_size = 13) +
    theme(
      plot.title = element_text(color = "white"),
      axis.title = element_text(color = "white"),
      axis.text = element_text(color = "white"),
      legend.position = "none",  # Optional: hide legend if labels are clear
      panel.grid.major = element_line(color = "gray30"),
      panel.grid.minor = element_blank(),
      panel.background = element_rect(fill = "black"),
      plot.background = element_rect(fill = "black")
    )

  print(p)
  Sys.sleep(2)
}
