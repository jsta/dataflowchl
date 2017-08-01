library(DataflowR)
library(raster)
library(gdalUtils)
library(ggplot2)
library(dplyr)
library(ggrepel)
library(cowplot)

fdir <- getOption("fdir")
goodyears <- read.csv("data/goodyears.csv", stringsAsFactors = FALSE)
goodyears <- as.list(as.data.frame(t(goodyears)))

edge_count <- function(in_path, ind){
  out <- gdalUtils::gdaldem("slope", in_path, "test.tif", 
            p = TRUE, output_Raster = TRUE, verbose = TRUE)
  
  x <- seq(0.05, cellStats(out, max), length.out = 12)
  y <- sapply(x, function(x) cellStats(out > x, sum))
  
  data.frame(x, y, ind = ind)
}

format_labels <- function(x){
  strftime(as.character(as.Date(paste0(x, "01"), format = "%Y%m%d")), format = "%b %Y")
}

range01 <- function(x){
  (x - min(x, na.rm = FALSE)) / 
    (max(x, na.rm = FALSE) - min(x, na.rm = FALSE))
}

in_paths <- file.path(fdir, "DF_Surfaces", goodyears, "chlext.tif")

res <- lapply(seq_len(length(goodyears)), 
              function(x) edge_count(in_paths[x], x))

test     <- dplyr::bind_rows(res)
test$ind <- factor(test$ind)
key      <- data.frame(yearmon = factor(unlist(goodyears)), ind = factor(1:19))
test     <- dplyr::left_join(test, key)

labs     <- data.frame(x = tapply(test$x, 
                test$yearmon, function(x) nth(x, -1L)), 
                lab = unlist(goodyears))
labs     <- labs[order(labs$x),]
labs$y   <- seq(log(1.5), log(max(test$y)), length.out = length(goodyears))

test     <- dplyr::group_by(test, yearmon)
test$y <- log(test$y)
test[test$y == -Inf, "y"] <- 0
test$y <- range01(test$y)

ggchl <- ggplot(test) + 
  geom_line(aes(x, y, colour = yearmon)) + 
  geom_label_repel(data = filter(test, x == max(x)), 
                   aes(x, y, label = yearmon, color = yearmon), 
                   fontface = 'bold', segment.color = "grey50", 
                   segment.alpha = 0.5, 
                   box.padding = unit(0.7, "lines")) + 
  labs(x = "Percent Slope (%)", 
       y = "Proportion(log(Count))", 
       colour = "Date") + 
  theme_classic() + 
  scale_color_hue(labels = c(format_labels(unlist(goodyears)))) + 
  theme(axis.line = element_line(), 
        panel.grid = element_blank(), 
        axis.text = element_text(size = 14), 
        axis.title = element_text(size = 14)) + 
  scale_x_reverse(lim = c(5, 0)) 
# + 
#   guides(color = guide_legend(ncol = 2))


in_paths <- file.path(fdir, "DF_Surfaces", goodyears, "sal.tif")

res <- lapply(seq_len(length(goodyears)), 
              function(x) edge_count(in_paths[x], x))

test     <- dplyr::bind_rows(res)
test$ind <- factor(test$ind)
key      <- data.frame(yearmon = factor(unlist(goodyears)), ind = factor(1:19))
test     <- dplyr::left_join(test, key)

labs     <- data.frame(x = tapply(test$x, 
                                  test$yearmon, function(x) nth(x, -1L)), 
                       lab = unlist(goodyears))
labs     <- labs[order(labs$x),]
labs$y   <- seq(log(1.5), log(max(test$y)), length.out = length(goodyears))

test     <- dplyr::group_by(test, yearmon)
test$y <- log(test$y)
test[test$y == -Inf, "y"] <- 0
test$y <- range01(test$y)

ggsal <- ggplot(test) + 
  geom_line(aes(x, y, colour = yearmon)) + 
  geom_label_repel(data = filter(test, x == max(x)), 
                   aes(x, y, label = yearmon, color = yearmon), 
                   fontface = 'bold', segment.color = "grey50", 
                   segment.alpha = 0.5, 
                   box.padding = unit(0.7, "lines")) + 
  labs(x = "Percent Slope (%)", 
       y = "Proportion(log(Count))", 
       colour = "Date") + 
  theme_classic() + 
  scale_color_hue(labels = c(format_labels(unlist(goodyears)))) + 
  theme(axis.line = element_line(), 
        panel.grid = element_blank(), 
        axis.text = element_text(size = 14), 
        axis.title = element_text(size = 14)) + 
  scale_x_reverse(lim = c(5, 0)) 
# + 
#   guides(color = guide_legend(ncol = 2))

gggrid <- plot_grid(ggchl + 
                      theme(legend.position = "none"), 
                    ggsal + 
                      theme(legend.position = "none", 
                            axis.title.y = element_blank()), 
                    rel_widths = c(1, 0.9), 
                    labels = c("a", "b"), 
                    hjust = c(-9, -6))

legend <- get_legend(ggchl + theme(legend.position = "bottom"))

plot_grid(gggrid, legend, ncol = 1, rel_heights = c(1, 0.2))

ggsave("figures/boundaries.png", width = 24, height = 12.5, units = "cm")
