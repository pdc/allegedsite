Title: Another SVG Roadblock
Topics: svg firefox
Date: 20060413
Image: ../icon-64x64.png

It is about ten years now since the need was recognized for a standard vector-graphics
language for the web; about five since [Mozilla rejected Adobe's
offer of a free plug-in][1]; a couple of years since they identified
SVG support as a key differentiator between Mozilla and Microsoft
Internet Explorer---and every time I try to use SVG in a web page, I
discover a new, show-stopping bug.

This time I was starting on a litttle presentation using Eric Meyer's
[S5][] package. I want to include a diagram; ideally it will be
stretched according to the resolution of the screen I am displaying the
slide on. It follows that I want to use SVG. Should be simple, right? A
few boxes and arrows, and some text to explain what the boxes mean. So
can I display this in Firefox? Sadly, no.

I created a test document that displays the SVG on its own, and the text is
visible.  When I display the same graphic using the same `embed` element in
the S5 slideshow,  the text is invisible.

If I change the text to have a coloured outline, then the outline
appears but not the fill: I end up with hollow text for my labels, which
looks stupid.

I haved tried looking for this bug on [Bugzilla][], but the dementia of
their search interface makes it hard to search for anything specific. I
get either 'zarroo' matches or a billion. Too bad they can't just let
Google scan all the juicy text in their bug reports and supply a search
service that works a bit, but must instead roll their own.

I could try reporting the bug myself. Probably I should. But it would be
a lot of bother---I need to try to whittle down the test case, and so
on, and even then they would complain that I have not downloaded and
compiled the latest bleeding-edge development version of Firefox first.
Given that I have no expectation that anything will be done to rectify
the situation (there are no plans for any changes to the SVG component
before 2007), I do not feel strongly motivated to make the effort.
Besides which, I did not sit down intending to spend the evening
debugging; if I wanted to do that, I could have stayed in the office.

**Updated to add:** I have installed Adobe's SVG plug-in, and I can display the
slides with SVG in Safari. the only problem is that safart does not seem to
support using mouse-clicks on the slides to advance to the next: I need to click
on the >> button. Camino does the same as Firefox.  

I installed Opera 8.54 to see it it does any better; it displays the SVG fine
and---being the original inspiration for S5---it can display the slide-show
full-screen, something that makes it unique amongst the browsers I have tried on
the Mac.  It also works well with the remote-control applet in my K700i phone: I
can control the slides using my phone via Bluetooth, which would be very swank
should I ever need to present to a client (a distant prospect).

  [1]: https://bugzilla.mozilla.org/show_bug.cgi?id=115528#c14
  [S5]: http://www.meyerweb.com/eric/tools/s5/
  [Bugzilla]: https://bugzilla.mozilla.org/

