# This package is required for Accessing APIS (HTTP or HTTPS URLS from Web)
library(httr)
#This package exposes some additional functions to convert json/text to data frame
library(rlist)
#This package exposes some additional functions to convert json/text to data frame
library(jsonlite)
#This library is used to manipulate data
library(dplyr)

resp<-GET("https://reqres.in/api/users?pageid=2")
#.When we get the response from API we will use to very basic methods of httr.
http_type(resp)  #. This method will tell us what is the type of response fetched from GET() call to the API.
http_error(resp)

query = list(page = "2")
resp = GET("https://reqres.in/api/users",query = query)
http_type(resp)
http_error(resp)

jsonRespText = content(resp,as = "text")
jsonRespParsed = content(resp,as = "parsed")

jsonliteparsed = fromJSON(jsonRespText)

modJson<-jsonRespParsed$data #. Access data element of whole list and ignore other vectors
View(modJson)

json_df = modJson%>%bind_rows%>%select(id,first_name,last_name,avatar)

rlistContent = list.select(modJson,id,last_name)
rlistStack = list.stack(modJson)

post_result <- POST(url="http://httpbin.org/post",body="this is a test") # where body argument accpets data we wish to send to server

#Get tibble from list is the very important point for this article