library(RISmed)
res <- EUtilsSummary("pinkeye", type="esearch", db="pubmed", datetype='pdat', mindate=2000, maxdate=2015, retmax=500)
QueryCount(res)

temp = EUtilsGet(res)
t = ArticleTitle(temp)
typeof(t)
head(t,1)
t[2]

YearPubmed(temp)
YearReceived(temp)

library(ggplot2)
date()
count<-table(y)
count<-as.data.frame(count)
names(count)<-c("Year", "Counts")
num <- data.frame(Year=count$Year, Counts=cumsum(count$Counts))
num$g <- "g"
names(num) <- c("Year", "Counts", "g")
q <- ggplot(aes(x=Year, y=Counts), data=count) + geom_bar(stat = "identity")
q <- q + ggtitle(paste("PubMed articles containing \'", "\' ", "= ", max(num$Counts), sep="")) +
  ylab("Number of articles") +
  xlab(paste("Year \n Query date: ", Sys.time(), sep="")) +
  labs(colour="") +
  theme_bw()
q

library(qdap)
myFunc<-function(argument){
  articles1<-data.frame('Abstract'=AbstractText(temp), 'Year'=YearPubmed(temp))
  abstracts1<-articles1[which(articles1$Year==argument),]
  abstracts1<-data.frame(abstracts1)
  abstractsOnly<-as.character(abstracts1$Abstract)
  abstractsOnly<-paste(abstractsOnly, sep="", collapse="")
  abstractsOnly<-as.vector(abstractsOnly)
  abstractsOnly<-strip(abstractsOnly)
  stsp<-rm_stopwords(abstractsOnly, stopwords = qdapDictionaries::Top100Words)
  ord<-as.data.frame(table(stsp))
  ord<-ord[order(ord$Freq, decreasing=TRUE),]
  head(ord,20)
}

oSix<-myFunc(2006)
oSeven<-myFunc(2007)
all<-cbind(oSix, oSeven)
names(all)<-c("2006","freq","2007","freq")


auths<-Author(temp)
typeof(auths)
auths[3]
Last<-sapply(auths, function(x) paste(x$LastName))
auths2<-as.data.frame(sort(table(unlist(Last)), dec=TRUE))
names(auths2)<-c("name")
head(auths2)
