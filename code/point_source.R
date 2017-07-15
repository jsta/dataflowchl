library(DataflowR)
library(sf)
library(gstat)

# load data ####
ras <- surfget(201509, "chlext")

s197_coords <- data.frame(lat = 25.257064, lon = -80.423032)
tr_coords   <- data.frame(lat = 25.190608, lon = -80.639136)
mk_coords <- data.frame(lat = 25.167077, lon = -80.732520)

pnt <- st_as_sf(tr_coords, coords = c("lon", "lat"), crs = 4326)
pnt <- st_as_sf(s197_coords, coords = c("lon", "lat"), crs = 4326)
# pnt <- st_as_sf(mk_coords, coords = c("lon", "lat"), crs = 4326)

pnt <- st_transform(pnt, projection(ras))

# plot(ras)
# plot(s197, add = TRUE)

# clip ras by point buffer ####
pnt_buf <- st_buffer(pnt, 2000)
ras_crop <- raster::crop(ras, as.vector(st_bbox(pnt_buf))[c(1, 3, 2, 4)])
p <- rasterToPoints(ras_crop)
p_raw <- data.frame(p)
fit <- lm(p_raw$chlext ~ p_raw$y)
p_raw$resid <- resid(fit)
p <- p_raw
# p     <- data.frame(p)
coordinates(p) <- ~ x + y

# plot(ras)
# plot(pnt_buf, add = TRUE)
# plot(ras_crop)
# plot(pnt, add = TRUE)

# fit variogram ####
al <- c(310, 320, 330, 340)
al <- 310
vg <- variogram(resid ~ 1, p, width = 10, alpha = c(al))
vg.fit <- fit.variogram(vg, vgm("Gau"))
plot(vg, model = vg.fit)
vg.fit$range[2]

# draw line on map  
new_y <- st_coordinates(pnt)[2] - (sin(al) * vg.fit$range[2])
new_x <- st_coordinates(pnt)[1] - (cos(al) * vg.fit$range[2])

new_pnt <- st_as_sf(data.frame(x = new_x, y = new_y), coords = c("x", "y"))

plot(ras)
plot(new_pnt, add = TRUE)
plot(pnt, add = TRUE)

# what is mean distance amoung grab sample points?

