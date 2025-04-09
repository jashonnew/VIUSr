vius <- read_csv("data-raw/vius_2021_puf.csv")

# Define numeric mapping for codes 1 to 7
code_to_value <- c(
  "1" = 50,
  "2" = mean(c(100, 499)),
  "3" = mean(c(500, 999)),
  "4" = mean(c(1000, 1999)),
  "5" = mean(c(2000, 4999)),
  "6" = mean(c(5000, 9999)),
  "7" = 10000
)

# Filter out rows where GM_COST is "8" or "X"
vius_clean <- subset(vius, GM_COST %in% names(code_to_value))

# Apply the mapping
vius_clean$GM_COST_NUM <- code_to_value[vius_clean$GM_COST]

plot(vius_clean$GM_COST)

