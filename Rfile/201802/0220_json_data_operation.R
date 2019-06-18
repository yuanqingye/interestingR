#Install package
library(rjson)
jsonfile <- "~/model_data/losangelesrevenue.json"

#Extract JSON data using rjson
rev <- fromJSON(file=jsonfile)
datalength <- length(rev$data)

programName <- {}
department <- {}
revenue <- {}
fiscalperiod <- {}

tryCatch(
for (x in 1:datalength) {
  if(!is.null(rev$data[[x]][[12]])){
     programName <- c(programName,toString(noquote(rev$data[[x]][12])))
  }
  else{
     programName = c(programName,"")
  }
  if(!is.null(rev$data[[x]][[10]])){
    department <- c(department,toString(noquote(rev$data[[x]][10])))
  }
  else{
    department = c(department,"")
  }
  if(!is.null(rev$data[[x]][[18]])){
     revenue <- c(revenue,as.double(noquote(rev$data[[x]][[18]])))
  }
  else{
     revenue = c(revenue,0)
  }
  if(!is.null(rev$data[[x]][[17]])){
    fiscalperiod <- c(fiscalperiod,as.double(noquote(rev$data[[x]][[17]])))
  }
  else{
    fiscalperiod = c(fiscalperiod,0)
  }
},finally = print(x))

funddata = as.data.frame(cbind(programName,department,revenue,fiscalperiod))
