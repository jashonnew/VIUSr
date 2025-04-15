
<!-- README.md is generated from README.Rmd. Please edit that file -->

did i fix it now

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
  Cleaning functions added include `names`, `drop_bad_values`, and
  `charToNum`.
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

## Installation

You can install the development version of VIUSr from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("jashonnew/VIUSr")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
#library(VIUSr)
## basic example code
```
