
library(DataflowR)

surveys<-unlist(lapply(strsplit(dir(file.path("/home","jose","Documents","Science","Data","Dataflow","DF_Surfaces"),recursive = TRUE,pattern = "*chlext.tif$"),"/"),function(x) x[1]))

dbfile<-file.path("/home","jose","Documents","Science","Data","ENP_MMN","WQSuM_2015.csv")

validdbhydro(200910,params = "chlext", tolerance = 30, dbfile = dbfile)

stats<-lapply(surveys,function(x) validdbhydro(yearmon = x,params = "chlext", tolerance = 30, dbfile = dbfile))

statsnames<-names(stats[[1]])
stats<-data.frame(matrix(unlist(stats),ncol = 5,byrow = TRUE))
names(stats)<-statsnames
stats[,"days"]<-round(abs(stats[,"days"]),2)
surveys<-surveys[which(stats[,"days"]<4)]
stats<-stats[stats[,"days"]<4,]
stats$surveys<-surveys
stats<-stats[,c(6,5,1,2,3,4)]


write.csv(stats,"tables/dbhydrovalid.csv",row.names = FALSE)

# 
# plot(abs(stats[,5]),stats[,1])
# plot(abs(stats[,5]),stats[,2])
# plot(abs(stats[,5]),stats[,3],ylim=c(0,500))
# plot(abs(stats[,5]),stats[,4])
# 
# hist(stats[,2])
# 
# ##investigate particular surveys
# yearmon<-201212
# 
# 
