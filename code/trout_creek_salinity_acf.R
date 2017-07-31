library(dataRetrieval)
library(wql)

# 251253080320100 = mouth of trout creek
# 00480 = bottom salinity

dt2 <- readNWISdata(service = "dv", sites = "251253080320100", parameterCd = "00480", startDate = "2008-08-01", endDate = "2015-09-01")

dt3 <- wql::interpTs(dt2$X_YSI.near.bottom_00480_00003, "linear")

png("figures/trout_creek_salinity_acf.png")
acf(dt3, lag.max = 14, main = "ACF of Trout Creek Salinity")
dev.off()

#####

library(DataflowR)
library(ggplot2)
library(methods)
library(ggsn)
library(maptools)

# Initial Set-up####
theme_opts <- list(ggplot2::theme(
  panel.grid.minor = ggplot2::element_blank(),
  panel.grid.major = ggplot2::element_blank(),
  panel.background = ggplot2::element_blank(),
  plot.background = ggplot2::element_rect(fill="white"),
  panel.border = ggplot2::element_blank(),
  axis.line = ggplot2::element_blank(),
  axis.text.x = ggplot2::element_blank(),
  axis.text.y = ggplot2::element_blank(),
  axis.ticks = ggplot2::element_blank(),
  axis.title.x = ggplot2::element_blank(),
  axis.title.y = ggplot2::element_blank(),
  plot.title = ggplot2::element_text(size=22),
  strip.background = ggplot2::element_rect(fill = 'white')))

fdir <- getOption("fdir")
fboutline <- rgdal::readOGR(file.path(fdir, "DF_Basefile", "FBcoast_big.shp"), layer = "FBcoast_big", verbose = FALSE, stringsAsFactors = FALSE)
fboutline <- raster::crop(fboutline, raster::extent(c(515000, 568000, 2770000, 2800000)))
fboutline@data$id <- rownames(fboutline@data)
fboutline.points <- ggplot2::fortify(fboutline, region = "id")
fboutline.df <- plyr::join(fboutline.points, fboutline@data,by="id")

trout_coords <- apply(rbind(c(25,12,53.66),c(-80,32,00.61)), 1, function(x) jsta::dms2dd(x))
trout_coords <- data.frame(lon = trout_coords[2], lat = trout_coords[1])
trout_coords <- coordinatize(trout_coords, "lat", "lon")
trout_coords <- data.frame(coordinates(trout_coords))
trout_coords$label <- "Trout Creek"

stream <- DataflowR::streamget(201509)
stream <- coordinatize(stream, "lat_dd", "lon_dd")
stream_coords <- data.frame(coordinates(stream))

gg <- ggplot()
gg <- gg + geom_rect(aes(xmin = 515000, xmax = 568000, ymin = 2770000, ymax = 2800000), linetype = 1, colour = "black", fill = "white")
gg <- gg + geom_map(data = fboutline.df, map = fboutline.df , aes(map_id = id), color = "black", alpha = 0.8)
gg <- gg + geom_point(data = stream_coords, aes(x = lon_dd, y = lat_dd), size = 0.5, alpha = 0.4, color = "gray")
gg <- gg + geom_point(data = trout_coords, aes(x = lon, y = lat), fill = "red", size = 0.8, color = "red")
gg <- gg + geom_text(data = trout_coords, aes(label = label, x = lon, y = lat), size = 2, color = "red", fontface = "bold", position = position_nudge(y = 900))

gg + theme_opts

ggsave("figures/fbmap_trout.png", width = 2, height = 1.5)
