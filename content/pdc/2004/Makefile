## AUTOMATICALLY GENERATED ##
# pdc/2004/Makefile: makefile for ROOTDIR/pdc/2004/*.html
# Generated 2007-02-09 by thmkmf 5.1.6 (2004-03-22).
# This makefile requires GNU make.

THC             = /Users/pdc/bin/thc
MAKE            = make
SHELL           = /bin/sh
INSTALL_HTML    = cp -p

srcRootDir      = ../..
htmlRootDir     = /Users/pdc/Sites/alleged.org.uk/
subDir          = pdc/2004
htmlDir         = $(htmlRootDir)/$(subDir)

inFiles         = index.th\
		zoetrope.th
subDirs         = 01 02 04 05 06 07 08 10 11 springy

# Explicit rules
htmlFiles	= $(inFiles:.th=.html)
filesFiles	= $(inFiles:.th=.files)

all:		$(htmlFiles)

install:	$(htmlFiles)
	for i in `cat $(filesFiles)`; do $(INSTALL_HTML) $$i $(htmlDir)/$$i; done
	for i in $(subDirs); do (cd $$i; $(MAKE) install); done

subdirs:
	for i in $(subDirs); do (cd $$i; $(MAKE) all subdirs); done

clean:
	rm -f `cat $(filesFiles)` $(filesFiles)
	rm -f $(htmlFiles) img.data
	for i in $(subDirs); do (cd $$i; $(MAKE) clean); done

# Implicit rules
.SUFFIXES:	.th .html

.th.html:
	$(THC)  --html_root $(htmlRootDir) --subdir $(subDir) $<


# Extra rules
include extra.mk
