DMR Landings
================

A lightweight R package to simplify the import of [DMR annual commercial
landings data](https://mainedmr.shinyapps.io/Landings_Portal/). As
described at the portal, the data are served in two forms:

- “Historic” annual statewide totals per species (1880-2019)

- “Modern” annual per-port totals per species (2008-2024)

We provide two more forms:

- “Merged” a simple merging of the two where “historic” ports are
  assigned the value of “ME”. This form likely has limited value.

- “Annualized” a simple state wide total per species per year. This may
  be more useful than “merged”.

The package should be updated every spring when [DMR updates the data
source](https://mainedmr.shinyapps.io/Landings_Portal/).

# Requirements

- [R v4.3+](https://www.r-project.org/)

- [readr](https://CRAN.R-project.org/package=readr)

- [dplyr](https://CRAN.R-project.org/package=dplyr)

# Installation

    remotes::install("BigelowLab/dmrlandings")

# Usage

``` r
suppressPackageStartupMessages({
  library(dmrlandings)
  library(dplyr)
})
```

``` r
x = read_dmr_landings("modern") |>
  glimpse()
```

    ## Rows: 5,517
    ## Columns: 10
    ## $ year        <dbl> 2008, 2008, 2008, 2008, 2008, 2008, 2008, 2008, 2008, 2008…
    ## $ species     <chr> "Bloodworms", "Bloodworms", "Bloodworms", "Bloodworms", "B…
    ## $ port        <chr> "Addison", "Bar Harbor", "Bass Harbor", "Bath", "Beals", "…
    ## $ county      <chr> "Washington", "Hancock", "Hancock", "Sagadahoc", "Washingt…
    ## $ lob_zone    <chr> "UK", "UK", "UK", "UK", "UK", "UK", "UK", "UK", "UK", "UK"…
    ## $ weight_type <chr> "Live Pounds", "Live Pounds", "Live Pounds", "Live Pounds"…
    ## $ weight      <dbl> 18934, 1397, 42, 9408, 1760, 4920, 1206, 233, 11307, 8248,…
    ## $ value       <dbl> 208982, 15277, 449, 101805, 18990, 52021, 13215, 2501, 121…
    ## $ trip_n      <dbl> 2393, 110, 4, 470, 1166, 202, 111, 20, 574, 413, 242, 12, …
    ## $ harv_n      <dbl> 145, 31, 3, 60, 75, 49, 26, 13, 61, 51, 39, 8, 51, 33, 25,…

``` r
x = read_dmr_landings("historic") |>
  glimpse()
```

    ## Rows: 2,193
    ## Columns: 6
    ## $ year    <dbl> 1950, 1951, 1952, 1953, 1954, 1955, 1956, 1957, 1958, 1959, 19…
    ## $ species <chr> "Alewife", "Redfish Acadian Ocean Perch", "Redfish Acadian Oce…
    ## $ weight  <dbl> 79281300, 73941800, 60468300, 60623200, 79670700, 67685000, 64…
    ## $ value   <dbl> 3102352, 3428816, 2612084, 2362155, 3205500, 2577442, 2464204,…
    ## $ trip_n  <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    ## $ harv_n  <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…

``` r
x = read_dmr_landings("annualized") |>
  glimpse()
```

    ## Rows: 2,516
    ## Columns: 12
    ## $ year        <dbl> 1950, 1951, 1952, 1953, 1954, 1955, 1956, 1957, 1958, 1959…
    ## $ species     <chr> "Alewife", "Alewife", "Alewife", "Alewife", "Alewife", "Al…
    ## $ port        <chr> "ME", "ME", "ME", "ME", "ME", "ME", "ME", "ME", "ME", "ME"…
    ## $ county      <chr> "ME", "ME", "ME", "ME", "ME", "ME", "ME", "ME", "ME", "ME"…
    ## $ lob_zone    <chr> "ME", "ME", "ME", "ME", "ME", "ME", "ME", "ME", "ME", "ME"…
    ## $ weight_type <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    ## $ weight      <dbl> 79281300, 3479200, 2783200, 2443100, 3296100, 3778600, 458…
    ## $ value       <dbl> 3102352, 26067, 29763, 27529, 26643, 33024, 41833, 32453, …
    ## $ trip_n      <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
    ## $ harv_n      <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
    ## $ count       <int> 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    ## $ town_n      <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
