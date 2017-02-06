DEPS=Makefile


all: transponder_check.pdf dump1090/dump1090 

data/%.txt: data/%_30005_output.bin bin/throttle
	(dump1090/dump1090 --net-only --interactive > $@) &
	sleep 1
	pv -cN input < $< | ./bin/throttle 102400 | nc localhost 30004
	killall dump1090


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

transponder_check.pdf: transponder_check.tex references.bib $(DEPS)
	pdflatex transponder_check.tex
	pdflatex transponder_check.tex
	pdflatex transponder_check.tex
	bibtex transponder_check.aux
	pdflatex transponder_check.tex
	pdflatex transponder_check.tex

#Image generation
img/%.pdf: img/%.svg $(DEPS)
	inkscape -z -D --file=$< --export-pdf=$@
#	 rsvg-convert -f pdf -o $@ $<
