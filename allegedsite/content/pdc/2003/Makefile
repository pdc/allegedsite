## AUTOMATICALLY GENERATED ##
# pdc/2003/Makefile: makefile for ROOTDIR/pdc/2003/*.html
# Generated 2007-02-09 by thmkmf 5.1.6 (2004-03-22).
# This makefile requires GNU make.

THC             = /Users/pdc/bin/thc
MAKE            = make
SHELL           = /bin/sh
INSTALL_HTML    = cp -p

srcRootDir      = ../..
htmlRootDir     = /Users/pdc/Sites/alleged.org.uk/
subDir          = pdc/2003
htmlDir         = $(htmlRootDir)/$(subDir)

inFiles         = con-close.th\
		copying-files.th\
		encoding-1.th\
		ibookvspbook.th\
		index.th\
		input-type-image.th\
		installing-pyxml.th\
		link-style.th\
		lotus-notes.th\
		marks-of-quotation.th\
		more-upload-woes.th\
		no-inverted-commas.th\
		no-writing-files.th\
		picky-rest.th\
		pythonic-psp.th\
		seh-in-the-news.th\
		serving-my-own.th\
		subjects.th\
		what-do-you-mean-ctrl-z.th\
		xhtml2-cite.th
subDirs         = 05 06 07 08 09 10 11 12 latin-1p mull percy picky

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
