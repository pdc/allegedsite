Title: iPhone, Leopard and Developer Expectations
Date: 2007-06-13
Icon: ../icon-64x64.png
Topics: apple iphone 

After [the keynote speech for WWDC][2], there is a lot of [kvetching][1]
about Steve Jobs’s announcement that the only way to develop apps for
the iPhone right now is as web applications, not to mention the features
announced for Mac OS X 10.5 Leopard are not exciting enough and there
are no exotic new Macs on display. Maybe if people concentrated more on
liking what they’re given they’d feel happier in general.

Leopard will be Fun
-----

<div class="wide_photo_right">
<a href="http://www.flickr.com/photos/pleeker/130658490/" title="Amur Leopard on Flickr"><img src="http://farm1.static.flickr.com/55/130658490_ff5ba4ffea_m.jpg" width="240" height="135" align="right"><br /><small>Photo by Matt McGee</small></a></div>

The next version of Mac OS has new desktop---which boils down to some
translucency effects and a new UI called [Stacks][]. When I saw the
icons spring gracefully out of the dock I knew I wanted Leopard, just
like when I first saw the [Exposé][] effect. The use of animation is not
just pretty, it also helps you make sense of what is going on, which
makes the feature easier to use. And, also like Exposé, it helps you
navigate around a desktop cluttered with all those extra applications
and files we couldn’t have fitted on our computer twenty years ago.
Stacks also replace the much-missed [pop-up windows][] of Mac OS 9, and
the use of the Apple menu to open applications.

No-one even bothered to mention that it casually uses rotated icons and
text to achieve that graceful arc.

A lot of the other things Mr Jobs was demonstrating were for sifting
through your heaps of media looking for just the right photo or for that
brochure you were thinking about: [Quick Look][], the Cover-Flow
effect in [Finder][], extending Spotlight to searching your local
network, and so on. In the keynote, he talks about Macs almost entirely
in a home setting, slotting invisibly in to everyday tasks like creating
home movies for Grandma or choosing your daughter’s college; he leaves
discussion of professional Mac users like designers and film makers to
other venues.

The really exciting thing about Leopard is the new facilities it offers
developers, like [Core Animation][], support for easier parallelism
(vital to properly exploit [multi-core processors][]), and other things
that have not been properly announced yet. And that’s how it should be:
the real worth of an operating system is the programs you can run on it.
And Leopard is adding enough magic for developers that many applications
plan to make their next version [Leopard-only][], a proposition that
sounds sufficiently risky that Mr Jobs made a point of mentioning that
most Mac owners actually run the most recent software. This is helped by
the fact that Mac OS X runs fine on quite elderly hardware, so more
people buy OS X upgrades than you might think.

In some ways this makes the postponement of the release of Leopard to
October seem quite sensible from the marketing point of view,
surprisingly enough: if the launch is going to be accompanied by a
flurry of releases of new Leopard-only software, it will make for quite
a buzz, nicely filling in the gap between the June launch of the iPhone
and the build-up to the December gift-buying season.

iPhone Has Not Even Started Yet
-----

For a gadget you can’t even buy yet, iPhone causes a lot of angst in the
bloggy-developery world. Since their original announcement of the
iPhone, Apple have maintained that they cannot allow third-party
programs to be installed on it without undermining the reliability and
robustness that a phone needs. At WWDC they relented a little,
announcing that there will be APIs for JavaScript in web pages displayed
on iPhone’s Safari application to access phone functions like making
calls and the map application.

<div class="small_photo_left">
<a href="http://www.flickr.com/photos/naufragio/541523566/" title="Asheesh in phone booth on Flickr"><img src="http://farm2.static.flickr.com/1127/541523566_9cf3559cfa_m.jpg" width="180" height="240"><small>Photo by Naufragio</small></a></div>

This is not to be sniffed at: developing UIs using HTML, JavaScript and
techniques like [Ajax][] is no longer the frustrating bumbling about in
the dark that it used to be; cookies allow for limited quantities of
local storage, and a combination of single-page application design and
caching should even allow for some usefulness even when temporarily
disconnected from the Internet. There is a lot of ‘fine print’ that will
drastically affect how useful this style of application can be.

This also is not the first time someone has suggested using web
techniques like HTML, JavaScript, and images to implement applications.
A lot of Mozilla Firefox is written in JavaScript, using an XML format
called XUL rather than HTML for most of its UI, admittedly; Microsoft
unveiled [HTML Applications][] with Internet Explorer 4 in 1997, then
quietly buried the idea when they realized that encouraging use of Web
techniques would loosen their grip on developers’ hearts and minds (they
still use HTAs themselves to implement installers for things like Visual
Studio). [Adobe AIR][] (née Apollo) is an attempt to do something
similar with added Flash. [Joyent Slingshot][] allows Ruby on Rails
applications to be run off-line like a desktop application. And, of
course, Apple’s desktop widgets are all miniature web applications. I
wonder if [Dashcode][] will be extended with an iPhone simulator.

