library(data.table)
library(feather)
library(tidytext)


###### Using bigrams -----------------------------------------------------------

# https://www.tidytextmining.com/ngrams.html#tokenizing-by-n-gram - to consider negation

test_labelled <- as.data.table(read_feather("./sentiment/test_labelled.feather"))

# Remove modifiers (could be useful for score but will get in the way)

test_labelled <- test_labelled[, review := gsub("$very |$quite ", "", review)]

# Unnest into words

words_in_reviews <- unnest_tokens(test_labelled, word, review)

# Unnest into bigrams

bigrams_in_reviews <- unnest_tokens(test_labelled, bigram, review, token = "ngrams", n = 2)

# Separate into words

separated_bigrams <- copy(bigrams_in_reviews[, .(original_index, bigram)])

separated_bigrams[, c("word_1", "word_2") := tstrsplit(bigram, " ", fixed = TRUE)]

# Remove stopwords
# Don't remove because gets rid of no!!!!

# separated_bigrams <- separated_bigrams[!word_1 %in% stop_words$word & !word_2 %in% stop_words$word]


# Check negated sentiment

library(textdata)

negation_words <- c("not", "no", "never", "without", "weren’t", "wasn't")

# Bing

bing_words <- as.data.table(get_sentiments("bing"))

negated_bing <- separated_bigrams[word_1 %in% negation_words & word_2 %in% bing_words[, word]]

# Take the individual word rating for each review and switch them if negated

# for (i in negated_bing[, .N]) {
#   bing_sentiment[original_index == negated_bing[i, original_index] & 
#                    word == negated_bing[i, word_2],
#                  sentiment := ifelse(
#                    sentiment == "positive", "negative", "positive"
#                  )]
# }

# NB - in the above think of how to deal with multiple

bing_sentiment <- merge(words_in_reviews, bing_words)

negated_bing_reviews <- negated_bing[, unique(original_index)]

for (review in 1:length(negated_bing_reviews)) {
  negated_bing_words <- negated_bing[original_index == negated_bing_reviews[review]]
  words_to_change <- negated_bing_words[, unique(word_2)]
  scores_to_change <- bing_sentiment[original_index == negated_bing_reviews[review] &
                                       word %in% words_to_change]
  bing_sentiment <- bing_sentiment[!(original_index == negated_bing_reviews[review] &
                                       word %in% words_to_change)]
  for (token in 1:length(words_to_change)) {
    scores_to_change_word <- scores_to_change[word == words_to_change[token]]
    words_for_changing <- negated_bing_words[word_2 == words_to_change[token]]
    for (occurrence in 1:words_for_changing[, .N]) {
      scores_to_change_word[occurrence, sentiment := ifelse(
        sentiment == "positive", "negative", "positive"
      )]
    }
    bing_sentiment <- rbind(bing_sentiment, scores_to_change_word)
    print(paste0("Completed: ", negated_bing_reviews[review], ", ", words_to_change[token]))
  }
}


positive_bing_words <- bing_sentiment[sentiment == "positive", .(positive_words = .N), by = original_index]
negative_bing_words <- bing_sentiment[sentiment == "negative", .(negative_words = .N), by = original_index]

all_bing_words <- merge(positive_bing_words, negative_bing_words, all = TRUE)

all_bing_words[is.na(all_bing_words)] <- 0

all_bing_words[, combined_sentiment := positive_words - negative_words]
all_bing_words[, overall_sentiment := ifelse(combined_sentiment < 0, "negative", ifelse(combined_sentiment == 0, "mixed", "positive"))]

bing_sentiment_outcome <- merge(test_labelled,
                                all_bing_words[, .(original_index, overall_sentiment)],
                                by = "original_index", all.x = TRUE)

bing_sentiment_outcome[is.na(overall_sentiment), overall_sentiment := "mixed"]

bing_sentiment_outcome[, match := sentiment_label == overall_sentiment]

bing_sentiment_outcome[, .N, by = match]


# AFINN

afinn_words <- as.data.table(get_sentiments("afinn"))

negated_afinn <- separated_bigrams[word_1 %in% negation_words & word_2 %in% afinn_words[, word]]

# Take the individual word rating for each review and switch them if negated

# for (i in negated_afinn[, .N]) {
#   afinn_sentiment[original_index == negated_afinn[i, original_index] & 
#                    word == negated_afinn[i, word_2],
#                  sentiment := ifelse(
#                    sentiment == "positive", "negative", "positive"
#                  )]
# }

