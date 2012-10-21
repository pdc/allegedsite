$(htmlFiles): ../pdcDefs.tcl

albumdir = ../../../albums
index.html:  $(albumdir)/albumDefs.tcl \
	$(albumdir)/peopleUrls.tcl\
	$(albumdir)/albums.data
