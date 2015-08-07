
.SUFFIXES: .css .less

all: targets


# Subdirectories

dir := alleged/blog/static/style
include $(dir)/Rules.mk

requirements_files_in=requirements.in dev-requirements.in
requirements_files_txt=$(requirements_files_in:.in=.txt)

REALCLEAN := $(REALCLEAN) $(requirements_files_txt)

requirements.txt: requirements.in
	$(PIPCOMPILE) $< > $@

dev-requirements.txt: dev-requirements.in
	$(PIPCOMPILE) $< > $@


# Generic rules

.less.css:
	$(LESSC) $(LESSFLAGS) -M $< $@ > $*.d.next && mv $*.d.next $*.d


# Variables TARGETS, CLEAN, and REALCLEAN may be added to by Rules.mk fragments
# in subdirectories

.PHONY: targets
targets: $(TARGETS)

.PHONEY: requirements
requirements: $(requirements_files_txt)

.PHONEY: clean
clean:
	rm -f $(CLEAN)

.PHONEY: realclean
realclean: clean
	rm -f $(REALCLEAN)

.PHONEY: depend
depend: $(DEPEND)

-include $(DEPEND)
