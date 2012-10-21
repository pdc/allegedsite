Title: OpenID versus Single-Sign-On Server
Date: 2007-08-13
Topics: openid sso work
Icon: openid_symbol.svg

While trying to figure out how to implement a single-sign-on (SSO)
system for a custom with OpenID, I has a minor insight when I realized
that OpenID is *not* a SSO server. Its actual purpose is slightly
different.

About Single Sign-On
====================

Suppose you have two web servers, one for Secrets and one for Mysteries.
Each has facilities that require users to log in. For marketing reasons,
you want users to view the two sites as a coherent whole: they should
not have to log in twice, once for each site. Whichever server the user
happens to visit first will redirect them to the login page, and once
they have logged in, both sites will treat them as logged in. What do
you need in order to implement this?

Simplest Case: Shared Host
--------------------------

Things are easiest if your sites are on the same server, for example, you could have

	http://example.com/secrets/
	http://example.com/mysteries/

Both sites use the same user database (more about this later), and store
the user name in a cookie encoded and encrypted in the same way. In
ASP.NET you add clauses to `Web.config` that specify the machine key and
the cookie name, and ensure that each site is configured with the same
values.

Now all you have to do is configure the two sites so that the login
cookie includes the attribute `path=/`. This ensures that the cookie is
included with all requests on the server `example.com`.

There is no actual requirement that the same physical machine be used to
serve both sites: using a load-balancer or a reverse proxy, you can
arrange for requests in the `http://example.com/` URL space to be
delegated to different application servers.

Simple Case: Shared Domain
--------------------------

If the different servers must be geographically dispersed then sharing a hostname may prove impractical. They can instead share a domain:

	http://secrets.example.com/
	http://mysteries.example.com/

In this case it is *still* possible to share a login cookie: you set its
`domain` attribute to `.example.com` and it will be included in all
requests to hosts in that domain.

The only wrinkle is that ASP.NET≈1.1 does not directly support
specifying the domain of the login cookie. You can work around this by
changing your `logjn.aspx` so that, instead of calling
`LogInAndRedirect`, it creates the cookie explicitly and then does the
redirect.  ASP.NET≈2.0 can be configured from `Web.config`.

The main trick here is that you cannot deploy (or test) this scheme on
an intranet if your intranet host names do not have domains. This can
cause some customers to believe it cannot be made to work.

Complicated Case: Single-Sign-On Server
---------------------------------------

If it is necessary to give the various servers domain names that do not have a common ancestor, then a single cookie cannot be shared between them.  Suppose you have the following two URLs:

	http://secrets.com/
	http://mysteries.com/

There is no way to set a cookie that is included in requests to both
these domains.

In this case we need a third server, the SSO server, whose purpose is to
keep track of who is logged in. When you visit a page on `secrets.com`,
if its cookie is not set, it consults the SSO server to find if the user
is already logged in, in which case it silently creates the cookie and
carries on as if they had already been logged in.  

Shared User Database
====================

Integration
-----------

In the above description I have glossed over an important step of the
process: the part of the login page that determines whether a request to
log in is valid or not. While the Secrets and Mysteries sites probably
do something similar (e.g., looking up a user record in the database and
comparing the password offered with the one in the database), if the
applications were developed separately, the details of how they work
will differ. Also, if they assume user records are mixed in with their
other database tables, they will have their own separate user databases.

It follows that when we start the process of integrating the two
applications, one step will be disentangling the user database for
authentication from any other databases they use, and tweaking them to
use the same database layout.

There is also the possibility that the authentication database will have
new entries added. Unless there is some back-channel that also adds
entries to the application database, the applications will need to be
able to add new entries on-the-fly. If there is a registration process,
then they will have to be changed so it is now triggered by the arrival
of an authenticated user for whom there is no user record.

Pluggable Authentication
------------------------

Suppose the web application is a product, meaning that it will be
deployed by a variety of customers on their own servers. Many of them
may already have a users database (such as LDAP or Active Directory),
and it would be tedious and error-prone to try to copy them to our user
database. Instead we want to use their existing authentication scheme
directly.

In ASP.NET the most straightforward way to do this, assuming some
programming expertise is available, is to supply a login page with a
customizable method for checking a user’s credentials. Since this is the
only place that needs to ‘know’ about the style of authentication, the
changes are fairly self-contained. The downside is that updates to the
application software will clobber the changes.

One way to address this problem, at the cost of some additional
complexity, is to have the login page call methods on a *strategy
object* (also called a ‘driver’) that encapsulates the knowledge about
authentication. In .NET, the strategy object implements an interface
called something like `IUserAuthenticator`, and is instantiated using a
type name that is obtained from `Web.config`. If custom authentication
schemes are deployed as assemblies distinct from those for the
application itself, they will not be clobbered when performing upgrades.

This assumes all your web sites are ASP.NET sites. With a mixture of
programming platforms, things could get more complicated, since you
would need to write fresh strategy objects in each language. At this
point you start wondering about having some sort of language-neutral RPC
to do the authentication.

Where OpenID Fits In
====================

OpenID servers do not correspond to the single-sign-on server mentioned
above. The crucial difference is that, if both the secrets and the
mysteries web sites supported OpenID, you would still be asked to sign
in with OpenID once for each site visited. All OpenID would take away is
the requirement to enter your password each time.

No, what OpenID corresponds to is pluggable authentication and a shared
user database. The difference is that, rather than writing a new .NET
object (or the equivalent for your platform’s programming language), you
instead add OpenID support to the authentication server. If you have to
do it from scratch, this is naturally a fair bit more work. On the other
hand, some authentication servers might already support OpenID (because
it is a standard).  OpenID support is also more valuable:

- adding OpenID support to authentication servers might benefit other
  applications in addition to our own (as more applications become
  OpenID consumers);

- OpenID providers can be on a different site from the application
  servers, which may allow us to host the application for the customer,
  while leaving the authentication servers on their network;

- OpenID allows for multiple authentication servers to be used together,
  which is useful if we are combining formerly disjoint user groups
  (after a company merger, say).

In extreme cases it may be necessary to have both OpenID and SSO
servers. In most cases, shared cookies + OpenID will suffice.
