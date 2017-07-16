library(DataflowR)
library(sf)
library(gstat)
library(raster)
library(ggplot2)
library(ggjoy)
library(hrbrthemes)

vg_range <- function(pnt, ras, year){
  print(year)
  pnt <- st_transform(pnt, projection(ras))
  
  if(is.na(raster::extract(ras, as(pnt, "Spatial")))){
    NA
  }else{
  
    # clip ras by point buffer ####
    pnt_buf <- st_buffer(pnt, 2000)
    ras_crop <- raster::crop(ras, as.vector(st_bbox(pnt_buf))[c(1, 3, 2, 4)])
    p <- rasterToPoints(ras_crop)
    p_raw <- data.frame(p)
    
    fit <- lm(p_raw[,grep("chlext", names(p_raw))[1]] ~ p_raw$y)
    p_raw$resid <- resid(fit)
    p <- p_raw
    # p     <- data.frame(p)
    coordinates(p) <- ~ x + y
    
    # fit variogram ####
    al <- c(310, 320, 330, 340)
    al <- 310
    vg <- variogram(resid ~ 1, p, width = 10, alpha = c(al))
    vg.fit <- fit.variogram(vg, vgm("Gau"))
    plot(vg, model = vg.fit)
    vg.fit$range[2]
  }
}

# load data ####
goodyears <- read.csv("data/goodyears.csv", stringsAsFactors = FALSE)
# limit to years with obvious within study domain point source evidence
goodyears <- c(201410, 201206, 200808, 201502, 201505) # tb
goodyears <- as.list(as.data.frame(t(goodyears)))

s197_coords <- data.frame(lat = 25.257064, lon = -80.423032)
tr_coords   <- data.frame(lat = 25.190608, lon = -80.639136)
mk_coords   <- data.frame(lat = 25.167077, lon = -80.732520)
tc_coords   <- data.frame(lat = 25.214955, lon = -80.533478)

pnt <- st_as_sf(tr_coords, coords = c("lon", "lat"), crs = 4326)
tr_dist <- lapply(goodyears, function(x) vg_range(pnt, surfget(x, "chlext"), x))

pnt <- st_as_sf(s197_coords, coords = c("lon", "lat"), crs = 4326)
# ras <- surfget(200910, "chlext")
s197_dist <- lapply(goodyears, function(x) vg_range(pnt, surfget(x, "chlext"), x))

pnt <- st_as_sf(mk_coords, coords = c("lon", "lat"), crs = 4326)
mk_dist <- lapply(goodyears, function(x) vg_range(pnt, surfget(x, "chlext"), x))

pnt <- st_as_sf(tc_coords, coords = c("lon", "lat"), crs = 4326)
tc_dist <- lapply(goodyears, function(x) vg_range(pnt, surfget(x, "chlext"), x))

mk_dist_order <- order(unlist(mk_dist), decreasing = TRUE)
mk_dist_order <- mk_dist_order[!is.na(unlist(mk_dist))]
unlist(goodyears[mk_dist_order])
unlist(mk_dist[mk_dist_order])

res <- data.frame(dists = unlist(c(tr_dist, s197_dist, mk_dist, tc_dist)), 
                  sites = rep(c("LM", "MB", "TB", "JB"), 
                              times = rep(length(goodyears), 4)))
res$sites <- factor(res$sites, levels = c("TB", "LM", "JB", "MB"))

ggplot(res) + geom_joy(aes(x = dists, y = sites)) + 
  xlim(c(0, 3000)) + 
  theme_ipsum() + theme(axis.line = element_line())

ggplot(data.frame(dists = unlist(mk_dist))) + 
  geom_histogram(stat = "count", aes(x = dists))


# draw line on map  
new_y <- st_coordinates(pnt)[2] - (sin(al) * vg.fit$range[2])
new_x <- st_coordinates(pnt)[1] - (cos(al) * vg.fit$range[2])

new_pnt <- st_as_sf(data.frame(x = new_x, y = new_y), coords = c("x", "y"))

plot(ras)
plot(new_pnt, add = TRUE)
plot(pnt, add = TRUE)

# what is min distance among grab sample points?
dbhydro_grabs <- read.csv("data/dbhydt.csv", stringsAsFactors = FALSE)
dbhydro_grabs <- dbhydro_grabs[dbhydro_grabs$zone %in% c("FBE", "FBC", "BS"), c("site", "zone", "latdec", "londec")]
dbhydro_grabs[dbhydro_grabs$zone == "BS", "zone"] <- "BB"
dbhydro_grabs <- suppressWarnings(aggregate(dbhydro_grabs, 
                             list(site = dbhydro_grabs[,"site"], 
                             zone = dbhydro_grabs[,"zone"]), mean)[,c(1,2,5,6)])
dbhydro_grabs <- st_as_sf(dbhydro_grabs, coords = c("londec", "latdec"), crs = 4326)
dbhydro_grabs <- st_transform(dbhydro_grabs, projection(ras))

pnt_dist <- dist(st_coordinates(dbhydro_grabs))
pnt_dist <- as.matrix(pnt_dist)
min(apply(pnt_dist, 2, function(x) min(x[x > 0])))

