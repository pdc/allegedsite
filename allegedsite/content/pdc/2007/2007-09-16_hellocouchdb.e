Title: Hello CouchDb version 1.0
Icon: ../icon-64x64.png
Date: 2007-09-16
Topics: couchdb hellocouchdb ajax javascript 

This weekend—over and above working on our ongoing greenhouse-erection
project—I have created a simple explorer for [CouchDb][] servers that
for want of a better name I have called Hello.

  [CouchDb]: http://couchdb.org/

I don’t have an official web site for this software yet. For now you can download <a href="HelloCouchDb-1.0.tgz"><code>HelloCouchDb-1.0.tgz</code></a>, comment on the [announcement on the CouchDb Google group][1], or (new!) see my [rough notes on Jottit][2].

  [1]: http://groups.google.com/group/couchdb/browse_thread/thread/7354e2143e31da5e
  [2]: http://hellocouchdb.jottit.com/

What it Does
============

It does not do all that much: it shows a list of databases. You can
select a database and it shows you a list of documents. You can select
documents to see their content, pretty-printed in tabular form.

There is a document editor, but it is limited to changing the values of
existing fields of your document: you cannot change the type of fields
or add new ones. Obviously this is an area I plan to do more work in.

Despite these limitations, it is already a useful GUI to the CouchDb
server.

Installation
============

The application of four files: `hello.html`, `hello.js`,
`hello.css`, and `formbg.gif`. 

It assumes that it is running on the CouchDb server, and that `json.js`
is available in its parent directory (that is, at relative URI
`../json.js`). To install it on your server, you unpack the files in to
a directory called `hello` in the directory containing `json.js`, then
visit `http://localhost:8888/_utils/hello/hello.html`.

It is a single-page AJAX application: the
lists of databases and documents work by making an HTTP request from the
JavaScript code, unpacking the JSON that the server returns, and
generating HTML elements on the fly via the DOM.  Depending on how slow your server is, you may see ‘Loading …’ and ‘Saving …’ messages flashing up while it waits for the responses.