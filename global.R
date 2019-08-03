library(data.table)
library(feather)
library(shiny)
library(shinyWidgets)
library(shinycssloaders)

## Read in data

fringe_shows <- as.data.table(read_feather("fringe_shows.feather"))

## inputs

categories <- sort(fringe_shows[, unique(Category)])

hour_seq <- as.character(seq("00", "23"))
hour_seq <- ifelse(grepl("^\\d$", hour_seq, perl = T), paste0("0", hour_seq), hour_seq)

min_seq <- as.character(seq("00", "55", by = 5))
min_seq <- ifelse(grepl("^\\d$", min_seq, perl = T), paste0("0", min_seq), min_seq)

## Other

today <- Sys.Date()
today_formatted <- paste0("\\b", format(today, "%d %b"), "\\b")
today_formatted <- gsub("\\b0", "\\b", today_formatted, fixed = TRUE)

if (today <= "2019-09-01" ) {
  start_date <- today
} else {
  start_date <- "2019-07-29"
}

if (today <= "2019-09-01" ) {
  end_date <- today
} else {
  end_date <- "2019-09-01"
}



