DMR Landings
================

A lightweight R package to simplify the import of [DMR annual commercial
landings data](https://mainedmr.shinyapps.io/Landings_Portal/). As
described at the portal, the data are served in three forms:

- “Historic” annual statewide totals per species (1880-2019)

- “Modern” annual per-port totals per species (2008-2024)

We provide two more forms:

- “Merged” a simple merging of the two where “historic” ports are
  assigned the value of “ME”. This form likely has limited value.

- “Annualized” a simple state wide total per species per year. This may
  be more useful than “merged”.

- “Consolidated” an extracted data set from decades of annual reports
  rich with tables of interest. Reyn Yoshioka extracted the tabular data
  using Claude (details below). These are annual records by species.

The package should be updated every spring when [DMR updates the data
source](https://mainedmr.shinyapps.io/Landings_Portal/), and after the
[DMR annual commercial landings
reports](https://www.maine.gov/dmr/fisheries/commercial) are published.

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

**Modern landings** data is broken down by species and port.

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

**Historical landings** data are broken down by species only (statewide
totals)

``` r
x = read_dmr_landings("historic") |>
  glimpse()
```

    ## Rows: 0
    ## Columns: 0

**Annualized landings** data merges modern and historical data into
species and port.

``` r
x = read_dmr_landings("annualized") |>
  glimpse()
```

    ## Rows: 614
    ## Columns: 12
    ## $ year        <dbl> 2020, 2021, 2022, 2023, 2024, 2008, 2009, 2010, 2011, 2012…
    ## $ species     <chr> "Alewife", "Alewife", "Alewife", "Alewife", "Alewife", "Bl…
    ## $ port        <chr> "ME", "ME", "ME", "ME", "ME", "ME", "ME", "ME", "ME", "ME"…
    ## $ county      <chr> "ME", "ME", "ME", "ME", "ME", "ME", "ME", "ME", "ME", "ME"…
    ## $ lob_zone    <chr> "ME", "ME", "ME", "ME", "ME", "ME", "ME", "ME", "ME", "ME"…
    ## $ weight_type <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
    ## $ weight      <dbl> 1576645, 1835855, 2689400, 2602355, 2244673, 18934, 11340,…
    ## $ value       <dbl> 586668, 723291, 1154127, 1161838, 1026532, 208982, 119917,…
    ## $ trip_n      <dbl> 0, 0, 0, 0, 0, 2393, 1423, 1290, 1648, 910, 1110, 1584, 52…
    ## $ harv_n      <dbl> 15, 17, 18, 16, 18, 145, 121, 126, 122, 83, 105, 83, 64, 4…
    ## $ count       <int> 1, 1, 1, 1, 1, 46, 43, 36, 37, 35, 30, 22, 27, 15, 14, 10,…
    ## $ town_n      <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…

**Consolidated landings** data were in October 2026 extracted using
Claude. After extraction a random sample of 150 records were manually
checked against the original report (all correct). Subsequent years will
be extracted by hand. Important considerations when using these data…

- whole pounds and live pounds were consolidated into pounds,
- confidential and fishery closed indications were translated to flag
  columns (1 means confidential or closed),
- salmon from 1990 and on are farmed,
- from 2001-2007, sea cucumber landings are as reported by harvesters,
  from 2008 and on landings are from dealers,
- all data are considered provisional by DMR, but future curators should
  understand that the last year on record is subject to change in the
  next year’s report.

``` r
x = read_dmr_landings("consolidated") |>
  glimpse()
```

    ## Rows: 2,589
    ## Columns: 17
    ## $ year                                 <dbl> 1950, 1951, 1952, 1953, 1954, 195…
    ## $ species                              <chr> "acadian redfish", "acadian redfi…
    ## $ metric_tons                          <dbl> 35961.44, 33539.48, 27427.99, 274…
    ## $ pounds                               <dbl> 79281300, 73941800, 60468300, 606…
    ## $ meat_pounds                          <dbl> NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ pounds_millions                      <dbl> 79.2813, 73.9418, 60.4683, 60.623…
    ## $ pounds_thousands                     <dbl> NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ meat_pounds_millions                 <dbl> NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ value                                <dbl> 3102352, 3428816, 2612084, 236215…
    ## $ value_millions                       <dbl> 3.1024, 3.4288, 2.6121, 2.3622, 3…
    ## $ price_per_lb                         <dbl> 0.04, 0.05, 0.04, 0.04, 0.04, 0.0…
    ## $ number_of_license_holders            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ number_of_traps_millions             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ water_temp_boothbay_harbor_station_c <dbl> NA, NA, NA, NA, NA, NA, NA, NA, N…
    ## $ confidential                         <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    ## $ fishery_closed                       <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
    ## $ cultured                             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, N…
