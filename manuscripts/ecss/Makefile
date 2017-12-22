diff: dataflowchl.tex
	latexdiff -t CTRADITIONAL save_dataflowchl.tex dataflowchl.tex > diff.tex
	pdflatex diff.tex

ms_word:
	pandoc -s dataflowchl.tex --bibliography=dataflowchl.bib -o dataflowchl.docx

