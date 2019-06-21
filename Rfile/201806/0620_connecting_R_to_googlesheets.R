library(googlesheets)
options(browser = "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe")
proxy_url <- "http://127.0.0.1:50837/" #Psiphon 3
Sys.setenv(http_proxy = proxy_url, https_proxy = proxy_url, ftp_proxy = proxy_url)
gs_auth(new_user = TRUE)

#this will give you all the sheets under https://docs.google.com/spreadsheets/
gs_ls()

for_gs <- gs_title("googlesheet_test")
# for_gs <- gs_key("your_key_here")

for_gs_sheet <- gs_read(for_gs)
str(for_gs_sheet)

#this will update the document automately, which need be more cautious
gs_edit_cells(for_gs, ws = "Sheet1", anchor = "A2", input = c(1,2), byrow = TRUE)
str(for_gs)

gs_new(title = "mtcars", ws_title = "first_sheet", input = mtcars)


