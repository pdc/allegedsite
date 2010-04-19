<!-- -*-HTML-*- -->
<entry date="20030609" icon="picky-80x80.png" xmlns="http://www.alleged.org.uk/2003/um" xmlns:dc="http://purl.org/dc/elements/1.1">
  <h>JavaScript image loading problems</h>
  <body>
    <p>
      The image-cycling feature of the 
      <a href="http://caption.org/picky/">Picky Picky Game
      prototype</a> depends on using JavaScript to load images.  If
      you click on the Cycle button before the images have been
      prloaded, then nothing visible happens&mdash;it appears to have
      failed.  There is no way for the user to see whether the images
      have loaded or not.  I have attempted to add such an indication,
      only to be thwarted by what appear to be bugs in the web
      browsers I&nbsp;have tried it on.
    </p>
    <p>
      The theory is as follows.  In JavaScript, you preload an image
      resource by creating an <code>Image</code> object and assigning
      the URL to its <code>src</code> attribute.  So far this is
      fairly uncontroversial.  You can also, allegedly, assign a
      JavaScript function to the <code>onload</code> attribute  of the
      <code>Image</code> object and it will invoke this function when
      the image has finished downloading.  Thus we might have:
    </p>
    <pre>var im  = new Image();
im.ipanel = ipanel; // Used in the onload handler
im.onload = function () { preloadOnload(this.ipanel); }
im.src = inf.src;</pre>
    <p>
      The event handler is, I believe, called in the context of the
      object that triggers it: in this case the <code>Image</code>
      object.  That means that the keyword <code>this</code> refers to
      the <code>Image</code> object.  Using the <code>ipanel</code>
      attribute I&nbsp;added to the image object, it invokes
      <code>preloadOnload</code> with the information it needs.  (The
      name <code>ipanel</code> is an index in to an array of panel
      descriptions.)
    </p>
    <p>
      <img src="loading.gif" alt="" align="right" width="135"
      height="78" />
      Based on the above, we can do the following.  First, replace the
      Cycle buttons in the skin files with an animated image saying
      LOADING.  Second, maintain a
      count, for each panel, of the number of images still to be
      preloaded.  When an image triggers its <code>onload</code>
      event, decrement the counter.  When it reaches zero, replace the
      LOADING... image with the Cycle button.  Voil&agrave;!
    </p>
    <p>
      My first attempt at getting this to work involved yet more
      JavaScript debugging on Safari.   I ended up adding lots of
      <code>alter</code> commands to the event-handling functions,
      none of which got triggered.  I&nbsp;concluded that I&nbsp;had
      been mistake in thinking that <code>onload</code> habdlers
      applied to image objects, and gave up and fixed some other bug.
      Monday morning I checked the Picky Picky Game site and
      discovered to my chagrin that the <code>alerts</code> do
      appear&mdash;in Mozilla Firebird.  As a result many visitors
      were getting weird pop-up messages which made them think the
      whole site was exploding or something.
    </p>
    <p>
      I got home and decided to try out Venkman, the JavaScript
      debugger bundled with Mozilla.  After only moderate pain I made
      some progress, and managed to get the event handlers to be
      called sometimes.  I also managed to get the debugger in to a
      state where it refused to run, or to stop, or something.
      Whatever it was, it was stuck on an old version of the page and
      I could not debug the new version.  After I poked it a few times
      the whole browser crashed.  Nevertheless, once I had restarted
      Mozilla, visiting the pages (sans debugger) seems to work!  The
      LOADING... animation plays below each image, and when they are
      ready the Cycle button replaces it.  Great!
    </p>
    <p>
      Camino&nbsp;0.7, being Gecko-based, also works, once you
      persuade it to refresh its cached copy of the JavaScript.
    </p>
    <p>
      Microsoft Internet Explorer for the Mac version 5.2 seemed to
      respond to the onload handlers at first, but now no longer seems
      to work.  Like Safari, one is left with the LOADING... animation
      playing forever, which obviously is not acceptable.  On the
      other hand, once it had crashed and been restarted, MSIE works
      fine.  Perhaps it was crahsed by reloading the same JavaScript
      file once too many times?  I have also tried it in Microsft
      Internet Explorer for Windows 5.5 and it works.
    </p>
    <p>
      Opera 5.0 on Linux fails the same way as Safari (the onload
      events apparently never being triggered).  On the other hand,
      its cycling looked wrong anyway, since the pictures would not
      resize...
    </p>
    <p>
      Based on this rather spotty success rate I&nbsp;think
      I&nbsp;will upload the modified JavaScript to caption.org so
      I&nbsp;can try it out on a wider variety of browsers than what
      I&nbsp;happen to have at home.    Hope this does not cause too
      much inconvenience...
    </p>
  </body>
  <dc:subject>picky</dc:subject>
  <dc:subject>javascript</dc:subject>
  <dc:subject>safari</dc:subject>
  <dc:subject>msie</dc:subject>
  <dc:subject>camino</dc:subject>
  <dc:subject>mozilla</dc:subject>
  <dc:subject>venkman</dc:subject>
</entry>
