pacman::p_load(tidyverse, patchwork, purrr, sf)


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

datavs <- dat %>% mutate(weightT = as.numeric(TABWEIGHT)*as.numeric(AVGWEIGHT)) %>%
  select(REGSTATE, weightT, TABWEIGHT) %>%
  group_by(REGSTATE) %>%
  summarise(TWeight = sum(weightT, na.rm = TRUE), TTab = sum(TABWEIGHT)) %>%
  mutate(TWeight/TTab)





