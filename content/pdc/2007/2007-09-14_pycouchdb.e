Title: First Cut of PyCouchDb
Topics: python couchdb pycouchdb 
Date: 2007-09-14
Icon: ../icon-64x64.png

I have been experimenting with CouchDb by creating the beginnings of a
Python API for it. It is not really ready for prime time yet, but in
best free-software tradition I am publishing early and will add to it
when I have time.

**Update**. In the time between posting to my blog and [posting to the
CouchDb group on Google][1], someone else started an identical project
[couchdb-python][2]. I’ll have a look whether any of my code can be
usefully merged with this project, but by the look of things it’s a
little further on than I was already.

  [1]: http://groups.google.com/group/couchdb/browse_thread/thread/cdcf9d8ddff2551e
  [2]: http://code.google.com/p/couchdb-python/

I have not created a proper distribution yet, but you can download [PyCouchDb-0.0.tgz][] and install it by hand if you want to try it out.

  [PyCouchDb-0.0.tgz]: PyCouchDb-0.0.tgz

CouchDb’s use of HTTP and JSON as the protocol, together with
[httplib2][] and [simplejson][] makes this code almost trivial. Most of
the work was in translating the unit tests from JavaScript to Python!
:-) A Python API is nevertheless useful because it can be extended to do
sanity-checking on parameters before making HTTP requests.

  [httplib2]: http://code.google.com/p/httplib2/
  [simplejson]: http://undefined.org/python/

What follows is the first approximation to some documentation.

Module Contents
===============

Module name: `couchdb` (I dithered for some time as to whether I should
arrogantly claim the top-level name `couchdb` or create one in a private
namespace like `alleged.couchdb`. In the end I have plumped for the
former.)

Classes provided: `Server`, `Db`

Class Server
============

Represents a database server. You use it to create and delete databases,
or to get a list of databases. You create the server object using the
base URL of the server. For example:

	import couchdb
	≈
	server = couchdb.Server('http://localhost:8888/')


Creating and Deleting Databases
-------------------------------

You create and delete databases using the database name. Database names
are lowercase alphanumeric strings that may not start with an
underscore.

	my_db = server.create_db('applecart')
	
Returns a Db object. If the database already existed, then it returns a Db object attached to the existing database.

You also delete databases by name: 
	
	server.delete_db('applecart')

This returns a boolean which is true iff the database existed before you
deleted it.

Listing Databases
-----------------

You can get a list of database names as follows:

	db_names = server.all_db_names()

Returns a list of strings.


Class Db
========

You create a `Db` object from its base URI, which is formed from the server URI, the database name, and another slash:

	import couchdb
	≈
	db = couchdb.Db('http://localhost:8888/applecart/')

You can also get a database object using the `Server.create_db` method.


Documents
---------

A database is a repository of *documents*. A document is represented in
Python as a JSON-compatible dictionary. JSON-compatible means:

- All keys are strings; and
- All values are JSON-compatible.

JSON-compatible values are:

- scalars: `None`, Boolean, numbers, strings (Unicode or byte string);
- sequences of JSON-compatible types; and
- mappings whose keys are strings and values are JSON-compatible.

Document keys starting with an underscore are reserved for CouchDb’s
use. There are two special keys:

- `_id` is the identifier of the document (a Unicode string); and
- `_rev` is the revision of the document (an integer).

You may supply a value for `_id` when creating the document. If you do
not, the server will choose an opaque 32-digit hexadecimal number.


Basic operations: put, get, delete
----------------------------------

The Db object has methods `put` and `get` for storing documents in the
database and retrieving them.

    doc = {'_id': 'fredj', 'name': 'Fred Jones', 'coins': 189}
    db.put(doc)

This returns an object with `_id` and `_rev` attributes that describe
the new document. Also, as a side effect, the document is updated with
entries for `_id` (if not already specified) and `_rev`.

You retrieve documents by document identifier:
    
    doc = db.get('fredj')
	print doc['coins']

To update a document you retrieve it, modify it, and put it again.

    doc['coins'] += 5
    db.put(doc)

It is important that the document you put back is the original document,
modified, or at least that it has the correct `_id` and `_rev` members.
These are used to check that no-one has modified the document between
your obtaining it and storing it back.

In the unlikely event that there *was* such a change, a
`ConflictException` is raised. At this point your program may choose to
retrieve the value, make the change again, and resubmit it, or take some
other action.

Finally, you can delete a document. 

	db.delete(doc)

Note that doc must be a dictionary, and contain at least the `_id` and
`_rev` members. Deletions can lead to conflict exceptions as well.


Queries and Views
-----------------

A *view* is a JavaScript function that is executed on every document in
the database. The value(s) returned by the function are accumulated in
to a set of JavaScript objects called *rows*, returned as a sequence.

A *query* is a one-time (temporary) view.

	result = db.query("""
		function (doc) {
			if (doc.coins > 10) {
				return doc;
			}
		}
		""")
	print result.total_rows
	for doc in result.rows:
		print doc['name'], doc['coins']

Exactly what you get back int he `rows` member depends on the
JavaScript.


Information About the Database
------------------------------

The total number of documents is in the database’s info:

    print db.info().doc_count

To get a list of all document ids:

	for info in db.all_doc_infos():
		print info._id, info._rev


Pretending to be a Dictionary
-----------------------------

You can also treat the database as a dictionary, with document ids as
its keys and documents as its values. Sometimes these methods are less
efficient (use more round-trips to the server) than using `put` and
`get` explicitly.

In particular, you can loop over all documents one at a time like this:

	for doc in db.itervalues():
		...doc...
	
Because this is an iterator it only loads the documents on demand. 









