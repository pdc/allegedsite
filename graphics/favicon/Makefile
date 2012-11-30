# Makefile for genreating favicon from bits

# Original makefile clobbered by thmkmf damnit :-(

PNGTOPPM =	pngtoppm


win.ppm: win.png
	$(PNGTOPPM) $< > $@

websafe.ppm:
	pamseq 3 5 -tupletype=RGB | pamtopnm > $@