source(file.path("/home","jose","Documents","Science","Data","ENP_MMN","pull_mmndbhydro.R"))

dt<-update_mmn(legacypath=legacypath,update=FALSE,tofile=FALSE)
dt$collection.date<-as.POSIXct(dt$collection.date)
dtfull<-dt[dt$collection.date>="1993-01-01",]
dtsub<-dt[dt$collection.date>="2008-01-01",]

testfull<-suppressWarnings(aggregate(dtfull,by=list(Dates=dtfull$date, Zone=dtfull$zone),mean)[,c("chl.a.ug.l","collection.date","Zone")])
testsub<-suppressWarnings(aggregate(dtsub,by=list(Dates=dtsub$date, Zone=dtsub$zone),mean)[,c("chl.a.ug.l","collection.date","Zone")])

library(ggplot2)
library(cowplot)
library(viridis)

plotfull<-ggplot(data = testfull, aes(x=collection.date,y=chl.a.ug.l,colour=Zone,lingtype=Zone)) + geom_line() + suppressWarnings(geom_point(size=1.5,na.rm = TRUE)) + theme_bw() + labs(x="",y="Chlorophyll a (ug/L)") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.text=element_text(size = 12), axis.title = element_text(size = 14, face = "bold"), legend.position = c(0.6,0.85), legend.direction = "horizontal") + scale_linetype_manual(values=c(1,2,2)) + scale_color_manual(values=viridis(3))


plotsub<-ggplot(data = testsub, aes(x=collection.date,y=chl.a.ug.l,colour=Zone,linetype=Zone)) + geom_line() + suppressWarnings(geom_point(na.rm = TRUE)) + theme_bw() + labs(x="",y="Chlorophyll a (ug/L)") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.text=element_text(size = 12), axis.title = element_text(size = 14, face = "bold"), legend.position = c(5,5)) + scale_linetype_manual(values=c(1,2,2)) + scale_color_manual(values=viridis(3))

png(filename = "figures/chltimeseries.png",width=520, height =386)

plot_grid(plotfull,plotsub,align = "v",ncol = 1,labels = c("A","B"), hjust = -47, vjust = 3.5)

dev.off()