## AUTOMATICALLY GENERATED ##
# pdc/Makefile: makefile for ROOTDIR/pdc/*.html
# Generated 2012-11-23 by thmkmf 5.1.6 (2004-03-22).
# This makefile requires GNU make.

THC             = /Users/pdc/bin/thc
MAKE            = make
SHELL           = /bin/sh
INSTALL_HTML    = cp -p

srcRootDir      = ..
htmlRootDir     = ../web
subDir          = pdc
htmlDir         = $(srcRootDir)/$(htmlRootDir)/$(subDir)

inFiles         = 
subDirs         = 2003 tarot

# Explicit rules
all:        subdirs

install:	
	for i in $(subDirs); do (cd $$i; $(MAKE) install); done

subdirs:
	for i in $(subDirs); do (cd $$i; $(MAKE) all subdirs); done

clean:
	for i in $(subDirs); do (cd $$i; $(MAKE) clean); done

# Implicit rules
.SUFFIXES:    .th .html

.th.html:
	$(THC)  --html_root $(htmlRootDir) --subdir $(subDir) $<

