library(DataflowR)

goodyears <- read.csv("data/goodyears.csv", stringsAsFactors = FALSE)
goodyears <- as.list(as.data.frame(t(goodyears)))

dt <- lapply(goodyears, function(x) streamget(x)[
        ,c("time", "chla", "temp", "cond", "sal", "trans", "cdom", "sec.x", 
           "brighteners", "phycoe", "phycoc", "c6chla", "c6cdom", 
           "c6turbidity", "c6temp", "sec.y", "datetime", "lon_dd", "lat_dd", 
           "gridcode", "name", 
           "fathom_id", "fbfs_zones")])
dt <- do.call("rbind", dt)

write.csv(dt, "data/allstreaming.csv", row.names = FALSE)
