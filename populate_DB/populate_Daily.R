#load data
print(load("/d6/adugger/WRF_Hydro/CONUS_IOC/OBS/USGS/obsStrData_ALLGAGES_2007_2016_DV_DT.Rdata"))
str(obsStrData)

###########format data
df_out <- as.data.frame(obsStrData)
df_out$Date <- NULL
#get all the non-duplicates of agency_cd, site_no and POSIXct
df_out <- df_out[c(1,2,4,3,5,6)]
df_out <- df_out[!duplicated(df_out[1:3]),]
str(df_out)

#MySQL connection and populate data_daily
source("/home/angts/populateDB/dbConnect.R")
on.exit(dbDisconnect(con))
dbListFields(con, "data_daily")
###DON'T RUN. Only run this if you want to populate data_daily database/
#dbWriteTable(con, "data_daily", df_out, row.names=FALSE, overwrite=FALSE, append=TRUE)

#get the data for data_daily from MySQL database.
query <- dbGetQuery(con, "SELECT * FROM data_daily")
str(query)

#Check if the database datas matches with the actual data.
source("checkStreamflowDB.R")
query$POSIXct <- as.POSIXct(query$POSIXct, tz='UTC')
intNames <- intersect(names(df_out),names(query))
query <- query[,intNames]
checkStreamflowDB(df_out,query, tol=1e-1)
