# source(file.path("/home","jose","Documents","Science","Data","ENP_MMN", "R", "update_mmndbhydro.R"))
# legacypath <- file.path("/home", "jose", "Documents", "Science", "Data", "ENP_MMN", "legacy", "SFER_Data_Thru_April2015.csv")
# dt <- update_mmn(legacypath = legacypath, update = FALSE, tofile = FALSE)

# dt <- read.csv("/home/jose/Documents/Science/Data/ENP_MMN/updateddb.csv", stringsAsFactors = FALSE)
dt <- read.csv("data/dbhydt.csv", stringsAsFactors = FALSE)
dt$collection.date <- as.POSIXct(dt$collection.date)
dtfull <- dt[dt$collection.date >= "1993-01-01",]
dtsub <- dt[dt$collection.date >= "2008-01-01",]

testfull <- suppressWarnings(aggregate(dtfull, by = list(Dates = dtfull$date, Zone = dtfull$zone), mean)[,c("chl.a.ug.l", "collection.date", "Zone")])
testsub <- suppressWarnings(aggregate(dtsub, by = list(Dates = dtsub$date, Zone = dtsub$zone), mean)[,c("chl.a.ug.l", "collection.date", "Zone")])

testfull <- testfull[!(testfull$Zone %in% c("FBS", "CEB", "FBW")),]
testsub <- testsub[!(testsub$Zone %in% c("FBS", "CEB", "FBW")),]

library(ggplot2)
library(cowplot)
library(viridis)

plotfull <- ggplot(data = testfull, aes(x = collection.date, y = chl.a.ug.l, colour = Zone, lingtype = Zone))
plotfull <-  plotfull + geom_line() + suppressWarnings(geom_point(size = 1.5, na.rm = TRUE))
plotfull <-  plotfull + theme_bw() + labs(x = "", y = "Chlorophyll a (ug/L)") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.text = element_text(size = 12), axis.title = element_text(size = 14, face = "bold"), legend.position = c(0.65, 0.87), legend.direction = "horizontal", legend.text = element_text(size = 6), legend.title = element_text(size = 9))
plotfull <- plotfull + scale_linetype_manual(values = c(1, 2, 2)) + scale_color_manual(values = viridis(3)) 

plotsub <- ggplot(data = testsub, aes(x = collection.date, y = chl.a.ug.l, colour=Zone, linetype = Zone))
plotsub <- plotsub + geom_line() + suppressWarnings(geom_point(na.rm = TRUE))
plotsub <-  plotsub + theme_bw() + labs(x = "", y = "Chlorophyll a (ug/L)") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.text=element_text(size = 12), axis.title = element_text(size = 14, face = "bold"), legend.position = c(5, 5))
plotsub <- plotsub + scale_linetype_manual(values=c(1,2,2)) + scale_color_manual(values=viridis(3))

png(filename = "figures/chltimeseries.png",width=1120, height =1400, res = 300)

plot_grid(plotfull, plotsub, align = "v", ncol = 1, labels = c("A","B"), hjust = -47, vjust = 3.5)

dev.off()

#system("pdftk figures/chltimeseries.pdf cat 2 output figures/chltimeseries2.pdf")
#system("convert figures/chltimeseries2.pdf figures/chltimeseries.png")
