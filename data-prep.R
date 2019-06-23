library(data.table)
library(feather)

all_files <- list.files(path = "./csvs", pattern = ".csv")

all_files <- paste0("./csvs/", all_files)

l <- lapply(all_files, fread)

fringe_shows <- rbindlist(l)

fringe_shows <- unique(fringe_shows)


### Cleaning

fringe_shows[Title == '="21"', Title := '21']

fringe_shows <- fringe_shows[!Title %like% "CANCELLED"]

fringe_shows[, names(fringe_shows) := lapply(.SD, function(x) gsub("â€™", "'", x))]

fringe_shows[, names(fringe_shows) := lapply(.SD, function(x) gsub("â€“", "-", x))]

fringe_shows[, names(fringe_shows) := lapply(.SD, function(x) gsub("Ã¨", "è", x))]

fringe_shows[, names(fringe_shows) := lapply(.SD, function(x) gsub("â„¢", "™", x))]

fringe_shows[, names(fringe_shows) := lapply(.SD, function(x) gsub("â€¦", "...", x))]

fringe_shows[, names(fringe_shows) := lapply(.SD, function(x) gsub("Ã©", "é", x))]

fringe_shows[, names(fringe_shows) := lapply(.SD, function(x) gsub("Ã¶", "ö", x))]

fringe_shows[, names(fringe_shows) := lapply(.SD, function(x) gsub("^\'", "", x))]

fringe_shows[, names(fringe_shows) := lapply(.SD, function(x) gsub("Ã’", "Ò", x))]


## Make into a feather file

write_feather(fringe_shows, "fringe_shows.feather")



