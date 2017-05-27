# seasonal distribution of P with respect to precip


# nuts ####
grabs <- read.csv(file.path("data", "allgrabs.csv"), row.names = NULL, stringsAsFactors = FALSE)

grabs$location <- factor(grabs$location, levels = c("Whipray Basin", "Rankin", "Terrapin Bay", "Monroe Lake", "Seven Palm Lake", "Madeira Bay", "Little Madeira", "Pond 5", "Joe Bay", "Long Sound", "Blackwater Sound", "Lake Surprise", "Manatee", "Barnes"))

metadata_fields <- c("date", "time", "location", "lat_dd", "lon_dd")
#data_fields <-   c("salt", "chla", "tss", "pp", "tp", "tdp", "po4", "toc", "doc", "tkn", "tdkn", "chlaiv", "temp", "cond", "sal", "trans", "cdom", "brighteners", "phycoe", "phycoc", "c6chl", "c6cdom", "c6turbidity", "c6temp")
data_fields <-   c("chla", "tss", "pp", "tp", "tdp", "po4", "toc", "doc", "tkn", "tdkn")
data_fields <-   c("pp", "tp", "tdp", "po4", "tn", "chla", "np_ratio")

library(jsta)

grabs$date <- jsta::date456posix(grabs$date, "20")
grabs$wy <-  sapply(grabs$date, function(x) wygen(x)$wy)
grabs$month <- factor(as.numeric(strftime(grabs$date, format = "%m")), levels = c("2","4","5", "6", "7", "8", "9", "10", "11", "12"))

plot(aggregate(grabs$tn, list(grabs$location), function(x) mean(x, na.rm = TRUE)), las = 2)
plot(aggregate(grabs$nh4um, list(grabs$location), function(x) mean(x, na.rm = TRUE)), las = 2)
plot(aggregate(grabs$n.num, list(grabs$location), function(x) mean(x, na.rm = TRUE)), las = 2)



plot(aggregate(grabs$tp, list(grabs$month), function(x) mean(x, na.rm = TRUE)))

# rain ####


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

rain$wy <- factor(sapply(rain$date, function(x) wygen(x)$wy))

plot(aggregate(rain$TaylorSlough, list(rain$wy), function(x) sum(x, na.rm = TRUE)))
