
test_that("drop_cols removes unwanted columns", {
  cleaned <- drop_cols(vius_raw_sample)
  expect_false("some_column_to_drop" %in% names(cleaned))  # replace w col name
  expect_true(is.data.frame(cleaned))
})

# Load the sample data included in the package
data("vius_raw_sample")

test_that("drop_cols removes unwanted columns and returns a data frame", {
  cleaned <- drop_cols(vius_raw_sample)
  expect_true(is.data.frame(cleaned))
})

test_that("char_to_num converts character to numeric where appropriate", {
  cleaned_step1 <- drop_cols(vius_raw_sample)
  converted <- char_to_num(cleaned_step1)

  # Find numeric-looking variables in original character columns

  for (col in c("AVGWEIGHT", "GM_COST", "ER_COST", "MPG")) {
    expect_type(dplyr::pull(converted, col), "double")
  }


})

test_that("convert_names properly recodes categorical variables", {
  # Load test data
  data("vius_raw_sample", package = "VIUSr")

  # Run conversion
  converted <- convert_names(vius_raw_sample)

  # Check output is a data frame with same number of rows
  expect_s3_class(converted, "data.frame")
  expect_equal(nrow(converted), nrow(vius_raw_sample))

  # PRIMPROD is a factor with expected levels
  expect_true("PRIMPROD" %in% names(converted))
  expect_s3_class(converted$PRIMPROD, "factor")
  expect_equal(levels(converted$PRIMPROD)[1], "Animals and fish, live")

  # BTYPE correctly mapped
  expect_true("BTYPE" %in% names(converted))
  expect_true(all(converted$BTYPE %in% c(
    "Pickup", "Minvan", "Other light van", "Sport utility vehicle", "Armored",
    "Beverage or bay", "Box truck", "Concrete mixer", "Concrete pumper",
    "Conveyor bed", "Crane", "Dump", "Flatbed, stake, or platform",
    "Hooklift/roll-off", "Logging", "Service, utility", "Service, other",
    "Street sweeper", "Tank, liquid or gases", "Tow/wrecker",
    "Trash, garbage, or recycling", "Vacuum", "Van, walk-in",
    "Van, other", "Wood chipper", "Other", "Not reported", NA_character_
  )))

  # FUELTYPE correctly mapped
  expect_true("FUELTYPE" %in% names(converted))
  expect_true("Gasoline" %in% unique(converted$FUELTYPE))

  # KINDOFBUS and PRIMCOMMACT are character vectors with mapped values
  expect_type(converted$KINDOFBUS, "character")
  expect_type(converted$PRIMCOMMACT, "character")
  expect_true("Transporting tools related to owner's business"
              %in% converted$PRIMCOMMACT)
})

test_that("get_btype_graphs returns a ggplot object", {
  cleaned <- convert_names(char_to_num(drop_cols(vius_raw_sample)))
  plot <- get_btype_graphs(
    vius1 = cleaned,
    var = MPG,
    plot_title = "Test Plot",
    x_plot_label = "Type",
    y_plot_label = "Value"
  )
  expect_s3_class(plot, "ggplot")
})

test_that("get_state_maps returns a plotly map", {
  cleaned <- convert_names(char_to_num(drop_cols(vius_raw_sample)))
  map <- get_state_maps(
    vius = cleaned,
    var = MPG,
    var_label = "MPG",
    dollars = FALSE
  )
  expect_s3_class(map, "plotly")
})