# NB - in the above think of how to deal with multiple

afinn_sentiment <- merge(words_in_reviews, afinn_words)

negated_afinn_reviews <- negated_afinn[, unique(original_index)]

for (review in 1:length(negated_afinn_reviews)) {
  negated_afinn_words <- negated_afinn[original_index == negated_afinn_reviews[review]]
  words_to_change <- negated_afinn_words[, unique(word_2)]
  scores_to_change <- afinn_sentiment[original_index == negated_afinn_reviews[review] &
                                       word %in% words_to_change]
  afinn_sentiment <- afinn_sentiment[!(original_index == negated_afinn_reviews[review] &
                                       word %in% words_to_change)]
  for (token in 1:length(words_to_change)) {
    scores_to_change_word <- scores_to_change[word == words_to_change[token]]
    words_for_changing <- negated_afinn_words[word_2 == words_to_change[token]]
    for (occurrence in 1:words_for_changing[, .N]) {
      scores_to_change_word[occurrence, value := value * -1]
    }
    afinn_sentiment <- rbind(afinn_sentiment, scores_to_change_word)
    print(paste0("Completed: ", negated_afinn_reviews[review], ", ", words_to_change[token]))
  }
}

afinn_sentiment <- merge(words_in_reviews, get_sentiments("afinn"))

afinn_reviews <- afinn_sentiment[, .(sentiment_score = sum(value)), by = original_index]

afinn_reviews[, overall_sentiment := ifelse(sentiment_score < 0, "negative", ifelse(sentiment_score == 0, "mixed", "positive"))]

afinn_sentiment_outcome <- merge(test_labelled,
                                 afinn_reviews[, .(original_index, overall_sentiment)],
                                 by = "original_index", all.x = TRUE)

afinn_sentiment_outcome[is.na(overall_sentiment), overall_sentiment := "mixed"]

afinn_sentiment_outcome[, match := sentiment_label == overall_sentiment]

afinn_sentiment_outcome[, .N, by = match]

# NRC

nrc_words <- as.data.table(get_sentiments("nrc"))

negated_nrc <- separated_bigrams[word_1 %in% negation_words & word_2 %in% nrc_words[, word]]

nrc_sentiment <- merge(words_in_reviews, nrc_words)

negated_nrc_reviews <- negated_nrc[, unique(original_index)]

for (review in 1:length(negated_nrc_reviews)) {
  negated_nrc_words <- negated_nrc[original_index == negated_nrc_reviews[review]]
  words_to_change <- negated_nrc_words[, unique(word_2)]
  scores_to_change <- nrc_sentiment[original_index == negated_nrc_reviews[review] &
                                       word %in% words_to_change]
  nrc_sentiment <- nrc_sentiment[!(original_index == negated_nrc_reviews[review] &
                                       word %in% words_to_change)]
  for (token in 1:length(words_to_change)) {
    scores_to_change_word <- scores_to_change[word == words_to_change[token]]
    words_for_changing <- negated_nrc_words[word_2 == words_to_change[token]]
    for (occurrence in 1:words_for_changing[, .N]) {
      scores_to_change_word[occurrence, sentiment := ifelse(
        sentiment == "positive", "negative", "positive"
      )]
    }
    nrc_sentiment <- rbind(nrc_sentiment, scores_to_change_word)
    print(paste0("Completed: ", negated_nrc_reviews[review], ", ", words_to_change[token]))
  }
}


positive_nrc_words <- nrc_sentiment[sentiment == "positive", .(positive_words = .N), by = original_index]
negative_nrc_words <- nrc_sentiment[sentiment == "negative", .(negative_words = .N), by = original_index]

all_nrc_words <- merge(positive_nrc_words, negative_nrc_words, all = TRUE)

all_nrc_words[is.na(all_nrc_words)] <- 0

all_nrc_words[, combined_sentiment := positive_words - negative_words]
all_nrc_words[, overall_sentiment := ifelse(combined_sentiment < 0, "negative", ifelse(combined_sentiment == 0, "mixed", "positive"))]

nrc_sentiment_outcome <- merge(test_labelled,
                                all_nrc_words[, .(original_index, overall_sentiment)],
                                by = "original_index", all.x = TRUE)

nrc_sentiment_outcome[is.na(overall_sentiment), overall_sentiment := "mixed"]

nrc_sentiment_outcome[, match := sentiment_label == overall_sentiment]

nrc_sentiment_outcome[, .N, by = match]

