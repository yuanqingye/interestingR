#Install if the package doesn't exist 
install.packages('DataExplorer')
# https://cran.r-project.org/src/contrib/Archive/DataExplorer/DataExplorer_0.5.0.tar.gz
# https://cran.r-project.org/src/contrib/Archive/DataExplorer/DataExplorer_0.4.0.tar.gz
install.packages("https://cran.r-project.org/src/contrib/Archive/DataExplorer/DataExplorer_0.4.0.tar.gz", repo=NULL, type="source")
library(DataExplorer)
library(rmarkdown)
choco = read.csv("flavors_of_cacao.csv",header = T,stringsAsFactors = F)
choco$Cocoa.Percent = as.numeric(gsub('%','',choco$Cocoa.Percent))
choco$Review.Date = as.character(choco$Review.Date)

PlotStr(choco)
PlotMissing(choco)
HistogramContinuous(choco)
DensityContinuous(choco)
CorrelationContinuous(choco)
BarDiscrete(choco)

GenerateReport(choco)
??`DataExplorer-package`
