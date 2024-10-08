Title: Desktop Web Server in .Net
Date: 20061113
Icon: ../wp/icon-64x64.png
Topics: web http dotnet csharp programming 

Web servers started as a solution to getting information from other sites. Then
it became convenient to use HTML and HTTP on one's local-area network, and for
some reason we had to call that idea an 'intranet' to make people pay attention.
Sometimes it is useful to run a mini-server on the same computer as your desktop
application; in this note I'll discuss this idea in the context of an
application written to Microsoft's .Net platform, since that's what we use at
work.

Desktop web servers
-----

<div>
<a href="http://www.flickr.com/photos/pdc/269431464/" title="Rachel and a Quilted Wall Hanging"><img src="http://static.flickr.com/83/269431464_a248a84e72_m.jpg" width="240" height="180" alt="" align="left" /></a>
</div>

The idea of running a web server locally is not new.  [Dave Winer][] used this
technique in [Radio Userland][] something like ten years ago: you run a web
server on the user's desktop, and the user-interface of the program runs as HTML
in their favourite web browser.  When the application is about building weblogs,
it makes some sense to hand over the job of displaying HTML to the web browser,
rather than trying to develop your own.

Depending on your operating system, presenting your UI in HTML does not even
mean it has to look like it is running in a web browser if you don't want it to.
On Microsoft Windows, you can turn your HTML page in to a [HTML Application][]
(HTA) by changing the file name to end in `.hta`; if you have installed
Microsoft .Net Framework or Microsoft SQL Server 2005 recently, you will have
seen an HTA in action: the installer front-end is implemented as HTML in this
way. On the Mac, the closest equivalent is [Dashboard][] widgets. Another
possibility is to have your application use an embedded web-browser as part of
its UI.

Obviously the performance requirements for a desktop web server are different
from one used to field requests from all over the internet. This means that the
footprint of the server can be much smaller: it does not need a farm of worker
processes to be set up, or eleborate support for caching or esoteric HTTP
headers or multi-layered security. Well-known, 'industrial-strength' web servers
like Apache and Microsoft IIS are too heavyweight for this niche: you want a
server that can scale *down* not scale *up*.

Why use a Desktop Web Server in .Net?
-----

<div>
<a href="http://www.flickr.com/photos/pdc/289477192/" title="The EndÑOr Just the Beginning?"><img src="http://static.flickr.com/118/289477192_cffc8cefd5_m.jpg" width="240" height="180" alt="" align="right" /></a>
</div>

Without going in to details (for reasons of client confidentiality), I think I
can admit to working on a desktop application using Microsoft .Net and its
WinForms class library. We want to allow users to add comments to things in the
program which for this article I shall call boojums; the customer wants threaded
bulletin-board-style comments. While it would be possible to display indented,
hierarchical comment lists with WinForms widgets, it is easier to see how to do
this in HTML ([WinForms is already obsolete][1], so learning how to do it in
Winforms would be a waste of time).

We already display some other info via an embedded browser window. For our
existing use of the browser control, we simply supply a static HTML file for it
to display (this involves making lots of temporary files). For the comments, I
will need users to be able to click on comments to show and hide them, and also
a way to reply to a particular comment. For this I want a mechanism for the
JavaScript running in the HTML to talk to the host application; rather than work out how
to install a new protocol (which is how Microsoft solved this for the Books
Online used in Microsoft Visual Bedsit Apartment Workshop .NET Solution Suite
2003), it seemed more straightforward to run a desktop web server for the HTML
in the comments view to talk to.

The trick is that the .Net worldview is all about web servers being big, in
fact, so far as .Net is concerned there is only one web server, IIS, and only
one way to write web pages, ASP.NET, both of which are far to clunky to stick on
the side of a desktop app. So I have to roll my own. This is the opposite of the
situation with Python, which is so eager to [make making web servers easy][2],
people complain there are *too many* web frameworks!

Adapting WSGI for .Net
-----

<div>
<a href="http://www.flickr.com/photos/pdc/289477198/" title="Christmas Baubles for Giants"><img src="http://static.flickr.com/103/289477198_f2782cd766_m.jpg" width="240" height="180" alt="Christmas Baubles for Giants" align="left" /></a>
</div>

You could spend ages designing a web server, and working out how to divide it in
to self-contained chunks that can be tested independently (I definitely do not
want to debugging of the web server to be mixed in with running the GUI
application). To save time, I decided to start by adapting the simplest
web-server API I know of: Python's [WSGI][] (Web-server gateway interface). This
is interesting because WSGI exploits Python's flexibility to define an interface
using no class definitions at all: your web application is not a class or a
swarm of classes, but a single callable object (a function, or a method on a
class instance, or an object that pretends to be a function by implementing a
method named `__call__`), and the web server exposes its functionality as a
dictionary and another callable. In .Net I use delegates where Python uses
callables (I could have used interfaces with a single member to similar effect).

Thus we have a division of labour that goes like this. The application-specific
'top half' of the server is a function that matches this signature:

    public delegate IEnumerable HandleRequestDelegate(
        IDictionary environ,
        StartResponseDelegate startResponse);
        
