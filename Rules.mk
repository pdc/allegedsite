
.SUFFIXES: .css .less

all: targets


# Subdirectories

dir := alleged/blog
include $(dir)/Rules.mk

dir := alleged/whyhello/static/style
include $(dir)/Rules.mk


# Defintiions of this built at this level

requirements_files_in=requirements.in dev-requirements.in
requirements_files_txt=$(requirements_files_in:.in=.txt)

REALCLEAN := $(REALCLEAN) $(requirements_files_txt)

requirements.txt: requirements.in
	$(PIPCOMPILE) $< > $@

dev-requirements.txt: dev-requirements.in
	$(PIPCOMPILE) $< > $@


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
