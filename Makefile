DEPS=Makefile


all: transponder_check.pdf $(DEPS)

view: transponder_check.pdf $(DEPS)
	qpdfview $<

data/%.rtlsdr: $(DEPS)
	rtl_sdr -f 1090000000 -s 2000000 -g 50 -n 120000000 - | pv -cN rtlsdr -s 240000000 > $@

data/%.txt: data/%_30005_output.bin bin/throttle dump1090/dump1090 $(DEPS)
	(dump1090/dump1090 --net-only --interactive > $@) &
	sleep 1
	pv -cN input < $< | ./bin/throttle 102400 | nc -q 1 localhost 30004
	killall dump1090


imgclean: $(DEPS)
	rm -f img/*.pdf

outputclean: $(DEPS)
	rm -f *.pdf

intermediateclean: $(DEPS)
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


transponder_check.pdf: transponder_check.tex references.bib img/setup.pdf data/2016-10-29_1438.txt $(DEPS)
	pdflatex transponder_check.tex
	pdflatex transponder_check.tex
	pdflatex transponder_check.tex
	bibtex transponder_check.aux
	pdflatex transponder_check.tex
	pdflatex transponder_check.tex

#Image generation
img/%.pdf: img/%.svg $(DEPS)
	 rsvg-convert -f pdf -o $@ $<
#	inkscape -z -D --file=$< --export-pdf=$@
