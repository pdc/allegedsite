Title: Fun! with Ajax
Date: 2007-09-26
Topics: ajax javascript html http hellocouchdb
Icon: ../icon-64x64.png

[A couple of weekends ago][1] I decided to take up one of the [Work
Items for CouchDb][4]: write a client for the server that runs as
JavaScript in the user’s browser, Ajax-style. As someone whose day job
is writing web sites using Microsoft ASP.NET and Microsoft SQL Server,
writing an application in plain JavaScript+HTML comes as a refreshing
change.


The challenge
=====

My first thought about how to create a simple explorer for a [CouchDb][]
server was that I would write a Python library that would speak to the
database, and plug it in to my WSGI-powered framework and write the
server logic in Python with templates using Genshi. But it occurred to
me that this would not fit Damien Katz’s criterion that it could be
bundled with the server. To do that I would need to use what you might
call pure Ajax, meaning a page that uses a JavaScript program to write
most of the page. The JavaScript would have to download the database
information using XMLHttpRequest and generate HTML using the DOM. Could
I do it?

Hello, World!
=============

The first step to finding out was writing a ‘Hello, World’ program. This
would talk to the database and display something.

As it turns out, if you have a CouchDb server running, you can visit
`http://localhost:8888/` and see this:

	{"couchdb": "Welcome", "version": "0.6.4"}

This is a JSON object with two fields, `couchdb` and `version`. Just the thing.

Let’s start with the HTML:

	<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
	   "http://www.w3.org/TR/html4/strict.dtd">
	<html lang="en-GB">
		<head>
			<meta http-equiv="Content-Type" 
					content="text/html; charset=utf-8">
			<title>Hello</title>
			<meta name="author" content="Damian Cugley">
			<script type="text/javascript" src="../json.js"></script>
			<script type="text/javascript" src="hello.js"></script>
			<link rel="stylesheet" type="text/css" href="hello.css">
		</head>
		<body onload="showWelcomeMessage()">
			<p>A message from the CouchDb server:</p>
			<blockquote id="welcome">
				<p>(You need JavaScript activated for this to work.)</p>
			</blockquote>
		</body>
	</html>

The reason for the strange message inside the `blockquote` is that we
don’t know whether JavaScript is enabled in the user’s browser. If all
goes well, the message will be removed by the JavaScript when it starts
up. Otherwise the `showWelcomeMessage` function is called, and one of the things it does is remove the message.

The function will be defined in the JavaScript file `hello.js`, but first we will need a little infrastructure. 

Functions for Adding to the DOM
===============================

While nowadays there are several JavaScript libraries that cover this sort of thing, for this project I wanted to have no dependencies (apart from `json.js`). 

Let’s start with a few shorthands for adding content to the DOM.  First, `getElement` for finding elements by id:

	function getElement(elementOrId) {
	    if (elementOrId.nodeType) {
	        return elementOrId;
	    }
	    return document.getElementById(elementOrId);
	}

If passed an element, it just returns that element. The idea is that all
functions that operate on a DOM element will accept either an element
object or the id of an element, and they will use `getElement` when
necessary to get the real element.

Here’s my way to add a child element to an element, inspired by Fredrik Lundh’s [ElementTree][] library:

	function subelement(elementOrId, tagName, atts, text) {
	    var elt = document.createElement(tagName);
	    if (atts) {
	        for (var key in atts) {
	            var value = atts[key];
	            if (typeof(value) == 'function') {
	                continue;
	            }
	            elt.setAttribute(key, atts[key]);
	        }
	    }
	    if (text) {
	        elt.appendChild(document.createTextNode(text));
	    }
	    getElement(elementOrId).appendChild(elt);
	    return elt;
	}

(This is the version that works on conforming browsers. Some
complications have to be added to also support IE6.) The idea here is to
compress three or four lines of DOM code in to one expression. For
example, to add a paragraph to a section you might have something like
the following:

	subelement(elt, 'p', {'class': 'lol'}, 'I can has cheesburger?');

Because
it returns the new child element, it can also be nested, as in

	var tbodyElt = subelement(subelement(elt, 'table'), 'tbody');

Its counterpart is `removeChildren`. This removes everything contained by a given element, preparing it for new content:

	function removeChildren(elementOrId) {
	    var elt = getElement(elementOrId);
	    var childElt = elt.firstChild;
	    while (childElt) {
	        var nextElt = childElt.nextSibling;
	        elt.removeChild(childElt);
	        childElt = nextElt;
	    }
	    return elt;
	}

