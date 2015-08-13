#chlext.R
survey<-commandArgs(trailingOnly=TRUE)[1]
x<-substring(basename(survey),1,6)
print(x)
print(survey)

suppressWarnings(library(DataflowR))
chlmap(x)