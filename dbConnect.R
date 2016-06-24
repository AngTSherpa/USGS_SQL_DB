library(DBI)

con <- dbConnect(RMySQL::MySQL(), user="streamflow_admin", password="*******", dbname="streamflow", host="hydro-c1-web.rap.ucar.edu")
dbListTables(con)
