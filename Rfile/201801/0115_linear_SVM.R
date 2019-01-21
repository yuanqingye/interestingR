#This has a problem in the code
sms_data<-read.csv("~/model_data/classification_SVM_Data.csv",header = FALSE,stringsAsFactors = FALSE)
# sms_data = readxl::read_xlsx("~/model_data/SVM_classification_Data.xlsx")
head(sms_data)

plot(c(-1,10), c(-1,10), type = "n", xlab = "x", ylab = "y", asp = 1)
abline(a =12 , b = -5, col=3)
text(1,5, "h(x)=0", col = 2, adj = c(-.1, -.1))
text(2,3, "h(x)>0,Ham", col = 2, adj = c(-.1, -.1))
text(0,3, "h(x)<0,Spam", col = 2, adj = c(-.1, -.1))

library(tm)
colnames(sms_data) = c("type","text")
sms_data$type<-factor(sms_data$type)

simply_text<-Corpus(VectorSource(sms_data$text))

cleaned_corpus<-tm_map(simply_text, tolower)
cleaned_corpus<-tm_map(cleaned_corpus,removeNumbers)
cleaned_corpus<-tm_map(cleaned_corpus,removeWords,stopwords())
#cleaned_corpus<-tm_map(cleaned_corpus,removePunctuation)
#cleaned_corpus<-tm_map(cleaned_corpus,stripWhitespace)

sms_dtm<-DocumentTermMatrix(cleaned_corpus)
sms_train<-sms_dtm[1:4000]
sms_test<-sms_dtm[4001:5574]
#sms_train<-cleaned_corpus[1:4000]
#sms_test<-cleaned_corpus[4001:5574]

freq_term=(findFreqTerms(sms_dtm,lowfreq=2))
sms_freq_train<-DocumentTermMatrix(sms_train,  list(dictionary=freq_term))
sms_freq_test<-DocumentTermMatrix(sms_test,list(dictionary=freq_term))

y<-sms_data$type
y_train<-y[1:4000]
y_test<-y[4001:5574]
library(e1071)
tuned_svm<-tune(svm, train.x=sms_train, train.y = y_train,kernel="linear", range=list(cost=10^(-2:2), gamma=c(0.1, 0.25,0.5,0.75,1,2)) )
print(tuned_svm)
adtm.m<-as.matrix(sms_train)
adtm.df<-as.data.frame(adtm.m)
svm_good_model<-svm(y_train~., data=adtm.df, kernel="linear",cost=tuned_svm$best.parameters$cost, gamma=tuned_svm$best.parameters$gamma)

adtm.m_test<-as.matrix(sms_freq_test)
adtm.df_test=as.data.frame(adtm.m_test)
y_pred<-predict(svm_good_model,adtm.df_test)
table(y_test,y_pred)

library(gmodels)
CrossTable(y_pred,y_test,prop.chisq = FALSE)