Title: TurboGears and OpenID, part 2
Topics: turbogears picky sqlobject hmac
Icon: ../icon-64x64.png
Date: 20060306

I wrote that I planned to return to my [TurboGears][] version of the
[Picky Picky Game][] once I had picture-uploading working.  Yesterday I
finally had a spare afternoon to do some more hacking on Picky2, and got
uploading of pictures working.  But before that I will finish off my description
of doing authentication with OpenID. 

Log-in Cookie
-----

In the [first episode][] I skipped the last step in authenticating a
user: remembering they are logged in so they don't have to repeat the
process for  every page.  In the process of adding that tiny detail I
also refactored the code so that the log-in controller class (used by
the [CherryPy][] part of TurboGears to run the `login` page) is in 
`authentication.py`; in `controllers.py` you just see

    class Root(controllers.Root):
        login = authentication.LoginController()
	... followed by method definitions ...

The cookie is saved with this function

    import sqlobject, hmac, base64, time
    ...
    
    def setLoggedInUserByUri(uri, remember=False):
        """The user identified by this URI is logged in: record this in a cookie."""
        # 1. Ensure there is an entry in our database.
        try:
            pers = model.Person.byUri(uri)
        except sqlobject.SQLObjectNotFound:
            label = uri
            if uri.startswith('http://'):
                label = label[7:]
            pers = model.Person(uri=uri, label=label)
            
        # 2. Create a cookie that contains an HMAC
        # (message authentication code) for the user's log-in URI.
        s = '%d,%s' % (int(time.time() + COOKIE_TTL), uri)
        h = hmac.new(SECRET, s).digest()
        cherrypy.response.simpleCookie['you'] = base64.standard_b64encode(h) + ',' + s 
        c = cherrypy.response.simpleCookie['you'] # Get the magic morsel object
        c['path'] = '/'
        if remember:
            c['max-age'] = COOKIE_TTL
            
        turbogears.flash('Welcome to Picky2')

The first part adds an entry to our database if this person is new to us. Recall
that the person is identified by URI they  supplied to OpenID. The label field
will eventually be the human-friendly name for the person; for now we fudge it
by just using the URI.

The second part creates a message-authentication code (MAC) of the HMAC flavour,
defined in [RFC 2104][]. The cookie's value looks something like

     IjlymCqVDwIpY6MxFTRXjQ==,1141631485,http://example.org/jsmith
	 
The last part is the identity of the logged-in person; the second part is the
time when this cookie should be considered expired, and the first part is the
HMAC that makes it hard for someone else to forge a cookie: without knowing the
value of `SECRET`, it will be infeasible to generate the correct HMAC value.
The time-out value is included so that even if your cookie *is* stolen by some
cross-site scripting naughtiness, it will not be useful for very long.

The last bit sets the cookie. The tricky part was finding documentatioin for how
CherryPy handles cookies; in the end it turns out Python has a [Cookie module][]
and that CherryPy uses that.

Is that my Cookie?
-----

The flip-side of all this is that when you visit a page later, it needs to know
if you have logged in.  To do that it uses this function to get the currently
logged in user:
	
    def getLoggedInUser():
        """Return the Person object for the logged-in user."""
        loginUri = 'login?next=%s' % util.uriParamEncode(cherrypy.request.browserUrl)
        c = cherrypy.request.simpleCookie.get('you')        
        auth = c and c.value
        if not auth:
            turbogears.flash('Please log in first')
            raise cherrypy.HTTPRedirect(loginUri)
        h, s = auth.split(',', 1)
        hh = hmac.new(SECRET, s).digest()
        if h != base64.standard_b64encode(hh):
            turbogears.flash('Cookie has expired (or had bad HMAC)')
            raise cherrypy.HTTPRedirect(loginUri)
        expires, u = s.split(',', 1)
        if int(expires) < time.time():
            turbogears.flash('Cookie has expired')
            raise cherrypy.HTTPRedirect(loginUri)
			
        try:
            pers = model.Person.byUri(u)
        except sqlobject.SQLObjectNotFound:
            turbogears.flash('This user has never logged in (or database broken)')
            raise cherrypy.HTTPRedirect(loginUri)
			
		# TODO. Refesh the cookie
        return pers

The first thing it tries is basically the *last* part of the set-cookie
function, run backwards: it gets the cookie, tries to see whether the HMAC
matches, then decomposes it in to the time-out and user-identity parts. Each
time it fails to verify the cookie, it uses `turbogears.flash` to explain why;
this is for my benefit (while debugging the application), and is probably too
indiscreet for a production web server. I should probably change it to just say
'Please log in' and not offer any explanations!

Next: all about uploading pictures. This time for sure.

  [Cookie module]: http://docs.python.org/lib/module-Cookie.html
  [RFC 2104]: http://www.ietf.org/rfc/rfc2104.txt "HMAC: Keyed-Hashing for Message Authentication"
  [first episode]: 02/10.html
  [TurboGears]: http://turbogears.org/
  [Picky Picky Game]: http://caption.org/picky/ "Picky Picky Game version 0.19"
  [CherryPy]: http://www.cherrypy.org/ "CherryPy is a pythonic,  object-oriented web development framework."
