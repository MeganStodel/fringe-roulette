library(data.table)
library(feather)
library(stringr)
extrafont::loadfonts(device="win")
library(ggplot2)

## Read in data ----------------

fringe_shows <- as.data.table(read_feather("fringe_shows.feather"))
names(fringe_shows) <- tolower(names(fringe_shows))
names(fringe_shows) <- gsub(" ", "_", names(fringe_shows))
setnames(fringe_shows, "title", "show")

reviews <- as.data.table(read_feather("./sentiment/all_reviews_differentiated.feather"))

##### Remove shows with broken links ----
fringe_shows <- fringe_shows[!(book_tickets %in% c("/whats-on/midsummer-night-s-dream-2", 
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

#### Add metrics ---------------------------------------------------------------

venue_name <- c("Pleasance", 
                "Gilded Balloon", 
                "Underbelly", 
                "Just the Tonic", 
                "Summerhall", 
                "Assembly", 
                "Laughing Horse", 
                "theSpace", 
                "Scottish Comedy Festival", 
                "PBH's Free Fringe", 
                "ZOO", 
                "Sweet", 
                "Greenside", 
                "The Stand", 
                "Heroes", 
                "C venues", 
                "Paradise")

for (i in 1:length(venue_name)) {
  fringe_shows[venue %like% venue_name[i], venue_for_analysis := venue_name[i]]
}

fringe_shows[is.na(venue_for_analysis), venue_for_analysis := venue]

fringe_shows[, run_length := str_count(dates, ',') + 1]

fringe_shows[, show_and_group := paste0(show, " (", group_name, ")")]

# Deal with multiple shows

multiple_shows <- fringe_shows[, .N, by = show_and_group][N != 1]
multiple_shows <- multiple_shows[, show_and_group]

multiple_shows_data <- fringe_shows[show_and_group %in% multiple_shows]


for (i in 1:length(multiple_shows)) {
  multiple_shows_data[show_and_group == multiple_shows[i], run_length := sum(run_length), by = group_name]
}

multiple_shows_data <- multiple_shows_data[, .(show_and_group, show, group_name, category, run_length, venue_for_analysis)]
multiple_shows_data <- unique(multiple_shows_data)

annoying_venue <- multiple_shows_data[, .N, by = show_and_group]
annoying_venue <- annoying_venue[N != 1, show_and_group]

multiple_shows_data <- multiple_shows_data[show_and_group %in% annoying_venue, venue_for_analysis := "Multiple"]
multiple_shows_data <- unique(multiple_shows_data)

fringe_shows <- fringe_shows[!(show_and_group %in% multiple_shows),
                             .(show_and_group, show, group_name, category, run_length, venue_for_analysis)]

fringe_shows <- rbind(fringe_shows, multiple_shows_data)

write_feather(fringe_shows, "sentiment/cleaned_fringe_shows.feather")

## Number of reviews per show

reviews_per_show <- reviews[, .(number_of_reviews = .N), by = show_and_group]

no_review_shows <- data.table(show_and_group = setdiff(fringe_shows[, show_and_group], reviews[, show_and_group]), 
                              number_of_reviews = 0)

reviews_per_show <- rbind(reviews_per_show, no_review_shows)

reviews_per_show[, got_reviewed := ifelse(number_of_reviews != 0, TRUE, FALSE)]

reviews_data <- merge(reviews_per_show, 
                          fringe_shows, 
                          all.x = TRUE)

write_feather(reviews_data, "sentiment/cleaned_review_data.feather")


#### Load prepared data ---------------

reviews_data <- read_feather("sentiment/cleaned_review_data.feather")

# Only looking at shows with runs of at least 18 performances

full_run_reviews_data <- reviews_data[run_length >= 19]

fringe_theme <- theme_classic() + 
  theme(panel.background = element_rect(fill = "#E7DECD", colour = "#E7DECD"), 
        plot.background = element_rect(fill = "#E7DECD"), 
        text = element_text(colour = "#2C2C54"), 
        plot.title = element_text(family = "Agency FB", 
                                  size = 28, 
                                  hjust = 0.5), 
        axis.text = element_text(size = 14), 
        axis.title = element_text(size = 18, 
                                  family = "Bahnschrift"), 
        axis.line = element_line(colour = "#2C2C54")
  )

ggplot(full_run_reviews_data, aes(number_of_reviews)) +
  geom_histogram(fill = "#A13D63") + 
  labs(title = "Distribution of the number of reviews for each show", 
       x = "Number of reviews", 
       y = NULL) +
  fringe_theme

## Plot: number of reviews by category

reviews_per_category <- full_run_reviews_data[, .(average_reviews = median(number_of_reviews)), by = category][order(-average_reviews)]
factor_order <- reviews_per_category[, category]
reviews_per_category[, category := factor(category, levels = factor_order)]

addline_format <- function(x,...){
  gsub('\\s','\n',x)
}

category_labels <- addline_format(factor_order)


ggplot(reviews_per_category, aes(x = category, y = average_reviews)) +
  geom_bar(stat = "identity", fill = "#A13D63") +
  labs(title = "Average (median) number of reviews by category", 
       x = "Category", 
       y = NULL) +
  scale_x_discrete(labels = category_labels) +
  fringe_theme

## Focus on venues with at least 25 shows

shows_per_venue <- full_run_reviews_data[, .N, by = venue_for_analysis][order(-N)]
enough_shows <- shows_per_venue[N >= 30, venue_for_analysis]

high_show_venue_reviews <- full_run_reviews_data[venue_for_analysis %in% enough_shows]

reviews_per_venue <- high_show_venue_reviews[, .(average_reviews = median(number_of_reviews)), 
                                             by = venue_for_analysis][order(-average_reviews)]
venue_factor_order <- reviews_per_venue[, venue_for_analysis]
reviews_per_venue[, venue_for_analysis := factor(venue_for_analysis, levels = factor_order)]

high_show_venue_reviews[, venue_for_analysis := factor(venue_for_analysis, levels = factor_order)]

venue_labels <- addline_format(venue_factor_order)

ggplot(high_show_venue_reviews, aes(x = venue_for_analysis, y = number_of_reviews)) +
  geom_boxplot(fill = "#5EC29C") + 
  labs(title = "Boxplots of reviews by venue", 
       x = "Venue group", 
       y = NULL) +
  scale_x_discrete(labels = venue_labels) +
  fringe_theme + 
  theme(axis.text = element_text(size = 10))
