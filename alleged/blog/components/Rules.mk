# This file is included by the top-level Makefile

# Maintain a stack of directory names. In this file $(d) is the current directory.

sp := $(sp).x
dirstack_$(sp) := $(d)
d := $(dir)


# Any subdirs would go here


# Local variables include the subdir in their name

top_$(d) = $(d)/entry-page.jsx
targets_$(d) = ${top_$(d):-page.js=.js}
# depend_$(d) = $(top_$(d):.jsx=.d)


# Add to variables used in toplevel Rules.mk

TARGETS := $(TARGETS) $(targets_$(d))
CLEAN := $(CLEAN) $(targets_$(d))
# REALCLEAN := $(REALCLEAN) $(depend_$(d))
# DEPEND := $(DEPEND) $(depend_$(d))




# Pop this dir off the stack

d := $(dirstack_$(sp))
sp := $(basename $(sp))





