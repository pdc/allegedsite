# Convert LESS files to CSS files

# List of top-level LESS files.
topfiles = grid1.less \
	grid2.less \
	grid3.less \
	grid5.less


LESSC = lessc
LESS_FLAGS =


all: $(topfiles:.less=.css)

clean:
	rm -f $(topfiles:.less=.css)

clean-deps:
	rm -f $(topfiles:.less=.mk)


.SUFFIXES: .css .less .mk

.less.css:
	$(LESSC) $(LESS_FLAGS) $< $@
	@$(LESSC) $(LESS_FLAGS) -M $< $*.css > $*.mk


-include $(topfiles:.less=.mk)