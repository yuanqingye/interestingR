# design a inner database, to store big datasets, here the format(file encoding) need to be noticed

# install.packages('MonetDBLite', dependencies = TRUE)
# install.packages("https://cran.r-project.org/src/contrib/Archive/MonetDBLite/MonetDBLite_0.6.0.tar.gz",repo = NULL,type = "source")
library(MonetDBLite)
library(DBI)
## Set directory to the database
dbdir <- 'database/'

## Creating a conection to the database
con <- dbConnect(MonetDBLite::MonetDBLite() , dbdir)

## Dumping the csv file to the database
monetdb.read.csv(conn = con, files = 'flavors_of_cacao.csv', tablename = 'cacao', header = TRUE, na.strings = '', delim = ',')

## Listing tables
dbListTables(con)

## Couting rows in the table
dbGetQuery(con, 'SELECT count(*) FROM cacao')

## Quering the firts 100 rows
teste <- dbGetQuery(con, "SELECT * FROM cacao LIMIT 100")

## Loading packages
library(dplyr)

## Connection to the database
my_db <- MonetDBLite::src_monetdb(embedded=dbdir)
my_tbl <- tbl(my_db, "cacao")

## Getting the average over province and administrative dependency
my_tbl %>% group_by(Review.Date, Broad.Bean.Origin) %>% summarise(mean(Rating)) -> consulta

## Collecting the data
consulta <- collect(consulta)