This function also returns the element, saving its caller from also calling `getElement`.  To see the two functions in action together, we can look at `showLoading`, which displays a ‘Loading …’ message while we are waiting for the server:

	function showLoading(elementOrId) {
	    var elt = removeChildren(elementOrId);
	    subelement(elt, 'p', {'class': 'loading'}, 'Loading \u2026');   
	    return elt;
	} 

Using these it is straightforward to  create a function `pretty` that pretty-prints a JSON-style object, creating a table for an object, a `ul` list for an array, and a `div` for numbers and strings. 

Asynchronous HTTP
=================

Now we need a function for doing an HTTP request. The request is issued asynchronously, so this function returns immediately. At some future point when the response arrives, the function `callback` will be called.

	function beginRequest(method, uri, content, callback) {
	    var req = createXmlHttpRequestObject();
	    if (req) {
	        req.onreadystatechange = function () {
	            if (req.readyState == 4 /* complete */) {
	                if (200 <= req.status && req.status < 300) {
	                    var obj = req.responseText.parseJSON();
	                    callback(obj);
	                } else {
	                    showMessage(req.status + ' ' + req.statusText);
	                }
	            }
	        }
	        req.open(method, uri, true);
	        req.send(content);
	    }   
	}

This is perhaps a little simplistic since it does not do anything much about errors form the server—it will simply fail to call  callback.

Back to Hello World
===================

As I said earlier, all the above is infrastructure that will be used throughout the application. Here at last is the `showWelcomeMessage` function itself:

	function showWelcomeMessage() {    
	    var elt = showLoading('welcome');    
	    beginRequest('GET', '/', '', function (obj) {
	        removeChildren(elt);
	        pretty(elt, obj);
	    });
	}

The first line replaces the ‘no JavaScript’ message with ‘Loading …’. Then it starts an asynchronous request for `/`. Since `hello.html` is on the CouchDb server, this means `http://localhost:8888/` (unless you have changed the server’s configuration). When the server replies, the function 

	function (obj) {
        removeChildren(elt);
        pretty(elt, obj);
    }

is called. First it removes the ‘Loading’ message, and then it replaces it with a pretty-printed version of the JSON object from the server. 

Once I got this working, adding another function that requests a list of database names and displays them is easy to do.

<div><a href="http://www.alleged.org.uk/pdc/2007/hello_screenshot_1.png"><img src="http://www.alleged.org.uk/pdc/2007/hello_screenshot_1_408.png" width="408" height="321" alt="(screenshot)"/></a></div>

Here it is displayed in Mozilla Firefox with Firebug showing me the HTTP requests that have been issued by my JavaScript code.  Neaters!

How to Link to Databases
========================

My original idea was that the link for a database `perdita` would link to `db.html?db=perdita`, with the JavaScript code obtaining the database name from the query string.  This did not work, because CouchDb’s HTTP file-serving subsystem does not strip the query string  from the URL before looking for the file (so it looks for a file called `db.html?db=perdita`, which does not exist).  

So instead the links display the database information in the same page.

Modes and Modularity
====================

The first version of this code had the functions hiding and showing parts of the page explicitly.  This is OK for one or two sections that need to be switched on or off, but I decided I needed more structure if I am to make it work with database documents, databases, and the server views, plus whatever other views I want to add later. So I added support for application ‘modes’.

So far as the JavaScript is concerned, a mode just means a particular subset of the HTML in `hello.html` is visible.  The sections are all present in `hello.html`, with all but the initial selection hidden through their `style` attribute:

	…
	<div class="section" id="dbListSection">
		<h2>Databases</h2>
		<ul class="commands" id="dbListCommands"></ul>
		<div id="dbList"></div>
	</div>
	≈
	<div class="section" id="dbInfoSection" style="display: none;">
		<h2>Database Info</h2>
		<div id="dbInfo"></div>
	</div>
	≈
	<div class="section" id="docListSection" style="display: none">
		<h2>Documents</h2>
		<div id="docList"></div>
	</div>
	…

In the JavaScript there is a table of which sections are visible in which modes:

	var sectionModeLists = {
	    welcomeSection: ['welcome'],
	    dbListSection: ['welcome'],
	    dbInfoSection: ['db'],
	    docListSection: ['db', 'doc'],
	    docSection: ['doc'],
	    hello: ['welcome'],
	    trail: ['db', 'doc']
	};
 
