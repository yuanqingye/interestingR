# https://stats.stackexchange.com/questions/141462/different-results-from-randomforest-via-caret-and-the-basic-randomforest-package
cvCtrl = trainControl(method = "repeatedcv",number = 10, repeats = 3, classProbs = TRUE, summaryFunction = twoClassSummary)
newGrid = expand.grid(mtry = c(2,4,8,15))
classifierRandomForest = train(case_success ~ ., data = train_data, trControl = cvCtrl, method = "rf", metric="ROC", tuneGrid = newGrid)
curClassifier = classifierRandomForest

##ROC-Curve
predRoc = predict(curClassifier, test_data, type = "prob")
myroc = pROC::roc(test_data$case_success, as.vector(predRoc[,2]))
plot(myroc, print.thres = "best")