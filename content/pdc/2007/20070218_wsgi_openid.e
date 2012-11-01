Title: OpenID in a WSGI filter
Topics: wsgi openid python quixotic 
Icon: ../icon-64x64.png
Date: 20070218

With all this [buzz about OpenID][] all of a sudden I have been reminded
of how a while back I was tinkering with a [TurboGears][]-based web game
using [OpenID][] (see parts [1][], [2][], [3][]). Having learned more
about [WSGI][] and [Python Paste][] I am inclined to see how far I can
push the idea of writing web applications using WSGI and a collection of
WSGI filters as my framework.

WSGI and WSGI filters
-----

The WSGI approach uses a Python callable to represent a web
application---or part of one, since WSGI apps can be composed in various
ways to make more complicated apps. An app is a function with a definition
like this:

    def something_app(environ, start_response):
        ...examine environ and process request...
    
        start_response('200 OK', headers)
        return ...content of response...

When the web server receives a request, it puts the information about the
request in `environ`, calls `something_app`, and then uses its return
value and the headers passed to the `start_response` function to issue the
response to the caller.

WSGI is designed to be used as a common interface for web frameworks, but
given that it has to pass the information in `environ` to the application
code in some way, the `environ` dictionary is as good a way as any.
Similarly, your application has to provide the server with status code,
headers, and response data, and the `start_response` callable is as good
away to do that as any. So why not use WSGI as your framework?
Because your application would have to have its own code for decoding query-strings, setting cookies, and so on, which would mean a lot of tedious repeated code.  But we can address this with filters.

A WSGI filter is a (higher-order) function that takes a WSGI app and
returns a new app with slightly modified behaviour. For example, WSGI
supplies your request's query-string but does not break it down in to
parameters. I've created a function `parse_query_string` that does just
that. I can then define a filter as follows:

    def query_string_filter(app):
        def wrapped_app(environ, start_response):
            environ['alleged.query_args'] = parse_query_string(
                    environ.get('QUERY_STRING', ''))
            return app(environ, start_response)
        return wrapped_app

This takes a function---here called `app`---that requires an extra entry
in the `environ` dictionary and makes a working WSGI app.  Python has a special syntax for applying functions to functions this way: you can write

    @query_string_filter
    def my_app(environ, start_response):
        ... code that exploits environ['alleged.query_args'] ...

This use of higher-order functions to simplify writing WSGI apps is called
middleware in the [WSGI][] documentation.

Why does the key start with `alleged.`? Simply to avoid name clashes with
other middleware that also works by adding extra entries to the `environ`
dictionary. The particular prefix I've chosen is taken from Alleged
Literature, our mini-comic publishing imprint from the 1990s. The
`alleged` prefix is also part of the package names for the reusable
filters. I suppose if I ever finished it I could add the Alleged
Microframework to the eleventy-one Python web frameworks. But don't hold
your breath.

Log-in filter
-----

One of the complaints about OpenID is that so far the number of consumers
(web sites that allow you to log in with your OpenID) is much lower than
the number of providers---this is natural, because it is much easier to
bolt an OpenID server on the side of an existing application than to rip
out its custom user database and replace it with one generic enough to
accept OpenIDs as well. The first wave of OpenID consumers will be
applications written with OpenID in mind from the start. Many, like
[Zoomr][] and [Simon Willison's blog comments][4], use OpenID as their
only authentication scheme. So I decided to have a go at making a log-in
system with pluggable authentication, but to only supply an OpenID
plug-in for now.

My log-in 'framework' (if that's not too grand a word) consists of just
two functions. First, `log_in_filter` is a more elaborate version of the
filter (middleware) functions described above. It roughly corresponds to
[Part 2][2] of my TurboGears+OpenID experiment: the wrapped app checks
for the log-in cookie before each request, and if no-one is logged in
then it redirects to a `login` page (with one exception: you do not need
to be logged in to visit the login page). At the end of each request, it
updates the log-in cookie.

The second function, `log_in_and_redirect`, is for use by the
implementation of the log-in page: it takes the user name as an
argument, and redirects to the page that the user originally requested.
You call it instead of calling `start_response` directly.

What's missing from this is the log-in page itself: it must be one of the
pages in the wrapped app, because it has to be able to communicate the
user's login name back to `log_in_filter`. It also has to be careful to
preserve the query-string parameter `next`; the most straightforward way
to do this is to have the log-in form use `request_uri(environ)` as its
`action` attribute and also specify `method="post"`.

Leaving the log-in page to the application allows any form of user name
and authentication to be used, including elaborate single-sign-on servers
and exotic smart-cards. Because the `log_in_filter` does not need to know
anything about the method of authentication, it needs a lot less
configuration than it might otherwise do.

Plugging in OpenID
-----

The next step is creating a log-in page that works via OpenID. So far I
have taken the code from [Part 1][1] of my TurboGears version and beaten
it roughly in to shape. Unlike the TurboGears version---which used
separate URIs for each stage of the OpenID handshake---it uses the same
`login` URI for displaying the form, handling the user's POST, and
handling the redirect back from the OpenID provider. The first and last
of these are implementing the same method (GET) but we can tell the which
is which by looking for the `token` argument amongst the query
parameters.

Unfortunately I have not yet been able to test this, since I have not yet
managed to get Pysqlite2 (needed to set up the OpenID database) installed
in Python 2.5 on my Mac as yet: I get an error message to the effect that
GCC 4.0 does not exist, so it looks like I need to trawl through the
Apple developer documentation to see what I need to do to get the
compiler to work. Grr.

Ah well.  Maybe next weekend...?

  [1]: ../2006/02/10.html "TurboGears and OpenID"
  [2]: ../2006/03/06.html "TurboGears and OpenID, part 2"
  [3]: ../2006/03/08.html "TurboGears and Uploading Pictures"
  [TurboGears]: http://turbogears.org/
  [OpenID]: http://openid.net/
  [buzz about OpenID]: http://simonwillison.net/tags/openid/
  [WSGI]: http://www.python.org/dev/peps/pep-0333/ "PEP 333 Python Web Server Gateway Interface v1.0"
  [Python Paste]: http://pythonpaste.org/
  [Zoomr]: http://zoomr.com/ "Like Flickr, except with black backgrounds"
  [4]: http://simonwillison.net/2006/Dec/19/openid/