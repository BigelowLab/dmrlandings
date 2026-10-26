#' Read ME DMR landings data
#' 
#' @description
#' [Maine's DMR landings data portal](https://mainedmr.shinyapps.io/Landings_Portal/) allows
#' for the download of "historic" (state wide annual totals per species), "modern" 
#' (per port per species annual totals) or "annualized" (statewide totals per year per species)
#' landings data. Consolidated data is extracted from decades of annual landings reports
#' distributed as PDF documents. Reyn Yoshioka extracted the data with using Claude, and 
#' then manually checked a random selection of 150 records and found that Claude was
#' faithful to the original. Use this function to read historic, modern, 
#' merged consolidated or annualized data.
#'  
#' @export
#' @param what chr, one of "modern" (default), "historic", "merged", "annualized"
#' @return data frame
read_dmr_landings = function(what = c("modern", "historic", 
                                      "merged", "annualized",
                                      "consolidated")[4]){
  
  what = tolower(what[1])
  
  if (what[1] %in% c("merged", "annualized")) {
    x = read_dmr_landings("modern")
    y = read_dmr_landings("historic") |>
      dplyr::mutate(port = "ME",
                    county = "ME",
                    lob_zone = "ME",
                    weight_type = NA_character_)
    r = dplyr::bind_rows(x,y)
    if (what[1] == "annualized") r = annualize_dmr_landings(r)
  } else {
    pat = switch(what[1],
                 "modern" = "^.*_Modern_.*\\.csv\\.gz$",
                 "historic" = "^.*_Historic_.*\\.csv\\.gz$",
                 "consolidated" = "^DMR_landings_consolidated_.*\\.csv\\.gz$",
                 stop("what not known", what[1]))
    filename = list.files(system.file("extdata", package = "dmrlandings"),
                          pattern = pat,
                          full.names = TRUE)
    r = readr::read_csv(filename, show_col_types = FALSE)
  }
  r
}

#' Aggregate data to state-wide annual totals per species
#' 
#' @export
#' @param x data frame of dmr landings (merged)
#' @return data frame
annualize_dmr_landings = function(x = read_dmr_landings(what = "merged")){
  
  x |>
    dplyr::group_by(species, year) |>
    dplyr::group_map(
      function(grp, key){
        grp |> 
          dplyr::slice(1)|>
          dplyr::mutate(
            count = nrow(grp),
            port = "ME",
            county = "ME",
            lob_zone = "ME",
            weight_type = NA_character_,
            weight = sum(weight, na.rm = TRUE),
            value = sum(value, na.rm = TRUE),
            trip_n = sum(trip_n, na.rm = TRUE),
            harv_n = sum(harv_n, na.rm = TRUE),
            town_n = dplyr::n())
      }, .keep = TRUE) |>
    dplyr::bind_rows()
}




#' Prep landings data form county analyses
#' 
#' @export
#' @param x DMR landings table
#' @return reduced DMR table to have valid county names
prep_dmr_landings_county = function(x = read_dmr_landings("modern")){
  x |>
    dplyr::filter(!(.data$county %in% c("UK", "Not-Specified", "ME")),
                  !is.na(.data$species))
}


#' Aggregate by DMR landings data by county, year and species
#' 
#' @export
#' @param x DMR landings data
#' @param collapse chr, "none" (default) or "year" to aggregate years etc
#' @return summary table
aggregate_dmr_landings_county = function(x = read_dmr_landings("modern"),
                                         collapse = "none"){
  
  r = switch(tolower(collapse[1]),
            "year" = prep_dmr_landings_county(x) |>
              dplyr::group_by(.data$county, .data$species),
             "none" = prep_dmr_landings_county(x) |>
               dplyr::group_by(.data$county, .data$year, .data$species),
            stop("collapse value not known:", collapse))
  
   r |>   
     dplyr::summarize(weight = sum(weight, na.rm = TRUE),
                      value = sum(value, na.rm = TRUE),
                      trip_n = sum(trip_n, na.rm = TRUE),
                      harv_n = sum(harv_n, na.rm = TRUE),
                      town_n = dplyr::n(),
                      .groups = "drop")
  
}
