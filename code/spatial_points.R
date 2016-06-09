# ID a set of DF points that are in the same location (within a set tolerance) accross surveys
# 1. start with all the points from 201308
# 2. loop through remaining surveys + remove dups in loop + tally points that are zerodist with template + remove points that do not appear with the percent_cutoff

library(DataflowR)
library(sp)

template <- 201308
zero_cutoff <- 120
percent_cutoff <- 0.80

good_years <- read.csv("data/goodyears.csv")[,1]
good_years <- good_years[-which(good_years %in% c(201002, 201102, 201209))] #rm small spatial extent

dt <- lapply(good_years, function(x) coordinatize(streamget(as.character(x)), latname = "lat_dd", lonname = "lon_dd"))

loop_ind <- 1:length(dt)
template_ind <- which(good_years == template)
template_dt <- dt[[template_ind]]
loop_ind <- loop_ind[-template_ind]

res_ind <- 1:nrow(dt[[template_ind]])
res <- list()

for(i in loop_ind){
  cur_sub <- dt[[i]]
  cur_sub <- remove.duplicates(cur_sub)
  
  cur_zdist <- zerodist2(template_dt, cur_sub, zero = zero_cutoff)
  length(unique(cur_zdist[,1])) #res should be equal
  
  res[[i]] <- res_ind[res_ind %in% cur_zdist[,1]]
  # print(i)
  # print(length(res[[i]]))
}

res_table <- data.frame(table(do.call("c", res)))
res_table$Freq <- res_table$Freq / length(res)
res_table <- res_table[res_table$Freq > percent_cutoff,]
plot(template_dt[res_table[,1],], main = paste(percent_cutoff, zero_cutoff))

# fit clustering algorithm to point wq data to delinate zones

