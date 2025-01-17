#' Retrieving the spoken meeting records 下載「委員發言」
#'
#'@param start_date numeric or double formatted by Taiwan calander. Requesting
#'meeting records starting from the date. If a double is used, it should specify
#'as Taiwan calendar format, e.g. 1090101.
#'
#'@param end_date numeric or double formatted by Taiwan calander. Requesting
#'meeting records ending from the date. If a double is used, it should specify as Taiwan
#'calendar format, e.g. 1090110.
#'
#'@param meeting_unit The default is NULL, which includes all meetings
#' between the starting date and the ending date.
#'
#'@param verbose logical, indicates whether get_meetings should print out
#'detailed output when retrieving the data.
#'
#'@return An object of the list, which contains query_time, retrieved_number,
#'meeting_unit, start_date_ad, end_date_ad, start_date, end_date, url,
#'variable_names, manual_info and data.
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'
#'
#'@export
#'@examples
#' ## query meeting records by a period of the dates in Taiwan ROC calender format
#' ## 輸入「中華民國民年」下載「委員發言」
#'get_meetings(start_date = "1050120", end_date = "1050210")
#'
#' ## query meeting records by a period of the dates in Taiwan ROC calender format
#' ## and a meeting
#' ## 輸入「中華民國民年」與「審查會議或委員會名稱」下載會議審查資訊
#'get_meetings(start_date = 1060120, end_date = 1070310, meeting_unit = "內政委員會")
#'
#'@seealso
#'\url{https://www.ly.gov.tw/Pages/List.aspx?nodeid=154}


get_meetings <- function(start_date = NULL, end_date = NULL,
                         meeting_unit = NULL, verbose = TRUE) {
  legisTaiwan::check_internet()
  legisTaiwan::api_check(start_date = legisTaiwan::check_date(start_date), end_date = legisTaiwan::check_date(end_date))
  set_api_url <- paste("https://www.ly.gov.tw/WebAPI/LegislativeSpeech.aspx?from=",
                       start_date, "&to=", end_date, "&meeting_unit=",meeting_unit,  "&mode=json", sep = "")
  tryCatch(
    {
      json_df <- jsonlite::fromJSON(set_api_url)
      df <- tibble::as_tibble(json_df)
      attempt::stop_if_all(length(df) == 0, isTRUE, msg = paste("The query is unavailable:", set_api_url, sep = "\n" ))
      df["date_ad"] <- do.call("c", lapply(df$smeeting_date, legisTaiwan::transformed_date_meeting))
      if (isTRUE(verbose)) {
        cat(" Retrieved URL: \n", set_api_url, "\n")
        cat(" Retrieved via :", meeting_unit, "\n")
        cat(" Retrieved date between:", as.character(legisTaiwan::check_date(start_date)), "and", as.character(legisTaiwan::check_date(end_date)), "\n")
        cat(" Retrieved number:", nrow(df), "\n")
        }
      list_data <- list("title" = "the spoken meeting records",
                        "query_time" = Sys.time(),
                        "retrieved_number" = nrow(df),
                        "meeting_unit" = meeting_unit,
                        "start_date_ad" = legisTaiwan::check_date(start_date),
                        "end_date_ad" = legisTaiwan::check_date(end_date),
                        "start_date" = start_date,
                        "end_date" = end_date,
                        "url" = set_api_url,
                        "variable_names" = colnames(df),
                        "manual_info" = "https://www.ly.gov.tw/Pages/List.aspx?nodeid=154",
                        "data" = df)
      return(list_data)
    },
    error = function(error_message) {
      message(error_message)
    }
  )
}


