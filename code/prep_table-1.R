library(xtable)
library(knitr)

grabs <- read.csv(file.path("data", "allgrabs_log.csv"), row.names = NULL, stringsAsFactors = FALSE)

grabs$location <- factor(grabs$location, levels = c("Whipray Basin", "Rankin", "Terrapin Bay", "Monroe Lake", "Seven Palm Lake", "Madeira Bay", "Little Madeira", "Pond 5", "Joe Bay", "Long Sound", "Blackwater Sound", "Lake Surprise", "Manatee", "Barnes"))
metadata_fields <- c("date", "time", "location", "lat_dd", "lon_dd")
data_fields <-   c("pp", "tp", "tdp", "po4", "tn", "nh4um", "no3um", "chla")

grabs_cor <- read.csv("tables/grabs_cor.csv", 
                      stringsAsFactors = FALSE)
p.values <- read.csv("tables/grabs_pvalues.csv", 
                     stringsAsFactors = FALSE)

# grabs_cor <- data.frame(
#   matrix(
#     sapply(unlist(grabs_cor), function(x) na.omit(x))
#     , ncol = ncol(grabs_cor), byrow = FALSE),
#   row.names = names(grabs[,data_fields])[1:(length(names(grabs[,data_fields])) - 1)])
# 
# p.values <- data.frame(
#   matrix(
#     sapply(unlist(p.values), function(x) na.omit(x))
#     , ncol = ncol(p.values), byrow = FALSE),
#   row.names = names(grabs[,data_fields])[1:(length(names(grabs[,data_fields])) - 1)])

sig.xy <- which(p.values <= 0.05, arr.ind = TRUE)
grabs_cor[sig.xy] <- paste0(grabs_cor[sig.xy], "*")

names(grabs_cor) <- names(grabs[,data_fields])[2:length(names(grabs[,data_fields]))]
names(grabs_cor)[1:(ncol(grabs_cor) - 1)] <- c(toupper(
  names(grabs_cor)[1:(ncol(grabs_cor) - 3)]), "NH4", "NO3")
rownames(grabs_cor) <- c(
  "PP", 
  names(grabs_cor)[1:(length(names(grabs_cor)) - 1)])

print(xtable(grabs_cor, caption = "Correlation matrix of water quality parameters for selected Florida Bay basins. TP = total phosphorus, TDP = total dissolved phosphorus, PO4 = ortho-phosphate, TN = total nitrogen, NH4 = ammonium, NO3 = nitrate, chla = chlorophyll a, PP = particulate phosphorus. $*$ indicates a significant correlation at P $<$ 0.05. Only complete cases were used in calculations (n = 86)."), 
      file = "manuscripts/est_coast/table_1.tex",
      caption.placement = "top")
  