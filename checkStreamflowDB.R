#check if two database are same.

df1 <- data.frame()
df2 <- data.frame()

checkStreamflowDB <- function (df1, df2){
  if (identical(df1, df2, single.NA = FALSE)){
    print ("Datas are same")
  }
  
  else {
    for (c in 1:ncol(df1)){
      result <- identical(df1[,c],df2[,c], single.NA = FALSE)
      print (paste(c,result))
    }
  } 
}