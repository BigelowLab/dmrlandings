#' Read ME DMR landings data
#' 
#' @description
#' [Maine's DMR landings data portal](https://mainedmr.shinyapps.io/Landings_Portal/) allows
#' for the download of "historic" (state wide annual totals per species) and "modern"
#' (per port per species annual totals) landings data.  Use this function to 
#' read historic, modern or merged data.
#'  
#' @export
#' @param when chr, one of "modern" (default), "historic" or "merged"
#' @return data frame
read_dmr_landings = function(when = c("modern", "historic", "merged")[3]){
  
  when = tolower(when[1])
  
  if (when[1] == "merged") {
    x = read_dmr_landings("modern")
    y = read_dmr_landings("historic") |>
      dplyr::mutate(port = "ME",
                    county = "ME",
                    lob_zone = "ME",
                    weight_type = NA_character_)
    r = dplyr::bind_rows(x,y)
  } else {
    pat = switch(when[1],
                 "modern" = "^.*_Modern_.*\\.csv$",
                 "historic" = "^.*_Historic_.*\\.csv$",
                 stop("when not known", when[1]))
    filename = list.files(system.file("extdata", package = "dmrlandings"),
                          pattern = pat,
                          full.names = TRUE)
    r = readr::read_csv(filename, show_col_types = FALSE)
  }
  r
}

#' Aggregate data to state-wide scale
#' 
#' @export
#' @param x data frame of dmr landings (merged)
#' @return data frame
annualize_dmr_landings = function(x = read_dmr_landings(when = "merged")){
  
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
