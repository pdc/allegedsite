Title: Packaging versus Building from Source on Mac OS X
Date: 2011-01-23
Topics: apple macosx python
Image: ../icon-64x64.png

It took me a weekend but I finally got [Python][] 2.7 + [PIL][] (Python
Imaging Library) working on my old [PowerBook G4][] 12&Prime; (which
runs Mac OS 10.4 Tiger). The problems I was having were partly because
of a mismatch between pre-compiled. and build-from-source packages.

The Problem
===========

The official Python package is pre-built, and to allow it to work on
both PowerPC and x86 processors, it is built with ‘fat’ binaries.

PIL is a Python package that uses an extension module written in C++.
When installed through <s>setuptools</s> <s>easy install</s> pip, it
builds the extension using the same compiler options as were used to
compile Python. This works automatically through Python‘s [sysconfig][]
module. So PIL will try to compile its extension as a fat binary as
well.

The extension depends on two libraries, `libjpeg` (from the [Independent
JPEG Group][IJG]) and `zlib`. I had previously installed `libjpeg` using
[MacPorts][], a port of [FreeBSD Ports][]. MacPorts works by downloading
source code and compiling it locally; it makes sense that it only
compiles it for the CPU of the local machine; it makes sense therefore
that it is *not* a fat-binary library.

As a result, after many minutes of compilation, the installation of PIL
fails with a mysterious error message.

(Note that this is not a problem on my desktop, which runs Mac OS 10.6
Snow Leopard and uses [Homebrew][] for package management.)

One Solution
============

I tried various ways around this. One might have been to use MacPorts to
install Python instead of using the standard package. The problem here
is that my MacPorts installation is broken—each time I try to update or
upgrade it it fails and advises me to try updating it. Another might be
to compile `libjpeg` youself, using [some glibtool hackery][1].

I started by [uninstalling MacPorts][3]. I only want to install a small
number of packages, so I am better off doing without MacPorts rather
than trying to work out what went wrong with it.

What I did instead to get my project ready was this:

Downloaded the JPEG source form the [IJG][] site. Read `install.txt` then
compiled and installed with `prefix=/usr/local`.

[Downloaded Python source][2], unpack, read the installation instructions
and do the following commands (where `$` is standing in for my command
prompt):

    $ ./configure --enable-framework
    $ make
    $ sudo make install

which creates a non-fat-binary version, builds and installs it. This
takes many minutes on my 12&Prime;. Checked this makes the new version
default with

    $ which python

This showeded Python coming from
`/Library/Frameworks/Python.framework/Versions/2.7/bin/python` as
expected.

Downloaded the [Setuptools egg][4] for Python 2.7 (you need Setuptools
to install Virtualenv). Installed it with

    $ sh setuptools-0.6c11-py2.7.egg

Checked this had worked as expected with

    $ which easy_install

And then installed [virtualenv][] and created an environment for my
project (in this case `minecraft-texture-maker`):

    $ easy_install virtualenv
    $ virtualenv --distribute --no-site-packages minecraft-texture-maker
    $ cd minecraft-texture-maker
    $ . bin/activate

Now I was finally ready to install the project requirements:

    (minecraft-texture-maker)$ git clone git@github.com:pdc/minecraft-texture-maker.git
    (minecraft-texture-maker)$ pip install -r minecraft-texture-maker/REQUIREMENTS

This automatically downloads and installs the files in `REQUIREMENTS`
(which was created on my other dev machine using `pip freeze`). After
all this work it is nice to see it spin up the C++ compiler to build the
extension and succeed.

One of those requirements was [Nose][] so I can check all is as expected with

    (minecraft-texture-maker)$ nosetests tests

Moral: Compiling packages from scratch is not as bad as all that.


  [Python]: http://python.org/
  [PIL]: http://www.pythonware.com/products/pil/
  [PowerBook G4]: ../2003/ibookvspbook.html
  [pip]: http://pip.openplans.org/
  [sysconfig]: http://docs.python.org/library/sysconfig.html
  [IJG]: http://www.ijg.org/
  [MacPorts]: http://www.macports.org/
  [FreeBSD Ports]: http://www.freebsd.org/ports/
  [1]: http://www.libgd.org/DOC_INSTALL_OSX#Building_libjpeg
  [2]: http://python.org/download/
  [3]: http://guide.macports.org/chunked/installing.macports.uninstalling.html
  [4]: http://pypi.python.org/pypi/setuptools#downloads
  [virtualenv]: http://virtualenv.openplans.org/
  [Nose]: http://somethingaboutorange.com/mrl/projects/nose/1.0.0/
  [Homebrew]: http://mxcl.github.com/homebrew/