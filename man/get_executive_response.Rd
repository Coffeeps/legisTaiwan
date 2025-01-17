% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parlquestions.R
\name{get_executive_response}
\alias{get_executive_response}
\title{Retrieving the records of the questions answered by the executives
行政院答復}
\usage{
get_executive_response(term = NULL, session_period = NULL, verbose = TRUE)
}
\arguments{
\item{term}{integer or numeric. The parameter should be set in a numeric
format. The default is 8. The data is only available from 8th
term 參數必須為數值，資料從立法院第8屆開始計算。}

\item{session_period}{session in the term. The session is between 1 and 8.
session_period 參數必須為數值。}

\item{verbose}{The default value is TRUE, displaying the description of data
retrieved in number, url and computing time.}
}
\value{
A list object contains a tibble carrying the variables of term, sessionPeriod,
sessionTimes, meetingTimes, eyNumber, lyNumber, subject, content, docUrl
selectTerm.
}
\description{
Retrieving the records of the questions answered by the executives
行政院答復
}
\examples{
## query the Executives' answered response by term and the session period.
## 輸入「立委屆期」與「會期」下載「行政院答復」
get_executive_response(term = 8, session_period = 1)
}
\seealso{
\url{https://data.ly.gov.tw/getds.action?id=2}
}