where `environ` has entries like `PATH_INFO` and `REQUEST_METHOD` based on the
CGI conventions, and `startResponse` is a function supplied by the
application-ignorant, HTTP-savvy 'lower half', and has this signature:

    public delegate void StartResponseDelegate(
        string status, IList headers);

The handler function examines `environ` to get the information about the
request. It then calls `startResponse` to begin its response, supplying the
headers for the HTTP response as an `IList` of `DictionaryEntry` objects (this
is the closest I could find to an equivalent of WSGI's list of tuples; I wonder
if an `IDictionary` might have done just as well). The result of the function is
an `IEnumerable` that returns zero or more chunks of the body of the response.
These chunks can be strings (which are always encoded as UTF-8 in my server) or
byte arrays.

A simple request-handler function would look like this:

    private IEnumerable HandleRequest(IDictionary environ, StartResponseDelegate startResponse) {
        ArrayList headers = new ArrayList();
        headers.Add(new DictionaryEntry("Content-Type", "text/plain; charset=UTF-8"));
        startResponse("200 OK", headers);
        return new string[]{"Hello, World!"};
    }
    
This is the direct adaptation of the corrsponding Python WSGI code:

    def handle_request(environ, start_response):
        headers = [('Content-type','text/plain; charset=UTF-8')]
        start_response('200 OK', headers)
        return ['Hello, World!']

You now create the server and start it up like this:

    InProcWebServer server = new InProcWebServer(
            new HandleRequestDelegate(HandleRequest));
    server.Start();
    Uri baseUri = server.BaseUri;

The `BaseUri` property is something like `http://127.0.0.1:2134/`, and is used
to generate URLs that talk to the new server. Because the hostname is
`127.0.0.1`, only processes running on this computer can connect to the server.
The port number 2134 is generated by the operating system, and is different each
time you run the program.

This leaves me with two tasks:

- Write the bottom half: the web server, which listens for requests, parses them to create the
  `environ` disctionary, and then calls the handle-request function; and
  
- Write the top half: a method on the application object that implements the handle-request
  function. 
  
The web server part is (at least in principle) reusable in other projects.


Writing the lower half
-----


<div>
<a href="http://www.flickr.com/photos/pdc/294548590/" title="Sparkler Squiggle"><img src="http://static.flickr.com/105/294548590_003e363c34_m.jpg" width="240" height="240" alt="" align="right" /></a>
</div>


The first few unit tests use `WebRequest` and `WebResponse` classes to talk to
the HTTP server. Since this trivial web application does not look at the
`environ` parameter, I was able to write the first unit tests that tested the
server threading without having to write the entire HTTP parser in one go.

This was the first time I'd needed to investigate the .Net class library's
networking classes. They supply a `Socket` class that does all the things that a
Unix programmer from the 1990s would expect. They also have a wrapper
`TclListener` that does bind, listen, accept for you. The greatest difficulty
was in guessing the class name of the synchronization object I would need to
co-ordinate server (background) thead with the caller: `AutoResetEvent`, as it
turned out.

The reason I need to synchronize the two threads is that the socket for the
server is created without specifying a port number: the system supplies a random
unused port. So my calling thread---which needs to know the port number---has to
be suspended long enough for the `TcpListener` to be created and ready to
divulge this piece of information.

After that, the server thread starts a loop along the lines of

    for (;;) {
        TcpClient client = listener.AcceptTcpClient();
        if (state == State.Stopping) {
            break;
        }
        Thread thread = new Thread(new ThreadStart(
                new Acceptor(client).Run));
        thread.IsBackground = true;
        thread.Start();
    }

I then define an inner class `Acceptor` that basically does nothing except
provide one method---`Run`---and a place to store its one variable, the client.
The method `Acceptor.Run` handles one HTTP request, issues the response, and
then quietly terminates.

