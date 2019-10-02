Title: Ancient albums
Date: 2019-10-01
Topics: meta photos

I have updated the style sheets for my [Ancient Photo Albums][]
because [Jeremy linked to them][] and I realized they had an old-timey non-responsive stylesheet.

This was a chance to use a few CSS techniques I don’t get to play with in the day job:

- CSS Grid
- CSS variables
- Dark mode
- Obviously


# CSS grid

Difficult to say much about this other than using Grid to create a layout that
is little more than a grid of photos seems very obvious.

I took the opportunity to strip out the JavaScript code that was used to tweak
the layout.

There is a little bit of flexbox in places but overall I have not bothered
with pre-Grid techniques. (Sorry if you are trying to see the layout on
IE11&minus;)


# CSS variables and Dark mode

This uses [CSS variables][] and a new `@media` test [prefers-color-scheme][]:

    :root {
        --paper: #CCC;
        --ink: rgba(0, 0, 0, 0.8);
        …

        background-color: var(--paper);
        color: var(--ink);
    }

    @media (prefers-color-scheme: dark) {
        :root {
            --paper: #333;
            --ink: rgba(255, 255, 255, 0.9);
            …
        }
    }

Possibly the most trivial use of both these features possible. On browsers
supporting dark mode, a light-on-dark scheme will be used in preference to the
default one. On older browsers they have no effect.


# Obviously

I used a typeface family called [Obviously][] from [OH no Type Company][]
because I like it and it gave ma a chance to use some wide and narrow type
mixed up together.

I got this family for cheap by supporting it early in its development on
[Future Fonts][]. I keep on  buying fonts because I still have nostalgia for
the days when we produced little photocopied whatsits and other actual printed
matter rather than just tweeting at each other all the time. Future Fonts is a
way I can indulge an interest in characterful typefaces without spending much
money.

One gotcha. I originally wrote the CSS fragments for the fonts like this:

    @font-face {
        font-family: "Obviously";
        src: url(Obviously-Wide_Black.woff2) format(woff2);
        font-weight: 800;
    }

Everything worked fine when I tested it in in Safari. I discovered *after* I
had gone live that it fails on Google Chrome and Firefox: unlike the `url(…)`
notation, the `format` function requires a string not a keyword:

    @font-face {
        font-family: "Obviously";
        src: url(Obviously-Wide_Black.woff2) format("woff2");
        font-weight: 800;
    }

Nowadays everyone who is anyone supports [WOFF 2.0][] so no need for the
elaborate list of fallback URLs.


# Old photos

These are old photos of when we were younger and digital cameras were less
capable than they are today (in case it wasn’t obvious: CAPTION96 was in
1996). Hope you enjoy them.



  [Jeremy linked to them]: https://twitter.com/cleanskies/status/1177722274306314245
  [Ancient Photo Albums]: /albums/
  [CSS variables]: https://caniuse.com/#search=css%20variables
  [prefers-color-scheme]: https://caniuse.com/#search=prefers-color-scheme
  [Obviously]: https://www.futurefonts.xyz/ohno/obviously
  [OH no Type Company]: https://ohnotype.co
  [Future Fonts]: https://www.futurefonts.xyz
  [WOFF 2.0]: https://caniuse.com/#search=woff2
