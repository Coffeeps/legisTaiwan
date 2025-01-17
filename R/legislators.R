#' Retrieving legislator' demographic information and background
#'
#'@param term A number, which requests answered questions from the term. The parameter should be set in
#'a numeric vector.
#'retrieved in number, url, and computing time.
#'@param verbose The default is TRUE, which return the information of the return.
#'object.
#'@return A list contains query_time, queried_term, url ,variable_names, manual_info and data
#'
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'
#'@export
#'
#'@examples
#' ## To retrieve legislator' demographic from 8th
#' ## 輸入「屆次」下載當屆立委資料
#'get_legislators(term = 8)
#'
#'
#' ## To retrieve legislator' demographic from all of terms
#' ## 輸入「空白」下載所有立委資料
#'get_legislators()
#'@seealso
#'\url{https://data.ly.gov.tw/getds.action?id=16}
#'
get_legislators <- function(term = NULL, verbose = TRUE) {
  legisTaiwan::check_internet()
  if (is.null(term)) {
    # request full data
    set_api_url <- paste("https://data.ly.gov.tw/odw/ID16Action.action?name=&sex=&party=&partyGroup=&areaName=&term=",
                         term, "=&fileType=json", sep = "")
  } else {
    attempt::stop_if_all(term, is.character, msg = "use numeric format only.")
    if (length(term) == 1) {
      term <- sprintf("%02d", as.numeric(term))
    } else if (length(term) > 1) {
      term <- paste(sprintf("%02d", as.numeric(term)), collapse = "&")
      message("The API is unable to query multiple terms and the retrieved data might not be complete.")
    }
    set_api_url <- paste("https://data.ly.gov.tw/odw/ID16Action.action?name=&sex=&party=&partyGroup=&areaName=&term=",
                         term, "=&fileType=json", sep = "")
  }
  tryCatch(
    {
      json_df <- jsonlite::fromJSON(set_api_url)
      df <- tibble::as_tibble(json_df$dataList)
      attempt::stop_if_all(nrow(df) == 0, isTRUE, msg = "The query is unavailable")
      term <- paste(sort(as.numeric(unique(df$term))), collapse = " ", sep = ",")
      if (isTRUE(verbose)) {
        cat(" Retrieved URL: \n", set_api_url, "\n")
        cat(" Retrieved term: ", term, "\n")
      }
      list_data <- list("title" = "the legislator's demographic information",
                        "query_time" = Sys.time(),
                        "queried_term" = term,
                        "url" = set_api_url,
                        "variable_names" = colnames(df),
                        "manual_info" = "https://data.ly.gov.tw/getds.action?id=16",
                        "data" = df)
      return(list_data)
    },
    error = function(error_message) {
      message(error_message)
    }
  )
}
