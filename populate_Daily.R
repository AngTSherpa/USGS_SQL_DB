#load data
print(load("/d6/adugger/WRF_Hydro/CONUS_IOC/OBS/USGS/obsStrData_ALLGAGES_2007_2016_DV_DT.Rdata"))
str(obsStrData)

#format data
df_out <- as.data.frame(obsStrData)
df_out$Date <- NULL

str(df_out)
max(nchar(df_out$agency_cd))

#SQL connection
source("/home/angts/populateDB/dbConnect.R")
dbListFields(con, "data_daily")
dbWriteTable(con, "data_daily", df_out, row.names=FALSE, overwrite=FALSE, append=TRUE)


#check DB
query <- dbGetQuery(con, "SELECT * FROM data_daily")
str(query)
dbDisconnect(con)

#compare data
source("checkStreamflowDB.R")
checkStreamflowDB(df_out,query)

query$POSIXct <- as.POSIXct(query$POSIXct, tz='UTC')

checkStreamflowDB(df_out,query, tol=1e-10)
