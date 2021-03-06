
Code for *Stachelek et al. (2017)*
==================================

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.839334.svg)](https://doi.org/10.5281/zenodo.839334)

**Joseph Stachelek, Christopher J. Madden, Stephen Kelly, Michelle Blaha (submitted)**. Improved estimation of phytoplankton abundance and fine-scale water quality features via simultaneous discrete and semi-continuous surveys.

Dependencies
------------

### R packages

|           |          |              |            |
|:----------|:---------|:-------------|:-----------|
| DataflowR | ggsn     | remake       | knitr      |
| raster    | maptools | gdalUtils    | kableExtra |
| ggplot2   | cowplot  | sf           | magrittr   |
| dplyr     | viridis  | fitdistrplus | gstat      |
| ggrepel   | sp       | GGally       | ggjoy      |

Data
----

**Christopher J. Madden, Joseph Stachelek, Stephen Kelly, Michelle Blaha (2017)** Florida Bay water quality estimated by underway flow-through measurement. *KNB Data Repository*. <http://dx.doi.org/10.5063/F11R6NGR>

Build
-----

Building the figures, tables, and manuscript has been streamlined with [GNU make](http://kbroman.org/minimal_make/). See the items defined as build targets by running the following line in the terminal:

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
    ## figures/boundaries.png        create boundaries figure
    ## tables                        create tables
    ## manuscripts/est_coast/table_2.texcreate table 2
    ## ms                            compile ms
    ## diff                          create latexdiff pdf
