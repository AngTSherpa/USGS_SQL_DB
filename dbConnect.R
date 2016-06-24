library(DBI)

con <- dbConnect(RMySQL::MySQL(), user="streamflow_admin", password="way2f1ow", dbname="streamflow", host="hydro-c1-web.rap.ucar.edu")
dbListTables(con)
