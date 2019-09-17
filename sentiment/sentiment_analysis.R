library(data.table)
library(feather)
library(tidytext)
# library(stringr)
# library(tidyr)

#### Read in and prepare data ---------------

labelled_reviews <- as.data.table(read_feather("./sentiment/labelled_data.feather"))

posneg_labelled <- labelled_reviews[sentiment_label %in% c("positive", "negative", "mixed")]

## Test set 50% of the sample size
smp_size <- floor(0.5 * posneg_labelled[, .N])

## set the seed to make your partition reproducible
set.seed(123)

train_index <- sample(seq_len(posneg_labelled[, .N]), size = smp_size)

train_labelled <- posneg_labelled[train_index, ]
test_labelled <- posneg_labelled[-train_index, ]

tidy_reviews <- unnest_tokens(test_labelled, word, review)

### Using bing --------------

bing_sentiment <- merge(tidy_reviews, get_sentiments("bing"))

positive_review_words <- bing_sentiment[sentiment == "positive", .(positive_words = .N), by = original_index]
negative_review_words <- bing_sentiment[sentiment == "negative", .(negative_words = .N), by = original_index]

all_review_words <- merge(positive_review_words, negative_review_words, all = TRUE)

all_review_words[is.na(all_review_words)] <- 0

all_review_words[, combined_sentiment := positive_words - negative_words]
all_review_words[, overall_sentiment := ifelse(combined_sentiment < 0, "negative", ifelse(combined_sentiment == 0, "mixed", "positive"))]

bing_sentiment_outcome <- merge(test_labelled,
                           all_review_words[, .(original_index, overall_sentiment)],
                           by = "original_index", all.x = TRUE)

bing_sentiment_outcome[is.na(overall_sentiment), overall_sentiment := "mixed"]

bing_sentiment_outcome[, match := sentiment_label == overall_sentiment]

bing_sentiment_outcome[, .N, by = match]


### Using AFINN ---------------

afinn_sentiment <- merge(tidy_reviews, get_sentiments("afinn"))

afinn_reviews <- afinn_sentiment[, .(sentiment_score = sum(score)), by = original_index]

afinn_reviews[, overall_sentiment := ifelse(sentiment_score < 0, "negative", ifelse(sentiment_score == 0, "mixed", "positive"))]

afinn_sentiment_outcome <- merge(test_labelled,
                                 afinn_reviews[, .(original_index, overall_sentiment)],
                                by = "original_index", all.x = TRUE)

afinn_sentiment_outcome[is.na(overall_sentiment), overall_sentiment := "mixed"]

afinn_sentiment_outcome[, match := sentiment_label == overall_sentiment]

afinn_sentiment_outcome[, .N, by = match]

### Using NRC ---------------

nrc_sentiment <- merge(tidy_reviews, get_sentiments("nrc"))

positive_review_words <- nrc_sentiment[sentiment == "positive", .(positive_words = .N), by = original_index]
negative_review_words <- nrc_sentiment[sentiment == "negative", .(negative_words = .N), by = original_index]

all_review_words <- merge(positive_review_words, negative_review_words, all = TRUE)

all_review_words[is.na(all_review_words)] <- 0

all_review_words[, combined_sentiment := positive_words - negative_words]
all_review_words[, overall_sentiment := ifelse(combined_sentiment < 0, "negative", ifelse(combined_sentiment == 0, "mixed", "positive"))]

nrc_sentiment_outcome <- merge(test_labelled,
                                 all_review_words[, .(original_index, overall_sentiment)],
                                 by = "original_index", all.x = TRUE)

nrc_sentiment_outcome[is.na(overall_sentiment), overall_sentiment := "mixed"]

nrc_sentiment_outcome[, match := sentiment_label == overall_sentiment]

nrc_sentiment_outcome[, .N, by = match]





