#check if two database are same.

df1 <- data.frame()
df2 <- data.frame()

checkStreamflowDB <- function (df1, df2, tolerance=1e-6){

  if (identical(df1, df2)){
    print ("Datas are same")
  }
  
  else {

      names1 <- names(df1)
      names2 <- names(df2)
      sameNames <- intersect(names1,names2)
      
    for (nn in sameNames){
      cat(nn,'\n')
      ##result <- identical(df1[,c],df2[,c], single.NA = FALSE)
      result <- all(df1[,nn]==df2[,nn], na.rm=TRUE)

      if(!result) result <- all(abs(df1[,nn]-df2[,nn]) < tolerance, na.rm=TRUE)
      
      cat(result,'\n')
      cat('\n')
    }
  } 
}
