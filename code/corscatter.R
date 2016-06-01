library(ggplot2)
library(GGally)

grabs <- read.csv(file.path("data", "allgrabs_log.csv"), row.names = NULL, stringsAsFactors = FALSE)

grabs$location <- factor(grabs$location, levels = c("Whipray Basin", "Rankin", "Terrapin Bay", "Monroe Lake", "Seven Palm Lake", "Madeira Bay", "Little Madeira", "Pond 5", "Joe Bay", "Long Sound", "Blackwater Sound", "Lake Surprise", "Manatee", "Barnes"))

metadata_fields <- c("date", "time", "location", "lat_dd", "lon_dd")
# data_fields <-   c("salt", "chla", "tss", "pp", "tp", "tdp", "po4", "toc", "doc", "tkn", "tdkn", "chlaiv", "temp", "cond", "sal", "trans", "cdom", "brighteners", "phycoe", "phycoc", "c6chl", "c6cdom", "c6turbidity", "c6temp")
# data_fields <-   c("chla", "tss", "pp", "tp", "tdp", "po4", "toc", "doc", "tkn", "tdkn")
data_fields <-   c("pp", "tp", "tdp", "po4", "tn", "chla")

grabs <- grabs[,data_fields]

GGally::ggpairs(grabs)
