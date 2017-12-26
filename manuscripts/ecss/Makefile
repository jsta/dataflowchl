diff: dataflowchl.tex
	latexdiff -t CTRADITIONAL save_dataflowchl.tex dataflowchl.tex > diff.tex
	pdflatex diff.tex

ms_word:
	pandoc -s dataflowchl.tex --reference-doc=template.docx --bibliography=dataflowchl.bib --csl=elsarticle-harv.csl -o dataflowchl.docx

pdf:
	pdflatex dataflowchl
	-bibtex dataflowchl
	pdflatex dataflowchl
	pdflatex dataflowchl
