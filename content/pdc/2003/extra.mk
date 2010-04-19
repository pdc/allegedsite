$(htmlFiles): ../pdcDefs.tcl ../entryDefs.tcl

index.html: *.e ../lj.data

subjects.html: ../*/*.e subjects.data