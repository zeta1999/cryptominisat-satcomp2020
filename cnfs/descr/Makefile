TEX = pdflatex -shell-escape -interaction=nonstopmode -file-line-error
PRE =  $(TEX) -ini -job-name="preamble" "&pdflatex preamble.tex\dump"
BIB = bibtex

all: cdcl-sls.pdf

view :
	    okular cdcl-sls.pdf

cdcl-sls.pdf : clean cdcl-sls.tex cdcl-sls.bbl cdcl-sls.blg
	    $(TEX) cdcl-sls.tex
	    $(TEX) cdcl-sls.tex

cdcl-sls.bbl cmsv5.blg : cdcl-sls.bib cdcl-sls.aux
	    $(BIB) cdcl-sls

cdcl-sls.aux : cdcl-sls.tex
	    $(TEX) cdcl-sls.tex

cdcl-sls.bib : cdcl-sls.tex
	    $(TEX) cdcl-sls.tex

clean:
	rm -f *.log *.pdf *.blg *.bbl *.aux *.out *.backup
