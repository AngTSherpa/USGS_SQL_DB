#load data
print(load("/d3/alyssah/USGS/HUC4_list_1.Rdata"))
print(load("/d3/alyssah/USGS/HUC4_list_2.Rdata"))
print(load("/d3/alyssah/USGS/HUC4_list_3.Rdata"))
print(load("/d3/alyssah/USGS/HUC4_list_4.Rdata"))

#format data
HUC4_list <- c(HUC4_list_1,HUC4_list_2,HUC4_list_3,HUC4_list_4)
obsPath<-'/d3/alyssah/USGS/'

#column to be renamed
reNameVect1 <- c(`X_00065_00011_m`='ht_m',`X_00065_00011_cd`= 'ht_cd')
reNameVect2 <- c(`X_00060_00011_cd`='q_cd')
reNameVect3 <- c(`X_00055_00011_m`='vel_ms',`X_00055_00011_cd`= 'vel_cd')

#connect to MySQL
source("/home/angts/populateDB/dbConnect.R")
dbListFields(con, "data_inst")

#Populate DB
for (h in 1:length(HUC4_list)) {
  fileNm <- paste0(obsPath, names(HUC4_list[h]), ".Rdata")
  if (file.exists(fileNm)) {
    load(fileNm)
    instData <- gageList$gageData
    df1 = data.table::data.table(agency_cd=c(instData$agency_cd),site_no=c(instData$site_no),POSIXct=c(instData$POSIXct))
    for (name in 1:length(names(instData))) { 
      if (names(instData)[name] =="X_00065_00011_cd" ){ instData <- plyr::rename(instData, reNameVect1) 
                                                        df1$ht_m=c(instData$ht_m)
                                                        df1$ht_cd= c(instData$ht_cd)}
      if (names(instData)[name] =="X_00060_00011_cd" ){ instData <- plyr::rename(instData, reNameVect2) 
                                                        df1$q_cms=c(instData$q_cms)
                                                        df1$q_cd=c(instData$q_cd)}
      if (names(instData)[name] =="X_00055_00011_cd" ){ instData <- plyr::rename(instData, reNameVect3) 
                                                       df1$vel_ms=c(instData$vel_ms)
                                                       df1$vel_cd=c(instData$vel_cd) }}
    df_out <- as.data.frame(df1)
    dbWriteTable(con, "data_inst", df_out, row.names=FALSE, overwrite=FALSE, append=TRUE)
  }
}


#send query to pull requests in batches
res <- dbSendQuery(con, "SELECT * FROM data_inst")
#here n is maximum number of records to retrieve per fetch.
data <- dbFetch(res, n = 5)

str(data)

dbDisconnect(con)

#Need code to check DB
#source("/home/angts/populateDB/checkStreamflowDB.R")
#checkStreamflowDB(dfOut,query)
s