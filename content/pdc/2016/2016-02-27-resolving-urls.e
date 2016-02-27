Title: Directory-ish and file-ish URLs
Topics: json url st-ouses
Date: 2016-02-27

In my [sketch of a RESTful API for St Ouses][1], I used a lot of
relative URLs ending with slashes. This is the style preferred when
there is a database-driven web server generating the content. When
using static files it is more convenient to use URLs ending with
_something_`.json`

Here is an example of a `Cat` entity using ‘file-ish’ URLs:

    {
        "href": "doomshadow.json",
        "aloofness": 72,
        "kits": {
            "href": "doomshadow-kits.json"
            "items": [
                {"href": "../kits/boppinjay.json", name": "Boppinjay"},
                {"href": "../kits/quinto.json", name": "Quinto"},
            ],
            "more": {
                "href": "doomshadow-kits-page2.json"
            }
        }
    }

If the URL this was retrieved from was
`file://path/to/cats/doomshadow.json`, then the URL of the collection
is `file://path/to/cats/doomshadow-kits.json`. This comes from
stripping off everything after the last slash in the original URL and
substituting `doomshadow-kits.json`.

Similarly, the URL of Boppinjay is
`file://path/to/kits/boppinjay.json`: after stripping off
`doomshadow-kits.json` from the collection URL, the `..` means we
drop `cats`, and then we add `kits/boppinjay.json`.

One thing that causes occasional confusion is that the rules for
resolving URLs are similar but not identical to those for resolving
relative file names. When resolving a URLs, the client does not know
whether `cats` is a file or a directory; creating the absolute URL is
entirely a string-manipulation process. This makes it important to
not forget to end URLs with a slash if they are intended to be
‘directory-ish’.

One reason for including a self-link in all entities (e.g., the `href`
attribute on the outermost object in the example) is to make
resolution of interior URLs less ambiguous. We had trouble with a
REST server that had its own ideas about which resources should have
slashes at the end of their URLs and as a convenience to sloppy
clients would redirect from `http://example.com/foo/bar/` to
`http://example.com/foo/bar` if it thought the resource `bar` was
file-ish rather than directory-ish. When interpreting a relative URL
`baz/quux/` found in the entity it returns, should the client start
with the redirected-to URL `http://example.com/foo/bar` (resulting in
`http://example.com/foo/baz/quux/` because `bar` gets stripped)? Or
use the URL it originally requested, resulting in
`http://example.com/foo/bar/baz/quux/`&thinsp;? Including the canonical URL in the entity is intended to insulate us from this confusion.

  [1]: 02/19.html
