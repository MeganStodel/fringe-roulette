library(rvest)
library(data.table)
library(feather)
library(stringr)
library(ggplot2)

## Read in data

fringe_shows <- as.data.table(read_feather("fringe_shows.feather"))

fringe_shows[, run_length := str_count(Dates, ',') + 1]

tweeted_shows <- c("Devil of Choice", 
                   "Vikki Stone: Song Bird", 
                   "Void", 
                   "Predictably Irrational", 
                   "Arson in the Queen's Swans", 
                   "Honey", 
                   "Funny in Real Life", 
                   "Little Death Club", 
                   "Fags, Mags and Bags", 
                   "Bowjangles: Excalibow", 
                   "Des Kapital: I'm Loving Engels Instead", 
                   "Laugh Till It Hurts: A BDSM Comedy Show", 
                   "Good Scout", 
                  # "MARVELus: Awww Snap!", (not on site)
                   "Black Dog", 
                   "Tumours", 
                   "Viva Music!", 
                   "Nights by Henry Naylor", 
                   "Claim", 
                   "Inflatable Space", 
                   "Carol Cates: Tell Tale", 
                   "HoneyBee", 
                   "Daniel Audritt: Better Man", 
                   "Cathy: A Retelling of Wuthering Heights", 
                   "Tarot", 
                   "Niteskreen", 
                   "Lock-In Cabaret", 
                   "Courtney Pauroso: Gutterplum", 
                   "Tokyo Rose", 
                   "Alice Snedden: Absolute Monster", 
                   "Merry Wives of Seoul", 
                   "Meddlin' Kids", 
                   "Trans*Atlantic", 
                   "Henry Box Brown", 
                   "American Idiot", 
                   "Elizabethan", 
                   "Dodici Ballerini", 
                   "Chocolate", 
                   "Black Blues Brothers", 
                   "Showstoppers' Kids Show", 
                   "I'll Take You to Mrs Cole!", 
                   "Wallace & Gromit's Musical Marvels", 
                   "Last Dance with Fayne and the Cruisers", 
                   "Iona Fyfe: Songs of the North East", 
                   "All the King's Men", 
                   "Bad Girls Upset by the Truth", 
                   "Chris Read: Little Man", 
                   "C for Free", 
                   "Chain of Trivia", 
                   "You're in a Bad Way by John Osborne", 
                   "Empathy Experiment", 
                   "Sugar", 
                   "Hyde and Seek", 
                   "Parasites", 
                   "Daily Ceilidh", 
                   "Catching Comets", 
                   "Antique Jokes Show", 
                   "My Leonard Cohen", 
                   "Cherie - My Struggle", 
                   "Becky Fury's One Hour to Save the World (in 55 Minutes)", 
                   "Out", 
                   "It's True, It's True, It's True", 
                   "John Kearns: Double Take and Fade Away", 
                   "James Hancox: 1000 Great Lives", 
                   "Pessimist's Guide to Being Happy", 
                   "Flora Anderson: Romantic", 
                   "1919-2019 Art Blakey's Centennial: Valery Ponomarev Quintet", 
                   "Jessie Cave: Sunrise", 
                   "Dangerous Adventures", 
                   "Rob Auton: The Time Show", 
                   "Die! Die! Die! Old People Die!", 
                   "Back of the Head with a Brick", 
                   "Sinatra: Raw", 
                   "JazzMain Presents Diggin Dexter!", 
                   "Spray")

fringe_roulette_shows <- fringe_shows[Title %in% tweeted_shows]
fringe_roulette_shows <- fringe_roulette_shows[!(Title == "Tarot" & Category == "Comedy") &
                                                 !(Title == "Chain of Trivia" & `Book Tickets` %like% "1") &
                                                 !(Title %like% "Cathy" & !`Book Tickets` %like% "1")]

all_reviews <- data.table(show = character(), 
                          review = character())

no_reviews <- character()

for (i in 1:fringe_roulette_shows[, .N]) {
  next_show <- xml2::read_html(paste0("https://tickets.edfringe.com", fringe_roulette_shows[, `Book Tickets`[i]]))
  
  review_text <- next_show %>%
    html_nodes(".review-inner p") %>%
    html_text()
  
  if (length(review_text) == 0) {
    no_reviews <- c(no_reviews, fringe_roulette_shows[, Title[i]])
  } else {
  new_data <- data.table(show = fringe_roulette_shows[, Title[i]], review = review_text)
  all_reviews <- rbind(all_reviews, new_data)
  }
}

all_reviews_clean <- all_reviews[!review %like% "Read the full review|Please login to add a review|Participants - for further details on our audience and|This review was reported and removed after review"]

all_review_shows <- all_reviews[, unique(show)]
all_review_clean_shows <- all_reviews_clean[, unique(show)]

## Number of reviews per show

reviews_per_show <- all_reviews_clean[, .(number_of_reviews = .N), by = show]

no_review_shows <- data.table(show = setdiff(all_review_shows, all_review_clean_shows), 
                              number_of_reviews = 0)

reviews_per_show <- rbind(reviews_per_show, no_review_shows)

ggplot(reviews_per_show, aes(number_of_reviews)) +
  geom_histogram()

## Write out review data

write_feather(all_reviews_clean, "./sentiment/all_reviews")


