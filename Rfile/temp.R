df <- read.table(textConnection("1|a,b,c\n2|a,c\n3|b,d\n4|e,f"), header = F, sep = "|", stringsAsFactors = F)

s <- strsplit(df$V2, split = ",")
data.frame(V1 = rep(df$V1, sapply(s, length)), V2 = unlist(s))
library(tidyr)
separate_rows(df, V2)

df = matrix(nrow = 3,ncol = 3)
df = data.frame(df)
library(plyr)
alply(df,1)

library(AUC)
data(churn)
test_roc = roc(churn$predictions,churn$labels)
test_auc = auc(test_roc)

library(rstudioapi)
temp = dirname(rstudioapi::getActiveDocumentContext()$path)
