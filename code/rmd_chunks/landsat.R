basedir<-"/home/jose/Documents/Science/Data/Dataflow/DF_Basefile"

files<-list.files(file.path("/home","jose","Documents","Science","Data","landsat"),pattern="*.TIF$",include.dirs = TRUE,full.names = TRUE)
tifs<-files[nchar(files)==70]
masks<-files[nchar(files)==73]
ctifs<-paste0(unlist(strsplit(tifs,".TIF")),"_f",".TIF")

if(!any(file.exists(ctifs))){
  for(i in 1:length(tifs)){
    
    system(paste("gdal_fillnodata.py -mask", masks[i], "-of GTiff", tifs[i], ctifs[i]))
    
  }
}

rstack<-raster::stack(ctifs)
testgrid<-rgdal::readOGR(paste0(basedir,"/testgrid3.shp"),layer="testgrid3", verbose = FALSE)
rstack<-raster::crop(rstack,testgrid)
