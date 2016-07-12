#load data
print(load("/d3/alyssah/USGS/HUC4_list_1.Rdata"))
print(load("/d3/alyssah/USGS/HUC4_list_2.Rdata"))
print(load("/d3/alyssah/USGS/HUC4_list_3.Rdata"))
print(load("/d3/alyssah/USGS/HUC4_list_4.Rdata"))

#format data
HUC4_list <- c(HUC4_list_1,HUC4_list_2,HUC4_list_3,HUC4_list_4)
obsPath<-'/d3/alyssah/USGS/'

#column to be renamed
reNameVect1 <- c(`X_00065_00011_m`='ht_m',    `X_00065_00011_cd`='ht_cd')
reNameVect2 <- c(`X_00060_00011_cd`='q_cd')
reNameVect3 <- c(`X_00055_00011_m`='vel_ms',  `X_00055_00011_cd`='vel_cd')

#connect to MySQL
source("dbConnect.R")
dbListFields(con, "data_inst")

outDfColNames <- c("agency_cd", 'site_no', 'POSIXct',
                   'ht_m',   'ht_cd',
                   'q_cms',  'q_cd',
                   'vel_ms', 'vel_cd')

#Populate DB
for (h in 1:length(HUC4_list)) {
  fileNm <- paste0(obsPath, names(HUC4_list[h]), ".Rdata")
  if (file.exists(fileNm)) {
    load(fileNm)
    instData <- gageList$gageData
    instNames <- names(instData)
    if (any(grepl("00065_00011", instNames))) instData <- plyr::rename(instData, reNameVect1) 
    if (any(grepl("00060_00011", instNames))) instData <- plyr::rename(instData, reNameVect2)
    if (any(grepl("00055_00011", instNames))) instData <- plyr::rename(instData, reNameVect3)    
    namesToNull <- setdiff(names(instData), outDfColNames)
    for(nn in namesToNull) instData[, nn] <- NULL
    
    dbWriteTable(con, "data_inst", df_out, row.names=FALSE, overwrite=FALSE, append=TRUE)
  }
  print(h)
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
