# This file is included by the top-level Makefile

# Maintain a stack of directory names. In this file $(d) is the current directory.

sp := $(sp).x
dirstack_$(sp) := $(d)
d := $(dir)


# Subdirs

dir := $(d)/static/style
include $(dir)/Rules.mk



# Local variables include the subdir in their name

WEBPACK	= ./node_modules/webpack/bin/webpack.js

# This says we want the outputs of components to go in static/js
targets_$(d) = $(d)/webpack.config.WEBPACKRUN
$(d)/webpack.config.WEBPACKRUN: $(d)/components/entry-page.jsx \
	$(d)/components/entry-nav.jsx \
	$(d)/components/entry-store.js \
	$(d)/webpack.config.js


# Add to variables used in toplevel Rules.mk

TARGETS := $(TARGETS) $(targets_$(d))
CLEAN := $(CLEAN) $(targets_$(d))
# REALCLEAN := $(REALCLEAN) $(depend_$(d))
DEPEND := $(DEPEND) $(depend_$(d))


# Generic rules
.SUFFIXES: .WEBPACKRUN

%.WEBPACKRUN: %.js
	P=$$(pwd); cd $(dir $<); $$P/$(WEBPACK) --config $(notdir $<) && date +%Y-%m-%dT%H:%M:%S > $(notdir $@)


# Pop this dir off the stack

d := $(dirstack_$(sp))
sp := $(basename $(sp))


