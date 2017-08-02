# header ####################################################	
md=manuscripts/dataflowchl.md
pdf=manuscripts/dataflowchl.pdf
csl=manuscripts/ecology.csl
refs=manuscripts/dataflowchl.bib
pflags= --template=manuscripts/template.tex --bibliography=$(refs) --csl=$(csl) 

#BASE_PATH=/home/jose/Documents/Science/Data/Dataflow
#GOODYEARS=200808 200910 201004 201007 201102 201105 201206 201209 201212 201305 201308 201311 201404 201407 201410 201502 201505 201507 201509
#SURFACE_PATHS = $(foreach yearmon, $(GOODYEARS), $(BASE_PATH)/DF_Surfaces/$(yearmon)/chlext.tif)
#DATA_PATHS = $(foreach yearmon, $(GOODYEARS), $(BASE_PATH)/DF_FullDataSets/$(yearmon)j.csv)

.PHONY: help
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z0-9\./\_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# convert_docx: ## convert docx ms to markdown
# 	pandoc -f docx -t markdown manuscripts/DataflowChl.docx -o manuscripts/dataflowchl.md

# data ####################################################	

data: data/goodyears.csv data/allstreaming.csv data/allgrabs.csv ## copy data from archives
	@echo "data pulled"

data/goodyears.csv: code/goodyears.R  ## listing of surveys with good spatial coverage
	Rscript -e "source('code/goodyears.R')"	

data/allstreaming.csv: ## move streaming data from archive folder
	Rscript -e "source('code/allstreaming.R')"	

data/allgrabs.csv: code/allgrabs.R ## move grab data from archive folder
	Rscript -e "source('code/allgrabs.R')"	

# data/dbhydt.csv: ## update DBHYDRO subset and move to local folder
# 	cd /home/jose/Documents/Science/Data/WQMN/ && Rscript -e "remake::make('updateddb.csv')" && rsync updateddb.csv /home/jose/Documents/Science/JournalSubmissions/DataflowChl/data 
# 	mv data/updateddb.csv data/dbhydt.csv

# data/modelfits.csv: /home/jose/Documents/Science/Data/Dataflow/DF_GrabSamples/extractChlcoef2.csv ## move model fit info from archive folder
# 	rsync /home/jose/Documents/Science/Data/Dataflow/DF_GrabSamples/extractChlcoef2.csv data    
# 	mv data/extractChlcoef2.csv data/modelfits.csv

# data/flow/ENPOps_flow.csv: ## pull USGS flow data from NWIS
# 	Rscript code/pull_usgs_flow.R

# figures #######################################################

figures: figures/multipanel.png figures/multipanel_mb.png figures/fbmap.png figures/rain.png figures/chlboxplot.png figures/nonchlboxplot.png figures/trout.png ## create figures
	@echo "figures built"

figures/multipanel.png: $(SURFACE_PATHS) code/multipanel.R ## create multipanel figure
	Rscript code/multipanel.R
	convert multipanel.png -gravity North -chop 0x85 figures/multipanel.png
	-rm multipanel.png

figures/multipanel_salinity.png: code/multipanel_salinity.R ## create salinity multipanel
	Rscript code/multipanel_salinity.R
	convert multipanel.png -gravity North -chop 0x85 figures/multipanel_salinity.png
	-rm multipanel.png
	
figures/multipanel_mb.png: $(SURFACE_PATHS) ## create multipanel figure zoomed to Manatee Bay
	Rscript --default-packages=methods,utils R/multipanel_mb.R	
	
figures/multipanel_jb.png: $(SURFACE_PATHS) ## create multipanel figure zoomed to Joe Bay
	Rscript --default-packages=methods,utils code/multipanel_jb.R	

figures/fbmap_dflow.png: code/fbmap.R ## create Florida Bay basemap with dflow grab points
	Rscript code/fbmap.R

figures/fbmap_wqmn.png: code/fbmap.R ## create Florida Bay basemap with wqmn grab points
	Rscript code/fbmap.R

figures/fbmap.png: code/fbmap.R  ## create 2 panel Florida Bay basemap with grab points
	Rscript code/fbmap.R
	convert figures/fl-inset_border.png -resize 12% -bordercolor black :- | convert figures/fbmap.png -page +870+1470 - -gravity east -flatten figures/fbmap.png

figures/rain.png: data/rain/NexradRainData.txt ## create rain time-series figure
	Rscript code/rain.R

figures/chlboxplot.png: ## create chlorophyll boxplot
	Rscript code/chlboxplot.R

figures/nonchlboxplot.png: code/nonchlboxplot.R ## create non-chlorophyll boxplot
	Rscript code/nonchlboxplot.R

figures/chltimeseries.png: data/dbhydt.csv code/chltimeseries.R ## create chlorophyll time-series plot 
	Rscript code/chltimeseries.R

figures/phycoc.png: code/avmap.R
	Rscript code/avmap.R

figures/chlext.png: code/avmap.R 
	Rscript code/avmap.R

figures/avmap.png: figures/phycoc.png figures/chlext.png ## create average chl and phycoc maps
	convert phycoc.png -gravity South -crop 100x94%+0+0 phycoc_crop.png
	convert chlext.png -gravity South -crop 100x94%+0+0 chlext_crop.png
	montage chlext_crop.png phycoc_crop.png -geometry +2+2 -tile x2 \
		figures/avmap.png
	-rm chlext_crop.png phycoc_crop.png

figures/trout.png: code/trout_creek_salinity_acf.R
	Rscript code/trout_creek_salinity_acf.R
	montage figures/fbmap_trout.png figures/trout_creek_salinity_acf.png \
		-geometry +2+2 -tile 2x -gravity south -trim figures/trout.png
		
figures/boundaries.png: code/boundaries.R data/goodyears.csv
	Rscript code/boundaries.R 

# tables     #######################################################

tables: manuscripts/est_coast/table_1.tex manuscripts/est_coast/table_2.tex ## create tables
	@echo "tables built"

tables/grabs_cor.csv: data/allgrabs_log.csv code/cormat.R
	Rscript code/cormat.R
	
tables/grabs_pvalues.csv: data/allgrabs_log.csv code/cormat.R
	Rscript code/cormat.R

manuscripts/est_coast/table_1.tex: tables/grabs_cor.csv tables/grabs_pvalues.csv code/prep_table-1.R
	Rscript code/prep_table-1.R
	
tables/modelfits.csv: code/modelfits.R
	Rscript code/modelfits.R

manuscripts/est_coast/table_2.tex: tables/modelfits.csv code/prep_table-2.R ## Table 2
	Rscript code/prep_table-2.R


# manuscript #######################################################

ms: data figures tables clean ## compile ms
	pandoc $(md) -o manuscripts/dataflowchl.tex $(pflags)
	pdflatex manuscripts/dataflowchl.tex

diff: manuscripts/est_coast/dataflowchl.tex ## create latexdiff pdf
	cd manuscripts/est_coast && make diff
	
# finalize + cleanup ###############################################

#all: render_rmd
#	@echo "built"

clean:
	-rm *.log
	-rm *.aux
	-rm *.tex
	-rm *.out

test:
	@grep -E '^[a-zA-Z0-9\./\_-]+:.*?## .*$$' $(MAKEFILE_LIST)