The next step is easier if you have two monitors. You display a copy of [RFC
2616][] (or the [W3C's sectionized version][3]) on one screen and your
development editor in the other. I mentioned earlier that you can write the
first few unit tests so they only need you to parse the [Request-Line (section
5.1)][4], leaving the message headers for later.

When parsing the incoming stream, I wrote the code to work byte by byte,
taking care not to copy character data in to  in a `StringBuilder` until after byte stream had been
passed through my scanner. The point to this is that the syntax of HTTP requests
is defined in terms of bytes (or octets), for which ASCII is a convenient
representation, and *not* character strings (which in .Net are something
different). I also did not want to risk .Net being to clever about line-endings
and confusing matters. This is particularly pertinent when parsing the
*message-header*s, where you might think you can just use the built-in
`ReadLine` routine, but then get confused over splicing in continuation lines and
not eating the whitespace at the start of the message body. To get it right, read the RFC and
draw yourself a [finite state machine][] on a piece of paper, that's my advice.

After that you need to call the `HandleRequestDelegate`, and then pump out the
headers and body content to the socket stream, and the server's job is done.

Developing the top half
-----

<div>
<a href="http://www.flickr.com/photos/pdc/294548571/" title="Green Fountain"><img src="http://static.flickr.com/117/294548571_482f9233d5_m.jpg" width="240" height="180" alt="" align="left" /></a>
</div>

The other side of the fence is the top half, the bit which knows about the
application. The neat thing about WSGI is that, apart from the unit testing
required to show the server stuff works, you do *not* need to test all of the
application-savvy half via the HTTP server: instead the unit tests can just
create an `environ` array, feed it to `HandleRequest`, and check the header list
and body that result. This makes the unit tests a little less complicated (and
probably makes them run faster, too).

After a while patterns began to emerge in the top-half code. For example, a lot
of the URL namespace managed by the server was split in to segments like
`/static` (read from files on disc), `/boojums` (information about boojum called
`fred` would be under URLs like `/boojums/fred/comments`). In the first iteration
of the code, this was done using repetative code:

    string path = (string) environ["PATH_INFO"];
    if (path.StartsWith('/static/')) {
        string fileName = path.Substring(8);
        ... look for a file and return its conents ...
    } else if (path.StartsWith('/boojums/')) {
        string rest = path.Substring(8);
        ... look for a boojum and return information about it ...
    } ...

The began to get overly elaborate when I wanted the GUI to be able to add an
extra URL path `/state`, that would tell the caller which was the current
boojum, and knew I would need to add HTTP methods to update boojum properties as
well as extract them.  So I spent Friday factoring out 'middleware' components. 
Middleware is the WSGI term for an object that handles requests by invoking
other request handlers---and doing a little bit of work in between. One example
is class `Selector`, a simplified version of the Python [WSGI Selector][].  The
`Selector` class as an `Add` method you use to register handlers for parts of
the URL namespace:

    Selector selector = new Selector();
    selector.Add("/static", "GET", new HandleRequestDelegate(
            new FileServer(dirName).HandleRequest));
    selector.Add("/boojums", "GET", new HandleRequestDelegate(Boojums_GET));
    selector.Add("/boojums", "POST", new HandleRequestDelegate(Boojums_POST));
    InProcWebServer server = new InProcWebServer(
            new HandleRequestDelegate(selector.HandleRequest));

My selector is not yet as clever as the WSGI one: it does not extract URL
parameters.  All it does is keep track of the `PATH_INFO` and `SCRIPT_NAME`
entries in `environ`, shifting the matched portion across so that the inner
request-handler thinks its namespace starts at `/`.

There are two advantages to extracting the `Selector` class from the application
code. First, it replaced a lot of repeatative ad-hoc switch and if statements
with declarative code, which means, it reduces the amount of
application-specific code by moving this functionality in to the generic class
library (which might be reused on other projects). Second, my boojum
class-library could supply the implementation of `/boojums`, and the GUI layer
add another handler for `/state` without the class library needing to know about
it.

Similarly, we need a way to synchronize access to the database of boojums, since
the database is not thead-safe. After a few false starts I settled on another
middleware class, which has a member variable `handleRequest` set via its
constructor, and a public member function `HandleRequest` method does whateber
is necessary for synchronization and then calls the `handleRequest` delegate.
When unit-testing the code, we cannot use the same synchronization code as we do
in the GUI (because we use the magial method `Contol.Invoke`); spinning it out
in to a separate middleware class allows us to test the rest of the code with a
different synchronization technique.


Does it work?
-----

So far I have spent a week developing the web server and wiring it in to the
application, and it has now reached the point where it works: the HTML page
shown in the browser widget gets the current boojum's address, and then gets the
list of comments and displays them. It also displays a form that can be used to
add a comment to the boojum. There are still some details to sort out (such as
making the form appear when you click Add Comment, rather than having it clutter
up the place all the time), but it is looking pretty good for a week's effort.



  [Dave Winer]: http://www.scripting.com/
  [Radio Userland]: http://radio.userland.com/
  [HTML Application]: http://msdn.microsoft.com/workshop/author/hta/overview/htaoverview.asp
  [Dashboard]: http://www.apple.com/macosx/features/dashboard/
  [1]: http://www.geekswithblogs.net/tscott/archive/2005/06/07/42506.aspx
  [2]: http://bitworking.org/news/Why_so_many_Python_web_frameworks "Why so many Python web frameworks? (Bitworking)"
  [WSGI]: http://www.python.org/dev/peps/pep-0333/ "PEP 333 Python Web Server Gateway Interface v1.0"
  [RFC 2616]: http://ietf.org/rfc/rfc2616.txt "Hypertext Transfer Protocol -- HTTP/1.1"
  [3]: http://www.w3.org/Protocols/rfc2616/rfc2616.html
  [4]: http://www.w3.org/Protocols/rfc2616/rfc2616-sec5.html#sec5.1
  [finite state machine]: http://en.wikipedia.org/wiki/Finite_state_machine
  [PEP 333]: http://www.python.org/dev/peps/pep-0333/ "PEP 333 Python Web Server Gateway Interface v1.0"
  [WSGI Selector]: http://lukearno.com/projects/selector/
