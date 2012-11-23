## AUTOMATICALLY GENERATED ##
# Makefile: makefile for ROOTDIR/*.html
# Generated 2012-11-23 by thmkmf 5.1.6 (2004-03-22).
# This makefile requires GNU make.

THC             = /Users/pdc/bin/thc
MAKE            = make
SHELL           = /bin/sh
INSTALL_HTML    = cp -p

srcRootDir      = .
htmlRootDir     = ../web
pathFromRoot    = .
htmlDir         = $(srcRootDir)/$(htmlRootDir)/$(pathFromRoot)

subdirs         = pdc

# Explicit rules
all:        subdirs

install:	
	for i in $(subdirs); do (cd $$i; $(MAKE) install); done

subdirs:
	for i in $(subdirs); do (cd $$i; $(MAKE) all); done

clean:
	for i in $(subdirs); do (cd $$i; $(MAKE) clean); done

# Implicit rules
.SUFFIXES:    .th .html

.th.html:
	$(THC)  --html_root $(htmlRootDir) --subdir $(pathFromRoot) $<

