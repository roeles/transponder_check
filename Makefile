DEPS=Makefile


all: dump1090/dump1090 


imgclean:
	rm -f img/*.pdf

outputclean:
	rm -f *.pdf

intermediateclean:
	rm -f *.aux
	rm -f *.bbl
	rm -f *.log
	rm -f *.out
	rm -f *.blg
	rm -f *.nlo
	rm -f *.ist
	rm -f *.nls

clean: imgclean outputclean intermediateclean

bin/%: code/%.c
	gcc -o $@ $<

dump1090/dump1090: dump1090/Makefile
	make -C dump1090

%.pdf-view: %.pdf
		qpdfview $<

%.pdf-install: %.pdf
	cp -v $< ~/public_html/


#PDF files
#minorchange_complete.pdf: minorchange.pdf preface.pdf
#	pdftk preface.pdf approval.pdf minorchange.pdf cat output $@

minorchange.pdf: transponder_check.tex references.bib $(DEPS)
	pdflatex minorchange.tex
	pdflatex minorchange.tex
	pdflatex minorchange.tex
#	bibtex kalman_paper.aux
#	pdflatex kalman_paper.tex
#	pdflatex kalman_paper.tex

#Image generation
img/%.pdf: img/%.svg $(DEPS)
	inkscape -z -D --file=$< --export-pdf=$@
#	 rsvg-convert -f pdf -o $@ $<
