library(tidyverse)
library(RSQLite)
library(RMySQL)
library(data.table)
rm(cbike)
rm(ptm)
rm(ptm1)

rm(cbike)
rm(ptm)
rm(ptm1)
rm(ptn2)
ptm1 <-proc.time()
cbike <-dir("data",full.names=T) %>% map_df(data.table::fread)
proc.time() - ptm1
# Rename columns
names(cbike) <-c("tripduration","starttime","stoptime","startstationid",
                 "startstationname","startstationlatitude",
                 "startstationlongitude","endstationid",
                 "endstationname","endstationlatitude","
                 endstationlongitude","bikeid","usertype",
                 "birthyear","gender")

# SQLite stuff
# Change Date to text before importing into SQLite
cbike$starttime <- as.character(cbike$starttime)
cbike$stoptime <- as.character(cbike$stoptime)
ptm2 <-proc.time()
db <- dbConnect(SQLite(),dbname="city_bike.sqlite3")
dbWriteTable(db,"cbike",cbike,row.names=FALSE,overwrite=TRUE)
# dbListTables(db)
# dbDisconnect(db)
proc.time() -ptm2
#
dbSendStatement(db, "create index duration on cbike(tripduration)")
dbSendStatement(db, "create index startstation on cbike(startstationid)")

rm(cbike)
rm(ptm)
rm(ptm1)

# CSV import speed:
# user  system elapsed 
# 67.81    5.38  101.36 
# Create table an
mydb <- dbConnect(MySQL(),user='root',password='dJj12345',dbname="test",
host='localhost')
ptm4 <-proc.time
dbWriteTable(mydb, "cbike", cbike, row.names = FALSE)
dbListTables(mydb)
proc.time() - pmt4