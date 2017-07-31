library(ggplot2)

grabs <- read.csv(file.path("data", "allgrabs.csv"), row.names = NULL, stringsAsFactors = FALSE)

grabs$location <- factor(grabs$location, levels = c("Whipray Basin", "Rankin", "Terrapin Bay", "Monroe Lake", "Seven Palm Lake", "Madeira Bay", "Little Madeira", "Pond 5", "Joe Bay", "Long Sound", "Blackwater Sound", "Lake Surprise", "Manatee", "Barnes"))

metadata_fields <- c("date", "time", "location", "lat_dd", "lon_dd")
#data_fields <-   c("salt", "chla", "tss", "pp", "tp", "tdp", "po4", "toc", "doc", "tkn", "tdkn", "chlaiv", "temp", "cond", "sal", "trans", "cdom", "brighteners", "phycoe", "phycoc", "c6chl", "c6cdom", "c6turbidity", "c6temp")
# data_fields <-   c("chla", "tss", "pp", "tp", "tdp", "po4", "toc", "doc", "tkn", "tdkn")
data_fields <-   c("pp", "tp", "tdp", "po4", "tn", "chla", "np_ratio", "c6cdom")

grabs <-  reshape2::melt(grabs[,c(metadata_fields, data_fields)], id = metadata_fields)

theme_opts <- list(ggplot2::theme(
  panel.grid.minor = ggplot2::element_blank(),
  panel.grid.major = ggplot2::element_blank(),
  panel.background = ggplot2::element_blank(),
  plot.background = ggplot2::element_rect(fill="white"),
  panel.border = ggplot2::element_blank(),
  axis.line.y = ggplot2::element_line(),
  axis.line.x = ggplot2::element_line(),
  axis.text.x = ggplot2::element_text(angle = 90, vjust = -0.0125),
  axis.text.y = ggplot2::element_text(),
  axis.ticks = ggplot2::element_line(),
  axis.title.x = ggplot2::element_blank(),
  axis.title.y = ggplot2::element_blank(),
  plot.title = ggplot2::element_text(size=24),
  strip.background = ggplot2::element_rect(fill = 'white')))

# param_names <- c(
#   `pp` = "PP uM",
#   `tp` = "TP uM",
#   `tdp` = "TDP uM",
#   `po4` = "PO4 uM",
#   `tn` = "TN uM",
#   `np_ratio` = "N/P Ratio"
# )

param_names <- read.table(text="
pp,PP (uM)
tp,TP (uM)
tdp,TDP (uM)
po4,PO4 (uM)
tn,TN (uM)
np_ratio,'NP Ratio'
c6cdom,'CDOM'", sep = ",", header = FALSE, col.names = c("variable", "variable_long"), stringsAsFactors = FALSE)
param_names[,"variable_long"] <- gsub("u", "\U03BC", param_names[,2])

grabs <- merge(grabs, param_names)

grabs$variable_long <- factor(grabs$variable_long, levels = c("PP (\U03BCM)", "TP (\U03BCM)", "TDP (\U03BCM)", "TN (\U03BCM)", "PO4 (\U03BCM)", "chla", "NP Ratio", "CDOM"))

gg <- ggplot(grabs[grabs$variable_long != "chla",], aes(x = location, y = value))
gg <- gg + geom_boxplot(outlier.shape = NA)
gg <- gg + facet_wrap(~variable_long, scales = "free_y", ncol = 2) + ylab("")
gg <- gg + theme_opts
gg
ggsave("figures/nonchlboxplot.png", width = 4.5, height = 6)
