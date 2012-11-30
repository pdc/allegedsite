# Makefile for genreating favicon from bits

# Original makefile clobbered by thmkmf damnit :-(

PNGTOPPM =	pngtopnm
PPMTOWINICON = ppmtowinicon

argfiles = 	48.8bit.ppm 48.mask.pgm \
		32.8bit.ppm 32.mask.pgm \
		32.4bit.ppm 32.mask.pgm \
		16.8bit.ppm 16.mask.pgm \
		16.4bit.ppm 16.mask.pgm

all: favicon.ico

install: all
	cp -p favicon.ico ../../web

clean:
	rm -f $(argfiles)
	rm -f websafe.ppm win.ppm

favicon.ico: $(argfiles)
	$(PPMTOWINICON) -and -output=$@ $(argfiles)

.SUFFIXES: .ppm .pgm .pam .png

%.8bit.ppm: %.fullcolour.png websafe.ppm
	$(PNGTOPPM) $< | pnmremap -mapfile=websafe.ppm - > $@

%.4bit.ppm: %.fullcolour.png win.ppm
	$(PNGTOPPM) $< | pnmremap -mapfile=win.ppm -fs - > $@

.png.pgm:
	$(PNGTOPPM) $< | ppmtopgm > $@

win.ppm: win.png
	$(PNGTOPPM) $< > $@

websafe.ppm:
	pamseq 3 5 -tupletype=RGB | pamtopnm > $@