setAPIKey <- function(){
  input = readline(prompt="Enter your FlightStats API Key: ")
  Sys.setenv(flightstats_api_key = input) # this is a more simple way of storing API keys, it saves it in the .Rprofile file, however this is only temporary - meaning next session the login details will have to be provided again. See below how to store login details in a more durable way.
}
setAppId <- function(){
  input = readline(prompt="Enter your FlightStats appID: ")
  Sys.setenv(flightstats_app_id = input)
}

#' Function list airlines by IATA code
#'
#' @param activeOnly logical value
#' @return data.frame() with the airline
#'
#' @author yuan qingye, \email{qingye.yuan@gmail.com}
#'
#' @examples
#' listAirlines()
#'
#' @import RCurl
#' @import jsonlite
#' @export
#'
listAirlines <- function(activeOnly=TRUE){
  ID = Sys.getenv("flightstats_app_id") 
  if (ID == ""){
    stop("Please set your FlightStats AppID and API Key with the setAPIKey() and setAppId() function. You can obtain these from https://developer.flightstats.com.")
  }
  KEY = Sys.getenv("flightstats_api_key")
  if (ID == ""){
    stop("Please set your FlightStats AppID and API Key with the setAPIKey() and setAppId() function. You can obtain these from https://developer.flightstats.com.")
  }  
  if(missing(activeOnly)){
    choice = "active"
  }
  if(activeOnly == FALSE) {
    choice = "all"
  } 
  else {
    choice = "active"
  }
  link = paste0("https://api.flightstats.com/flex/airlines/rest/v1/json/",choice,"?appId=",ID,"&appKey=",KEY)
  dat = getURL(link)
  dat_list <- fromJSON(dat)
  airlines <- dat_list$airlines
  return(airlines)
}

#' Function searches a specific airline by IATA code
#'
#' @param value character, an airline IATA code
#' @return data.frame() with the airline
#'
#' @author yuan qingye, \email{qingye.yuan@gmail.com}
#'
#' @examples
#' searchAirline("FR")
#'
#' @import RCurl
#' @import jsonlite
#' @export
#'
searchAirline <-
  function(value){
    ID = Sys.getenv("flightstats_app_id")
    if (ID == ""){
      stop("Please set your FlightStats AppID and API Key with the setAPIKey() and setAppId() function. You can obtain these from https://developer.flightstats.com.")
    }
    KEY = Sys.getenv("flightstats_api_key")
    if (ID == ""){
      stop("Please set your FlightStats AppID and API Key with the setAPIKey() and setAppId() function. You can obtain these from https://developer.flightstats.com.")
    }
    link = paste0("https://api.flightstats.com/flex/airlines/rest/v1/json/iata/",toupper(value),"?appId=",ID,"&appKey=",KEY)
    dat <- getURL(link)
    dat_list <- fromJSON(dat)
    result <- dat_list$airlines
    if (length(result)==0){
      warning("Please make sure that you provide a valid airline IATA code.")
    }
    return(result)
  }

#function need the explanation as I wrote above
package.skeleton(name = "FlightR", list = c("listAirlines","searchAirline","setAPIKey","setAppId"))
setwd("~/R_Projects/interestingR/FlightR")

#remove the file under man and NAMESPACE file
library(roxygen2)
# remove files in man
# add roxygen frame for all function then run
# if you set wd inside local package folder, no input, if you set other place, you need to specify the
# path of the folder, if you just outside the local package folder, just type the package/folder name
roxygenize()

library(devtools)
#all the process below need inside the local package folder(setwd)
#write document for the package using roxygenize
document()
#build the R package and store it in the containing folder of local package folder,which is important
#for linux system,or you can install directly from local package
build()
#install the package,can do directly 
install()

library(testR)

# can also using github to store the code:
# Note: These steps assume that you have Git installed and configured on your PC.
# 1) Create a new repository in your github account.
# 2) Create and copy the https link to clone the repo on your PC.
# 3) Go to the folder on your PC where you want to save your repo, open the command line interface & type:
#   
# $ git clone https://github.com/YourGithub/YourPackage.git
# 4) Copy all the files from your package in the folder and run:
#   
# $ git add .
# $ git commit -m "whatever message you want to add"
# $ git push origin master
# 5) Voila – now your package should be on GitHub!
#   
#   Now people can download & install your package straight from GitHub or GitLab – the devtools package has a function for this:
#   
#   if (!require(devtools)) {
#     install.packages('devtools')
#   }    
# # If your repo is on GitHub:
# devtools::install_github('YourGithub/YourPackage')
