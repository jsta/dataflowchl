library(DataflowR)

sample_dates <- c(200808, 200910, 201004, 201007, 201102, 201105, 201206, 201209, 
                  201212, 201305, 201308, 201311, 201404, 201407, 201410, 201502, 
                  201505, 201507, 201509)

format_labels <- function(x){
  strftime(as.character(as.Date(paste0(x, "01"), format = "%Y%m%d")), 
           format = "%b %Y")
}

label_strings <- sapply(as.character(sample_dates), format_labels)
  
grassmap(rnge = sample_dates, params = 'chlext', numrow = 5, numcol = 4, 
         labelling = TRUE, label_string = label_strings, label_size = 35)
