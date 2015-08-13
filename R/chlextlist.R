library(DataflowR)

fdir<-getOption("fdir")

dt<-read.csv(file.path(fdir,"DF_GrabSamples","extractChlcoef2.csv"))

sapply(dt[which(is.na(dt$notes)),"yearmon"],function(x) write.csv(x,file.path("logs",paste0(x,"fit.log")),row.names = FALSE))

write.csv(dt[which(is.na(dt$notes)),"yearmon"],"yearmonfits.csv",row.names = FALSE)