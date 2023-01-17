# legisTaiwan: An R Package for Downloading Taiwan Legislative Data <img src="https://raw.githack.com/davidycliao/figures/master/hexsticker_tw.png" width="140" align="right" /> <br /> 

[![R](https://github.com/davidycliao/legisTaiwan/actions/workflows/r.yml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/r.yml)

`legisTaiwan` is an R package for downloading the legislative data of spoken meeting records and bill sponsor/co-sponsor via the [Taiwan Legislative Yuan API](https://www.ly.gov.tw/Home/Index.aspx). 







### 仍在測試中，使用上有任何問題歡迎email我 ~ Let's make Taiwan and our country more transparent and better. 


### The following scaling packages and relevant toolkits are used by this course:

| TLY API (台灣國會API)  <img width=400/>                                                                         | `legisTaiwan` <img width=250/> |     Since     <img width=250/>  |
| --------------------------------------------------------------------------------------------------------------- | ------------------------------ | ------------------------------- |
|[**Spoken Meeting Records (委員發言)**](https://www.ly.gov.tw/Pages/List.aspx?nodeid=154)                        | [`get_meeting`]()              |  7th* (西2011民100)             |
|[**Bill Sponsor and Co-sponsor (法律提案)**](https://www.ly.gov.tw/Pages/List.aspx?nodeid=154)                   | [`get_bill`]()                 |  7th* (西2011民100)             |
|[**name list for Committee Meeting (委員會發言名單)**](https://data.ly.gov.tw/getds.action?id=223)               | Coming soon                    |  8th  (西2014民104)             |
|[**Name List for the Floor Meeting (院會發言名單)**](https://data.ly.gov.tw/getds.action?id=221)                 |                                |  8th  (西2014民104)             |
|[**Original Proceedings  (議事錄原始檔案)**](https://data.ly.gov.tw/getds.action?id=45)                          |                                |  8th  (西2014民104)             |
|[**Legislator Information (歷屆委員資料)**](https://data.ly.gov.tw/getds.action?id=16)                           |                                |  2th  (西1992國81)              |
|[**The Questions Answered by the Legislative Yuan(立委質詢部分)**](https://data.ly.gov.tw/getds.action?id=6)     |  Coming soon                   |  8th  (西2014民104)             |
|[**The Questions Answered by the Executive Yuan(行政院答復質詢事項)**](https://data.ly.gov.tw/getds.action?id=1) |                                |  8th  (西2014民104)             |


## Install from GitHub Using `remotes`

```
install.packages("remotes")
remotes::install_github("davidycliao/legisTaiwan", force = TRUE)
```
```
library(legisTaiwan)
```

## Quick Start

### Search Spoken Meetings

```
# query meeting records by a period of the dates in Taiwan ROC calender format
# 輸入「中華民國民年」下載會議審查資訊
get_meetings(start_date = 1060120, end_date = 1070310)
```
<p align="center">
  <img width="950" height="280" src="https://raw.githack.com/davidycliao/figures/master/1.png" >
</p>

```
# query meeting records by a period of the dates in Taiwan ROC calender format 
# and a meeting
# 輸入「中華民國民年」與「審查會議或委員會名稱」下載會議審查資訊
get_meetings(start_date = 1060120, end_date = 1070310, meeting_unit = "內政委員會")
```
<p align="center">
  <img width="950" height="280" src="https://raw.githack.com/davidycliao/figures/master/2.png" >
</p>

```
# query meeting records by a period of the dates in Taiwan ROC calender format 
# and multiple meetings
# 輸入「中華民國民年」與「多個審查會議或委員會名稱」下載會議審查資訊
get_meetings(start_date = 1060120, end_date = 1070310, meeting_unit = "內政委員會&朝野協商")
```
<p align="center">
  <img width="950" height="280" src="https://raw.githack.com/davidycliao/figures/master/3.png" >
</p>

### Search Records of Bill Sponsor and Co-sponsor

```
# query bill records by a period of the dates in Taiwan ROC calender format
# 輸入「中華民國民年」下載立法委員提案資料
get_bills(start_date = 1060120, end_date = 1070310)
```
<p align="center">
  <img width="950" height="280" src="https://raw.githack.com/davidycliao/figures/master/4.png" >
</p>

```
# query bill records by a period of the dates in Taiwan ROC calender format 
# and a specific legislator 
# 輸入「中華民國民年」與「指定立法委員」下載立法委員提案資料
x <- get_bills(start_date = 1060120, end_date = 1070310,  proposer = "孔文吉")
```
<p align="center">
  <img width="950" height="280" src="https://raw.githack.com/davidycliao/figures/master/5.png" >
</p>

```
# query bill records by a period of the dates in Taiwan ROC calender format 
# and multiple legislators 
# 輸入「中華民國民年」與「指定多個立法委員」下載立法委員提案資料
get_bills(start_date = 1060120, end_date = 1060510,  proposer = "孔文吉&鄭天財")
```
<p align="center">
  <img width="950" height="260" src="https://raw.githack.com/davidycliao/figures/master/6.png" >
</p>


