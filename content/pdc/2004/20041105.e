Title: Death to Java! Death! Death! Death!
Image: ../icon-64x64.png
Date: 20041105
Topics: java python pyana cocoon

At work I keep my work-log and my work plan in one big XML document
(actually one per client, for the sake of limiting the enormity of the
files). This single document is then sliced and diced through various
XSL transforms to create different views: for example, when you look at
the entry for one task, you see all the notes describing that task and
the work I did on it, and when you look at the log for a particular day,
you see the notes for that day regardless of which task they belong to. 

I kept all this organized using <img src="cocoon-logo.gif" width="220" height="51" align="left" alt="" />
[Apache Cocoon][1], a web-application
framework from the Apache project. This was really overkill -- I used
the simplest kind of pipeline, sucking in XML files at one end and
choosing a particular XSLT to render it based on parts of the URL. Installing it was a bit of an
adventure (installing a new version of Java on to my old Windows 2000
machine, copying JAR files around,and so on), but
it worked well enough (except for running our of memory when I tried to
render pages as PDF using [FOP][2]). 

On Thursday, I made a foolish mistake: I decided to upgrade <img src="tomcat.gif" 
width="130" height="92" align="right" alt="" /> [Apache
Jakarta Tomcat][3], the web server that hosts Cocoon. The original
impetus was that I wanted to install [VeryQuickWiki][4], and that was
because I am not content with having specifications passed around as long and unweildy Microsoft Word
documents. VeryQuickWiki is very quick to install, assuming that your
JSP compilations do not fail with a 200-line error message, which is
what happened to me. Google's wisdom suggested reinstalling Tomcat in a
directory whose name does not contain spaces (amateurs!!), and I thought I might as
well switch from version 4.1 to 5.0 while I was at it.

Needless to say the usual shennanigans of installing Java software
ensued. On <img src="debian-openlogo-75.jpg" width="75" height="92" align="left" alt="" /> [Debian GNU/Linux][5], I have been spoiled by APT, where the
most difficult part is often guessing the name of the package; after
that, you type `apt-get install xalan` and lo! Xalan-C++ *and other
packages it depends on* are downloaded, installed, and configured.
Installing on
Microsoft Windows systems is not this slick at the best of times
(you have to do your own downloading, step through interminable wizards,
and so on), and Java adds a whole new level of not-quite-workingness.
(The server is at work and so is running Microsoft Windows.)
Apache tends to assume that people installing Tomcat are Java
enthusiasts with infinite knowlege and patience regarding Java's special
conventions; all I want is software that will make Cocoon and
VeryQuickWiki work. 

So what went wrong? My first attempts at visiting the Tomcat front page
just got 'connection refused' (which translates as, 'the server has
failed to open the listener socket'). Rebooting the server fixed this. I ended up
doing the usual random rearrangements of JAR files (Tomcat has three
places to store JARs, and a lot of places that seem plausible at first),
rebooting the server each time because merely restarting the service did
not work). Eventually I got it to display the Tomcat documentation and
example JSPs. Fine. But when I dropped the Cocoon or VeryQuickWiki WAR files in to its
`webapps` directory, the files were unpacked but something prevented
them from working -- all I got was a strangely terse message saying the
URL was 'unavailable'. I say strangely terse, because I am used to the
more usual Java error messages including a 200-line stack dump. After
wasting a couple more hours fruitlessly tring to work out where in the
configuration files I might be expected to fix this, I gave up.

<a href="http://www.python.org/"><img src="python-powered.gif" width="110" height="44" align="right"
alt="" /></a>
I gave up not because I don't think the problem was solveable, and not
because I don't think that eventually I could have worked it out or got
advice from some Cocoon mailing list. I gave up because I decided that
it would take me less time to *write my own web server from scratch*
than to fix my Tomcat/Cocoon problem. That may seem a
bold claim, but remember two things:

  * I was really using Cocoon to do no more
    than parse the URI, choose one of the XSLT scripts, set some parameters,
    and set it running (all the 'smarts' of the server are in the XML and XSLT), and 

  * [Python][10].


I already know how to throw together a web server in Python using `BaseHTTPServer`: I've
used it as one of the implementations of the [Picky Picky Game][5] (the deployed version
uses CGI instead). The main trick was running the XSLT transforms (something that should
have been absorbed in to the standard Python library long ago). Google found me a Python
wrapper for the <img src="apache-xml-group-logo.gif" width="220" height="65"
align="left" alt="" /> [Apache Xalan-C++ library][8], called [Pyana][7] for some reason.
On Windows, the Pyana installer comes with the required libraries: you just run the
installer and it works. By the end of the afternoon I had sorted out a working
replacement work-log server (with a bug in the formatting of dates, which I will fix
later). The most time-consuming part was rearranging the directory structure of the
source files, since they no longer lived in Cocoon's directory tree (this boiled down to
judiciously adding `../` to various relative URLs).

What are the lessons here (apart from 'Don't write your own work-log
web server in the first place')? First, XSLT makes your formatting more mobile between platforms:
switching from Java to Python
would have been tough had the HTML layouts been mixed in with Java code (or
ASP or PHP for that matter). Second, [Java Sucks for Sysadmins][9].
Third, Python excels at providing simple interfaces to complex
libraries, which makes it possible to write sophisticated applications
in a hurry.


  [1]: http://cocoon.apache.org/
  [2]: http://xml.apache.org/fop/
  [3]: http://jakarta.apache.org/tomcat/
  [4]: http://veryquickwiki.croninsolutions.com/
  [5]: http://www.uk.debian.org/index.eo.html "Libera mastruma sistemo (OS) por komputilo"
  [6]: ../2003/picky.html
  [7]: http://pyana.sourceforge.net/examples/
  [8]: http://xml.apache.org/xalan-c/
  [9]: http://www.panix.com/userdirs/jdw/javasucks.html
  [10]: http://www.python.org/
