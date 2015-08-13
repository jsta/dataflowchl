source(file.path("/home","jose","Documents","Science","Data","ENP_MMN","pull_mmndbhydro.R"))

dt<-update_mmn(legacypath=legacypath,update=FALSE,tofile=FALSE)
dt$collection.date<-as.POSIXct(dt$collection.date)
dtfull<-dt[dt$collection.date>="1993-01-01",]
dtsub<-dt[dt$collection.date>="2008-01-01",]

testfull<-suppressWarnings(aggregate(dtfull,by=list(Dates=dtfull$date, Zone=dtfull$zone),mean)[,c("chl.a.ug.l","collection.date","Zone")])
testsub<-suppressWarnings(aggregate(dtsub,by=list(Dates=dtsub$date, Zone=dtsub$zone),mean)[,c("chl.a.ug.l","collection.date","Zone")])

library(ggplot2)

par(mfrow=c(2,1))

suppressWarnings(ggplot(data = testfull, aes(x=collection.date,y=chl.a.ug.l,colour=Zone)) + geom_line() + suppressWarnings(geom_point(na.rm = TRUE)) + theme_bw() + labs(x="",y="Chlorophyll a (ug/L)") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.text=element_text(size = 12), axis.title = element_text(size = 14, face = "bold"), legend.position = c(0.1,0.8)) +  scale_color_hue(h=c(80,180)))

suppressWarnings(ggplot(data = testsub, aes(x=collection.date,y=chl.a.ug.l,colour=Zone)) + geom_line() + suppressWarnings(geom_point(na.rm = TRUE)) + theme_bw() + labs(x="",y="Chlorophyll a (ug/L)") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.text=element_text(size = 12), axis.title = element_text(size = 14, face = "bold"), legend.position = c(5,5)) +  scale_color_hue(h=c(80,180)))