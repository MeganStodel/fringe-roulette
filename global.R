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

