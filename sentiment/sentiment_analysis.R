library(data.table)
library(feather)
library(tidytext)

#### Read in and prepare data ---------------

labelled_reviews <- as.data.table(read_feather("./sentiment/labelled_data.feather"))

## Test set 50% of the sample size
smp_size <- floor(0.5 * labelled_reviews[, .N])

## set the seed to make your partition reproducible
set.seed(123)

train_index <- sample(seq_len(labelled_reviews[, .N]), size = smp_size)

train_labelled <- labelled_reviews[train_index, ]
test_labelled <- labelled_reviews[-train_index, ]

words_in_reviews <- unnest_tokens(test_labelled, word, review)

### Using bing --------------

bing_sentiment <- merge(words_in_reviews, get_sentiments("bing"))

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


### Using AFINN ---------------

afinn_sentiment <- merge(words_in_reviews, get_sentiments("afinn"))

afinn_reviews <- afinn_sentiment[, .(sentiment_score = sum(value)), by = original_index]

afinn_reviews[, overall_sentiment := ifelse(sentiment_score < 0, "negative", ifelse(sentiment_score == 0, "mixed", "positive"))]

afinn_sentiment_outcome <- merge(test_labelled,
                                 afinn_reviews[, .(original_index, overall_sentiment)],
                                by = "original_index", all.x = TRUE)

afinn_sentiment_outcome[is.na(overall_sentiment), overall_sentiment := "mixed"]

afinn_sentiment_outcome[, match := sentiment_label == overall_sentiment]

afinn_sentiment_outcome[, .N, by = match]

### Using NRC ---------------

nrc_sentiment <- merge(words_in_reviews, get_sentiments("nrc"))

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





