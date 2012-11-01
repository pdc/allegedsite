Date: 2009-08-06
Title: URL Routing > URL Rewriting
Topics: django apache php ruby-on-rails

One of the differences between Django and many older web application
platforms such as PHP, ASP, ASP.NET, JSP, etc., is that it has no
implicit URL routes: every URL that is handled by your Django site is
handled by matching it in a URLconf. And this is a good thing.

Background
==========

URLs work like a government department: there is no central list of
files, so instead if someone wants the list of sports centres is, they
will ask you to ‘go to Millie and ask for the list of sports centres’.
The URL <http://jeremyday.org.uk/projects/> tells you (1) use the HTTP
protocol, (2) talk to the computer named `jeremyday.org.uk`, and (3) ask
for `/projects/`. These [parts of the URL][1] are called the _scheme_, the
_authority_, and the _path_.

Within the server there is a routine that decides, given the path, which
procedure to use to generate the response. The process of mapping a URL
path to the routine is called _URL routing_.

URL Routing Using the File System
---------------------------------

The file system on your computer is designed to map names on to data, so
why not use that to organize your web server?

Early web servers had a single routing algorithm: data for the
response is stored in files such that the file path was the same as the
URL path. For example, if you set [Apache’s `DocumentRoot` directive][2]
to `/var/www/jeremyday/`, then the file `/var/www/jeremyday/foo.html` is
used when the server gets a request for `/foo.html`. So very simple and
lovely.

It gets more complicated when you remember that not all possible URL
paths are valid file names. In particular, directly mapping `/projects/`
is impossible because file names cannot end in a slash. (Actually on
some systems directories are also technically files, but here we mean
the sort of file that can contain HTML data.) So the `DirectoryIndex`
directive tells Apache to treat `/projects/` as if the path had been
specified as `/projects/index.html`.

Sometimes you want a program to generate the response data; Apache added
a system where certain file folders were expected to contain programs
(CGI scripts) instead of HTML files. So more directives were
added to control this. Later support for programs written in languages
like PHP was bolted on with the `AddHandler` directive. Because it works
by recognizing the `.php` suffix, PHP requires URLs to end in `.php`.

URL Rewriting
-------------

Systems like [Drupal][3] want instead to have URLs like
`http://drupal.org/node/69500`. to do this you have to add another layer
of complexity to your configuration, called _URL rewriting_. The
following Apache directives should do the trick:

    # Rewrite current-style URLs of the form 'index.php?q=x'.

    RewriteCond %{REQUEST_URI} "!cgi-bin/"

    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule ^(.*)$ index.php?q=$1 [L,QSA]

The upshot of this is that `/node/69500` is rewritten as
`index.php?q=node/69500`, at which point `index.php` is recognized as
invoking PHP. Drupal’s code then takes over, and begins the URL routing
process from scratch starting with `node/69500`.

The upshot of this is that to let Drupal do its own URL routing, you
need to add a dozen directives expressly to disable Apache’s default
URL routing. Apache directives are notoriously difficult to get
right at the best of time, and any configuration file involving
rewriting rules is automatically confusing and difficult to debug (see
[sendmail][] for another example), so getting URL rewriting right is
sometimes viewed as a back art.

Comingling
----------

Another problem with file-based routing is that you have all your code
files and other files mixed up together. This means 

1. You have to add more
directives to tell Apache to *not* serve your source code to naughty
children eager to find out your database passwords. 

2. If naughty people can upload a file called something.php on to your
server, they can run their own code on your server—a security disaster. If they can clobber one of your own `.php` files it is worse.

3. It can make maintenance more complicated if you have different people
updating the code files versus the stylesheets and graphics.

4. On a high-traffic site you will want to move static files on to a
separate web server (or a content-delivery network),
and this is harder if the designers of the web pages assumed the files
are all mixed up together.

That doesn’t mean there’s no place for a file-system-based web server,
just that it should not be the default or sole URL routing algorithm.


Routing without Files
=====================

Deployment with Nginx (or similar)
----------------------------------

[Nginx][6] is one of several small-footprint web servers that whose job
is to speak HTTP to the outside world and then pull the result from its
cache or dispatch to the real application server as quickly as possible.
Nginx has modules for static files, HTTP, and FastCGI as resolution
mechanisms; you can in principle recompile it with just the modules you
need.

On my own practice server I have [Nginx proxying to my Django
application with FastCGI][7]. I think this is a pretty good arrangement
(doubtless someone can tell me I have missed a trick and there is a
better way; there always is).

With Nginx, you can essentially hand over the entire URL to the
application framework as-is with minimum mucking about. What happens
next is up to your framework.

Zope and Rails
--------------

I played with Zope some years ago, so what I am describing is probably out of date.

Zope had a routing algorithm based on Python objects: the path is mapped
on to a hierarchy of objects. Each element in the but the last two are
dictionaries in which the next segment is found. The last segment is the
method name.

Rails takes a similar approach. The default routes handles a path
`/forum/edit/123` by creating an instance of a class named `ForumController`,
which must be defined in a file `app/controllers/forum_controller.rb`, and
invoking a method named `edit`. A dictionary called `params` will contain
an entry mapping `:id` to `123`.

