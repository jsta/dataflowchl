library(DataflowR)
fdir <- getOption("fdir")
fathombasins <- rgdal::readOGR(file.path(fdir, "DF_Basefile/fbzonesmerge.shp"),layer = "fbzonesmerge", verbose = FALSE, stringsAsFactors = FALSE)
goodyears <- read.csv("data/goodyears.csv", stringsAsFactors = FALSE)
goodyears <- as.list(as.data.frame(t(goodyears)))

dt <- lapply(goodyears, function(x) grabget(x))
dt <- do.call("rbind", dt)
dt <- dt[!is.na(dt$lon_dd) & !is.na(dt$lat_dd),]
dt <- dt[dt$location %in% methods::slot(fathombasins, "data")$ZoneName,]

grabs <- dt
grabs <- grabs[!(grabs$location %in% c("Deer Key", "Taylor River")),]

grabs$tn <- grabs$tkn + grabs$tdkn
grabs <- grabs[,!(names(grabs) %in% c("tkn", "tdkn"))]

# fit distribution to PO4 to fill in zeros following Helsel and Hirsh ch. 13
library(fitdistrplus)
# STEVE SAYS THAT DETECTION LIMIT IS 0.015 uM (0.5 ppb)
# FABIOLA SAYS THAT Solorzano METHOD DETECTION LIMIT IS 0.025 uM
po4_detect_limit <- 0.025
greaterthan_detect_limit <- grabs[grabs$po4 > po4_detect_limit & !is.na(grabs$po4), "po4"]
fit.normal <- fitdist(greaterthan_detect_limit, "lnorm")

get_lowerquantile <- function(quant){
  res <- rnorm(1, fit.normal$estimate[1], fit.normal$estimate[2])
  while(res > qnorm(quant, fit.normal$estimate[1], fit.normal$estimate[2])){
    res <- rnorm(1, fit.normal$estimate[1], fit.normal$estimate[2])
  }
  res
}

lessthan_detect_limit <- grabs[grabs$po4 < po4_detect_limit & !is.na(grabs$po4), "po4"]
grabs[grabs$po4 < po4_detect_limit & !is.na(grabs$po4), "po4"] <- exp(sapply(1:length(lessthan_detect_limit), function(x) get_lowerquantile(.1)))

write.csv(grabs, "data/allgrabs.csv", row.names = FALSE)

grabs$chla <- log(grabs$chla)

grabs[grabs$pp < 0.05 & !is.na(grabs$pp), "pp"] <-  NA# made-up detection limit
grabs$pp <- log(grabs$pp)


grabs$tp <- log(grabs$tp)
grabs$po4 <- log(grabs$po4)
grabs$tdp <- log(grabs$tdp)

write.csv(grabs, "data/allgrabs_log.csv", row.names = FALSE)