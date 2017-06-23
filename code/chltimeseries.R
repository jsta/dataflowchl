
## Load Data ==============================================#
dt <- read.csv("data/dbhydt.csv", stringsAsFactors = FALSE)
names(dt) <- tolower(names(dt))
dt$collection.date <- as.POSIXct(dt$collection.date)
dtfull <- dt[dt$collection.date >= "1993-01-01",]
dtsub <- dt[dt$collection.date >= "2008-01-01" & dt$collection.date <= "2015-09-30",]


testfull <- suppressWarnings(aggregate(dtfull, by = list(Dates = dtfull$collection.date, Zone = dtfull$zone), mean)[,c("chl.a.ug.l", "collection.date", "Zone")])
testsub <- suppressWarnings(aggregate(dtsub, by = list(Dates = dtsub$collection.date, Zone = dtsub$zone), mean)[,c("chl.a.ug.l", "collection.date", "Zone")])

testfull <- testfull[!(testfull$Zone %in% c("FBS", "CEB", "FBW")),]
testsub <- testsub[!(testsub$Zone %in% c("FBS", "CEB", "FBW")),]

rain <- read.csv("data/rain/ENPOps_rain_monthly.csv", stringsAsFactors = FALSE)
rain$date <- as.POSIXct(rain$date)
rain <- rain[rain$date >= range(testsub$collection.date)[1] & rain$date <= range(testsub$collection.date)[2],]
rain[,!(names(rain) %in% "date")] <- rain[,!(names(rain) %in% "date")] * 2.54 #convert in to cm

library(ggplot2)
library(cowplot)
library(viridis)

## Full POR chl ===========================================#
plotfull <- ggplot(data = testfull, aes(x = collection.date, y = chl.a.ug.l, colour = Zone, lingtype = Zone))
plotfull <-  plotfull + geom_line() + suppressWarnings(geom_point(size = 1.5, na.rm = TRUE))
plotfull <-  plotfull + theme_bw() + labs(x = "", y = "Chlorophyll a (ug/L)") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.text = element_text(size = 12), axis.title = element_text(size = 10, face = "bold"), legend.position = c(0.65, 0.77), legend.direction = "horizontal", legend.text = element_text(size = 6), legend.title = element_text(size = 9))
plotfull <- plotfull + scale_linetype_manual(values = c(1, 2, 2)) + scale_color_manual(values = viridis(3)) 

## Restricted POR chl =====================================#
plotsub <- ggplot(data = testsub, aes(x = collection.date, y = chl.a.ug.l, colour=Zone, linetype = Zone))
plotsub <- plotsub + geom_line() + suppressWarnings(geom_point(na.rm = TRUE))
plotsub <-  plotsub + theme_bw() + labs(x = "", y = "Chlorophyll a (ug/L)") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.text=element_text(size = 12), axis.title = element_text(size = 10, face = "bold"), legend.position = c(5, 5))
plotsub <- plotsub + scale_linetype_manual(values=c(1,2,2)) + scale_color_manual(values=viridis(3))

## Rain ===================================================#
plot_rain <- ggplot(data = rain, aes(x = date, y = TaylorSlough))
plot_rain <- plot_rain + geom_line(na.rm = TRUE) + geom_point(na.rm = TRUE) + xlab("") + theme(axis.title = element_text(size = 10, face = "bold")) + ylab("Precipitation(cm)")

## Figure montage + save ===================================#
png(filename = "figures/chltimeseries.png",width=1120, height =1400, res = 300)

plot_grid(plotfull, plotsub, plot_rain, align = "v", ncol = 1, labels = "auto", hjust = -6, vjust = 1.7)

dev.off()

#system("pdftk figures/chltimeseries.pdf cat 2 output figures/chltimeseries2.pdf")
#system("convert figures/chltimeseries2.pdf figures/chltimeseries.png")

# calculate cumulative rain per year
library(dplyr)
rain$year <- strftime(rain$date, format = "%Y")
# rain$wy <- jsta::wygen(rain$date)$wy
# rain <- group_by(rain, wy)
rain <- group_by(rain, year)
summarise(rain, sum = sum(TaylorSlough))




