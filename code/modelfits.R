library(DataflowR)

fdir <- getOption("fdir")
dt <- read.csv(file.path(fdir,"DF_GrabSamples","extractChlcoef2.csv"), 
               row.names = NULL)

dt <- dt[!is.na(dt$date),]
dt <- dt[order(dt$yearmon),]
dt <- dt[,c("yearmon", "cdom", "chlaiv", "phycoe", "c6chl", "c6cdom", 
            "phycoc", "intercept", "rsquared", "pvalue")]

dt[,2:8]                  <- round(dt[,2:8],4)
dt[,"rsquared"]           <- round(dt[,"rsquared"],2)
dt[,"pvalue"]             <- round(dt[,"pvalue"],2)
dt$pvalue[dt$pvalue == 0] <- "< 0.00"

write.csv(dt, "tables/modelfits.csv", row.names = FALSE)