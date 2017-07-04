library(xtable)

dt <- read.csv("tables/modelfits.csv", stringsAsFactors = FALSE)
dt <- dt[order(dt$yearmon),]
dt[dt$pvalue < 0.01 & !is.na(dt$pvalue), "pvalue"] <- "<0.01"
dt <- dt[dt$yearmon <= 201509,]

dt$yearmon <- 
  sapply(dt$yearmon, function(x) paste0(substring(x, 0, 4), 
                                        "-",
                                 substring(x, 5, 6)))

print(xtable(dt, caption = "Model coefficients for regressions between Dataflow and chlorophyll concentration of discrete grab samples. Also given is the coefficient of determination (R2) and p-value of each regression."
), 
      file = "manuscripts/est_coast/table_2.tex",
      caption.placement = "top", 
      include.rownames = FALSE)
