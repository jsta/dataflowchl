
Dataflow Chlorophyll Manuscript
===============================

Dependencies
------------

### R packages

| packages  |              |
|:----------|--------------|
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

``` bash
make help
```

    ## [36mdata                          [0m copy data from archives
    ## [36mdata/goodyears.csv            [0m listing of surveys with good spatial coverage
    ## [36mdata/allstreaming.csv         [0m move streaming data from archive folder
    ## [36mdata/allgrabs.csv             [0m move grab data from archive folder
    ## [36mfigures                       [0m create figures
    ## [36mfigures/multipanel.png        [0m create multipanel figure
    ## [36mfigures/multipanel_salinity.png[0m create salinity multipanel
    ## [36mfigures/multipanel_mb.png     [0m create multipanel figure zoomed to Manatee Bay
    ## [36mfigures/multipanel_jb.png     [0m create multipanel figure zoomed to Joe Bay
    ## [36mfigures/fbmap_dflow.png       [0m create Florida Bay basemap with dflow grab points
    ## [36mfigures/fbmap_wqmn.png        [0m create Florida Bay basemap with wqmn grab points
    ## [36mfigures/fbmap.png             [0m create 2 panel Florida Bay basemap with grab points
    ## [36mfigures/rain.png              [0m create rain time-series figure
    ## [36mfigures/chlboxplot.png        [0m create chlorophyll boxplot
    ## [36mfigures/nonchlboxplot.png     [0m create non-chlorophyll boxplot
    ## [36mfigures/chltimeseries.png     [0m create chlorophyll time-series plot 
    ## [36mfigures/avmap.png             [0m create average chl and phycoc maps
    ## [36mtables                        [0m create tables
    ## [36mmanuscripts/est_coast/table_2.tex[0m Table 2
    ## [36mms                            [0m compile ms
    ## [36mdiff                          [0m create latexdiff pdf
