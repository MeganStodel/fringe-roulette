library(data.table)
library(feather)


reviews_data <- as.data.table(read_feather("sentiment/all_reviews_differentiated.feather"))

number_of_reviews <- reviews_data[, .N]

set.seed(5)

reviews_to_label <- sample(1:number_of_reviews, 400)

check_reviews <- reviews_data[reviews_to_label]

fwrite(check_reviews, "sentiment/reviews_to_label.csv")


### Read back in

labelled_data <- fread("sentiment/labelled reviews.csv")

labelled_data[, original_index := reviews_to_label]

check_reviews[, original_index := reviews_to_label]

labelled_data <- merge(check_reviews, labelled_data[, .(original_index, sentiment_label)])

labelled_data[, .N, by = sentiment_label]

write_feather(labelled_data, "sentiment/labelled_data.feather")
