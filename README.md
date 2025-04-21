
<!-- README.md is generated from README.Rmd. Please edit that file -->

# VIUSr

<!-- badges: start -->

[![R-CMD-check](https://github.com/jashonnew/VIUSr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jashonnew/VIUSr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Overview

**`VIUSr`** is an R package developed to facilitate the cleaning,
exploration, and visualization of data from the 2021 Vehicle Inventory
and Use Survey (VIUS) conducted across the United States. This package
provides a suite of tools to streamline the workflow from raw data to
actionable insights, supporting users in extracting meaningful patterns
at both national and state levels.

## Key Features

- **Automated Data Cleaning**: Efficiently prepares raw VIUS 2021 data
  into a tidy, analysis-ready format with minimal user intervention.
  Cleaning functions added include `convert_names`, `drop_bad_values`,
  and `charToNum`.
- **State-Level Exploration**: Generate focused summaries and
  visualizations for individual U.S. states to understand regional
  vehicle usage patterns.
- **Cross-State Comparison**: Compare metrics across states to identify
  trends and outliers in vehicle inventory and usage.
- **National Overview**: Access high-level summaries and visual
  representations of key statistics across the entire U.S.
- **Built-In Visualization Tools**: Create interactive and
  publication-ready plots, including maps and charts, with intuitive
  functions designed for ease of use.

`VIUSr` is ideal for transportation analysts, researchers, policy
makers, and data professionals seeking to work with VIUS 2021 data in a
reproducible and interpretable manner.

While many columns from the VIUS dataset are included in our cleaned
version of the 2021 data within the package, using a future year’s data
with the package or using any of the columns that we chose not to
include will require a local download of the dataset upon which you can
then apply our cleaning functions and subsequently use our graphing
functions.

## Installation

You can install the development version of VIUSr from
[jashonnew/VIUSr](https://github.com/jashonnew/VIUSr) with:

``` r
install.packages("jashonnew/VIUSr")
```

## Data Cleaning

This package contains a cleaned version of the 2021 VIUS data set. Three
functions, `drop_cols`, `char_to_num`, and `convert_names`, have been
included in the package to enable users to clean future editions of the
VIUS data set in the same way that the data has been cleaned herein.
Each function only takes one argument, the VIUS data set that the user
would like to clean. Future releases of the VIUS data set can be passed
through these functions to prepare them for use with the VIUSr package.

The data set `vius_raw_sample` has been included in the package to
demonstrate the data cleaning functions. This data set includes the
first 100 rows of the VIUS data set with no cleaning.

``` r
library(VIUSr)

head(vius_raw_sample)
#> # A tibble: 6 × 168
#>   ID    TABWEIGHT REGSTATE ACQUIREYEAR ACQUISITION AVGWEIGHT BRAKES BTYPE
#>   <chr>     <dbl> <chr>    <chr>             <dbl> <chr>     <chr>  <chr>
#> 1 00001      38.5 MT       11                    2 14        3      X    
#> 2 00002     197.  NC       Z                     2 12        3      X    
#> 3 00003    1709   SD       21P                   2 01        X      04   
#> 4 00004      52   ID       03                    2 X         3      X    
#> 5 00005     286.  MO       Z                     2 01        1      13   
#> 6 00006    8593.  MD       20                    1 01        X      04   
#> # ℹ 160 more variables: BUSRELATED <dbl>, CAB <chr>, CABDAY <chr>,
#> #   CABHEIGHT <dbl>, CI_AUTOEBRAKE <dbl>, CI_AUTOESTEER <dbl>,
#> #   CI_RAUTOEBRAKE <dbl>, CUBICINCHDISP <chr>, CW_BLINDSPOT <dbl>,
#> #   CW_FWDCOLL <dbl>, CW_LANEDEPART <dbl>, CW_PARKOBST <dbl>,
#> #   CW_RCROSSTRAF <dbl>, CYLINDERS <chr>, DC_ACTDRIVASST <dbl>,
#> #   DC_ADAPCRUISE <dbl>, DC_LANEASST <dbl>, DC_PLATOON <dbl>, DC_VTVCOMM <dbl>,
#> #   DEADHEADPCT <chr>, DRIVEAXLES <dbl>, ENGREBUILD <chr>, ER_COMPOWN <chr>, …

vius_cleaned <- drop_cols(vius_raw_sample)
vius_cleaned <- char_to_num(vius_cleaned)
vius_cleaned <- convert_names(vius_cleaned)
head(vius_cleaned)
#> # A tibble: 6 × 17
#>   ID    TABWEIGHT REGSTATE ACQUIREYEAR AVGWEIGHT BTYPE  ER_COST FUELTYPE GM_COST
#>   <chr>     <dbl> <chr>          <dbl>     <dbl> <chr>    <dbl> <chr>      <dbl>
#> 1 00001      38.5 MT                11    115000 <NA>         0 Diesel      3000
#> 2 00002     197.  NC                NA     70000 <NA>         0 Diesel      7500
#> 3 00003    1709   SD                21      3000 Sport…       0 Gasoline     250
#> 4 00004      52   ID                 3    130000 <NA>         0 <NA>       10000
#> 5 00005     286.  MO                NA      3000 Flatb…       0 Gasoline   10000
#> 6 00006    8593.  MD                20      3000 Sport…       0 Gasoline     250
#> # ℹ 8 more variables: KINDOFBUS <chr>, MILESANNL <dbl>, MILESLIFE <dbl>,
#> #   MODELYEAR <dbl>, MPG <dbl>, PRIMCOMMACT <chr>, PRIMPROD <fct>,
#> #   TRIPOFFROAD <dbl>
```

## VIUS Plotting

### Vehicle Body Type Averages

The `get_btype_graphs()` function computes weighted averages by vehicle
body type and generates a horizontal bar chart.

``` r
get_btype_graphs(vius1 = vius_cleaned,
                 var = `MPG`,
                 plot_title = "Average MPG by Body Type",
                 x_plot_label = "Body Type",
                 y_plot_label = "Average Miles Per Gallon")
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

### Mapping State-Level Data

The `get_state_maps()` function visualizes state-level VIUS data on an
interactive U.S. map. This interactive plotting feature does not render
inside the `github_document` format but please try it for yourself with
the code below!

``` r
get_state_maps(vius = vius_cleaned,
               var = `MPG`,
               var_label = "Fuel Volume",
               dollars = FALSE)
```

<div class="plotly html-widget html-fill-item" id="htmlwidget-c0068b37a6a014002611" style="width:100%;height:480px;"></div>
<script type="application/json" data-for="htmlwidget-c0068b37a6a014002611">{"x":{"visdat":{"52304e194383":["function () ","plotlyVisDat"]},"cur_data":"52304e194383","attrs":{"52304e194383":{"locationmode":"USA-states","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"z":{},"text":{},"locations":{},"color":{},"colors":"Blues","hoverinfo":"text","inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"mapType":"geo","geo":{"domain":{"x":[0,1],"y":[0,1]},"scope":"usa","projection":{"type":"albers usa"},"showlakes":true,"lakecolor":"rgba(255,255,255,1)"},"scene":{"zaxis":{"title":"total"}},"hovermode":"closest","showlegend":false,"legend":{"yanchor":"top","y":0.5}},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"colorbar":{"title":"total","ticklen":2,"len":0.5,"lenmode":"fraction","y":1,"yanchor":"top"},"colorscale":[["0","rgba(247,251,255,1)"],["0.0416666666666667","rgba(239,246,252,1)"],["0.0833333333333333","rgba(230,240,250,1)"],["0.125","rgba(222,235,247,1)"],["0.166666666666667","rgba(214,230,244,1)"],["0.208333333333333","rgba(206,224,242,1)"],["0.25","rgba(198,219,239,1)"],["0.291666666666667","rgba(185,213,234,1)"],["0.333333333333333","rgba(172,208,230,1)"],["0.375","rgba(158,202,225,1)"],["0.416666666666667","rgba(142,193,221,1)"],["0.458333333333333","rgba(125,183,218,1)"],["0.5","rgba(107,174,214,1)"],["0.541666666666667","rgba(94,165,209,1)"],["0.583333333333333","rgba(81,155,203,1)"],["0.625","rgba(66,146,198,1)"],["0.666666666666667","rgba(57,135,192,1)"],["0.708333333333333","rgba(46,124,187,1)"],["0.75","rgba(33,113,181,1)"],["0.791666666666667","rgba(27,102,173,1)"],["0.833333333333333","rgba(19,91,164,1)"],["0.875","rgba(8,81,156,1)"],["0.916666666666667","rgba(9,70,139,1)"],["0.958333333333333","rgba(9,59,123,1)"],["1","rgba(8,48,107,1)"]],"showscale":true,"locationmode":"USA-states","z":[5,10.59,23,21.760000000000002,5,7,6,12,13.85,10.619999999999999,10,10.619999999999999,20,1,15,6.9199999999999999,6,10.19,14,12,10.19,21.760000000000002,10,7.7199999999999998,10,9,12.1,21.760000000000002,4,12,15.59,12.1,18,7.7199999999999998,15.59,10.59,6.9199999999999999,12,10,7.7199999999999998,24.91,10.59,6,14,10.710000000000001,14.65,18.489999999999998,10.59,24.91,10.59,13.800000000000001,13.85,20,14.65,13.85,21.760000000000002,20,15.59,7,14.65,10.710000000000001,6,8.5800000000000001,5,18.489999999999998,5,8.5800000000000001,6.9199999999999999,18.489999999999998,18,5,13.800000000000001],"text":["State: MT<br>Fuel Volume: 5","State: NC<br>Fuel Volume: 10.59","State: SD<br>Fuel Volume: 23","State: MD<br>Fuel Volume: 21.76","State: GA<br>Fuel Volume: 5","State: NJ<br>Fuel Volume: 7","State: OH<br>Fuel Volume: 6","State: HI<br>Fuel Volume: 12","State: UT<br>Fuel Volume: 13.85","State: WV<br>Fuel Volume: 10.62","State: MA<br>Fuel Volume: 10","State: WV<br>Fuel Volume: 10.62","State: KY<br>Fuel Volume: 20","State: AZ<br>Fuel Volume: 1","State: CO<br>Fuel Volume: 15","State: VT<br>Fuel Volume: 6.92","State: LA<br>Fuel Volume: 6","State: AL<br>Fuel Volume: 10.19","State: NM<br>Fuel Volume: 14","State: MN<br>Fuel Volume: 12","State: AL<br>Fuel Volume: 10.19","State: MD<br>Fuel Volume: 21.76","State: NY<br>Fuel Volume: 10","State: TX<br>Fuel Volume: 7.72","State: MA<br>Fuel Volume: 10","State: ID<br>Fuel Volume: 9","State: CA<br>Fuel Volume: 12.1","State: MD<br>Fuel Volume: 21.76","State: IL<br>Fuel Volume: 4","State: IN<br>Fuel Volume: 12","State: DE<br>Fuel Volume: 15.59","State: CA<br>Fuel Volume: 12.1","State: ME<br>Fuel Volume: 18","State: TX<br>Fuel Volume: 7.72","State: DE<br>Fuel Volume: 15.59","State: NC<br>Fuel Volume: 10.59","State: VT<br>Fuel Volume: 6.92","State: AR<br>Fuel Volume: 12","State: KS<br>Fuel Volume: 10","State: TX<br>Fuel Volume: 7.72","State: CT<br>Fuel Volume: 24.91","State: NC<br>Fuel Volume: 10.59","State: FL<br>Fuel Volume: 6","State: NM<br>Fuel Volume: 14","State: RI<br>Fuel Volume: 10.71","State: IA<br>Fuel Volume: 14.65","State: SC<br>Fuel Volume: 18.49","State: NC<br>Fuel Volume: 10.59","State: CT<br>Fuel Volume: 24.91","State: NC<br>Fuel Volume: 10.59","State: WY<br>Fuel Volume: 13.8","State: UT<br>Fuel Volume: 13.85","State: DC<br>Fuel Volume: 20","State: IA<br>Fuel Volume: 14.65","State: UT<br>Fuel Volume: 13.85","State: MD<br>Fuel Volume: 21.76","State: ND<br>Fuel Volume: 20","State: DE<br>Fuel Volume: 15.59","State: MI<br>Fuel Volume: 7","State: IA<br>Fuel Volume: 14.65","State: RI<br>Fuel Volume: 10.71","State: PA<br>Fuel Volume: 6","State: NE<br>Fuel Volume: 8.58","State: WI<br>Fuel Volume: 5","State: SC<br>Fuel Volume: 18.49","State: WI<br>Fuel Volume: 5","State: NE<br>Fuel Volume: 8.58","State: VT<br>Fuel Volume: 6.92","State: SC<br>Fuel Volume: 18.49","State: TN<br>Fuel Volume: 18","State: NV<br>Fuel Volume: 5","State: WY<br>Fuel Volume: 13.8"],"locations":["MT","NC","SD","MD","GA","NJ","OH","HI","UT","WV","MA","WV","KY","AZ","CO","VT","LA","AL","NM","MN","AL","MD","NY","TX","MA","ID","CA","MD","IL","IN","DE","CA","ME","TX","DE","NC","VT","AR","KS","TX","CT","NC","FL","NM","RI","IA","SC","NC","CT","NC","WY","UT","DC","IA","UT","MD","ND","DE","MI","IA","RI","PA","NE","WI","SC","WI","NE","VT","SC","TN","NV","WY"],"hoverinfo":["text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text","text"],"type":"choropleth","marker":{"line":{"colorbar":{"title":"","ticklen":2},"cmin":1,"cmax":24.91,"colorscale":[["0","rgba(247,251,255,1)"],["0.0416666666666667","rgba(239,246,252,1)"],["0.0833333333333333","rgba(230,240,250,1)"],["0.125","rgba(222,235,247,1)"],["0.166666666666667","rgba(214,230,244,1)"],["0.208333333333333","rgba(206,224,242,1)"],["0.25","rgba(198,219,239,1)"],["0.291666666666667","rgba(185,213,234,1)"],["0.333333333333333","rgba(172,208,230,1)"],["0.375","rgba(158,202,225,1)"],["0.416666666666667","rgba(142,193,221,1)"],["0.458333333333333","rgba(125,183,218,1)"],["0.5","rgba(107,174,214,1)"],["0.541666666666667","rgba(94,165,209,1)"],["0.583333333333333","rgba(81,155,203,1)"],["0.625","rgba(66,146,198,1)"],["0.666666666666667","rgba(57,135,192,1)"],["0.708333333333333","rgba(46,124,187,1)"],["0.75","rgba(33,113,181,1)"],["0.791666666666667","rgba(27,102,173,1)"],["0.833333333333333","rgba(19,91,164,1)"],["0.875","rgba(8,81,156,1)"],["0.916666666666667","rgba(9,70,139,1)"],["0.958333333333333","rgba(9,59,123,1)"],["1","rgba(8,48,107,1)"]],"showscale":false,"color":[5,10.59,23,21.760000000000002,5,7,6,12,13.85,10.619999999999999,10,10.619999999999999,20,1,15,6.9199999999999999,6,10.19,14,12,10.19,21.760000000000002,10,7.7199999999999998,10,9,12.1,21.760000000000002,4,12,15.59,12.1,18,7.7199999999999998,15.59,10.59,6.9199999999999999,12,10,7.7199999999999998,24.91,10.59,6,14,10.710000000000001,14.65,18.489999999999998,10.59,24.91,10.59,13.800000000000001,13.85,20,14.65,13.85,21.760000000000002,20,15.59,7,14.65,10.710000000000001,6,8.5800000000000001,5,18.489999999999998,5,8.5800000000000001,6.9199999999999999,18.489999999999998,18,5,13.800000000000001]}},"geo":"geo","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>

### Batch Plotting by State

To generate multiple bar plots by state, use the `get_state_graphs()`
function. This is useful when you want to examine how a specific
variable varies across different U.S. states.

Note: This function produces multiple plots and is best used in an
interactive session or saved to files.

``` r
Reference only
get_state_graphs(dataset = vius_data,
                  db_header = `MPG`,
                  states = c("CA", "TX", "NY"),
                  plot_title = "Average MPG by State",
                  x_plot_label = "Average MPG",
                  y_plot_label = "State")
```
