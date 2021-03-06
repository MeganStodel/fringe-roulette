library(rvest)
library(data.table)
library(feather)
library(stringr)
library(ggplot2)

## Read in data

fringe_shows <- as.data.table(read_feather("fringe_shows.feather"))

all_reviews <- data.table(show_and_group = character(), 
                          review = character())

no_reviews <- character()

##### Remove shows with broken links ----
fringe_shows <- fringe_shows[!(`Book Tickets` %in% c("/whats-on/midsummer-night-s-dream-2", 
                                                                      "/whats-on/tick-tick-boom", 
                                                                      "/whats-on/zero-hour", 
                                                                      "/whats-on/slime", 
                                                                      "/whats-on/will-artificial-intelligence-liberate-or-infantilise-humanity", 
                                                                      "/whats-on/being-norwegian", 
                                                                      "/whats-on/comrade-egg-and-the-chicken-of-tomorrow", 
                                                                      "/whats-on/daft-show-with-bony-tony", 
                                                                      "/whats-on/isiqalo-the-beginning", 
                                                                      "/whats-on/maths-madness-with-kyle-d-evans", 
                                                                      "/whats-on/reality-sucks", 
                                                                      "/whats-on/whistle-while-you-werk", 
                                                                      "/whats-on/clash-of-the-tight-tens-2", 
                                                                      "/whats-on/eliott-simpson-a-sexy-and-i-know-it", 
                                                                      "/whats-on/in-conversation-with-len-mccluskey", 
                                                                      "/whats-on/careless-love", 
                                                                      "/whats-on/dog-in-the-manger", 
                                                                      "/whats-on/glowed-up", 
                                                                      "/whats-on/late-17th-to-mid-19th-century-arias", 
                                                                      "/whats-on/rod-shepherd-slacktivist-free-2", 
                                                                      "/whats-on/triplex-adventures-1", 
                                                                      "/whats-on/community-circle", 
                                                                      "/whats-on/death-and-the-maiden", 
                                                                      "/whats-on/hoichi-the-earless", 
                                                                      "/whats-on/how-to-raise-a-teenager-in-2019", 
                                                                      "/whats-on/narcolepsy", 
                                                                      "/whats-on/positive-education-sponsored-by-the-rsa", 
                                                                      "/whats-on/veronica-yen-piano-recitals", 
                                                                      "/whats-on/yo-wu-debut-recital", 
                                                                      "/whats-on/daisy-macdade-sugarbaby", 
                                                                      "/whats-on/jamie-fraser-and-maybe-someone-else-i-don-t-know", 
                                                                      "/whats-on/thinking-outside-the-penalty-box", 
                                                                      "/whats-on/zahra-barri-s-special-work-in-progress-2", 
                                                                      "/whats-on/good-morning-nation", 
                                                                      "/whats-on/humoresque", 
                                                                      "/whats-on/interviewing-electric-frog-2", 
                                                                      "/whats-on/mother-goose", 
                                                                      "/whats-on/nicky-wilkinson-game-on-2", 
                                                                      "/whats-on/scottish-youth-parliament-are-student-voices-being-heard", 
                                                                      "/whats-on/17th-to-21st-century-airs", 
                                                                      "/whats-on/andrew-carnegie-2", 
                                                                      "/whats-on/clinic-4-kidz", 
                                                                      "/whats-on/goodnight-mr-tom", 
                                                                      "/whats-on/of-sound-mind", 
                                                                      "/whats-on/pottervision-1", 
                                                                      "/whats-on/russell-howard-work-in-progress-afternoon", 
                                                                      "/whats-on/steve", 
                                                                      "/whats-on/1890-1930-the-uncrowned-queens-of-blues-hot-jazz-and-hokum-from-new-orleans-to-memphis-2", 
                                                                      "/whats-on/alternative-comedy-cabaret", 
                                                                      "/whats-on/bloom-2", 
                                                                      "/whats-on/darcie-silver-i-know-you-are", 
                                                                      "/whats-on/david-ephgrave-niche", 
                                                                      "/whats-on/mistaken-2", 
                                                                      "/whats-on/musicedy", 
                                                                      "/whats-on/monsters-a-new-musical", 
                                                                      "/whats-on/nik-coppin-shark-2", 
                                                                      "/whats-on/shaggers-5", 
                                                                      "/whats-on/train-d-afrique-1", 
                                                                      "/whats-on/1890-1930-the-uncrowned-queens-of-blues-hot-jazz-and-hokum-from-new-orleans-to-memphis-1", 
                                                                      "/whats-on/alfie-and-george", 
                                                                      "/whats-on/dr-lara-love-love-leans-in-2", 
                                                                      "/whats-on/edinburgh-comedy-awards-gala", 
                                                                      "/whats-on/joe-bor-the-story-of-walter-and-herbert-1", 
                                                                      "/whats-on/ruby-wax-how-to-be-human", 
                                                                      "/whats-on/this-time-it-will-be-different", 
                                                                      "/whats-on/adventures-in-dementia-steve-day-2", 
                                                                      "/whats-on/andrew-carnegie-1835-1919", 
                                                                      "/whats-on/andy-zaltzman-ctrl-z", 
                                                                      "/whats-on/borne-of-chaos", 
                                                                      "/whats-on/cerys-nelmes-80s-gameshow-mash-up-2", 
                                                                      "/whats-on/deskchair-burlesque", 
                                                                      "/whats-on/kimchi-life-is-a-happy-dream", 
                                                                      "/whats-on/left-wing-conspiracy-theorist-with-dyspraxia-2-2", 
                                                                      "/whats-on/please-forget", 
                                                                      "/whats-on/train-d-afrique", 
                                                                      "/whats-on/confetti-and-chaos", 
                                                                      "/whats-on/identity-crisis", 
                                                                      "/whats-on/not-black-and-white", 
                                                                      "/whats-on/scotland-today", 
                                                                      "/whats-on/absolute-zero-jez-watts-2", 
                                                                      "/whats-on/alcohol-is-good-for-you-sam-kissajukian-2", 
                                                                      "/whats-on/aidan-goatley-happy-britain-part-1", 
                                                                      "/whats-on/degrees-of-guilt", 
                                                                      "/whats-on/extracts-from-1936-by-tom-mcnab", 
                                                                      "/whats-on/perfect", 
                                                                      "/whats-on/shameless-berlin-presents-pussy-powered-cabaret", 
                                                                      "/whats-on/unfair-advantage", 
                                                                      "/whats-on/allan-taylor", 
                                                                      "/whats-on/edinbra-fringe-comedy-2", 
                                                                      "/whats-on/marvelus-awww-snap", 
                                                                      "/whats-on/peter-seivewright-pianoforte", 
                                                                      "/whats-on/self-ish", 
                                                                      "/whats-on/comedy-gala-2019-in-aid-of-waverley-care", 
                                                                      "/whats-on/eric-andre-the-stand-up-tour-1", 
                                                                      "/whats-on/brown-guys-grey-skies-1", 
                                                                      "/whats-on/sin-on-my-face", 
                                                                      "/whats-on/st-andrews-revue-presents-hot-yogurt", 
                                                                      "/whats-on/toxic", 
                                                                      "/whats-on/gary-lamont-fancy-a-stiff-one", 
                                                                      "/whats-on/oxford-revue-in-poor-taste", 
                                                                      "/whats-on/random", 
                                                                      "/whats-on/1890-1930-the-uncrowned-queens-of-blues-hot-jazz-and-hokum-from-new-orleans-to-memphis", 
                                                                      "/whats-on/aidan-taco-jones-52-days-2", 
                                                                      "/whats-on/bbc-the-tim-vine-chat-show", 
                                                                      "/whats-on/ben-hart-the-nutshell-1", 
                                                                      "/whats-on/edinburgh-tv-festival-presents-donovan-in-conversation-with-jez-butterworth", 
                                                                      "/whats-on/even-more-twisted-2", 
                                                                      "/whats-on/needle-dicks-2", 
                                                                      "/whats-on/phil-jerrod-unrelatable", 
                                                                      "/whats-on/salfunni-comedy-2", 
                                                                      "/whats-on/2019-greek-comedian-of-the-year", 
                                                                      "/whats-on/abandoman-aka-rob-broderick-the-road-to-coachella", 
                                                                      "/whats-on/brown-guys-grey-skies", 
                                                                      "/whats-on/toxic-1", 
                                                                      "/whats-on/black-never-die", 
                                                                      "/whats-on/bobby-mair-cockroach", 
                                                                      "/whats-on/heavenly-comedy-edinburgh-2", 
                                                                      "/whats-on/gloria-hole-presents-the-clinic", 
                                                                      "/whats-on/julia-rorke", 
                                                                      "/whats-on/late-night-comedy-death-camp-2", 
                                                                      "/whats-on/nico-no-regrets", 
                                                                      "/whats-on/rich-b-tch-how-to-make-money-with-the-power-of-your-mind", 
                                                                      "/whats-on/russell-howard-work-in-progress-evening", 
                                                                      "/whats-on/yum-yum", 
                                                                      "/whats-on/phil-kay-a-happening-1", 
                                                                      "/whats-on/piece-now-more-artistically-accessible", 
                                                                      "/whats-on/scot-roast-afterburn", 
                                                     "/whats-on/gravel-road-show", 
                                                     "/whats-on/comedy-boxing-best-of-the-best-2", 
                                                     "/whats-on/benefit-in-aid-of-silver-line", 
                                                     "/whats-on/jack-tucker-comedy-stand-up-hour"))]



#### Make show names distinct -----

fringe_shows[, show_and_group := paste0(Title, " (", `Group Name`, ")")]

#### Run loop to get data ----

for (i in 1:fringe_shows[, .N]) {
  next_show <- xml2::read_html(paste0("https://tickets.edfringe.com", fringe_shows[, `Book Tickets`[i]]))
  
  review_text <- next_show %>%
    html_nodes(".review-inner p") %>%
    html_text()
  
  if (length(review_text) == 0) {
    no_reviews <- c(no_reviews, fringe_shows[, show_and_group[i]])
  } else {
    new_data <- data.table(show_and_group = fringe_shows[, show_and_group[i]], review = review_text)
    all_reviews <- rbind(all_reviews, new_data)
  }
}

#### Check missing data -----

shows_so_far <- unique(all_reviews[, show])
tail(shows_so_far)

all_reviews_clean <- all_reviews[!review %like% "Read the full review|Please login to add a review|Participants - for further details on our audience and|This review was reported and removed after review|This review has been removed by the original author"]

## Write out review data

write_feather(all_reviews_clean, "./sentiment/all_reviews_differentiated.feather")

