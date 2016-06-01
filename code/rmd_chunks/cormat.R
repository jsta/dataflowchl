grabs <- read.csv(file.path("data", "allgrabs_log.csv"), row.names = NULL, stringsAsFactors = FALSE)

grabs$location <- factor(grabs$location, levels = c("Whipray Basin", "Rankin", "Terrapin Bay", "Monroe Lake", "Seven Palm Lake", "Madeira Bay", "Little Madeira", "Pond 5", "Joe Bay", "Long Sound", "Blackwater Sound", "Lake Surprise", "Manatee", "Barnes"))

metadata_fields <- c("date", "time", "location", "lat_dd", "lon_dd")
#data_fields <-   c("salt", "chla", "tss", "pp", "tp", "tdp", "po4", "toc", "doc", "tkn", "tdkn", "chlaiv", "temp", "cond", "sal", "trans", "cdom", "brighteners", "phycoe", "phycoc", "c6chl", "c6cdom", "c6turbidity", "c6temp")
data_fields <-   c("chla", "tss", "pp", "tp", "tdp", "po4", "toc", "doc", "tkn", "tdkn")
data_fields <-   c("pp", "tp", "tdp", "po4", "tn", "chla")

grabs_cor <- grabs[,data_fields]
grabs_cor <- grabs_cor[complete.cases(grabs_cor),]

comb_names <- expand.grid(names(grabs_cor), names(grabs_cor))

p.values <- apply(comb_names, 1, function(x) round(cor.test(grabs_cor[,x[1]], grabs_cor[,x[2]])$p.value, 2))
p.values <- matrix(p.values, ncol = ncol(grabs_cor))


grabs_cor <- matrix(round(cor(grabs_cor), 2), ncol = ncol(grabs_cor))

grabs_cor[lower.tri(grabs_cor)] <- NA
grabs_cor[seq(from = 1, to = 36, by = 7)] <- NA

p.values[lower.tri(p.values)] <- NA
p.values[seq(from = 1, to = 36, by = 7)] <- NA

#grabs_cor <- matrix(as.character(grabs_cor), ncol = ncol(grabs_cor))

grabs_cor <- data.frame(grabs_cor)
grabs_cor <- grabs_cor[1:(nrow(grabs_cor) - 1), 2:ncol(grabs_cor)]

p.values <- data.frame(p.values)
p.values <- p.values[1:(nrow(p.values) - 1), 2:ncol(p.values)]

grabs_cor <- data.frame(
  matrix(
  sapply(unlist(grabs_cor), function(x) na.omit(x))
  , ncol = ncol(grabs_cor), byrow = FALSE),
  row.names = names(grabs[,data_fields])[1:(length(names(grabs[,data_fields])) - 1)])

p.values <- data.frame(
  matrix(
    sapply(unlist(p.values), function(x) na.omit(x))
    , ncol = ncol(p.values), byrow = FALSE),
  row.names = names(grabs[,data_fields])[1:(length(names(grabs[,data_fields])) - 1)])

sig.xy <- which(p.values <= 0.0001, arr.ind = TRUE)
grabs_cor[sig.xy] <- paste0(grabs_cor[sig.xy], "*")

names(grabs_cor) <- names(grabs[,data_fields])[2:length(names(grabs[,data_fields]))]

knitr::kable(grabs_cor)