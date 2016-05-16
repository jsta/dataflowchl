library(DataflowR)
fdir<-getOption("fdir")

#scatter plot of variable with max corr against ext chl
plotchl<-function(yearmon){
  #yearmon<-200804
  dt<-grabget(yearmon,remove.flags=TRUE)
  varlist<-c("chla","cdom","chlaiv","phycoe","c6chl","phycoc","c6cdom")
  varlist<-varlist[sapply(varlist,function(x) sum(!is.na(dt[,x]))>1)]
  
  
  if(length(varlist)>2){
    maxcor<-which(abs(cor(dt[,varlist],use="complete")[-1,1])==max(abs(cor(dt[,varlist],use="complete")[-1,1])))+1
  }else{
    maxcor<-2
  }
    plot(dt[,varlist[maxcor]],dt[,"chla"],xlab="",ylab="",yaxt="n",xaxt="n")
    abline(lm(dt[,"chla"]~dt[,varlist[maxcor]]),col="red")
    legend("topleft",legend=yearmon)
    varlist[maxcor]
  
    
  }

dtcoef<-read.csv(file.path(fdir,"DF_GrabSamples","extractChlcoef2.csv"))
dtcoef<-dtcoef[order(dtcoef$yearmon),]

badyrs<-dtcoef[is.na(dtcoef$date),"yearmon"]
goodyrs<-dtcoef[!is.na(dtcoef$date),"yearmon"]
mediumyrs<-c(200804,200812,201007)
goodyrs<-goodyrs[!(goodyrs %in% mediumyrs)]

par(mfrow=c(4,4))
par(mar=c(0,0,0,0))
res<-sapply(goodyrs,plotchl)
par(mfrow=c(1,1))
par(mar=c(2,2,2,2))
barplot(table(res))

par(mfrow=c(3,3))
par(mar=c(0,0,0,0))
res<-sapply(badyrs,plotchl)
res<-unlist(res)[!is.na(unlist(res))]
par(mfrow=c(1,1))
par(mar=c(2,2,2,2))
barplot(table(res))

par(mfrow=c(3,1))
par(mar=c(0,0,0,0))
res<-sapply(mediumyrs,plotchl)
res<-unlist(res)[!is.na(unlist(res))]
par(mfrow=c(1,1))
par(mar=c(2,2,2,2))
barplot(table(res))

