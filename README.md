
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SiapR

<!-- badges: start -->
<!-- badges: end -->

The goal of SiapR is to provide an easy way to extract and gather the
agricultural and cattle information from siap since 1980 until the last
release. For that porpuse are built two funcions: extract_a() for
agricultural data and extract_g() for cattle data

The data is taken from http://infosiap.siap.gob.mx/gobmx/datosAbiertos_a.php and http://infosiap.siap.gob.mx/gobmx/datosAbiertos_a.php

## Installation

You can install the development version of SiapR like so:

``` r
library(devtools)

devtools::install_github(repo = "CarlosGlezDlt/SiapR")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(SiapR)
agriculture_dataframe <- extract_a()
cattle_dataframe <- extract_g()
```
