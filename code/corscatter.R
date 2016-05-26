library(ggplot2)
library(GGally)

grabs <- read.csv(file.path("data", "allgrabs.csv"), row.names = NULL, stringsAsFactors = FALSE)
grabs <- grabs[!(grabs$location %in% c("Deer Key", "Taylor River")),]
grabs$location <- factor(grabs$location, levels = c("Whipray Basin", "Rankin", "Terrapin Bay", "Monroe Lake", "Seven Palm Lake", "Madeira Bay", "Little Madeira", "Pond 5", "Joe Bay", "Long Sound", "Blackwater Sound", "Lake Surprise", "Manatee", "Barnes"))

metadata_fields <- c("date", "time", "location", "lat_dd", "lon_dd")
# data_fields <-   c("salt", "chla", "tss", "pp", "tp", "tdp", "po4", "toc", "doc", "tkn", "tdkn", "chlaiv", "temp", "cond", "sal", "trans", "cdom", "brighteners", "phycoe", "phycoc", "c6chl", "c6cdom", "c6turbidity", "c6temp")
# data_fields <-   c("chla", "tss", "pp", "tp", "tdp", "po4", "toc", "doc", "tkn", "tdkn")
data_fields <-   c("pp", "tp", "tdp", "po4", "tkn", "tdkn", "chla")

grabs <- grabs[,data_fields]
grabs$chla <- log(grabs$chla)
grabs$pp <- log(grabs$pp)
grabs$tp <- log(grabs$tp)
grabs$tn <- grabs$tkn + grabs$tdkn
grabs <- grabs[,!(names(grabs) %in% c("tkn", "tdkn"))]

# fit distribution to PO4 to fill in zeros
library(fitdistrplus)
greaterthan0 <- log(grabs[grabs$po4 > 0 & !is.na(grabs$po4), "po4"]) 
fit.normal <- fitdist(greaterthan0, "norm")

# min(grabs[grabs$po4 > 0 & grabs$po4 < 0.1, "po4"], na.rm = TRUE)
# hist(grabs[grabs$po4 > 0 & grabs$po4 < 0.1, "po4"])
# hist(grabs[grabs$po4 < 0.1, "po4"])

# STEVE SAYS THAT DETECTION LIMIT IS 0.015 uM (0.5 ppb)
# FABIOLA SAYS THAT Solorzano METHOD DETECTION LIMIT IS 0.025 uM
grabs[grabs$po4 == 0 & !is.na(grabs$po4), "po4"] <- NA
grabs$po4 <- log(grabs$po4)

get_lowerquantile <- function(){
  res <- rnorm(1, fit.normal$estimate[1], fit.normal$estimate[2])
  while(res > qnorm(.1, fit.normal$estimate[1], fit.normal$estimate[2])){
    res <- rnorm(1, fit.normal$estimate[1], fit.normal$estimate[2])
  }
  res
}

# test <- sapply(1:500, function(x) get_lowerquantile())


grabs$tdp <- log(grabs$tdp)


GGally::ggpairs(grabs)
