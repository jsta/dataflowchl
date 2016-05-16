library(DataflowR)
grassmap(rnge = c(200808, 200910, 201002, 201004, 201007, 201102, 201105, 201206, 201209, 201212, 201305, 201308, 201311, 201404, 201407, 201410, 201502, 201505, 201507, 201509), params = 'chlext', numrow = 5, numcol = 4, basin = "Little Madeira Bay")

rlist <- create_rlist(rnge = c(200808, 200910, 201002, 201004, 201007, 201102, 201105, 201206, 201209, 201212, 201305, 201308, 201311, 201404, 201407, 201410, 201502, 201505, 201507, 201509), params = 'chlext')$rlist

sapply(rlist, function(x) extent(raster(x)))

rstack <- raster::stack(rlist)
rstack_mean <- mean(rstack)


