grabs <- read.csv(file.path("data", "allgrabs.csv"), row.names = NULL, stringsAsFactors = FALSE)


grabs <- grabs[!(grabs$location %in% c("Deer Key", "Taylor River")),]

grabs$location <- factor(grabs$location, levels = c("Whipray Basin", "Rankin", "Terrapin Bay", "Monroe Lake", "Seven Palm Lake", "Madeira Bay", "Little Madeira", "Pond 5", "Joe Bay", "Long Sound", "Blackwater Sound", "Lake Surprise", "Manatee", "Barnes"))

metadata_fields <- c("date", "time", "location", "lat_dd", "lon_dd")
#data_fields <-   c("salt", "chla", "tss", "pp", "tp", "tdp", "po4", "toc", "doc", "tkn", "tdkn", "chlaiv", "temp", "cond", "sal", "trans", "cdom", "brighteners", "phycoe", "phycoc", "c6chl", "c6cdom", "c6turbidity", "c6temp")
data_fields <-   c("chla", "tss", "pp", "tp", "tdp", "po4", "toc", "doc", "tkn", "tdkn")
data_fields <-   c("pp", "tp", "tdp", "po4", "tkn", "tdkn", "chla")

grabs_cor <- grabs[,data_fields]
#apply(grabs_cor, 2, function(x) sum(!is.na(x)))
grabs_cor <- grabs_cor[complete.cases(grabs_cor),]
grabs_cor <- matrix(round(cor(grabs_cor), 2), ncol = ncol(grabs_cor))
grabs_cor[lower.tri(grabs_cor)] <- NA
grabs_cor[seq(from = 1, to = 49, by = 8)] <- NA
grabs_cor <- data.frame(grabs_cor)
grabs_cor <- grabs_cor[1:(nrow(grabs_cor) - 1), 2:ncol(grabs_cor)]
grabs_cor <- data.frame(matrix(
  sapply(unlist(grabs_cor), function(x) na.omit(x))
  , ncol = ncol(grabs_cor), byrow = FALSE), row.names = names(grabs[,data_fields])[1:(length(names(grabs[,data_fields])) - 1)])
names(grabs_cor) <- names(grabs[,data_fields])[2:length(names(grabs[,data_fields]))]

knitr::kable(grabs_cor)