Of course this is not the same as being allowed to develop and install
Cocoa applications on the iPhone, writing in Objective C++, using Core
Animation, Core Data, and all that jazz, with an icon on the home page
and direct access to the [multi-touch][] gestures. But wait! what’s the
API for multi-touch? Cocoa has APIs for mouse movement and tick boxes
and drop-down menus, and so on—but the iPhone has none of these. With
the iPhone, user interfaces are being reinvented, with very little
directly carried over from conventional mouse-driven GUIs. 
<div class="wide_photo_right">
<a href="http://www.flickr.com/photos/nedrichards/84323979/in/set-1800692/" title="Kovács Telephone on Flickr"><img src="http://farm1.static.flickr.com/42/84323979_5f50e22c35_m.jpg" width="240" height="180"><small>Photo by nedrichards</small></a></div>
How will this
work? How will the description of the user’s touch be described to the
application: a collection of paths representing the movement of the
finger after some processing, or as raw readings of the electric fields,
or what?

I don’t know how a multi-touch class library would be designed. I don’t
think Apple know yet, either. By this I don’t mean to suggest they have
no plans, or no idea of what they are doing; it’s just that developing
simple, elegant, powerful and efficient library interfaces is hard work
and takes a long time. You can’t really write a library until you have
written enough applications to understand which functions can be
usefully shared, and what the common abstractions are. You can’t even
write the applications without creating and discarding a few prototypes
first while you work out the details of how physical events will turn in
to application events, and discover which gestures work well and which
turn out to feel unnatural or turn out to be unsuitable in some other
way. You can’t plan all this in advance of writing the software: a large
part of programming is an exploration of the problem domain, and you
can’t fully understand what you really need the program to do until you
have got it to almost, but not quite, do it.

It seems to me that a sensible plan for the iPhone might look like this:

- iPhone 
- iPhone plus some new applications from Apple
- iPhone plus new applications by partners working closely with Apple
- iPhone plus  third-party applications that are certified by Apple.

During the first couple of iterations, Apple would be bashing away at
library design, refining it and refactoring existing applications to use
it, until it is ready for use by outsiders.

This isn’t just a necessity of engineering, I also think it may turn out to be good for Apple’s style of marketing: after a year to get used to iPhone, you can talk about iPhone plus X.  This parallels the progressive enhancement of the iPod:

- iPod (1000 tunes in your pocket)
- iPod, but with contacts
- iPod, but for Windows too
- iPod, but with photos
- iPod, but smaller
- iPod, but with video
- iPod, but with games

The iPod with video would have been too complicated to describe all in
one go. It isn’t until the public at large have absorbed the concept of
the iPod that they are ready to hear about iPod plus photos. The latest
iPod is less simple than the original, because it has more features; it
is only the familiarity of the basic iPod package that allows them to
sell the more complex version. In the same way, later iPhones will have
more features, possibly including some of those features everyone has
condemned it for lacking, and new features will be introduced one at a
time.

  [1]: http://mjtsai.com/blog/2007/06/13/a-very-sweet-solution/
  [2]: http://daringfireball.net/2007/06/wwdc_2007_keynote "John Gruber, WWDC 2007 Keynote News"
  [Stacks]: http://www.apple.com/macosx/leopard/features/desktop.html
  [Exposé]: http://www.apple.com/macosx/features/expose/
  [pop-up windows]: http://docs.info.apple.com/article.html?artnum=50627
  [Quick Look]: http://www.apple.com/macosx/leopard/features/quicklook.html
  [Finder]: http://www.apple.com/macosx/leopard/features/finder.html
  [Core Animation]: http://www.apple.com/macosx/leopard/technology/coreanimation.html
  [multi-core processors]: http://www.apple.com/macosx/leopard/technology/multicore.html
  [Leopard-only]: http://theocacao.com/document.page/397 "The Reasons for Leopard-Only Apps"
  [Ajax]: http://en.wikipedia.org/wiki/Ajax_(programming) "Ajax (programming)"
  [HTML Applications]: http://msdn2.microsoft.com/en-us/library/ms536496.aspx "Introduction to HTML Applications (HTAs)"
  [Dashcode]: http://www.apple.com/macosx/leopard/developer/dashcode.html
  [Adobe AIR]: http://labs.adobe.com/wiki/index.php/Apollo
  [multi-touch]: http://www.apple.com/iphone/technology/
  [Joyent Slingshot]: http://joyeur.com/2007/03/22/joyent-slingshot