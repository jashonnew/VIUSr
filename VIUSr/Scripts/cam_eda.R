library(tidyverse)
library(plotly)

vius <- read_csv("~/Downloads/vius_2021_puf.csv")

vius$MODELYEAR <- str_replace_all(vius$MODELYEAR, "P", "") |>
  as.numeric()
vius$MODELYEAR <- (vius$MODELYEAR + 1) %% 100
mean(vius$MODELYEAR) - 1

vius <- vius |>
  filter(AVGWEIGHT != "X") |>
  mutate(AVGWEIGHT = as.numeric(AVGWEIGHT)) |>
  mutate(AVGWEIGHT = case_when(
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
  ))

vius <- vius |>
  filter(GM_COST != 'X' & GM_COST != '8') |>
  mutate(GM_COST = as.numeric(GM_COST)) |>
  mutate(GM_COST = case_when(
    GM_COST == 1 ~ 50,
    GM_COST == 2 ~ 250,
    GM_COST == 3 ~ 750,
    GM_COST == 4 ~ 1500,
    GM_COST == 5 ~ 3000,
    GM_COST == 6 ~ 7500,
    TRUE ~ 10000
  ))

vius <- vius |>
  filter(ER_COST != '7') |>
  mutate(ER_COST = case_when(
    ER_COST == '1' ~ 750,
    ER_COST == '2' ~ 1500,
    ER_COST == '3' ~ 3000,
    ER_COST == '4' ~ 7500,
    ER_COST == '5' ~ 15000,
    ER_COST == '6' ~ 20000,
    TRUE ~ 0
  ))

miles <- vius |>
  select(TABWEIGHT, REGSTATE, MILESANNL) |>
  group_by(REGSTATE) |>
  mutate(totalMiles = sum(TABWEIGHT * MILESANNL))

dollars <- vius |>
  select(TABWEIGHT, REGSTATE, GM_COST) |>
  group_by(REGSTATE) |>
  mutate(dollarsSpent = sum(TABWEIGHT * GM_COST) / sum(TABWEIGHT)) |>
  mutate(dollarsSpent = round(dollarsSpent, 2))

extensive <- vius |>
  select(TABWEIGHT, REGSTATE, ER_COST) |>
  filter(ER_COST > 0) |>
  group_by(REGSTATE) |>
  mutate(dollarsSpent = sum(TABWEIGHT * ER_COST) / sum(TABWEIGHT)) |>
  mutate(dollarsSpent = round(dollarsSpent, 2), count = round(TABWEIGHT, 0))

g1 <- list(scope = 'usa', projection = list(type = 'albers usa'), showlakes = TRUE, lakecolor = toRGB("white"))

miles$hover <- with(miles, paste("State: ", miles$REGSTATE, "<br>", "Miles: ",
                                 miles$totalMiles))

dollars$hover <- with(dollars, paste("State: ", dollars$REGSTATE, "<br>",
                                     "Average repair costs: $",
                                     dollars$dollarsSpent, sep = ""))

extensive$hover <- with(extensive, paste("State: ", extensive$REGSTATE, "<br>",
                                         "Vehicles requiring extensive repairs: ",
                                         extensive$count, "<br>",
                                       "Average repair costs: $",
                                       extensive$dollarsSpent, sep = ""))

averageRepairs <- plot_geo(dollars, locationmode = "USA-states") |>
  add_trace(z = ~dollarsSpent, text = ~hover, locations = ~REGSTATE,
            color = ~dollarsSpent, colors = 'Blues',
            hoverinfo = "text") |>
  layout(geo = g1)
averageRepairs

extensiveRepairs <- plot_geo(extensive, locationmode = "USA-states") |>
  add_trace(z = ~dollarsSpent, text = ~hover, locations = ~REGSTATE,
            color = ~dollarsSpent, colors = 'Blues',
            hoverinfo = "text") |>
  layout(geo = g1)
extensiveRepairs
