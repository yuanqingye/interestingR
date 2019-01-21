library(lime)
library(text2vec)
library(xgboost)

# Explaining a model based on text data
# Purpose is to classify sentences from scientific publications
# and find those where the team writes about their own work
# (category OWNX in the provided dataset).
data(train_sentences)
data(test_sentences)
# AIMX - The specific research goal of the paper
# OWNX - The author's own work (methods, results, conclusions...)
# CONT - Contrast, comparasion or critique of past work
# BASE - Past work that provides the basis for the work in the article
# MISC - Any other sentences.

get_matrix <- function(text) {
  it <- itoken(text, progressbar = FALSE)
  create_dtm(it, vectorizer = hash_vectorizer())
}

dtm_train = get_matrix(train_sentences$text)

xgb_model <- xgb.train(list(max_depth = 7, eta = 0.1, objective = "binary:logistic",
                            eval_metric = "error", nthread = 1),
                       xgb.DMatrix(dtm_train, label = train_sentences$class.text == "OWNX"),
                       nrounds = 50)

sentences <- head(test_sentences[test_sentences$class.text == "OWNX", "text"], 1)
explainer <- lime(train_sentences$text, xgb_model, get_matrix)
explanations <- explain(sentences, explainer, n_labels = 1, n_features = 2)

print(explanations)

# Explaining a model based on tabular data
library(MASS)
iris_test <- iris[1, 1:4]
iris_train <- iris[-1, 1:4]
iris_lab <- iris[[5]][-1]
# Create linear discriminant model on iris data
model <- lda(iris_train, iris_lab)
# Create explanation object
explanation <- lime(iris_train, model)
explain(iris_test, explanation, n_labels = 1, n_features = 2)

# using ?model_support to see how to deal with different models