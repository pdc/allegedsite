Title: OpenID as a WSGI filter, part 2
Topics: wsgi openid python quixotic storm
Icon: openid_symbol.svg
Date: 2007-08-05

Programmers learn through programming, and my research into [OpenID][]
has got as far as a web application that lets you do nothing at all
*except* log in with OpenID. Along the way I have played a bit with
[Canonical][]’s own [object-relational mapper (ORM)][ORM] called
[Storm][].

Previously
==========

WSGI Filters
------------

In [part 1, back in February][prev] I had created a home page log-in
page using [WSGI][] and some higher-order functions to make writing
direct to the WSGI conventions more convenient. These include the
following function decorations for WSGI app functions:

- `@form_data_filter`—decode form parameters, and place them in the
  `environ` dictionary as `alleged.form_args`;

- `@query_string_filter`—decode form parameters, and place them in the
  `environ` dictionary as `alleged.query_args`;

- `@cookie_parsing_filter`—decodes the cookies supplied with the
  request, and places them in the `environ` dictionary
  `alleged.cookies`;

- `@genshi_html(template_name)`—the app function must return a
  dictionary rather than the usual iterator, and the output
  will be generated from the named template with this dictionary
  supplying the template arguments; and

- `@log_in_filter(cookie_name)`—the app function will have the side
  effect of discarding any log-in cookie.

These filters, and the functions used to implement them, live in Python
modules in a package `alleged.http`. They are intended to be reusable,
although without more doco they are not really ready for other people to
use.

The upshot of which is that the shortest of the application’s controllers can be written as follows:

	@log_out_filter
	@genshi_html('logged_out.html')
	def logout_POST(environ, start_response):
	    start_response('200 OK', [])
	    return {}

The application as a whole is knitted together from a bunch of WSGI
functions using the [Selector][] class, and this is wrapped in
`log_in_filter` (which provides a generic mechanism for creating and
tracking the log-in cookie) and `genshi_config_filter` (which adds an
`environ` entry for the benefit of `genshi_html` decorators).

OpenID
------

Having created a bare-bones web-application framework, I took the
OpenID-processing code from my previous effort and beat it in to the new
conventions. This results in two factory functions that take
configuration information (such as the cookie name) and return WSGI apps
for the log-in URL. These in turn are plugged in to the log-in filter
framework and lo! we have an application that allows the user to log in
with OpenID, and remembers who they are logged in as (with a cookie).

Actually, [Part 1][prev] ended just before this point, because I had
somehow broken PySqlite support when I upgraded to Python 2.5 (or
something). Although I said I would try to finish it ‘next weekend’, I
ended up leaving it for a good few months. Once SQLite support was
restored, the OpenID log-in process worked fine.

I moved the code in to its own Python module
`alleged.http.openidfactory`. The function `login_GET_factory` takes
some configuration parameters and returns a WSGI function suitable for
use as the handler of GET requests for the `login` page. A similar
function `login_POST_factory` is used for the intermediate step.


Adding User Settings
====================

Storm
-----

The next step was adding a way to store user settings (without which
there is not much point in getting them to log in, of course). There are
lots of way to handle storage in this context, but I went for the
conventional solution in Python-land, which is an ORM—essentially a
library that hides most of the details of talking to the database and
exposes a set of objects that correspond to the entities in the
database, such as users.

ORMs are popular in Python because Python’s introspection and flexible
class structures makes it easy to implement, and it lets one avoid
writing (much) [SQL][]. The downside is that the access to the RDBMS may
be inefficient because it is trying to impose an object-oriented view of
the world on the relational database (the [object–relational impedance
mismatch][1]). Microsoft’s frameworks, such as VB6 and .NET, take the
other approach, with the relational database’s view of the world imposed
on the object-oriented program.

Of the various options, I am trying out [Storm][], one of the outputs of
the Canonical company’s Launchpad project. Storm code is short and
involves slightly less magic (or less of the appearance of magic) than
some other ORMs I have tried. Here’s our bare-bones `User` class:

	class User(object):
	    __storm_table__ = 'Users'
	    id = Int(primary=True)
	    nick = Unicode()
	    uri = Unicode()
    ≈
	    def __init__(self, uri, nick):
	        self.uri = uri
	        self.nick = nick

For the first iteration, there are only two settings: their display name
(here called `nick`) and the URI of their home page. When and if this
application gets extended in to something more than an OpenID testbed,
there will be more fields here to record application-specific info. The
third field mentioned in the class definition is `id`, the database’s
identifier (dbid) for users; these are an artefact of the database that
Storm takes care of for us.

There is no field for login name, because this is a pure-OpenID system.
there is no field for OpenID URI, because a given user account might
have more than one OpenID: in the relational world, this means OpenIDs
need their own database table. We define this table in Python as
follows:

	class OpenID(object):
	    __storm_table__ = 'OpenIDs'
	    uri = Unicode(primary=True)
	    user_id = Int()
	    user = Reference(user_id, User.id)
    ≈
	    def __init__(self, uri, user):
	        self.uri = uri
	        self.user = user

Storm is happy for me to use the URIs as the primary key of the table,
rather insisting on having an `id` column as well. The field `user_id`
is again an artefact of the database representation—it holds the dbid of
the user that owns this OpenID. In Python code we will instead use the
field `user`, which contains a reference to the `User` object itself.
Storm takes care of keeping the two of them in sync with each other.

Given a Storm store called `store`, we could retrieve a user by using `openID = store.get(OpenID, openID_uri)` and then use `openID.user` to get the `User` object. Another option is to use a SQL-like declarative query:

	users = store.find(User, OpenID.user_id == User.id, OpenID.uri == uri)