Now whenever changing mode, we call `setMode` to hide or show them.

	function setMode(mode) {
	    for (var section in sectionModeLists) {
	        var modes = sectionModeLists[section];
	        if (typeof (modes) == 'function') {
	            continue;
	        }
	        var display = 'none';
	        for (var i = 0; i < modes.length; ++i) {
	            if (modes[i] == mode) {
	                display = 'block';
	                break;
	            }
	        }
	        var elt = getElement(section);
            elt.style.display = display;
	    }
	}

As an example, there is the `selectDatabase` function called when the user clicks on a database name:

	function selectDatabase(dbName) {
	    setMode('db');
	    ≈
	    var infoElt = showLoading('dbInfo');
	    beginRequest('GET', '/' + dbName + '/', '', function (obj) {
	        removeChildren(infoElt);
	        pretty(infoElt, obj);
	    });
	    ≈
		…
	}

Once this is all set up, only a little handle-turning is required to take care of the list of databases, the list of database documents, and displaying one document.

The Editor
==========

The editor used to change the values of a document is still a work in
progress. It works in a fashion similar to the pretty-printer function:
it iterates over the properties of the document, and creates HTML
elements depending on the type of value the property has. It keeps a
list of these HTML elements in a list, which it stores on the Save
Changes button. (I am making a point of *not* having a layer of business
objects between the document obtained from the server and the HTML used
to edit it, and all the application state is passed around as function
parameters rather than stored in global variables.)

The Save Changes button uses a variation on the ‘Loading’ conventions.
First, (obviously) the message is ‘Saving …’ not ’Loading …’. Second,
the HTTP request is made synchronously. This is important, because we
cannot safely dispose of the form until we know the changes truly have
been saved.

Forms don’t use the ‘mode’ system described above. Instead when a form is shown it is displayed on top of the rest of the page content, in a style similar to the sheets introduced with Apple’s Aqua conventions. This is the closest we can get to a modal dialogue box in a web page.

JavaScript and HTML as an Application Platform
==============================================

I started this project as an experiment to see how I took to the Ajax
style of web development. So far it has been fun—the work described here
took me about one working day (Saturday) and part of Sunday. Compared
with the dead weight of Microsoft Visual Studio .NET 2003 and Microsoft
SQL Server 2005 Management Studio, working with just a text editor
([TextMate][]) and occasional use of [Firebug][] felt practically
weightless.

This is something of a toy app; would this technique work for a larger
application? I think the mode concept provides a structure that could
handle navigation a fair bit more elaborate than that in Hello. At some
point keeping the entire app in one JavaScript file might make
collaboration between programmers difficult. And you need developers who
are not afraid of JavaScript and can work in a fairly disciplined
fashion without their hands being held.

In terms of scalability, this is probably the most scalable app I have
written—all the logic is in the user’s browser, which is the ultimate in
scalability, and CouchDb’s lockless concurrency is intended to make
horizontal scaling of the server a snap. Having been caught out by
database locking in the past, I think CouchDb’s locklessness is actually
as interesting a feature as its RESTiness.

Future Work
===========

I have created a sort of project notepad at
<http://hellocouchdb.jottit.com/>. This includes a page for [Future
Development Ideas][2]. Apart from fixing up obvious gaps (such as
compatibility with various browsers), I would like to make the document
editor cleverer about properties whose values are lists.

I would like to get Hello in to a state where it can be merged in with the CouchDb project files—since the script needs to be run on the CouchDb server to work, it would make sense for it to be bundled with the server. That’s why I have not bothered to set a proper project web site. 

Latest Version
==============

I have a new version 1.1 available as <a href"HelloCouchDb-1.1.tgz"><code>HelloCouchDb-1.1.tgz</code></a>, with [release notes][3] online.


  [1]: 09/16.html
  [2]: http://hellocouchdb.jottit.com/future
  [3]: http://hellocouchdb.jottit.com/v1.1
  [4]: http://www.couchdbwiki.com/index.php?title=Open_Project_Work_Items
  [ElementTree]: http://effbot.org/zone/element-index.htm
  [CouchDb]: http://couchdb.org/
  [TextMate]: http://macromates.com/
  [Firebug]: http://www.getfirebug.com/