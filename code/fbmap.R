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
#fboutline.df <- fboutline.df[fboutline.df$hole == FALSE,]

fathombasins <- rgdal::readOGR("data/fbzonesmerge.shp", layer = "fbzonesmerge", verbose = FALSE, stringsAsFactors = FALSE)
fathombasins_centroids <- as.data.frame(cbind(fathombasins$AbbrName, coordinates(fathombasins)))
names(fathombasins_centroids) <- c("ZoneName", "long", "lat")
fathombasins_centroids[,2:3] <- apply(fathombasins_centroids[,2:3], 2, function(x) as.numeric(as.character(x)))
fathombasins <- ggplot2::fortify(fathombasins, region = "ZoneName")

dbhydro_grabs <- read.csv("data/dbhydt.csv", stringsAsFactors = FALSE)
dbhydro_grabs <- dbhydro_grabs[dbhydro_grabs$zone %in% c("FBE", "FBC", "BS"), c("site", "zone", "latdec", "londec")]
dbhydro_grabs[dbhydro_grabs$zone == "BS", "zone"] <- "BB"
dbhydro_grabs <- suppressWarnings(aggregate(dbhydro_grabs, 
                  list(site = dbhydro_grabs[,"site"], 
                       zone = dbhydro_grabs[,"zone"]), mean)[,c(1,2,5,6)])

zone_poly <- lapply(unique(dbhydro_grabs$zone), function(x){
  zone_sub <- coordinatize(dbhydro_grabs[dbhydro_grabs$zone == x,])
  raster::buffer(rgeos::gConvexHull(zone_sub), width = 900 , dissolve = TRUE)
})
zone_poly <- zone_poly[[1]] + zone_poly[[2]] + zone_poly[[3]]
zone_poly <- SpatialPolygonsDataFrame(zone_poly ,data.frame(id = 1:3, zonename = c("BB", "FBC", "FBE")))
zone_poly_centroids <- as.data.frame(cbind(as.character(zone_poly@data$zonename), coordinates(zone_poly)))
names(zone_poly_centroids) <- c("ZoneName", "long", "lat")
zone_poly_centroids[,2:3] <- apply(zone_poly_centroids[,2:3], 2, function(x) as.numeric(as.character(x)))
zone_poly <- ggplot2::fortify(zone_poly, region = "zonename")

# surveytrack <- coordinatize(streamget(201507), latname = "lat_dd", 
#                             lonname = "lon_dd")
# surveytrack <- data.frame(surveytrack)[,c("lon_dd", "lat_dd")]
# surveytrack <- surveytrack[sample(seq_len(nrow(surveytrack)), 
#                                   nrow(surveytrack) * 0.5),]
# surveytrack$id <- "1"
# names(surveytrack)[1:2] <- c("x", "y")

## WQMN Grab Map ####
gg <- ggplot()
gg <- gg + geom_rect(aes(xmin = 515000, xmax = 568000, ymin = 2770000, ymax = 2800000), linetype = 1, colour = "black", fill = "white")
gg <- gg + geom_map(data = fboutline.df, map = fboutline.df , aes(x = long, y = lat, map_id = id), color = "black", alpha = 0.8)
# gg <- gg +  geom_point(data = surveytrack, aes(x = x, y = y), 
#                        shape = 21, size = 1, colour = "black", 
#                        fill = "black", alpha = 0.15)
gg <- gg + geom_map(data = zone_poly, map = zone_poly, aes(x = long, y = lat,  map_id = id), alpha = 0.4, fill = "black", color = "black")
gg <- gg + geom_text(data = zone_poly_centroids, aes(label = ZoneName, x = long, y = lat), size = 4, color = "red", fontface = "bold", position = position_nudge(y = 900))
gg <- gg + geom_point(data = data.frame(coordinates(coordinatize(dbhydro_grabs))), aes(x = londec, y = latdec), size = 2, fill = "red", color = "red")
gg_wqmn <- gg + theme_opts
gg_wqmn
ggsave("figures/fbmap_wqmn.png", width = 4, height = 3)

## Dataflow Grab Map ####
gg <- ggplot()
gg <- gg + geom_rect(aes(xmin = 515000, xmax = 568000, ymin = 2770000, ymax = 2800000), linetype = 1, colour = "black", fill = "white")
gg <- gg + geom_map(data = fboutline.df, map = fboutline.df , aes(x = long, y = lat, map_id = id), color = "black", alpha = 0.8)

gg <- gg + geom_map(data = fathombasins, map = fathombasins, aes(x = long, y = lat,  map_id = id), alpha = 0.4, fill = "grey", color = "black")
gg <- gg + geom_text(data = fathombasins_centroids, aes(label = ZoneName, x = long, y = lat), size = 4, color = "red", fontface = "bold", position = position_nudge(y = 900))

gg <- gg + geom_point(data = fathombasins_centroids, aes(x = long, y = lat), size = 2, fill = "red", color = "black")

gg_df <- gg + theme_opts + scalebar(dist = 10, location = "bottomright", st.size = 3, x.min = 515000, x.max = 565000, y.min = 2772200, y.max = 2800000)
gg_df
ggsave("figures/fbmap_dflow.png", width = 4, height = 3)

library(cowplot)

plot_grid(gg_df, gg_wqmn, ncol = 1, labels = "auto", hjust = -4.8, vjust = 3)
ggsave("figures/fbmap.png", width = 4, height = 6)
# 

ggsn::north(fboutline.df, location = "topleft", symbol = 1, scale = 0.2)
#===============================================================#

# library(sp)
# arrow <- list("SpatialPolygonsRescale", layout.north.arrow(), offset = c(574000, 2790000), scale = 7000)
# spplot(fboutline, sp.layout = list(arrow, fathombasins), colorkey = FALSE, xlim = c(513107, 578000), ylim = c(2767383, 2802745))