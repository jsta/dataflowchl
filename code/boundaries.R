library(DataflowR)
library(raster)
library(gdalUtils)
library(ggplot2)
library(dplyr)

fdir <- getOption("fdir")
goodyears <- read.csv("data/goodyears.csv", stringsAsFactors = FALSE)
goodyears <- as.list(as.data.frame(t(goodyears)))

# ras <- DataflowR::surfget(goodyears[[length(goodyears)]], "chlext")

in_paths <- file.path(fdir, "DF_Surfaces", goodyears, "chlext.tif")

edge_count <- function(in_path, ind){
  out <- gdalUtils::gdaldem("slope", in_path, "test.tif", 
            p = TRUE, output_Raster = TRUE, verbose = TRUE)
  
  x <- seq(0.05, cellStats(out, max), length.out = 12)
  y <- sapply(x, function(x) cellStats(out > x, sum))
  
  data.frame(x, y, ind = ind)
}

res <- lapply(seq_len(length(goodyears)), function(x) edge_count(in_paths[x], x))

test <- dplyr::bind_rows(res)
test$ind <- factor(test$ind)
key <- data.frame(yearmon = factor(unlist(goodyears)), ind = factor(1:20))
test <- dplyr::left_join(test, key)

labs <- data.frame(x = tapply(test$x, test$yearmon, function(x) nth(x, -1L)), 
                   lab = unlist(goodyears))
labs <- labs[order(labs$x),]
labs$y <- seq(log(0.1), log(max(test$y)), length.out = length(goodyears))

ggplot(test) + 
  geom_line(aes(x, log(y), colour = yearmon)) + 
  scale_y_reverse(lim = c(10, 0)) + 
  geom_text(data = labs, aes(x, log(y), label = lab), 
            position = position_jitter(height = 2)) + 
  labs(x = "Percent Slope (%)", y = "log(Count)", colour = "Date")

ggplot(test) + geom_line(aes(x, y, colour = yearmon)) + scale_y_reverse(lim = c(12000, 0))



tapply(test$y, test$yearmon, first)


test <- res



test <- purrr::flatten(test)
cbind(rbind(test[[seq(1, length(test), by = 2)]]), 
      rbind(test[[seq(1, length(test), by = 2)]])
      )


test[[1]]$ind <- 1



edge_count(in_paths[1], label = goodyears[1])
edge_count(in_paths[2], label = goodyears[2])
edge_count(in_paths[3], label = goodyears[3])
edge_count(in_paths[4], label = goodyears[4])
edge_count(in_paths[5], label = goodyears[5])
edge_count(in_paths[6], label = goodyears[6])
edge_count(in_paths[7], label = goodyears[7])
edge_count(in_paths[8], label = goodyears[8])
edge_count(in_paths[9], label = goodyears[9])
edge_count(in_paths[10], label = goodyears[10])
edge_count(in_paths[11], label = goodyears[11])
edge_count(in_paths[12], label = goodyears[12])
edge_count(in_paths[13], label = goodyears[13])
edge_count(in_paths[14], label = goodyears[14])
edge_count(in_paths[15], label = goodyears[15])
edge_count(in_paths[16], label = goodyears[16])
edge_count(in_paths[17], label = goodyears[17])
edge_count(in_paths[18], label = goodyears[18])
edge_count(in_paths[19], label = goodyears[19])
edge_count(in_paths[20], label = goodyears[20])
