Title: Microsoft’s ‘X-UA-Compatible’ Rethought in the Style of HTTP
Date: 2008-02-29
Topics: microsoft rfc2616 http conventions wilderness stupid 
Icon: ../icon-64x64.png

There is some controversy over the [proposal by the Microsoft Internet Explorer 8][1] team to support a new header `X-UA-Compatible` in IE8. Leaving aside the argument as to whether this header should exist at all, there is the question of whether anyone at Microsoft has read [RFC 2616][2] (the HTTP 1.1 specification) and spent as much as five minutes considering how to make their header fit in to the established conventions.

Proposed syntax
---------------

The proposal is for a header line this:

    X-UA-Compatible: IE=7; FF=3

Meaning, ‘render this page in the style of either Microsoft IE version 7 or Firefox version
3’. A hypothetical future browser would use backward-compatibility code to try to emulate
the bugs of IE7.

Header Name
-----------

If the header does not mention `IE=8` does that mean it is known to not be compatible with IE8, or simply that it has not been tested? What can we infer form the omission of `Opera/9` and `Lynx/4` from the list? The problem here is that the use of ‘compatibility’ in the name, which suggests it is in some sense a definitive list of compatible browsers—which is impossible because future browsers might also be compatible. What it does list is browsers the page has (presumably) been tested with.

It is also a problem because ‘compatibility’ can mean a lot of things. For web pages, the
thing they are worried about is that the appearance of some web pages may change, which is
at the mild end of what ‘incompatibility’ might mean.

For these reasons, I suggest that `X-Tested-In` is a clearer and more future-proof field
name for this header. It tells us what testers know as fact: it has been tested in the
named user agents, and works well enough that the testers thought it was OK.

Version identifiers
-------------------

The proposed syntax uses `IE=7` to represent IE version 7. But there is already a syntax for specifying user agents: *product tokens*, defined in [RFC 2616, §3.8][3]. They look like this: `MSIE/7`, `MSIE/5.5`. 

The full syntax for identifying agents allows the use of parameters following the token, separated by semicolons, as in 

    MSIE/7; ColorDepth=16; ScreenWidth=1024

This may be useful for distinguishing variations on user agents that differ by some configuration other than version number.

Commas, not semicolons
----------------------

The next problem is that they propose to use semicolons to separate items in a list. RFC 2616 uses commas to separate repeatable items in headers. It also has special rules for combining same-named headers with commas. For example,

    X-Tested-In: MSIE/7
    X-Tested-In: Mozilla/6

is equivalent to

    X-Tested-In: MSIE/7, Mozilla/6

thanks to the miracle of splicing. This means that using semicolons instead is dumb.

Default behaviour
-----------------

Web browsers other than IE will probably prefer to ignore this header altogether, and stick
to doing their best to support standards.

They might want to allow

    X-Tested-In: MSIE/6; mode=quirks

to be used to switch on quirks mode explicitly.

Microsoft could take the absence of a `X-Tested-In` header to mean that they infer that the pages are best viewed in MSIE/7 if they wish, but I imagine other browsers will not.

Conclusion
----------

Not only is Microsoft’s proposed header debatable in its long-term usefulness, they could
not even be bothered to design it to fit in with HTTP’s long-established conventions for
header syntax. Lame.


Updated (2008-03-31)
-----

The first version of this note was based on my erroneous memory that the field name was `X-UI-Compatible`, whereas it was in fact `X-UA-Compatible` which is about 5% less lame, but still excessively lame.

  [1]: http://alistapart.com/articles/beyondDOCTYPE
  [2]: http://tools.ietf.org/html/rfc2616
  [3]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.8