In both cases the routing is no longer tied to files on the web server,
which is nice, but it is tied to the names of methods and classes in the
code.

Drupal
------

[Drupal][] 6 calls its URL routing system menus. Each module can offer a
set of menu items, and these are knitted together in to the hierarchical
list with wildcards that specify entities to load. Being implemented in
PHP, the code is rather clunky:

  $items['example/baz/%example_baz/edit'] = array(
    'title' => 'Baz',
    'page callback' => 'example_baz_edit_page',
    'page arguments' => array(2),
    'access arguments' => array('access baz content'),
    'type' => MENU_CALLBACK,
  );

This says that paths like `/example/baz/123/edit` will cause the
function `load_example_baz('123')` to be called, and if it returns
non-false the page function `example_baz_edit_page` will be called with
that return value as its argument.  (The `type` entry specifies that this
defines a URL route that has no corresponding item in the menu as shown to the end user.)

Drupal modules have to choose disjoint prefixes to avoid name clashes with other modules. 

When Interaction Designers Attack
---------------------------------

These routing methods assume some sort of sensible mapping between URL
paths and the underlying object types in your database.

This all comes unstuck when you are working on a government web site and
your designer decides that the QCDA forum should be
`/qcdadirect/feedback` whereas the nine regional forums should be called
things like `/communities/regions/yorkshireandhumberside`, because that
better reflects the user’s journey through the site. Or perhaps you are
implementing a news website and want entries to have paths like
`/2010/08/05/man-bites-dog` rather than `/node/12345`.

With Ruby it is possible to address this through explicit routing:

    map.with_options(:controller => article, :blah => 'baz') do |article_map|
        article_map.news_front_page '/', :action => :front_page
        article_map.news_article '/:year/:month/:day/:slug', 
            :action => :show,
            :year => /20[0-9][0-9]/,
            :month => /[01][0-9]/,
            :day => /[0-3][0-9]/,
            :slug => /[a-z-]+/
    end

Of the parameters, those with regexes as values constrain elements in
the path, those without are default values that do not have to be in the
URL, and it took me a while to realize the method name is being used to
pass another parameter, the name of this route. I spent ages trying to find where the
method `news_article_path` was defined.

With Drupal as an administrator you have the option of installing the
`paths` module and adding URL aliases for the pages whose paths you care
about. This works pretty well—code can use the internal paths, and they
are converted to aliases in the HTML—but you would have to define an
alias for every article. (And they did!) You could also create a module
whose sole contents was PHP code for new menu entries that use the
desired paths and map them on to the existing modules’ functions.

You can even do URL routing in ASP.NET 3.5 or so; I know this because I
created a site using them to let me have URLs like `/video/1`. The code
is naturally far more verbose than the Django or Rails equivalent, and
you need special incantations in the configuration file to suppress the
default routing algorithm. It also did not work on our web server—still
running ASP.NET 2.0—so I had to rewrite it to use rather the style
`Video.aspx?videoID=1` after all. Oh, well.

How Django Differs
==================

Explicit Routes
---------------

Django has no default routing at all: cleaving to the [Python
principle][4] that explicit is better than implicit, the URLs understood
by your site are listed in your URLconf, a Python
file mapping regexes to the Python callable that implements them:

    more_args = {'blah': 'baz'}
    
    urlpatterns = patterns('example.newspaper.views',
        (r'^$', 'front_page', more_args, 'news_front_page'),
        (r'^(?P<year>20[0-9][0-9])/(?P<month>[012][0-9])/(?P<day>[0-3][0-9])/(?P<slug>[a-z-]+)$', 
            'article', more_args, 'new_article'),
    )

For example, given path `/2010/08/05/man-bites-dog`, it matches the fourth
entry and calls the function `example.newspaper.views.article` as if invoked as follows:

    article(request, year='2010', month='08', day='05', 
        slug='man-bites-dog', blah='baz')

Admittedly anything involving regexes is not going to be pretty, but I
think the Django version is about as concise and flexible as you can
get. The view function (which is Django’s term for what Rails calls a
controller’s action method) can be just a function or it can be an
object method or any object with a `__call__` method. Pattern-matching
with regexes is well-understood and is fast.

Separation of Static Files (No comingling)
------------------------------------------

Django makes mixing static files in with your dynamic pages as
inconvenient as possible. There is a way to [serve static files from
your development server][5] but it is discouraged. Since Apache is
installed by default on Mac OS&nbsp;X, I do my development with the static
files served directly by Apache via a symbolic link, just to keep things
nicely separated. On the production site, I use a separate domain name
`static.jeremyday.org.uk` for static files used by `jeremyday.org.uk`. they
are both the same server, but on a larger site with many visitors I
could easily switch to using a separate static server.

This also means the security concerns of having code files on your web
server’s file system can be greatly reduced.



  [1]: http://tools.ietf.org/html/rfc3986
  [2]: http://httpd.apache.org/docs/2.2/mod/core.html#documentroot
  [3]: http://drupal.org/
  [4]: http://www.python.org/dev/peps/pep-0020/
  [5]: http://docs.djangoproject.com/en/dev/howto/static-files/
  [6]: http://nginx.org/
  [7]: 04/11.html
  [sendmail]: http://www.sendmail.org/documentation/configurationReadme