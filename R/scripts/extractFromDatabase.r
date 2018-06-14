# code to access a database and extract data into a dataframe loaded in R (similar to java jdbc)

require("RMySQL");

con <- dbConnect(RMySQL::MySQL(),host='hostname',user='username',password='xxxxxx',dbname='database name')

loadFromDB<-function(sql) {
    suppressWarnings(rs <- dbSendQuery(con,sql))
    data<-fetch(rs,n=-1)
    data[sapply(data,is.character)] <- lapply(data[sapply(data,is.character)],as.factor)
    dbClearResult(rs)
    data<-data[sample(nrow(data)),]
    return(data)
}


dataFrame<-loadFromDB("SELECT * FROM bob");

dbDisconnect(con)