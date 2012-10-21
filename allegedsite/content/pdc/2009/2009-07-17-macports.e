Title: The hilarity of MacPorts
Topics: macports macosx
Date: 2009-07-17
Image: macports-logo-top.png
Href: http://www.macports.org/

One day I decided I wanted to try installing [RabbitMQ][] on my iMac. The most straightforward way seemed to be to use [MacPorts][]. I had not actually tried MacPorts before this week, so it was interesting to see how it worked out.

MacPorts an the equivalent of the [APT][] system in [Debian GNU/Linux][] (there is at least one other, [Fink][]). It has a list of packages, and when you give it commands like

	port install python26

it downloads the package and installs it. Like APT it does dependency-checking: if the `python26` package needs the `gettext` package installed to work, then it downloads that and installs it first, and so on recursively.

It is different from my experiences with Debian in two ways. First, it downloads source packages and builds them itself—which is slightly surprising given how Mac hardware is relatively constrained compared with the plethora of platforms supported by binary packages on Debian. 

Second, whereas Debian packages have been sliced and diced quite enthusiastically, after several attempts to subdivide packages without causing needless confusion, MacPorts seems to have settled on instead making packages install the same complete set of components you would get building it by hand. Thus Python includes IDLE, and IDLE requires Tk, and Tk requires the X11 client libraries, which means that installing Python 2.6 on my PowerBook 12" took an afternoon as it downloaded and compiled a sizeable fraction of the X window system!

<div class="wide">
	<a href="http://www.alleged.org.uk/pdc/2009/macports.png""><img src="http://www.alleged.org.uk/pdc/2009/macports.png" width="526" alt="(diagram)" /></a>
</div>

So far this has been amusing rather than actually any sort of problem. It’s like being some mighty potentate, who expresses a vague desire for a strawberry only to have his faithful servant travel to distant lands at fabulous expense and return weeks later with a strawberry packed in ice acquired on a side journey to the frozen north. You feel a little embarrassed but it is easier to let him get on with it than countermand the order.

The one thing that MacPorts depends on but does not install is [Xcode][], Apple’s own development environment, which includes GCC and the like. So it was that when I intoned the incantation

	port install erlang

it chugged away  for a longish time before suddenly complaining

    On Mac OS X 10.5, tiff 3.8.2 requires Xcode 3.1 
    or later but you have Xcode 3.0.

It seems that some sequence of dependencies from the Erlang programming language leads tortuously to TIFF. 

After downloading a fresher Xcode install (a 900 MB download, mind you) I finally have Erlang ready to compile the RabbitMQ server—I hope.

  [RabbitMQ]: http://www.rabbitmq.com/
  [MacPorts]: http://www.macports.org/
  [Debian GNU/Linux]: http://debian.org/
  [APT]: http://www.debian.org/doc/manuals/apt-howto/
  [Xcode]: http://developer.apple.com/TOOLS/Xcode/
  [Fink]: http://www.finkproject.org/