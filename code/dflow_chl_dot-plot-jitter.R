#==================================================================#
# Create a jittered dot-plot of Dataflow chlorophyll
#==================================================================#

grabs <- read.csv(file.path("data", "allgrabs.csv"), row.names = NULL, stringsAsFactors = FALSE)
grabs <- grabs[!(grabs$location %in% c("Taylor River", "Deer Key")),]

grabs$datetime <- jsta::date456posix(grabs$date, century = "20")

theme_opts <- list(ggplot2::theme(
  panel.grid.minor = ggplot2::element_blank(),
  panel.grid.major = ggplot2::element_blank(),
  panel.background = ggplot2::element_blank(),
  plot.background = ggplot2::element_rect(fill="white"),
  panel.border = ggplot2::element_blank(),
  axis.line = ggplot2::element_line(),
  axis.text.x = ggplot2::element_text(),
  axis.text.y = ggplot2::element_text(),
  axis.ticks = ggplot2::element_line(),
  axis.title.x = ggplot2::element_blank(),
  axis.title.y = ggplot2::element_text(),
  plot.title = ggplot2::element_text(size=22),
  strip.background = ggplot2::element_rect(fill = 'white')))

grabs$location <- factor(grabs$location, levels = c("Whipray Basin", "Rankin", "Terrapin Bay", "Monroe Lake", "Seven Palm Lake", "Madeira Bay", "Little Madeira", "Pond 5", "Joe Bay", "Long Sound", "Blackwater Sound", "Lake Surprise", "Manatee", "Barnes"), ordered = TRUE)

colourCount <- length(unique(grabs$location))
getPalette <- colorRampPalette(RColorBrewer::brewer.pal(7, "Set1"))

library(ggplot2)
gg <- ggplot(grabs, aes(y = chla, x = datetime, ymax = max(chla) * 1.05))
gg <- gg + geom_point(pch = 19, position = position_jitter(w = 0.9), aes(colour = location), size = 3) + theme_opts + ylab("Chla (ug/L)")
gg <- gg + scale_color_manual(values = getPalette(colourCount))
gg <- gg + theme(legend.position = "bottom") + guides(col = guide_legend(title = NULL, ncol = 4, byrow = TRUE))
gg                             
