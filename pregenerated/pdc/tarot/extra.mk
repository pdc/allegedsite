PYTHON 		= python

trumpsFiles = 	0-fool.svg i-magician.svg ii-papess.svg iii-empress.svg \
		iiii-emperor.svg v-pope.svg vi-lovers.svg vii-chariot.svg \
		viii-justice.svg viiii-hermit.svg x-wheel.svg xi-strength.svg \
		xii-hanged.svg xiii-death.svg \
		xiiii-temperance.svg xv-devil.svg xvi-tower.svg xvii-star.svg \
		xviii-moon.svg xviiii-sun.svg xx-judgement.svg xxi-world.svg

pipsFiles =	wands-2.svg cups-2.svg swords-2.svg coins-2.svg \
		wands-3.svg cups-3.svg swords-3.svg coins-3.svg \
		wands-4.svg cups-4.svg swords-4.svg coins-4.svg \
		wands-5.svg cups-5.svg swords-5.svg coins-5.svg \
		wands-6.svg cups-6.svg swords-6.svg coins-6.svg \
		wands-7.svg cups-7.svg swords-7.svg coins-7.svg \
		wands-8.svg cups-8.svg swords-8.svg coins-8.svg \
		wands-9.svg cups-9.svg swords-9.svg coins-9.svg \
		wands-ten.svg cups-ten.svg swords-ten.svg coins-ten.svg

courtFiles =	wands-page.svg wands-knight.svg wands-queen.svg wands-king.svg\
		cups-page.svg cups-knight.svg cups-queen.svg cups-king.svg \
		swords-page.svg swords-knight.svg\
		swords-queen.svg swords-king.svg \
		coins-page.svg coins-knight.svg coins-queen.svg coins-king.svg

indexSvgFiles =	wands.svg cups.svg swords.svg coins.svg \
		trumps0.svg trumps12.svg

svgFiles = 	$(trumpsFiles) \
		wands-ace.svg cups-ace.svg swords-ace.svg coins-ace.svg \
		$(pipsFiles) \
		$(courtFiles)


$(htmlFiles):	 ../pdcDefs.tcl tarotDefs.tcl ../abbrDefs.tcl

png.html: 	$(svgFiles:%.svg=%-100w.png) \
		$(svgFiles:%.svg=%-360h.png) \
		tarotDefs.tcl

svg.html: 	$(svgFiles:%.svg=%-card3.svg) \
		tarotDefs.tcl descs.tcl



%-card3.svg: 	%.svg mkcard3.tcl descs.tcl
	tclsh mkcard3.tcl $* > $@

.SECONDARY: $(svgFiles:.svg=.cmap)

%.svg: 		%.sk.svg %.cmap cmapAdjust.py
	python fixsvg.py $*.sk.svg
	@cp -p cmyk.cmap cmyk.cmap~
	cat $*.cmap > cmyk.cmap
	python cmapAdjust.py $*

%.cmap: 	%.sk.ppm %.ppm ppmtocmap.py
	python ppmtocmap.py $*
	cat tmp.cmap > $@

$(pipsFiles:.svg=-card3.svg): pips-templ.xml
$(trumpsFiles:.svg=-card3.svg): trumps-templ.xml
$(courtFiles:.svg=-card3.svg): trumps-templ.xml

$(indexSvgFiles): 	mksvgindex.py
	$(PYTHON) mksvgindex.py dir=.

install: install-svg-timestamp install-png-timestamp

install-svg-timestamp: $(svgFiles:.svg=-card3.svg) $(indexSvgFiles)
	mkdir -p $(htmlDir)
	cp -p $? $(htmlDir)
	date > $@

install-png-timestamp:  $(svgFiles:.svg=-100w.png) \
		$(svgFiles:.svg=-360h.png) \
		$(svgFiles:.svg=-64x64.png)
	mkdir -p $(htmlDir)
	cp -p $? $(htmlDir)
	date > $@

.SUFFIXES: .png .tga

%-64x64.png: %.ppm
	pnmcut -width 577 -height 792 $< \
	| pnmcut 0 107 577 577 \
	| pnmscale -width 64 | ppmquant 256 \
	| pnmtopng -comp 9 -v > $@
	rm -f img.data

%-100w.png: %.ppm
	pnmcut -width 577 -height 792 $< \
	| pnmscale -width 100 | ppmquant 256 \
	| pnmtopng -comp 9 -v > $@
	rm -f img.data

%-360h.png: %.ppm
	pnmcut -width 577 -height 792 $< \
	| pnmscale -height 360 | ppmquant 256 \
	| pnmtopng -comp 9 -v > $@
	rm -f img.data

%.ppm: %.tga
	tgatoppm $< > $@
