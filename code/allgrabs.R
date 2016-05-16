library(DataflowR)
fdir <- getOption("fdir")
fathombasins<-rgdal::readOGR(file.path(fdir,"DF_Basefile/fbzonesmerge.shp"),layer="fbzonesmerge",verbose=FALSE,stringsAsFactors=FALSE)
goodyears <- read.csv("data/goodyears.csv", stringsAsFactors = FALSE)
goodyears <- as.list(as.data.frame(t(goodyears)))

dt <- lapply(goodyears, function(x) grabget(x))
dt <- do.call("rbind", dt)
dt <- dt[!is.na(dt$lon_dd) & !is.na(dt$lat_dd),]
dt <- dt[dt$location %in% methods::slot(fathombasins, "data")$ZoneName,]

write.csv(dt, "data/allgrabs.csv", row.names = FALSE)