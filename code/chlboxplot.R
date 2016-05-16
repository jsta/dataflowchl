grabs <- read.csv(file.path("data", "allgrabs.csv"), row.names = NULL, stringsAsFactors = FALSE)


grabs <- grabs[!(grabs$location %in% c("Deer Key", "Taylor River")),]

grabs$location <- factor(grabs$location, levels = c("Whipray Basin", "Rankin", "Terrapin Bay", "Monroe Lake", "Seven Palm Lake", "Madeira Bay", "Little Madeira", "Pond 5", "Joe Bay", "Long Sound", "Blackwater Sound", "Lake Surprise", "Manatee", "Barnes"))

metadata_fields <- c("date", "time", "location", "lat_dd", "lon_dd")
#data_fields <-   c("salt", "chla", "tss", "pp", "tp", "tdp", "po4", "toc", "doc", "tkn", "tdkn", "chlaiv", "temp", "cond", "sal", "trans", "cdom", "brighteners", "phycoe", "phycoc", "c6chl", "c6cdom", "c6turbidity", "c6temp")
data_fields <-   c("chla", "tss", "pp", "tp", "tdp", "po4", "toc", "doc", "tkn", "tdkn")
data_fields <-   c("pp", "tp", "tdp", "po4", "tkn", "tdkn", "chla")

grabs <-  reshape2::melt(grabs[,c(metadata_fields, data_fields)], id = metadata_fields)


theme_opts <- list(ggplot2::theme(
  panel.grid.minor = ggplot2::element_blank(),
  panel.grid.major = ggplot2::element_blank(),
  panel.background = ggplot2::element_blank(),
  plot.background = ggplot2::element_rect(fill="white"),
  panel.border = ggplot2::element_blank(),
  axis.line = ggplot2::element_line(),
  axis.text.x = ggplot2::element_text(angle = 90),
  axis.text.y = ggplot2::element_text(),
  axis.ticks = ggplot2::element_line(),
  axis.title.x = ggplot2::element_blank(),
  axis.title.y = ggplot2::element_text(),
  plot.title = ggplot2::element_text(size=22),
  strip.background = ggplot2::element_rect(fill = 'white')))

library(ggplot2)
grabs_chl <- grabs[grabs$variable == "chla",]
gg <- ggplot(grabs_chl, aes(x = location, y = value))
gg <- gg + theme_opts
gg + geom_boxplot(outlier.shape = NA) + ylab("Chla (ug/L)") + scale_y_continuous(limits = c(0, 20))
ggsave("figures/chlboxplot.png", width = 4, height = 3)

