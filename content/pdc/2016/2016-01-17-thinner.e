Title: Slimming My Blog Page
Date: 2016-01-17
Topics: css javascript react webfont meta

After reading the text version of a talk by [Maciej Cegłowski][1]
titled [The Web Obesity Epidemic][2] I felt pretty smug because I
thought I had redesigned my blog on reasonably minimal lines. Then I
checked and was chagrined to discover a recent entry page was
1.01&thinsp;MB compared with Maciej Cegłowski’s entire talk weighing
in at slightly less than 1&thinsp;MB. I decided to try to work out
where I went wrong.


What is minimal?
================

My main aim with the visual design is to get the content of the
page—the blog entry, in this case—as near to the top left of the page
as possible, so that my readers (should I have any) don’t waste time
scrolling through junk to read the text.

The technical design of the page matches this: the content of the
page is as early in the HTML of the page as I could manage, given the
list of things that are required go in the `head` element of the
page. Even the top bar with the Alleged Literature logo is later in
the file and positioned at the top with CSS. Without the style sheet,
the page is still in a reasonable reading order, with the article up
front and the navigation and other cruft at the end.

There are only a couple of images builtin to the design—this is
different from the olden days, when in lieu of CSS backgrounds and
gradients it was usual to use  several large backround images to
create the textured background s that were in fashion.

So I thought my blog should be pretty resource-efficient.


What went wrong?
================

The first step in investigating this was to check the Resources tab
of my Browser and click on the Size column a couple of times to find
the largest downloads. Top of the list was `react.js` at
587&thinsp;KB. It seems I forgot to switch from the development file
to the minified version. Swapping to `react.min.js` reduces the total
weight of the page down to 315&thinsp;KB transferred (535&thinsp;KB
uncompressed). This is a lot better but still a largish figure
considering that there is basically a few kilobytes of actual text in
the article. What else am I spending my readers’ bandwidth on?

I used Chrome’s resource page, copied the data transferred numbers in
to a spreadsheet, grouped by category, and got the following figures:

<table>
    <thead><tr><th>Category</th><th>Cost/KB</th></tr></thead>
    <tbody>
        <tr><td>Navigation</td><td class="td-number">77.5</td></tr>
        <tr><td>Fonts</td><td class="td-number">76.5</td></tr>
        <tr><td>Images &amp; style sheet</td><td class="td-number">65.5</td></tr>
        <tr><td>Twitter</td><td class="td-number">43.4</td></tr>
        <tr><td>Flattr</td><td class="td-number">27.0</td></tr>
        <tr><td>Project Wonderful</td><td class="td-number">21.2</td></tr>
        <tr><td>CONTENT</td><td class="td-number">4.5</td></tr>
    </tbody>
</table>

The ‘cost’ figure takes in to account the fact that most
resources are Gzip-compressed in transit. For example the CONTENT
category (the HTML itself) is 14&thinsp;KB uncompressed but costs
4.5&thinsp;KB.


Third-party content
------------------

There are three chunks of JavaScript and imagery that I import from
other sites. I don‘t have much control over how much bandwidth they
consume, except that I can omit them altogether.

[Project Wonderful][3] is the advertising network I use. Project
Wonderful is unusual in that you bid for time in a slot rather than
paying for clicks or impressions—thus eliminating all the stress over
click fraud—and ads are just images, with no option to track users
between sites or any of the other creepy things most advertising
networks facilitate. I should point out I mostly added it to my blog
as an experiment to see how these things work: I don’t get enough
traffic for ads to pay for my server costs, let alone give me an
income.

In the same way I include a [Flattr][4] button less to make serious
money as proof of concept of how a blog might in principle fund
itself ethically and without becoming a grotesque billboard plastered
with ads. The idea with Flattr is the button acts like Facebook’s
Like button, except that it costs a small amount of money rather than
a tiny sliver of your soul. Moreover, with Flattr you decide in
advance how much you want to donate to the arts per month in advance,
so there’s no anxiety about clicking too often.

The Twitter button represents an effort at promoting content by
facilitating the sharing of links. There are third-party
share-o-matics that let you add half a dozen or more social-media
buttons to your pages; I chose to narrow it down to Twitter because
it is the best-known micro-blogging platform that isn’t Facebook.
It’s a pity that Twitter can’t see a future for itself that does not
involve trying to become more like Facebook. It is also a shame that
the simple Tweet button somehow requires almost 44&thinsp;KB to
display. I reckon I could create a button and a link to
<http://twitter.com/share?url=http://alleged.org.uk/pdc/2016/01/05>
in a fraction of that.

Possible actions:

- Remove Twitter, or
- Reduce Twitter to a button + link to its share URL.


Images &amp; style sheet
---------------

This subdivides in to two images and a style sheet, as follows:

<table>
    <thead>
        <tr><th>Resource</th><th>Cost/KB</th></tr>
    </thead>
    <tbody>
        <tr><td><code>byantonia-super-s140.png</code></td><td class="td-number">42.7</td></tr>
        <tr><td><code>bnr2015a-1440x80.jpeg</code></td><td class="td-number">19.4</td></tr>
        <tr><td><code>min.css</code></td><td class="td-number">3.4</td></tr>
    </tbody>
