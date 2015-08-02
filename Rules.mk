
.SUFFIXES: .css .less

all: targets


# Subdirectories

dir := alleged/blog/static/style
include $(dir)/Rules.mk


# Generic rules

.less.css:
	$(LESSC) $(LESSFLAGS) -M $< $@ > $*.d.next && mv $*.d.next $*.d



# Variables TARGETS, CLEAN, and REALCLEAN may be added to by Rules.mk fragments
# in subdirectories

.PHONY: targets
targets:    $(TARGETS)

.PHONEY: clean
clean:
	rm -f $(CLEAN)

.PHONEY: realclean
realclean: clean
	rm -f $(REALCLEAN)

.PHONEY: clean
depend: $(DEPEND)





