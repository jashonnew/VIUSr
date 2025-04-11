pacman::p_load(tidyverse, patchwork, purrr, sf, usmap, plotly)


dat <- read_csv("data-raw/vius_2021_puf.csv")


dat <- dat %>% mutate(across(where(is.character), as.factor))

# Identify column types
num_cols <- dat %>% select(where(is.numeric)) %>% names()
cat_cols <- dat %>% select(where(is.factor)) %>% names()

# Plot numeric distributions
num_plots <- map(num_cols, ~ ggplot(dat, aes(x = .data[[.x]])) +
                   geom_histogram(bins = 30, fill = "blue", alpha = 0.7) +
                   labs(title = paste("Distribution of", .x)) +
                   theme_minimal())

# Plot categorical distributions
cat_plots <- map(cat_cols, ~ ggplot(dat, aes(x = .data[[.x]])) +
                   geom_bar(fill = "orange", alpha = 0.7) +
                   labs(title = paste("Count of", .x)) +
                   theme_minimal())

# Combine all plots
all_plots <- c(num_plots, cat_plots)

# Function to display 10 plots at a time
show_plots <- function(page_num = 1, page_size = 10) {
  start <- (page_num - 1) * page_size + 1
  end <- min(start + page_size - 1, length(all_plots))

  if (start > length(all_plots)) {
    message("No more plots to display.")
    return(NULL)
  }

  wrap_plots(all_plots[start:end], ncol = 2)
}

# Example: Show the first 10 plots
show_plots(page_num = 1)

# Example: Show the second set of 10 plots
# show_plots(page_num = 2)

datavs <- dat %>% mutate(AVGWEIGHT = case_when(
  AVGWEIGHT == 1 ~ 3000,
  AVGWEIGHT == 2 ~ 7250,
  AVGWEIGHT == 3 ~ 9250,
  AVGWEIGHT == 4 ~ 12000,
  AVGWEIGHT == 5 ~ 15000,
  AVGWEIGHT == 6 ~ 17750,
  AVGWEIGHT == 7 ~ 22750,
  AVGWEIGHT == 8 ~ 29500,
  AVGWEIGHT == 9 ~ 36500,
  AVGWEIGHT == 10 ~ 45000,
  AVGWEIGHT == 11 ~ 55000,
  AVGWEIGHT == 12 ~ 70000,
  AVGWEIGHT == 13 ~ 90000,
  AVGWEIGHT == 14 ~ 115000,
  TRUE ~ 130000
)) %>% mutate(weightT = as.numeric(TABWEIGHT)*as.numeric(AVGWEIGHT)) %>%
  select(REGSTATE, weightT, TABWEIGHT) %>%
  group_by(REGSTATE) %>%
  summarise(TWeight = sum(weightT, na.rm = TRUE), TTab = sum(TABWEIGHT)) %>%
  mutate(avgwt = TWeight/TTab)


States <- usmap::us_map(regions = "states")

left_join(datavs, States, by = join_by(REGSTATE == abbr)) %>%
  ggplot() +
  geom_sf(aes(geometry = geom, fill = avgwt)) +
  scale_color_gradient()

data_joined <- left_join(datavs, States, by = join_by(REGSTATE == abbr))

plot_ly(
  data = data_joined,
  type = "choropleth",
  locations = ~REGSTATE,         # State abbreviations
  locationmode = "USA-states",   # Use 2-letter state codes
  z = ~avgwt,                    # The variable to color by
  colorscale = "Viridis",
  colorbar = list(title = "Average Weight")
) %>%
  layout(
    title = "Average Weight by State",
    geo = list(
      scope = "usa",
      projection = list(type = "albers usa"),
      showland = TRUE,
      landcolor = toRGB("gray95"),
      subunitcolor = toRGB("white"),
      showlakes = TRUE,
      lakecolor = "white"
    )
  )


