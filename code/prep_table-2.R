# library(xtable)
library(knitr)
library(kableExtra)
library(magrittr)

dt <- read.csv("tables/modelfits.csv", stringsAsFactors = FALSE)
dt <- dt[order(dt$yearmon),]
dt[dt$pvalue < 0.01 & !is.na(dt$pvalue), "pvalue"] <- "<0.01"
dt <- dt[dt$yearmon <= 201509,]

gy <- read.csv("data/goodyears.csv", stringsAsFactors = FALSE)
gy <- rbind(200804, 200812, gy)
gy <- gy[order(gy$x),]
gy <- data.frame(x = gy)
gy$n <- unlist(lapply(gy[,1], function(x) nrow(DataflowR::grabget(x))))

dt <- dplyr::left_join(dt, gy, by = c("yearmon" = "x"))

dt$yearmon <- 
  sapply(dt$yearmon, function(x) paste0(substring(x, 0, 4), 
                                        "-",
                                 substring(x, 5, 6)))


kable(dt, format = "latex", booktabs = TRUE, 
      caption = "Model coefficients for regressions between Dataflow and chlorophyll concentration of discrete grab samples. Also given is the coefficient of determination (R2) and p-value of each regression.") %>% 
  add_header_above(c(" ", "Primary" = 2, "Secondary" = 4))
                                                                                                                                                                                                                                                                               

names(dt) <- c("Date", "CDOM")

# print(xtable(dt, caption = "Model coefficients for regressions between Dataflow and chlorophyll concentration of discrete grab samples. Also given is the coefficient of determination (R2) and p-value of each regression."
# ), 
#       file = "manuscripts/est_coast/table_2.tex",
#       caption.placement = "top", 
#       include.rownames = FALSE)
