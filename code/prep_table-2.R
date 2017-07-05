# library(xtable)
library(knitr)
library(kableExtra)
library(magrittr)
options(knitr.kable.NA = '')

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

# knitr ####
# dt <- data.frame(
#   matrix(
#     sapply(unlist(dt), function(x) na.omit(x))
#     , ncol = ncol(dt), byrow = FALSE))

names(dt) <- c("Date", 
               "CDOM", "chla",
               "PE", "chla", "CDOM", "PC", 
               "intercept", "$R^2$", "p", "n")


dt$p[grep("<", unlist(dt$p))] <- paste0("\\textless", 
                      rep("0.01", length(dt$p[grep("<", unlist(dt$p))])))

file.create("manuscripts/est_coast/table_2.tex")
fileConn <- file("manuscripts/est_coast/table_2.tex")
writeLines(kable(dt, format = "latex", booktabs = TRUE, 
      caption = "Model coefficients for regressions between Dataflow and chlorophyll concentration of discrete grab samples. CDOM = colored dissolved organic matter, PE = phycoerythrin, PC = phycocyanin. Also given is the coefficient of determination $R^2$ and p-value of each regression.", escape = FALSE, digits = 3) %>% 
  add_header_above(c(" ", "Primary" = 2, "Secondary" = 4)), fileConn)
close(fileConn)

# xtable ####
# names(dt) <- c("Date", 
#                "CDOM", "chla",
#                "PE", "chla", "CDOM", "PC", 
#                "intercept", "$R^2$", "p", "n")
# print(xtable(dt, caption = "Model coefficients for regressions between Dataflow and chlorophyll concentration of discrete grab samples. Also given is the coefficient of determination (R2) and p-value of each regression."
# ), 
#       file = "manuscripts/est_coast/table_2.tex",
#       caption.placement = "top", 
#       include.rownames = FALSE)
