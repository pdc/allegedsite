# This makefile creates a single depenency graph
# based on Makefile fragments in subdirs
# instead of using a recursive invocation of the `make` command.
#
# For this to work the subdir makefile fragments follow
# a few stylized conventions to maintain a stack of current
# subdirs.
#
# Idea stolen from <http://evbergen.home.xs4all.nl/nonrecursive-make.html>

# Define compilers here

LESSC=lessc
LESSFLAGS=--no-color --strict-math=on --clean-css
# Do not use -v as it breaks the .d file!

BABEL = babel
BABELFLAGS = --source-map inline

PIPCOMPILE=pip-compile


# Now build up the dependency graph

include Rules.mk


# Generic rules


.SUFFIXES: .less .css .js .jsx

# Generic rules

.less.css:
	$(LESSC) $(LESSFLAGS) -M $< $@ > $*.d.next && mv $*.d.next $*.d

.jsx.js:
	$(BABEL) $(BABELFLAGS) $< > $@
