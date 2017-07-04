grabs <- read.csv(file.path("data", "allgrabs_log.csv"), row.names = NULL, stringsAsFactors = FALSE)

grabs$location <- factor(grabs$location, levels = c("Whipray Basin", "Rankin", "Terrapin Bay", "Monroe Lake", "Seven Palm Lake", "Madeira Bay", "Little Madeira", "Pond 5", "Joe Bay", "Long Sound", "Blackwater Sound", "Lake Surprise", "Manatee", "Barnes"))

metadata_fields <- c("date", "time", "location", "lat_dd", "lon_dd")
data_fields <-   c("pp", "tp", "tdp", "po4", "tn", "nh4um", "no3um", "chla")

grabs_cor <- grabs[,data_fields]
grabs_cor <- grabs_cor[complete.cases(grabs_cor),]

comb_names <- expand.grid(names(grabs_cor), names(grabs_cor))

p.values <- apply(comb_names, 1, function(x) round(cor.test(grabs_cor[,x[1]], grabs_cor[,x[2]], alternative = "two.sided", method = "spearman")$p.value, 2))
p.values <- matrix(p.values, ncol = ncol(grabs_cor))


grabs_cor <- matrix(round(cor(grabs_cor, method = "spearman"), 2), ncol = ncol(grabs_cor))

grabs_cor[lower.tri(grabs_cor)] <- NA

grabs_cor[seq(from = 1, to = length(grabs_cor), by = dim(grabs_cor)[1] + 1)] <- NA

p.values[lower.tri(p.values)] <- NA
p.values[seq(from = 1, to = length(p.values), by = dim(p.values)[1] + 1)] <- NA

#grabs_cor <- matrix(as.character(grabs_cor), ncol = ncol(grabs_cor))

grabs_cor <- data.frame(grabs_cor)
grabs_cor <- grabs_cor[1:(nrow(grabs_cor) - 1), 2:ncol(grabs_cor)]

p.values <- data.frame(p.values)
p.values <- p.values[1:(nrow(p.values) - 1), 2:ncol(p.values)]

# write.csv(apply(grabs_cor, 2, function(x) vapply(x, paste, collapse = ", ", character(1L))), "tables/grabs_cor.csv", row.names = FALSE)

names(grabs_cor) <- names(grabs[,data_fields])[2:length(names(grabs[,data_fields]))]
names(grabs_cor)[1:(ncol(grabs_cor) - 1)] <- c(toupper(
  names(grabs_cor)[1:(ncol(grabs_cor) - 3)]), "NH4", "NO3")

write.csv(grabs_cor, "tables/grabs_cor.csv", row.names = FALSE)
write.csv(p.values, "tables/grabs_pvalues.csv", row.names = FALSE)
