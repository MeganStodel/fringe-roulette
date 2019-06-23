library(data.table)
library(feather)
library(shiny)
library(shinyWidgets)

## Read in data

fringe_shows <- as.data.table(read_feather("fringe_shows.feather"))

##

categories <- sort(fringe_shows[, unique(Category)])
