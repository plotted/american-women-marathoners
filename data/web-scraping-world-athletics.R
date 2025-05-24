# Script to web crawl "World Athletics" and be able to scrape data for
# Women Marathoners' Running Times (2001 to 2024)
#
# Source: World Athletics
# URL: https://worldathletics.org/
#
#
# Reference: New York Times
#
# Why Are American Women Running Faster Than Ever? 
# https://www.nytimes.com/interactive/2020/02/28/sports/womens-olympic-marathon-trials.html
#
# https://www.nytimes.com/2020/09/17/learning/whats-going-on-in-this-graph-women-marathoners-running-times.html 
#
# https://static01.nyt.com/images/2020/09/17/learning/WomenMarathonGraphLN/WomenMarathonGraphLN-superJumbo.png
#


# Packages
library(tidyverse)
library(rvest)
library(httr2)


# ==============================================================================
# Approach 1) Based on package "httr"
# ==============================================================================

# Top 50 women marathon runners in 2022
# https://worldathletics.org/records/toplists/road-running/marathon/all/women/senior/2022?regionType=countries&region=usa&page=1&bestResultsOnly=true&maxResultsByCountry=50&eventId=10229534&ageCategory=senior

# If you try to scrape the above URL with read_html() you get an error :(

# to avoid error message, we could use GET() from "httr"
# https://stackoverflow.com/questions/62106074/webscraping-read-html-error-in-open-connectionx-rb-ssl-certificate-p
httr::set_config(httr::config(ssl_verifypeer = FALSE, ssl_verifyhost = FALSE))
doc = read_html(httr::GET(url))


# ==============================================================================
# Approach 2)
# ==============================================================================
#
# Another option to get the data is to download the HTML files 
# and locally import the HTML tables

# Main URL:
# https://worldathletics.org/records/toplists/road-running/marathon/all/women/senior/2022?regionType=countries&region=usa&page=1&bestResultsOnly=true&maxResultsByCountry=50&eventId=10229534&ageCategory=senior


# download HTML files from 2001 to 2024
url1 = "https://worldathletics.org/records/toplists/"
url2 = "road-running/marathon/all/women/senior/"
url3 = "?regionType=countries&region=usa&page=1&bestResultsOnly=true&maxResultsByCountry=50&eventId=10229534&ageCategory=senior"

for (year in 2001:2024) {
  print(year)
  url = paste0(url1, url2, year, url3)
  dest = paste0("marathon-women-", year, ".html")
  download.file(url, destfile = dest)
  Sys.sleep(runif(1, min = 2, max = 6))
}


# Once downloaded, here's how you can scrape the HTML table
tables_list = read_html("marathon-women-2001.html") |> 
  html_table()

tbl = tables_list[[1]]
tbl

