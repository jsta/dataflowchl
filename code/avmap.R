# Create average chlext and phycoc maps

library(DataflowR)
library(raster)

goodyears <- read.csv("data/goodyears.csv", stringsAsFactors = FALSE)

rlist <- create_rlist(goodyears$x, "phycoc")$rlist
phycoc <- average_rlist(rlist, 0.8)

rlist <- create_rlist(goodyears$x, "chlext")$rlist
chlext <- average_rlist(rlist, 0.8)

raster::writeRaster(phycoc, filename = "data/phycoc.tif", format = "GTiff", overwrite = TRUE)
raster::writeRaster(chlext, filename = "data/chlext.tif", format = "GTiff", overwrite = TRUE)

DataflowR::grassmap(fpath = "data/chlext.tif", params = "chlext", label_string = "Chlorophyll a (mg/L)")
DataflowR::grassmap(fpath = "data/phycoc.tif", params = "phycoc", label_string = "Phycocyanin (RFU)")

