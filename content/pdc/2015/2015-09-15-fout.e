Title: Web Fonts Suddenly Stopped Working Part II
Topics: webfont css less
Date: 2015-09-15

Including web fonts in web pages should be simple and fun but as [previously
noted][1] there are various gotchas along the way.  One of these is that web
fonts are invisible until downloaded. There are ways around this that depend
on where you get your fonts from.


# The horror of FOUT

Downloadable fonts bring with them the possibility of your text being shown
before the fonts are ready. What happens then?

The old system was that the usual CSS rule would apply. Suppose you had a CSS
definition like the following:

    h1 {
        font-family: 'Alegreya', 'Times New Roman', 'Times', serif;
    }

Then if [Alegreya][] was unavailable and Times New Roman was, then Times would be
used. When Alegreya became available, the formatting engine would reassess the
affected CSS declarations and switch the font. The user would then see text in
Times replaced with text in Alegreya. This jarring change is often referred to
as a flash of unstyled text (FOUT).

For many purposes this will be the best option for the readers of the
site—assuming the content is interesting, then they will want to read it as
soon as possible, and assuming the use of custom fonts adds value then they
will want to see them when available.

The problem is that designers are very attuned to nuances of typography and
FOUT causes them to want to gouge their eyes out. They envy people working
on Macromedia Flash sites, where users patiently watch the page count up to
100 before seeing anything at all.


# End FOUT misery with LOUT

The solution to the designers’ angst was to make web fonts an exception to the
CSS `font-family` stack: they are treated as available unconditionally and blank
space is shown instead of text. The result is a *lack* of unstyled text, or
LOUT.

The problem some users have with making the text on the site invisible is that
it makes it impossible to read—obviously. Looking at many sites on mobile on
3G networks often results in a screen empty except for a few line segments
where invisible links are underlined. Sometimes the text appears after several
seconds, sometimes it remains invisible.

Some older, buggy desktop browsers get so confused by the presence of webfonts
in formats other than the one they expect that they blank out all the text
whether the font is available or not.


# FOUT or LOUT? You Decide!

While the LOUT approach goes some way to reducing the number of designers
gouging their eyes out, it is not pleasing to content snobs like me. There is
a way to customize the appearance of styled fonts using  JavaScript library
[Web Font Loader][2] co-developed by Google and Typekit.

Once set up, this does two things. First, it sets CSS classes on your document
indicating that fonts are being loaded or have been loaded. Second, it fires
JavaScript events. This means you can customize your style sheet to control the
appearance at each stage.

For example, my current experiment uses a mixin definition like this (using
[Less][] syntax):

	.body-fnt() {
	    font-family: "Trebuchet MS", "Helvetica Neue", "Arial", "Helvetica", sans-serif;
	    letter-spacing: 0.002em;

	    .wf-firasans-n4-active & {
	        font-family: "Fira Sans", sans-serif;
	        letter-spacing: inherit;
	    }
	}

This effectively reinstates FOUT in preference to LOUT: at first you see
[Trebuchet MS][], but once the font is loaded the CSS class is added and you
see Fira Sans. The letter-spacing tweak is an attempt to make the metrics a
close enough match that the page does not shuffle around too much. 

Some people have advocated hybrid solutions, with the text remaining blank for
a short period of time waiting for the font to arrive, and then if it does not
falling back on the system fonts. When the web font does become available it
might be suppressed on the grounds that once the reader has seen the page in
the fallback fonts they cannot be allowed to be exposed to a belated FOUT.
Either way, to achieve these effects you would need to write a few lines of
JavaScript exploiting events fired by the font-loading library.


# What Happens Next?

It seems inevitable that now there is a JavaScript-based solution to a styling
problem there will surely be special features added to a future iteration of
CSS to make all that work redundant. Watch this space!


  [1]: ../2014/12/27.html
  [2]: https://github.com/typekit/webfontloader
  [Less]: http://lesscss.org/
  [alegreya]: http://www.huertatipografica.com/en/fonts/alegreya-ht-pro
  [Trebuchet MS]: http://www.microsoft.com/typography/fonts/family.aspx?FID=2