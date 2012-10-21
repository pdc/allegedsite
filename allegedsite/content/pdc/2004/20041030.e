Title: Migrating my website workspace, part 1
Image: ../icon-64x64.png
Date: 20041030
Topics: xml yaml tclhtml elementtree python svg debian

My website is maintained by a rather complex amalgamation of software,
accreted over generations. Having migrated it from my old desktop
`lickity` to my new(ish) PowerBook Ariel, I now want to migrate it
again to my new server Tranq (a [Tranquil PC T2][10]); this will allow me to use `cron` to keep
some parts up-to-date automatically.

So what software do I need to install to do this?

  * [TclHTML][1], my quirky Tcl-based HTML-generating system; I ended up
    using the version from CVS, which suggests I should create a new
    distribution some day. Spent some time trying to infer from the
    tutorial information on [SourceForge][2] what the host name of the CVS
    server is; it has changed since I last needed to connect.
  * CVS, since I had not previously installed it.
  * the [elementtree][3] package for Python, used to generate SVG for the [Flickr][4] icons.
  * The Debian package `python-dev`, because Debian  does not include the
    `distutils` package in their standard Python install (another evening annoyingly spent on Google
    to discover what this package-fragment was called).
  * [PyYaml][5], which I use in the program that downloads things like
    my Flickr badge. 
  * even though [libxml2][6] is already installed, I
    have to install a Debian ackage `xsltproc` to get the `xsltproc` command
    that I have recently started using to generate some 
    recent additions to the site (like the Flickr badge, which is in SVG
    generated from XML cobbled together from the JavaScript code used to
    make the standard Flash-based Flickr badge).
  * Something to render SVG as PNG. This turns out to be something of a
    blocker -- see below.
    
This is as far as I have got since I started earlier this week
(Wednesday).
    
For the love of SVG
-------------------

<a href="http://flickr.org/photos/pdc/"><img src="flickr.png"
width="100" height="50" align="right" alt="" /></a>
[SVG][11] is a standard for vector graphics. It is relatively easy to generate
graphics files -- you can even use a plain old text editor at a pinch --
and there is a fairly detailed spec for how to render them.  I use SVG on
my web site to do a lot of the graphics, including the Flickr icons.
Because web browsers have trouble displaying SVG graphics in the same
way they display PNG, GIF and JPEG, I have been converting them to PNG
using [Batik][7].

Batik requires Java, which is installed as standard on Mac OS X. 
On Tranq, running Debian GNU/Linux things are more complicated.
Debian's package lists three different JVMs with (as usual) no guidance
as to which I might want to install. This is a common problem with
package-based systems: they concentrate more on ensuring that every
possible variation is available than on helping users determine which
packages they actually want. None of the JVM websites can tell me at a
glance whether they implement all of Java (or at least all of it that I
need), and there is a nasty implication that I have to acquire the class
library as a whole separate package (probably several packages). In short, installing all the
prerequisites of Batik looks like a difficult job. What other SVG
renderers are there?  

So far as I can ascertain there are two strands of development of SVG as
conventional Unix programs (written in C or C++ as opposed to Java):
`librsvg2` (used by GNOME) and `libsvg-cairo`, part of [Cairo][9], which is
hosted on [Freedesktop.org][12].  

On Debian it turns out that installing `librsvg2` does not get you the
command-line utilities;
one needs to install an additional `librsvg2-bin`
package to get the program `rsvg`. Having done all this, I have
discovered that `librsvg2` does not
understand HTTP URLs. Since I refer to the images on Flickr's server
directly, it cannot process my Flickr icons.  I need to change my
program that makes the badges to download the image files itself.

The Cairo-based SVG package is not yet part of
Debian proper (although `libcairo` itself is, according to [Debian bug
216196][8]). There is a repository of Debian package files in
<http://cairographics/packages/debian/>, but (not being a Debian wizard
yet) I have not found a way to get APT to exploit them; it expects them
to have a more complicated directory structure.  Maybe I am supposed to
download and install the `.deb` files individually and install them
myself, but that is an adventure for another day: the tinkering time I
had to spare today is exhausted.
    
  
  [1]: http://tclhtml.sourceforge.net/
  [2]: http://sourcefourge.net/
  [3]: http://effbot.org/zone/element-index.htm
  [4]: http://flickr.com/
  [5]: http://www.pyyaml.org/cgi-bin/trac.cgi
  [6]: http://xmlsoft.org/XSLT/
  [7]: http://xml.apache.org/batik/
  [8]: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=216196
  [9]: http://cairographics.org/
  [10]: http://www.tranquilpc.co.uk/Nonflash/T2.htm
  [11]: http://www.w3.org/Graphics/SVG/
  [12]: http://freedesktop.org/
