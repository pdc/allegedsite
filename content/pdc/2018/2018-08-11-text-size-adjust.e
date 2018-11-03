Title: iPhone Landscape Zoom Prevent
Date: 2018-08-11
Topics: css html
Link: <https://octodon.social/@pdc/100601703924310915>; rel=syndication

Writing the CSS for a responsive or mobile site and it inexplicably  zooms in
when I turned the phone in to landscape mode. I want it to show more text when
I rotate, not enlarge the text that is already there.


# Yes, This is Mobile

When writing HTML and CSS for mobile layouts you have to include incantations
that tell the browser ‘yes, I know about mobile phones with their tiny
screens’. If you don’t, they make a bunch of changes to your styles that are
intended to make large-screen layouts readable on small screens.

The first thing is the HTML needs to contain

    <meta name="viewport" content="width=device-width, initial-scale=1">

Without this the browser will assume you designed your site with 15&Prime;
1024&times;768-pixel screens in mind, and second-guess the scaling
accordingly.

The second thing is you need to include an incantation in your CSS:

    -webkit-text-size-adjust: 100%;
    -ms-text-size-adjust: 100%;
    text-size-adjust: 100%;

Not to be confused with `font-size-adjust`, the `text-size-adjust` setting
controls an algorithm for enlarging text on small screens on the assumption it
was designed to look good on large screens. A setting of `100%` is equivalent
to setting it to `none`, and indicates you think you know what you are doing
and have taken small screens in to account.

With the default setting of `auto`, my iPhone 5c inflates the text in
landscape mode so that it appears that it has decided to assume a CSS width of
320&thinsp;px, which in turn made me think that they had defined the `meta
viewport` so that `device-width` always means the short dimension of the
screen regardless of orientation, which made me wonder what the heck they were
thinking.

The upshot of this is that the `text-size-adjust` incantation should probably
be part of your mobile-savvy style-sheet boilerplate.


# Google Remembers

If you try to google for this problem then you find a lot of references to an
iOS zoom bug and fixes for it in posts from 2011 or 2012. These refer to a
different problem, but persist and make it hard to find other references of
surprise zooming on orientation change.

Hopefully next time I have this problem and I search for it I will find this
article and not one of the red herrings from 2011.




  [spreadsite.org]: https://spreadsite.org/
