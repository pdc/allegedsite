
$(htmlFiles): ../../pdcDefs.tcl

albumdir = ../../../../albums
index.html: $(albumdir)/albumDefs.tcl $(albumdir)/albums.data
