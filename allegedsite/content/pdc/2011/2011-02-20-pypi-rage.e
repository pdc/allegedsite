Title: How to Package my Python Project for PyPI?
Date: 2011-02-20
Topics: python
Image: ../icon-64x64.png

I have a [small Python project][1] and would like to make it easy for
people to download and install it. Ideally it would be on the [Python
Package Index][2] PyPI (because [if it isn’t on PyPI it does not
exist][8]) with the proper dependency information to allow it to be
installed with commands like [Pip][3]. So what do I do?

Where we are
============

So far as I understand it, the current situation is that Python’s
built-in module [Distutils][4] has been superseded by [Setuptools][4]
and `easy_install`, which has been forked to make [Distribute][5], which
will be replaced by [Distutils2][6].

One consequence of this is that the documentation for Distribute is not
finished, and [will not be][7]: development energy is concentrated on
its future replacement. What they have is an introduction stating that
Distribute is a fork and outlining some of its unique features, and a
reference to a copy of the Setuptools documentation which has ben
partially search-and-replaced with the new project name. This means that
none of this document can be trusted, since the reader cannot tell which
bits have been left as ‘setuptools’ because the old name is used for
backward compatibility, and which bits have been left unchanged by
mistake. There are whole sections describing features not supported by
Distribute.

The Setuptools documentation itself was not  self-contained: it starts
with a long discussion of features it has distinguishing it from the old
Distutils, and then describes its API in terms of the Distutils API. As
a result you need to already know Distutils inside-out to understand the
Setuptools documentation—including the parts of Distutils that
Setuptools boasts of having rendered obsolete.

The upshot of this is I started writing an installer one weekend and
gave up after several hours that might better have been spent on
developing the module itself.

OK, enough of the mess we are in. What would I like to see?

Where We Need To Be
===================

First, something somewhere which says definitively which packaging
system is the correct one to use, or at least offers an algorithm for
choosing one.

Second, instructions that tell you how to package your software,
as opposed to what features the packaging software has. I do not care
about the latter, and I want to spend a minimum amount of time on the
former. Essentially after a minimum of introduction I would like to see
a table of contents along the lines of:

- Create a basic `setup.py`
- Add list of modules
- Add list of scripts
- If your package includes extensions, add building instructions
- If your package fits in to a larger namespace, add namespace definitions
- Add metadata for the Packaging Index
- Test installation in a virtualenv
- Upload to PyPI

These would be links to instructions for doing each step. See how the
more complex features are guarded by an ‘if’ that lets most people
ignore the link without further reading. The aim is to allow simple
packages to be packaged up in less than an hour, including reading the
documentation.

Third, systems in place so that RPMs, DEBs, YUMs, etc., can be
automatically generated from PyPI metadata. I think this is something
the Distutils2 effort is intending to address. The ideal here would be
that once I have properly set up my `setup.py`, people using these
systems will be able to install it using their usual installer without
further work being required.

Future
=====

I want to use my package in a Django site, and this will be easier by
far if I can get my module in to Pip’s requirements file. So I plan to
have another go at getting a Distribute-based installer done. If I
succeed I will try to write a basic HOWTO for future reference.

  [1]: https://github.com/pdc/minecraft-texture-maker
  [2]: http://pypi.python.org/pypi
  [3]: http://pip.openplans.org/
  [4]: http://pypi.python.org/pypi/setuptools
  [5]: http://pypi.python.org/pypi/distribute
  [6]: https://bitbucket.org/tarek/distutils2/src/tip/docs/design/wiki.rst
  [7]: https://bitbucket.org/tarek/distribute/issue/144/documentation-is-confusing
  [8]: http://blog.wearpants.org/elitism-and-the-importance-of-pypi