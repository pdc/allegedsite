Title: Why my Web Fonts Suddenly Stopped Working
Date: 2014-12-27
Topics: css webfont cors

New versions of briwsers have cone out that extend the `Access-Control-Allow-Origin` header to control access to fonts as well as to JavaScript files. This means that on all my sites—personal and professional—that use webfonts, they have reverted to using already-available fonts, with ugly results.

To check that this is what is causing your site to lose its custom fonts, activate the developer tools on your browser. On Chrome the console is full of messages like this:

> Font from origin 'http://static.alleged.org.uk' has been blocked from loading by Cross-Origin Resource Sharing policy: No 'Access-Control-Allow-Origin' header is present on the requested resource. Origin 'http://alleged.org.uk' is therefore not allowed access.

To make this worse, it is a problem that only manifests when deployed to the production server (or your staging server, if you have one). While I am developing the site my local, development server serves static files itself rather than linking to files on a  a separate server (through the magic of [Django’s `static` template-tag][1]).


## What is Cross-Origin Resource Sharing for?

Cross-Origin Resource Sharing is a workaround for part of the
**Same-Origin Policy**, which in turn is a security feature that restricts access to
the content of a web page to JavaScript code that comes from the same server
(identified by its _origin_: the combination of scheme, domain name and port
number).  This means that if your site has ads and the ads are served from a
separate company’s server, and they contain JavaScript code, then code introduced
with the ad cannot read information from the page and report it back to the
advertisers.  It also defeats certain kinds of nasty malware propagated
through JavaScript concealed in content in some clever way.

Seen from the point of view of the server serving the JavaScript, the same-origin policy also works to prevent JavaScript from being accessed by sites other than those on the same origin—this might be important if the JavaScript resource is some kind of internal API exposed as executable code.

For those occasions when accessing JavaScript from another origin is safe, the
CORS conventions can instruct the browser to relax the restrictions. This
works to protect the external server from being used by pages other than those
intended, by adding an `Access-Control-Allow-Origin` header. The browser should then reject dynamically loaded JavaScript not including that header, or quoting a different origin.

It does not apply to the other side of the equation, protecting your browser from dynamically loading JavaScript that does bad things. For that there is an entirely separate [Content Security Policy][2] proposal.


## What has this got to do with fonts?

I seem to have talked a lot about JavaScript rather then fonts. Why should a
security mechanism designed to stop the propagation of malware in JavaScript
prevent my using custom fonts on my site?

The answer is that at some point it was decided that fonts should be inclded in the single-origin policy. I have not been able to find the official rationale, but candidate rationalizations would be the following:

- some font formats are technically executable code;

- font formats contain lots of internal parameters affecting resources used in rendering the font, and up until downloadable fonts became a reality font parsers could confidently assume they were reasonable (since no-one would sell fonts that crashed people’s Macs), so insufficient checks were included in font-handling code—which makes them potential vectors for viruses; and

- copyright holders would prefer that font resources not be exploitable by people who have not paid for a licence for that font.

The last of these is the only one for which CORS and `Access-Control-Allow-
Origin` actually makes sense, though it seems to be extending ‘security’ to
include the prevention of unauthorized copying—which might or might not be a
good idea. Many owners of widly distributed images would love to have similar
control over which web sites are allowed to show a given image resource—but if
single-origin and CORS conventions were extended to images then 99% of
websites would be horribly disfigured, so no-one does that. This practicality
means font publishers get a privilege denied to professional photographers and
artists.

The upshot of this was that a lot of sites suddenly ‘lost’ their fonts, and no
doubt a lot of web programmers got their heads bitten off by their bosses for
allowing the formatting of a deployed site to change unexpectedly overnight.


## What is the fix?

The solution is of course to read all of the [W3C Recommendation CORS][3] (warning: violently horrible use of coloured typography) and parts of [RFC 6454: The Web Origin Concept][4], digest it all and eventually deduce that what you need to do to restore the previous status quo is add the following header to your fonts’ HTTP responses:

    Access-Control-Allow-Origin: *

If you prefer to exploit the new power to prevent people using fonts served by
your server on their pages, and like the idea of spending an afternoon
debugging the site, you could try instead using something like this:

    Access-Control-Allow-Origin: http://alleged.org.uk

The recommendation and RFC do not tell you what you shoukld do if you have
more than one origin; the usual convention is to repeat the header or to
repeat values, separated by commas, but on the other hand the RFC suggests
space-separated values, whereas on the third hand the W3C recommendation says
this probably does not work. Instead your serve needs to echo back the
`Origin` header of the request (assuming it is on the access list). This makes
it seem to me that this was not particularly well thought through, but what do
I know?

How do you add this header? This depends on how you are serving your fonts.
If you have your own server it is relatively straightforward; for example, with Nginx some variation on this will do the trick:

    add_header Access-Control-Allow-Origin *;

This assumes that `Access-Control-Allow-Origin` is harmless when it is not
required. The alternative might be to try to trigger the header based on the
presence of an `Origin` header:

    if ($http_origin ~* (https?://[^/]*\.alleged\.org\.uk(:[0-9]+)?)$) {
        add_header 'Access-Control-Allow-Origin' "$http_origin";
    }

The problem here is that the `if` directive in Nginx is confusingly not
evaluated at thhe same time as the rest of the config and this is confusing to
get right. If you want to actually exploit the new features then the [Enable
CORS][6] site has a [more elaborate sample config][5].

But what if you are using Amazon S3 as the backing storage for a
<abbrev title="Content-Delivery Network">CDN</abbrev>? You don’t get to just set the
header—that would be too easy. You need instead to read through Amazon’s
documentation labyrinth and after digesting it all work out that someting like
the following XML incantation needs to be installed as a CORS policy on the
relevant bucket:

    <?xml version="1.0" encoding="UTF-8"?>
    <CORSConfiguration>
        <CORSRule>
            <AllowedOrigin>*</AllowedOrigin>
            <AllowedMethod>GET</AllowedMethod>
            <MaxAgeSeconds>3000</MaxAgeSeconds>
            <AllowedHeader>Content-*</AllowedHeader>
            <AllowedHeader>Host</AllowedHeader>
        </CORSRule>
    </CORSConfiguration>

I say ‘something like this’ because I just stopped when I got it just about
working, and it is possible there are some fields in this document that could
be omitted to simplify it.




  [1]: https://docs.djangoproject.com/en/1.6/ref/contrib/staticfiles/
  [2]: http://en.wikipedia.org/wiki/Content_Security_Policy
  [3]: http://www.w3.org/TR/cors/
  [4]: http://tools.ietf.org/html/rfc6454
  [5]: http://enable-cors.org/server_nginx.html
  [6]: http://enable-cors.org/