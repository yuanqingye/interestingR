# Create data to illustrate combining data frames
left <- data.frame(id=c(2:7),
                   y2=rnorm(6,100,5))

right <- data.frame(id=rep(1:4,each=2),
                    z2=sample(letters,8, replace=TRUE))

# Merging left and right: Data frames have columns "id" in common
merge(x=left, y=right, by="id", all.x = TRUE)

# Merging left and right: Data frames have columns "id" in common
library(sqldf)
mysqldatajoin <- sqldf("select left.*, right.* from left left join right on right.id = left.id")

#Generating datasets for stacking:
stackdf1 <- data.frame(both.int=1:4,
                       expand.factor=c("blue", "yellow"),
                       mixed.fac.int=factor(letters[1:4]),
                       date=as.Date("1983-11-22"),
                       df1only=rep(1:2, each=2),
                       mixed.fac.chr=I(c("a","b","NA",NA)))
stackdf2 <- data.frame(both.int=5:24,
                       expand.factor=factor(rep(c(1:4, NA), 4)),
                       mixed.fac.int=1:4,
                       date=as.Date("1981-09-24"),
                       df2only=factor(c("c", "d")),
                       mixed.fac.chr=c("a","b",NA,"c"))

#This is not join, just put data.frame with different col names together
library(Stack)
Stack(stackdf1,stackdf2)

Stack(left,right)
