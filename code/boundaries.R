library(DataflowR)
library(raster)
library(gdalUtils)
library(ggplot2)
library(dplyr)
library(hrbrthemes)
library(ggrepel)

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
labs$y <- seq(log(1.5), log(max(test$y)), length.out = length(goodyears))

format_labels <- function(x){
  strftime(as.character(as.Date(paste0(x, "01"), format = "%Y%m%d")), format = "%b %Y")
}

# test <- ungroup(test)
test <- dplyr::group_by(test, yearmon)

ggplot(test) + 
  geom_line(aes(x, log(y), colour = yearmon)) + 
  #scale_y_reverse(lim = c(10, 0)) + 
  geom_label_repel(data = filter(test, x == max(x)), 
                   aes(x, log(y), label = yearmon)) + 
  labs(x = "Percent Slope (%)", y = "log(Count)", colour = "Date") + 
  theme_classic() + 
  scale_color_hue(labels = c(format_labels(unlist(goodyears)))) + 
  theme(axis.line = element_line(), 
        panel.grid = element_blank(), 
        axis.text = element_text(size = 14), 
        axis.title = element_text(size = 14)) + 
  scale_x_reverse(lim = c(5, 0))

ggsave("figures/boundaries.png")
