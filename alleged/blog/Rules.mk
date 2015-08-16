# This file is included by the top-level Makefile

# Maintain a stack of directory names. In this file $(d) is the current directory.

sp := $(sp).x
dirstack_$(sp) := $(d)
d := $(dir)


# Subdirs

dir := $(d)/static/style
include $(dir)/Rules.mk

dir := $(d)/components
include $(dir)/Rules.mk



# Local variables include the subdir in their name

# This says we want the outputs of components to go in static/js
# targets_$(d) = $(targets_$(d)/components:$(d)/components/%.js=$(d)/static/js/%.js)
# I have not got the above to work so here it is explicitly:
targets_$(d) = $(d)/static/js/entry-nav.js
# depend_$(d) = $(top_$(d):.jsx=.d)


# Add to variables used in toplevel Rules.mk

TARGETS := $(TARGETS) $(targets_$(d))
CLEAN := $(CLEAN) $(targets_$(d))
# REALCLEAN := $(REALCLEAN) $(depend_$(d))
# DEPEND := $(DEPEND) $(depend_$(d))


# Generic rules

$(d)/static/js/%.js: $(d)/components/%.js
	cp -p $< $@


# Pop this dir off the stack

d := $(dirstack_$(sp))
sp := $(basename $(sp))


