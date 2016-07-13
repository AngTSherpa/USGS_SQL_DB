# USGS_SQL_DB

This repository is to manage/populate USGS Streamflow Database to MySQL using 'RMySQL' package from R.

RMySQL is a database interface and MySQL driver for R.

## Installation
https://github.com/rstats-db/RMySQL

## Hello World
```R 
library(DBI)
 
#Connect to MySQL
con <- dbConnect(RMySQL::MySQL(),
+                  user="streamflow_admin",
+                  password="*****",
+                  dbname="streamflow",
+                  host="****")

dbListTables(con)
dbListFields(con, "metadata")

To retrieve all the results:
query <- dbGetQuery(con, "SELECT * FROM metadata”)
str(query)

#To retrieve results a chunk at a time, use dbSendQuery, dbFetch, then dbClearResult 
-res <- dbSendQuery(con, "SELECT * FROM metadata”)
-data <- dbFetch(res, n = 2)
-data
##Here n = maximum number of records to retrieve per fetch. Use -1 to retrieve all pending 
##records; use 0 for to fetch the default number of rows as defined in MySQL .

# Clear the result
dbClearResult(res)

# Disconnect from the database
dbDisconnect(con)
```

##MySQL syntax
```R 
res <- dbSendQuery(con, "MySQL syntax”)
```
```MySQL
#TO SELECT PARTICULAR ROWS
SELECT * FROM metadata LIMIT 400
##Returns first 400 rows.

SELECT * FROM metadata WHERE site_no = '01010000' AND lat_va = '464202’
##Selects row with site_no = '01010000' and lat_va = '464202’.

SELECT * FROM metadata WHERE site_no = '01010000' OR lat_va = '464202’
##Selects row with site_no = '01010000' or lat_va = '464202’.

#TO SELECT PARTICULAR COLUMNS

SELECT station_id, lat_va FROM metadata
##Selects column station_id and lat_va

SELECT station_id, lat_va FROM metadata
WHERE site_no = '01010000' AND lat_va = '464202’
##selects column station_id and lat_va with rows site_no = '01010000' or lat_va = '464202’.
```

##Resources
 
 https://cran.r-project.org/web/packages/RMySQL/RMySQL.pdf
 http://www.w3schools.com/sql/sql_top.asp
 http://dev.mysql.com/doc/refman/5.7/en/retrieving-data.html
 

