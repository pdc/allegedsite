Title: Keyboard Project: Plated
Date: 2017-04-13
Topics: keyboard making

I have been making a hand-wired computer keyboard and now is as good a time as any for a status update.


# Plate

[Previously in this saga][prev] I had created software for drawing the plans for
the top plate. In order to calibrate the process I added a way for it to
generate a test piece with several switch holes, each slightly different in
size. Nonsensically enough I neglected to bring a copy of the files with me to
the [Hackspace][]. Instead I had to borrow their Windows-10-powered CAD
machine and install [Microsoft Visual Studio Code][], [GitHub Desktop][], and
[Python][] so I could run the program there and then.

<div class="image-full-width-plus">
    <img src="x1-test-plate-1-640w.jpeg" srcset="x1-test-plate-1-1280w.jpeg 1280w"
        width="640" height="360" alt="(photo)">
    <img src="x1-test-plate-640w.jpeg" srcset="x1-test-plate-1280w.jpeg 1280w"
        width="640" height="185" alt="(photo)">
</div>

Having cut the tester, I measured it every way I could think of with a
friend’s [vernier calipers][2] to calculate the kerf value for this cutter,
and the desired size of the holes. I fed these tweaks back in to the script
and generated drawings for the plate and under-plate proper. Some trepidation
as I committed my acrylic sheets to the laser.

<div class="image-full-width-plus">
    <img src="x1-two-plates-640w.jpeg" srcset="x1-two-plates-1280w.jpeg 1280w"
        width="640" height="360" alt="(photo)">
</div>

As it turns out there was one problem with the design: while I allowed
0·75&thinsp;mm in the under-plate for the clips of the stabilizers, they
actually needed a little more. As a result the two layers were forced a little
apart by the stabilizer clips. I addressed this with a little  filing. Luckily
it is in a place that should not show in the finished keyboard, because the
transparency of the acrylic makes the filed sections look messy.

Another issue was differences in tolerances between the acrylic sheet I
wanted the switches to clip in to and the tolerances of the clips themselves:
the acrylic is nominally 1·5&thinsp;mm but I measure it as almost
1·6&thinsp;mm. Now this *is* in tolerance for its intended use but might be
the reason why my switches do not clip in as firmly as I would have liked.


<div class="image-full-width-plus">
    <img src="x1-with-switches-640w.jpeg" srcset="x1-with-switches-1280w.jpeg 1280w"
        width="640" height="257" alt="(photo)">
</div>


Plan is to wire it up as tightly as I can and then see whether it needs a spot of glue as well.

There are more photos in my [Keyboard Plate album on Flickr][].


# Next

The next step is [wiring up the matrix circuit][next].


  [Keyboard Plate album on Flickr]: https://www.flickr.com/photos/pdc/albums/72157680961344360
  [prev]: 02/26.html
  [2]: https://en.wikipedia.org/wiki/Vernier_scale
  [next]: 04/17.html
  [Hackspace]: https://oxhack.org
  [Microsoft Visual Studio Code]: https://code.visualstudio.com
  [GitHub Desktop]: https://desktop.github.com
  [Python]: https://www.python.org
  [Hobbytronics]: https://www.hobbytronics.co.uk
  [3]: https://deskthority.net/workshop-f7/brownfox-step-by-step-t6050.html
  [4]: http://imgur.com/a/qcgdF
