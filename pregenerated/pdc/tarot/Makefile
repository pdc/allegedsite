## AUTOMATICALLY GENERATED ##
# pdc/tarot/Makefile: makefile for ROOTDIR/pdc/tarot/*.html
# Generated 2012-11-23 by thmkmf 5.1.6 (2004-03-22).
# This makefile requires GNU make.

THC             = /Users/pdc/bin/thc
MAKE            = make
SHELL           = /bin/sh
INSTALL_HTML    = cp -p

srcRootDir      = ../..
htmlRootDir     = ../web
pathFromRoot    = pdc/tarot
htmlDir         = $(srcRootDir)/$(htmlRootDir)/$(pathFromRoot)

inFiles         = about-svg.th\
		about.th\
		aboutDealer.th\
		index-png.th\
		index-svg.th\
		index.th\
		references.th\
		referrers.th\
		svg.th\
		technical.th

# Explicit rules
htmlFiles   = $(inFiles:.th=.html)
filesFiles  = $(inFiles:.th=.files)

all:        $(htmlFiles)

install:	$(htmlFiles)
	mkdir -p $(htmlDir)
	for i in `cat $(filesFiles)`; do\
		$(INSTALL_HTML) $$i $(htmlDir)/$$i;\
	done

clean:
	rm -f `cat $(filesFiles)` $(filesFiles)
	rm -f $(htmlFiles) img.data

# Implicit rules
.SUFFIXES:    .th .html

.th.html:
	$(THC)  --html_root $(htmlRootDir) --subdir $(pathFromRoot) $<


# Extra rules
include extra.mk
