source('/home/angts/populateDB/checkStreamflowDB.R')

#load data
library(rwrfhydro)
print(load("/home/jamesmcc/WRF_Hydro/CONUS/analysis/masterUsgsMetadata.Rdata"))

#populate DB
nchar(masterMeta$huc_cd)
masterMeta$huc_cd[masterMeta$huc_cd == ""]<-"--------"
dfOut=masterMeta
dfOut$HUC2=substr(dfOut$huc_cd,1,2)
dfOut$HUC4=substr(dfOut$huc_cd,1,4)
dfOut$HUC6=substr(dfOut$huc_cd,1,6)
dfOut$HUC8=substr(dfOut$huc_cd,1,8)
str(dfOut)

gages=ncdump("/home/jamesmcc/WRF_Hydro/TESTING/TEST_FILES/CONUS/WORKING/DOMAIN/RouteLink_2016_04_07.nudgingOperational2016-04-08_chanparm3_mann_BtmWdth.nc","gages")
gages=trimws(gages)
gages=gages[gages!=""]
gages2ref=gages2Attr$CLASS
gages2ref=gages2Attr$CLASS[gages2Attr$CLASS=="Ref"]
str(gages2ref)
masterMeta$site_no %in% gages2ref
masterMeta$site_no %in% trimws(gages2ref)
sum(masterMeta$site_no %in% trimws(gages2ref))
gages2ref=gages2Attr$STAID[gages2Attr$CLASS=="Ref"]
sum(masterMeta$site_no %in% trimws(gages2ref))
masterMeta$site_no %in% trimws(gages2ref)
dfOut$inGagesIIRef=masterMeta$site_no %in% trimws(gages2ref)
str(dfOut)
str(gages)
dfOut$source = "USGS"
str(dfOut)
str(gages2Attr)
dfOut$inRouteLink=masterMeta$site_no %in% gages
str(dfOut)

#connect to mysql
source("/home/angts/populateDB/dbConnect.R")
dbListFields(con, "metadata")
dbWriteTable(con, "metadata", dfOut, row.names=FALSE, overwrite=TRUE, append=FALSE)
dbListFields(con, "metadata")

#query
query <- dbGetQuery(con, "SELECT * FROM metadata")
dbDisconnect(con)

#compare data
source("/home/angts/populateDB/checkStreamflowDB.R")
checkStreamflowDB(dfOut,query)

         