#' Retrieving the meeting records of cross-caucus session 下載「黨團協商」資料
#'
#'@param start_date Requesting meeting records starting from the date.
#'A double represents a date in ROC Taiwan format.
#'If a double is used, it should specify as Taiwan
#'calendar format, e.g. 109/01/10.
#'
#'@param end_date Requesting meeting records ending from the date.
#' A double represents a date in ROC Taiwan format. If a double is used,
#' it should specify as Taiwan calendar format, e.g. 109/01/20.
#'
#'@param verbose logical, indicates whether get_meetings should print out
#'detailed output when retrieving the data.
#'
#'@return An object of the list, which contains query_time, retrieved_number,
#'start_date_ad, end_date_ad, start_date, end_date, url, variable_names,
#' manual_info and data
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'
#'@export
#'@examples
#' ## query the meeting records of cross-caucus session using a period of
#' ## the dates in Taiwan ROC calender format with forward slash (/).
#' ## 輸入「中華民國民年」下載「黨團協商」，輸入時間請依照該格式 "106/10/20"
#' ## ，需有「正斜線」做隔開。
#'get_caucus_meetings(start_date = "106/10/20", end_date = "107/03/10")
#'
#'@seealso
#'\url{https://data.ly.gov.tw/getds.action?id=8}
#
get_caucus_meetings <- function(start_date = NULL, end_date = NULL, verbose = TRUE) {
  legisTaiwan::check_internet()
  legisTaiwan::api_check(start_date = legisTaiwan::transformed_date_meeting(start_date), end_date = legisTaiwan::transformed_date_meeting(end_date))
  set_api_url <- paste("https://data.ly.gov.tw/odw/ID8Action.action?comYear=&comVolume=&comBookId=&term=&sessionPeriod=&sessionTimes=&meetingTimes=&meetingDateS=",
                       start_date, "&meetingDateE=", end_date, "&fileType=json", sep = "")
  tryCatch(
    {
      json_df <- jsonlite::fromJSON(set_api_url)
      df <- tibble::as_tibble(json_df$dataList)
      attempt::stop_if_all(length(df) == 0, isTRUE, msg = paste("The query is unavailable:", set_api_url, sep = "\n" ))
      if (isTRUE(verbose)) {
        cat(" Retrieved URL: \n", set_api_url, "\n")
        cat(" Retrieved date between:", as.character(legisTaiwan::transformed_date_meeting(start_date)), "and", as.character(legisTaiwan::transformed_date_meeting(end_date)), "\n")
        cat(" Retrieved number:", nrow(df), "\n")
      }
      list_data <- list("title" = "the meeting records of cross-caucus session",
                        "query_time" = Sys.time(),
                        "retrieved_number" = nrow(df),
                        "start_date_ad" = legisTaiwan::transformed_date_meeting(start_date),
                        "end_date_ad" = legisTaiwan::transformed_date_meeting(end_date),
                        "start_date" = start_date,
                        "end_date" = end_date,
                        "url" = set_api_url,
                        "variable_names" = colnames(df),
                        "manual_info" = "https://data.ly.gov.tw/getds.action?id=8",
                        "data" = df)
      return(list_data)
    },
    error = function(error_message) {
      message(error_message)
    }
  )
}


#' Retrieving full video information of meetings and committees
#' 下載「委員發言片段相關影片資訊」
#'@param start_date Requesting meeting records starting from the date.
#'A double represents a date in ROC Taiwan format.
#'If a double is used, it should specify as Taiwan
#'calendar format, e.g. 109/01/10.
#'
#'@param end_date Requesting meeting records ending from the date.
#' A double represents a date in ROC Taiwan format. If a double is used,
#' it should specify as Taiwan calendar format, e.g. 109/01/20.
#'
#'@param verbose logical, indicates whether get_meetings should print out
#'detailed output when retrieving the data.
#'
#'@return An object of the list, which contains query_time, retrieved_number, start_date_ad,
#'end_date_ad, start_date, end_date, url, variable_names, manual_info and data
#'
#'
#'@importFrom attempt stop_if_all
#'
#'@importFrom jsonlite fromJSON
#'
#'@export
#'
#'@examples
#' ## query full video information of meetings and committees using a period of
#' ## the dates in Taiwan ROC calender format with forward slash (/).
#' ## 輸入「中華民國民年」下載「委員發言片段相關影片資訊」，輸入時間請依照該
#' ## 格式 "105/10/20"，需有「正斜線」做隔開。
#'get_speech_video(start_date = "105/10/20", end_date = "109/03/10")
#'
#'@seealso
#'委員發言片段相關影片資訊 \url{https://data.ly.gov.tw/getds.action?id=148}

