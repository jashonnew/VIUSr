vius_raw_sample <- readr::read_csv("data-raw/vius_2021_puf.csv")

vius_raw_sample <- vius_raw_sample |>
  head(n = 100)

usethis::use_data(vius_raw_sample, overwrite = TRUE)