</table>

The embarrassing thing here is that the little portrait image weighs
more than the banner and style sheet combined. There is a reason for
this, but it is a stupid one: it is a PNG rather than a JPEG.

The reason it is a PNG is that I wanted the portrait shape to be
(approximately) a superellipse rather than a square or circle. My
original plan was to achieve this with SVG + JPEG but this came
unstuck as I had trouble getting the clipping and the scaling to work
the way I thought it should. After getting most of the way through an
entry on how SVG was still not working in browsers I realized I had
been misspelling `viewBox` as `viewPort`. So I really need to go back
and do the tests all over again.

Possible actions:

- Try again to get the SVG solution to making the superelliptical
  border to work; or even
- Switch to a design that is easier to realize.


Fonts
-----

Webfonts are an important part of the styling of the site—but often a
controversial one. Most people are not consciously of typefaces used
in print, let alone on screens, so designers’ insistence that a
choice of typeface is vital to making the text look right often
baffles.

The best I can say about my insistence on specifying the fonts is that

1. the 77&thinsp;KB download only needs to happen for the first page
   you visit the site, and will be cached thereafter, and
2. [I have taken steps][4] to ensure the text is readable even before
   the font is downloaded.

I chose [Fira Sans][5] because it is more readable on small screens
than the default Helvetica or Arial. My experiments with serif fonts
for body text convinced me they are still less clear on screens than
sanserif types. Instead I used [Alegreya][6] exclusively to add some
visual interest to headings.

My plan for now is to retain the web fonts. People who would rather
not see fonts can install a content blocker  such as [SansFonts][7].


Navigation
----------

This may the least  justifiable expense on the page (if you allow for
the inclusion of the the advertisement panel as being justified by
its being a proof of concept). How often do readers of a given blog
entry want to navigate through old archived articles? I may be the
only one. In any case, the version without the JavaScript enhancement
was perfectly fine, and for the sort of simple user interface it
uses, React is arguably overkill.

Here is a breakdown of the 77&thinsp;KB:

<table>
  <thead>
    <tr><th>Resource</th><th>Cost/KB</th></tr>
  </thead>
  <tbody>
    <tr><td><code>react.min.js</code></td><td class="td-number">36.2</td></tr>
    <tr><td><code>jquery.min.js</code></td><td class="td-number">29.4</td></tr>
    <tr><td><code>entry-nav.js</code></td><td class="td-number">11.9</td></tr>
  </tbody>
</table>

The last of these is my code for the naviation—including the
templates for laying it out.

The main reason for using jQuery is that its wrappers include code to
work around the different ways you have to acquire the
`XMLHttpRequest` object in different browsers—though that is not an
issue any longer if you don’t mind disappointing users of
antediluvian versions of Internet Explorer.  I could probably replace
it with a simplified Ajax wrapper.

React is harder to remove (short of rewriting the UI from scratch).
In principle it need not be download often as I am using a CDN
version that is shared by other React-based sites. There is a
[React-Lite][8] package that claims to do what React does, minus a few
server-side features, in a smaller download.

Possible actions:

- Revert to using the old, JavaScript-free version;
- See whether React-Lite (a) works and (b) reduces the download size significantly;
- Replace use of jQuery as an Ajax wrapper.


Time to first paint?
===================

There are two reasons to reduce the amount of data downloaded: first,
it reduces the cost to your reader (who is paying for their Internet
access one way or another), and second it makes the page appear
faster.

Google Chrome has an option to artificially throttle network
performance to simulate looking at a page on 2G or 3G networks.
Assuming this is a realistic simulation, it seems  my typical page
gets its first paint event within half a second on 3G or better
networks. Hopefully that’s quick enough for the reader not to have lost interest
before it appears.

Improving on this measure will probably require improvements to
server response time (perhaps adding a CDN would help with that), and
more difficult optimization like moving some of the style code out of
the CSS file and in to the HTML. Reducing the size of the font and
JavaScript downloads is still worthwhile, but they will only
marginally improve the time to first paint.


Plans
====

Overall looking at the my page it could be a lot worse. My plan is to
try those optimizations mentioned above that don’t reduce the
functionality of the page. This way I am seeing how compact a web
page can be while still retaining the features of a commercial text-
based site (like an advertising slot and fancy styling).

After that I can look in to what options there are for slicing up the
style sheet so some of it can be inlined as Google PageSpeed Insights
would have me do. If there is a general tool for doing this I have
not yet found it.


  [1]: http://idlewords.com
  [2]: http://idlewords.com/talks/website_obesity.htm
  [3]: https://www.projectwonderful.com/about.php
  [4]: ../2015/09/15.html
  [5]: http://www.carrois.com/fira-4-1/
  [6]: http://www.huertatipografica.com/en/fonts/alegreya-ht-pro
  [7]: https://github.com/jlnr/SansFonts
  [8]: https://github.com/Lucifier129/react-lite