get_speech_video <- function(start_date = NULL, end_date = NULL, verbose = TRUE) {
  legisTaiwan::check_internet()
  legisTaiwan::api_check(start_date = legisTaiwan::transformed_date_meeting(start_date), end_date = legisTaiwan::transformed_date_meeting(end_date))
    # 自第9屆第1會期起 2016  民國 105
  queried_year <- format(legisTaiwan::transformed_date_meeting(start_date), format = "%Y")
  attempt::warn_if(queried_year < 2016,
            isTRUE,
            msg =  paste("The query retrieved from", queried_year,  "may not be complete.", "The data is only available from the 6th session of the 8th legislative term in 2015/104 in ROC."))
  set_api_url <- paste("https://data.ly.gov.tw/odw/ID148Action.action?term=",
                       "&sessionPeriod=",
                       "&meetingDateS=", start_date,
                       "&meetingDateE=", end_date,
                       "&meetingTime=&legislatorName=&fileType=json" , sep = "")
  tryCatch(
    {
      json_df <- jsonlite::fromJSON(set_api_url)
      df <- tibble::as_tibble(json_df$dataList)
      attempt::stop_if_all(length(df) == 0, isTRUE, msg = paste("The query is unavailable:", set_api_url, sep = "\n" ))
      if (isTRUE(verbose)) {
        cat(" Retrieved URL: \n", set_api_url, "\n")
        cat(" Retrieved date between:", as.character(legisTaiwan::transformed_date_meeting(start_date)), "and", as.character(legisTaiwan::transformed_date_meeting(end_date)), "\n")
        cat(" Retrieved number:", nrow(df), "\n")
      }
      list_data <- list("title" = "the meeting records of cross-caucus session",
                        "query_time" = Sys.time(),
                        "retrieved_number" = nrow(df),
                        "start_date_ad" = legisTaiwan::transformed_date_meeting(start_date),
                        "end_date_ad" = legisTaiwan::transformed_date_meeting(end_date),
                        "start_date" = start_date,
                        "end_date" = end_date,
                        "url" = set_api_url,
                        "variable_names" = colnames(df),
                        "manual_info" = "https://data.ly.gov.tw/getds.action?id=8",
                        "data" = df)
      return(list_data)
    },
    error = function(error_message) {
      message(error_message)
    }
  )
}

#' Retrieving the records of national public debates 下載「國是論壇」資料
#'
#'@param term Requesting answered questions by term. The parameter should be set
#'in a numeric vector The default value is 8. The data is only available from
#'the 8th term 參數必須為數值，資料從立法院「第8屆」開始計算。
#'
#'@param session_period legislative session in the term. The session is between
#'1 and 8. 參數必須為數值。The parameter should be set in a numeric vector.
#'
#'@param verbose logical, indicates whether get_meetings should print out
#'detailed output when retrieving the data. The default is TRUE
#'
#'@return A list contains query_time, retrieved_number, start_date_ad,
#'end_date_ad, start_date, end_date, url, variable_names, manual_info and data
#'
#'@importFrom attempt stop_if_all
#'@importFrom jsonlite fromJSON
#'
#'@export
#'@examples
#' ## query the Executives' answered response by term and the session period.
#' ## 輸入「立委屆期」與「會期」下載「質詢事項 (行政院答復部分)」
#'get_public_debates(term = 10, session_period = 2)
#'
#'get_public_debates(term = 10, session_period = 1)
#'
#'@seealso
#'\url{https://data.ly.gov.tw/getds.action?id=7}

get_public_debates <- function(term = 8, session_period = NULL, verbose = TRUE) {
  legisTaiwan::check_internet()
  attempt::stop_if_all(term, is.character, msg = "use numeric format only")
  attempt::stop_if_all(term, is.character, msg = "use numeric format only")
  set_api_url <- paste("https://data.ly.gov.tw/odw/ID7Action.action?term=",
                       sprintf("%02d", as.numeric(term)), "&sessionPeriod=", sprintf("%02d", as.numeric(session_period)),
                       "&sessionTimes=&meetingTimes=&legislatorName=&speakType=&fileType=json", sep = "")

  tryCatch(
    {
      json_df <- jsonlite::fromJSON(set_api_url)
      df <- tibble::as_tibble(json_df$dataList)
      attempt::stop_if_all(nrow(df) == 0, isTRUE, msg = paste("The query is unavailable:", set_api_url, sep = "\n" ))
      if (isTRUE(verbose)) {
        cat(" Retrieved URL: \n", set_api_url, "\n")
        cat(" Retrieved Term: ", term, "\n")
        cat(" Retrieved Num: ", nrow(df), "\n")
      }
      list_data <- list("title" = "the records of the questions answered by the executives",
                        "query_time" = Sys.time(),
                        "retrieved_number" = nrow(df),
                        "retrieved_term" = term,
                        "url" = set_api_url,
                        "variable_names" = colnames(df),
                        "manual_info" = "https://data.ly.gov.tw/getds.action?id=7",
                        "data" = df)
      return(list_data)
    },
    error = function(error_message) {
      message(error_message)
    }
  )
}
