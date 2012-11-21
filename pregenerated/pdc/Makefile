## AUTOMATICALLY GENERATED ##
# pdc/Makefile: makefile for ROOTDIR/pdc/*.html
# Generated 2012-11-21 by thmkmf 5.1.6 (2004-03-22).
# This makefile requires GNU make.

THC             = /Users/pdc/bin/thc
MAKE            = make
SHELL           = /bin/sh
INSTALL_HTML    = cp -p

srcRootDir      = ..
htmlRootDir     = ../web
subDir          = pdc
htmlDir         = $(htmlRootDir)/$(subDir)

inFiles         = 
subDirs         = tarot

# Explicit rules
htmlFiles   = $(inFiles:.th=.html)
filesFiles  = $(inFiles:.th=.files)

all:        $(htmlFiles)

install:	$(htmlFiles)
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

