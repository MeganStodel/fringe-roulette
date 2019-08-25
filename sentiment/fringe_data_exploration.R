library(rvest)
library(data.table)
library(feather)
library(stringr)

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
                   "MARVELus: Awww Snap!", 
                   "Black Dog", 
                   "Tumours", 
                   "Viva Music!", 
                   "Nights by Henry Naylor", 
                   "Claim", 
                   "Inflatable Space", 
                   "Carol Cates: Tell Tale", 
                   "HoneyBee", 
                   "Daniel Audritt: Better Man ", 
                   "Cathy: a Retelling of Wuthering Heights", 
                   "Tarot", 
                   "Niteskreen", 
                   "Lock-in Cabaret", 
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
                   "Back of the Head with a Brick")

fringe_roulette_shows <- fringe_shows[Title %in% tweeted_shows]
fringe_roulette_shows <- fringe_roulette_shows[!(Title == "Tarot" & Category == "Comedy") &
                                                 !(Title == "Chain of Trivia" & `Book Tickets` %like% "1")]


all_reviews <- data.table(show = character(), 
                          review = character())


next_show <- xml2::read_html("https://tickets.edfringe.com/whats-on/rust")

review_text <- next_show %>%
  html_nodes(".review-inner p") %>%
  html_text()

review_text <- head(review_text, -5)

new_data <- data.table(show = "Rust", review = review_text)

all_reviews <- rbind(all_reviews, new_data)

