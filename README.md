
Dataflow Chlorophyll Manuscript
===============================

Dependencies
------------

### R packages

|           |              |
|:----------|:-------------|
| DataflowR | remake       |
| raster    | gdalUtils    |
| ggplot2   | sf           |
| dplyr     | fitdistrplus |
| ggrepel   | GGally       |
| ggsn      | knitr        |
| maptools  | kableExtra   |
| cowplot   | magrittr     |
| viridis   | gstat        |
| sp        | ggjoy        |

Build
-----

`$ make help`

    ## data                          copy data from archives
    ## data/goodyears.csv            listing of surveys with good spatial coverage
    ## data/allstreaming.csv         move streaming data from archive folder
    ## data/allgrabs.csv             move grab data from archive folder
    ## figures                       create figures
    ## figures/multipanel.png        create multipanel figure
    ## figures/multipanel_salinity.pngcreate salinity multipanel
    ## figures/multipanel_mb.png     create multipanel figure zoomed to Manatee Bay
    ## figures/multipanel_jb.png     create multipanel figure zoomed to Joe Bay
    ## figures/fbmap_dflow.png       create Florida Bay basemap with dflow grab points
    ## figures/fbmap_wqmn.png        create Florida Bay basemap with wqmn grab points
    ## figures/fbmap.png             create 2 panel Florida Bay basemap with grab points
    ## figures/rain.png              create rain time-series figure
    ## figures/chlboxplot.png        create chlorophyll boxplot
    ## figures/nonchlboxplot.png     create non-chlorophyll boxplot
    ## figures/chltimeseries.png     create chlorophyll time-series plot 
    ## figures/avmap.png             create average chl and phycoc maps
    ## tables                        create tables
    ## manuscripts/est_coast/table_2.texCreate table 2
    ## ms                            compile ms
    ## diff                          create latexdiff pdf
