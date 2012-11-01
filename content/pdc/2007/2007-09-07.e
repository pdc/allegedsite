Title: First Adventures with CouchDb
Date: 2007-09-07
Topics: couchdb python httplib2
Icon: ../icon-64x64.png

I’ve just run my first client program against the CouchDb server.  It doesn’t do much yet, but it shows that I’ve managed to install and build the thing successfully.

CouchDb
=====

The iPod Touch will not be for sale until the end of the month, so I
have been pursuing other temporary obsessions this week. One is a
project that might be the future of web storage: [CouchDb][]. Its
external interface is GET, PUT, POST and DELETE of JSON objects. You
define stored queries, called views, in the form of JavaScript functions
that decide which objects match and which properties to return. This
interface appeals to me as very elegant, simple, and web-friendly in a
way that SQL-based databases like Microsoft SQL Server 2005 is not.

The simple API conceals [a complex interior][1] that knows all about handling conflicts between simultaneous updates locklessly (which is more scalable than the locking approach used by most SQL databases), and synchronization between databases—even ones with only intermittent network connections.
It is built on Erlang, a programming language that resembles the love-child of Occam and Orwell, the outré languages the University taught  us as students to try to help us escape the imperative-programming mindset. It also is a project with gaps in it that I could help to fill in—a chance for me to do some free-software development for the first time in however many years. Even downloading the source, compiling it, and getting it to display an welcome message feels more like proper programming than beating my head against ASP.NET’s bureaucracy.

To explain the name: Couch = Cluster of Unreliable Comodity Hardware. You talk to your CouchDb database in the Representational State Transfer style, or REST. Thus ‘REST on the CouchDb’.

My First Client Program
====

Here’s a short Python program:

	import httplib2
	≈
	h = httplib2.Http('.cache')
	resp, content = h.request('http://localhost:8888/pongo/', 'PUT', '')
	≈
	print repr(resp)
	print '---'
	print content
	print '\t\t* * *'
	≈
	resp, content = h.request('http://localhost:8888/_all_dbs', 'GET')
	print repr(resp)
	print '---'
	print content

The first call to `request` creates a database called `pongo`, and the
second gets the list of all databases. I’m using Joe Gregorio’s
[Httplib2][] to connect to the server.

Here’s the output:

	{'status': '201', 'damien': 'awesome', 'expires': 'Fri, 07 Sep 2007
	07:54:36 GMT', 'server': 'inets/develop', 'transfer-encoding':
	'chunked', 'pragma': 'no-cache', 'cache-control': 'no-cache', 'date':
	'Fri, 07 Sep 2007 07:54:36 GMT', 'content-type': 'text/plain;
	charset=utf-8'}
	---
	{"ok":true}
	                * * *
	{'status': '200', 'content-location': 'http://localhost:8888/_all_dbs',
	'damien': 'awesome', 'expires': 'Fri, 07 Sep 2007 07:54:36 GMT',
	'server': 'inets/develop', 'transfer-encoding': 'chunked', 'pragma':
	'no-cache', 'cache-control': 'no-cache', 'date': 'Fri, 07 Sep 2007
	07:54:36 GMT', 'content-type': 'text/plain; charset=utf-8'}
	---
	["pongo"]
	
Success: I now have a database created on the server.  This is a good start.  I should also draw the reader’s attention to the non-standard HTTP response header amonst those reported above:

	Damien: awesome

This refers to [Damien Katz][], the chief perpetrator of CouchDb, along with [Jan Lehnardt][].  
	

  [CouchDb]: http://couchdb.org/
  [httplib2]: http://code.google.com/p/httplib2/
  [1]: http://www.couchdbwiki.com/index.php?title=Technical_Overview
  [Damien Katz]: http://damienkatz.net/
  [Jan Lehnardt]: http://jan.prima.de/
