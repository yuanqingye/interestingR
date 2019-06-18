#import data from SPSS
library(foreign)
df <- read.spss("dataset.sav", use.value.label=TRUE, to.data.frame=TRUE)

#Import data from Stata
df <- read.dta("dataset.dta")

#Import data from SAS
library(Hmisc)
df <- sasxport.get("/filename.xpt") 

#Import data from CSV
read.csv()

#Import data from txt
df <- read.table("dataset.txt", as.is=TRUE, header=T)

#Import data from R
load("XXX.RData")