The arguments (apart from the first) are using operator overloads
defined on the classes `Int`, `Unicode`, et al. to create objects
representing expressions. These are used by Storm to generate the SQL
incantation that will be used to retrieve the results.

One thing I like about Storm is that the store is not hidden: this
means you add a user to the store explicitly (`store.add(user)`), or
implicitly, when linking it to another object in the store. I prefer
this slightly to the having the database details stored in some global
variable.

Registration = Settings
-----------------------

Users do not need to register before they can log in, since their OpenID
is set up outside this application. Instead, the first time they sign
in, we redirect to the settings page, inviting them to enter their
nickname (any any other settings that this application needs). When they
click the submit button, an entry is created for them in the `Users`
table.

This sounds complicated but the code in the GET function for the
`settings` page starts like:

    openID_uri = environ.get('REMOTE_USER')
    user = model.get_user_from_OpenID(openID_uri)
    is_new = openID_uri and not user

When `user` is not `None`, the form is filled in with data from `user`;
otherwise we fill in the form with blanks or guesses. When the user
presses the submit button, the POST function extracts the arguments and
does something like the following:

	if is_new:
        user = model.create_user(openID_uri, nick)
    else:
        user.nick = nick
        if home_page:
            user.uri = home_page
    model.commit()

There is very little difference left between changing your settings and
registering for the first time: the template has a message that is
displayed if `is_new` is true that contains extra instructions, but that
is about it.

My first version of this placed the check for whether a visitor was new,
and so needed to be redirected to the settings page, in the welcome
page. After some thought I factored it out as (yet another) filter. Like
the `log_in_filter`, it converts the wrapped app in to one that checks
whether we have a `User` object for this OpenID, and redirects to the
`settings` page if not, adding a `next` query-string parameter so that
the settings page can include a link back to the page originally asked
for. Because it has to know about the application-specific database,
this new filter `need_settings_filter` is not part of my generic
framework.

Attaching more OpenIDs
======================

User interface
--------------

There are various reasons why someone might want to use multiple OpenIDs
with an account. There will be several points where we might attach an
OpenID to an existing account:

- Sign in with the OpenID used before. On the settings page, there is an
  Attach another OpenID link. From a programming point of view, this is
  the easy case.

- Sign in with a new OpenID. When redirected to the Settings page, the
  ‘Hello, you are new’ message should have a link to a page for
  attaching this new openID to your existing account, by signing in as
  that OpenID as well.

- Sign in with a new OpenID. Create a new account. Belatedly remember
  you have an existing account. From the Settings page, click on Attach
  new OpenID. When signed in as the old OpenID, it offers to merge the
  two accounts.

To the user these may seem like different operations. The underlying
mechanism for each of them is similar (collect two OpenIDs, then do what
is needed to join them), but the wording of the links and form labels
may need to vary to keep the operations clear to the user.

Implementation
--------------

The main complication was that my mechanism for verifying an OpenID was designed for logging in and setting the log-in cookie—but if it did that when attaching an OpenID, it would overwrite the original OpenID.

After pondering various schemes, like copying the login cookie before
creating the new one, and so on, I worked out that I could use the
existing `login_GET_factory` with one simple change: where it calls
`log_in_and_redirect`, it now calls a function passed as a parameter
(with `log_in_and_redirect` as the default value). In a way, this is
vindication of my splitting the maintenance of the login cookie in to a
separate module.

In the application, I define this function to present yet another form,
showing the old and new OpenIDs, and asking the user to confirm they
want these to be attached to the same user account. This form is needed
first so that merging accounts requires a POST, not a GET request, and
second so that if there are indeed two accounts involved, we can insert
a warning message.

Security 
--------

We have to be careful here to avoid creating a spoofable form. The form
must contain the new OpenID as a hidden form item. Without adding
safeguards, it would be possible to create a similar form on another
site that POSTs a form to my application containing the attacher’s
OpenID as the hidden parameter. This would merge your account with the
attacker’s, allowing the attacker to access whatever resources are owned
by your account.

My fix for this is to include a second hidden parameter called `check`
that is a HMAC of the two OpenIDs. You don’t get the check field except
by displaying ownership of both OpenIDs, and outsiders cannot create a
valid check field (because they lack the secret key).

Next steps
==========

I now have a web application that runs and allows people to log in with
OpenID, and to record user settings thereby. (You can also visit some
pages without logging in.) What it lacks is anything other than OpenID
support! I really ought to consider writing some amusing web bame based
on this framework.

Some of the new code is still mixed in with the application code. I
could spin some of it out in to reusable modules. The application's
controllers live in the `run_server.py` script. They should have their
own Python module.

Because WSGI functions are just functions, it should be possible to use
unit testing do do more of the development than I have so far: I have
been testing new WSGI code by running it in the web application, rather
that writing tests. This is a little careless, and if this were a
production project I would be feeling a bit guilty for not having tests
with better coverage.

At some point I might want (for academic interest only) to investigate
how well my OpenID testbed would fit in with deployment systems like
Python Paste. I believe that the factory functions I have would fit in
with Paste’s conventions, but I have not actually tried this out.




  [1]: http://en.wikipedia.org/wiki/Object-Relational_impedance_mismatch
  [prev]: 02/18.html
  [WSGI]: http://www.python.org/dev/peps/pep-0333/
  [Canonical]: http://canonical.com/
  [Storm]: http://storm.canonical.com/
  [Storm tutorial]: https://storm.canonical.com/Tutorial
  [ORM]: http://en.wikipedia.org/wiki/Object-relational_mapping
  [OpenID]: http://en.wikipedia.org/wiki/OpenID
  [Selector]: http://lukearno.com/projects/selector/
  [SQL]: http://en.wikipedia.org/wiki/SQL