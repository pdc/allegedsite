## AUTOMATICALLY GENERATED ##
# pdc/2005/02/Makefile: makefile for ROOTDIR/pdc/2005/02/*.html
# Generated 2007-02-09 by thmkmf 5.1.6 (2004-03-22).
# This makefile requires GNU make.

THC             = /Users/pdc/bin/thc
MAKE            = make
SHELL           = /bin/sh
INSTALL_HTML    = cp -p

srcRootDir      = ../../..
htmlRootDir     = /Users/pdc/Sites/alleged.org.uk/
subDir          = pdc/2005/02
htmlDir         = $(htmlRootDir)/$(subDir)

inFiles         = index.th
subDirs         = 

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
