Title: Simplicity versus Flash
Topics: adobe flash apple iphone html javascript
Date: 2007-07-11
Icon: ../icon-64x64.png

Last week I was struggling with Adobe Flash development, wishing that my
recommendation that we drop Flash and spend the programming time on
improving our fall-back HTML+JavaScript version instead had not fallen
on such stony ground. Then on Sunday there was a flurry of articles
speculating that not only is Apple’s iPhone missing an implementation of
Flash, but Apple might not intend to add one---and might even want to
start pushing web developers towards alternatives like HTML+JavaScript.

No Flash for iPhone?
-----

There is no Flash plug-in for iPhone. But will Apple be adding one real
soon now via a software update? The only person who thinks yes is Walt
Mossberg (one of the four reviewers privileged with an advance review
unit). Everyone else writing post-iPhone-day who thinks Apple will is
[citing Mr Mossberg][walt]. Apple has not said anything one way or another.

Reasons for not believing in Flash on iPhone include the following:

- [it is a resource hog and iPhone has no CPU and memory to waste][3];
- [it crashes too much][1];
- [Apple want to avoid dependencies on proprietary plug-ins][4];
- [Apple might prefer people to depend on their own Quartz and Core Animation instead][5]; and
- [Apple’s development guidelines][6] warn explicitly, more than once, against using Flash.


  [1]: http://inessential.com/?comments=1&postid=3432
  [2]: http://www.roughlydrafted.com/RD/RDM.Tech.Q3.07/F793A972-337D-4CBB-AA4A-2F787E6E861E.html "Gone in a Flash: More on Apple’s iPhone Web Plans (RoughlyDrafted.com)"
  [3]: http://www.stuffonfire.com/2007/06/13/iphone-sdk/
  [4]: http://www.roughlydrafted.com/RD/RDM.Tech.Q2.07/879DD82D-5595-4746-BFCE-524BBA7C7A85.html
  [5]: http://daringfireball.net/linked/2007/july#sat-07-rd
  [6]: http://developer.apple.com/iphone/designingcontent.html
  [walt]: http://www.google.com/search?hl=en&client=safari&rls=en-us&q=iPhone+Flash+Walt+Mossberg+&btnG=Search

There is another reason, which is the same as for the SDK issue [I
mentioned last month][prev]: how will the no-mouse GUI work with Flash’s
mouse-oriented interactions? Flash movies that implement menus work by
detecting mouse-down, mouse-move, and mouse-up events, and working out
which part of the picture was clicked on; iPhone has no mouse, and this
means there are no mouse-clicks for your Flash menus or Flash games or
Flash galleries to be controlled by.

  [prev]: 06/13.html

Why You Might Not Want Flash
-----

While it might be that some people find developing a web site in Flash
is easier than in HTML+JavaScript, this only works if you can guarantee
that your viewers will have Flash Player installed (and that it is a
recent enough version). Adobe offer a disturbingly large [Flash
Detection Kit][10], and [Adobe claim 98% of desktops have Player 6 or
later][11]. *BUT* if you do need your fancy user interface to work
*whether or not* your readers have Flash Player installed, you will need
to also develop an HTML+JavaScript alternative to the Flash version, and
even if Flash is easier than HTML+JavaScript, Flash+HTML+JavaScript
certainly is not.

  [10]: http://www.adobe.com/support/flash/detection.html
  [11]: http://www.adobe.com/products/player_census/flashplayer/

My project at work falls in to that trap: we have to provide a no-Flash
alternative to the Flash version, partly in case our customer’s
customers’ IT departments uninstall Flash, and partly because Flash does
not seem to include right-to-left scripts like Hebrew. to do this we
have to have a script on one page to detect Flash and store a flag in a
cookie that we examine on another page, and then through and elaborate
mechanism pass to the plug-in that generates the HTML or Flash code so
that it knows which version of the page to generate. This is a lot of
extra work, and extra complexity (and potential for extra bugs), and we
could avoid it by dropping the Flash version and spend the effort
improving the HTML version instead. As a bonus, we reduce the number of
programming languages you need to know by one, by eliminating
ActionScript.

Is it really possible to produce as slick an interface without Flash?
As a case in point, [Flickr][12] used to display photos and annotations
with Flash. They then replaced that interface with a more sophisticated
HTML+JavaScript version. Apple have also dropped Flash from the [Apple
web site][13]: the fancy, cover-flow-inspired product catalogue uses
JavaScript, not Flash.

  [12]: http://flickr.com/
  [13]: http://www.apple.com/mac/

Web Developers Should Learn JavaScript
-----

Flash developers will be dismayed at the idea of dropping Adobe’s
integrated development environment (IDE) for Flash in favour of editing
HTML and JavaScript with some text editor instead. I, on the other hand,
would gladly never use the Flash IDE ever again. The IDE is a strange
beastie, combining a slightly quirky vector-graphics editor with a
feeble text editor and dysfunctional debugger. I quickly switched to
using [jEdit][] to edit the ActionScript files, of which I needed a fair
number. 

ActionScript is not a very nice language to work in; they have
bolted a JavaScript syntax on to the original version, but it has
surprising gaps in its competence (I was taken aback to discover I could
not used regexes to fix up strings, and it seems to be even more stupid
about implicit type conversions than JavaScript). I  gave up on
the debugger, resorting to the old-fashioned approach of having the
program print lots of messages to tell me how it was getting along.

  [jEdit]: http://jedit.org/

With JavaScript, on the other hand, there is more than one debugger
available: Microsoft Visual Studio .NET 2003 has a perfectly fine
debugger, with breakpoints, inspection of variable values, and all those
other fine things. Firefox has an extension called [Venkman][] which I
have not used myself but which is supposed to be good. It is because
JavaScript is an open standard (unlike Flash) that we have a
multiplicity of good debuggers rather than one bad one. 

Time spent learning to program JavaScript well will help
you wherever you use JavaScript, whereas ActionScript expertise only
profits you if you stick with Flash. You can use JavaScript to extend
Mozilla Firefox and even to write the server side of your web
application if your server supports [Server-side JavaScript][14]. The
[Helma Object Publisher (HOP)][15] in particular offers an interesting
approach to web programming, with JavaScript used from top to bottom.

  [Venkman]: http://developer.mozilla.org/en/docs/Venkman
  [14]: http://en.wikipedia.org/wiki/Server-side_JavaScript
  [15]: http://en.wikipedia.org/wiki/Helma_Object_Publisher

