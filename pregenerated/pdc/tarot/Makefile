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
subDir          = pdc/tarot
htmlDir         = $(srcRootDir)/$(htmlRootDir)/$(subDir)

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
subDirs         =

# Explicit rules
htmlFiles   = $(inFiles:.th=.html)
filesFiles  = $(inFiles:.th=.files)

all:        $(htmlFiles) subdirs

install:	$(htmlFiles)
	mkdir -p $(htmlDir)
	for i in `cat $(filesFiles)`; do\
		$(INSTALL_HTML) $$i $(htmlDir)/$$i;\
	done
	for i in $(subDirs); do (cd $$i; $(MAKE) install); done

subdirs:
	for i in $(subDirs); do (cd $$i; $(MAKE) all subdirs); done

clean:
	rm -f `cat $(filesFiles)` $(filesFiles)
	rm -f $(htmlFiles) img.data
	for i in $(subDirs); do (cd $$i; $(MAKE) clean); done

# Implicit rules
.SUFFIXES:    .th .html

.th.html:
	$(THC)  --html_root $(htmlRootDir) --subdir $(subDir) $<


# Extra rules
include extra.mk
