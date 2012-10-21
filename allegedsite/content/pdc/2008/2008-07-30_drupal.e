Title: First Adventures in Drupal
Image: ../icon-64x64.png
Date: 2008-07-30
Topics: drupal php web python work 

My current project at work has involved a quick-and-dirty crash-course in [Drupal][], a [content-management system][] written in [PHP][]. Here are some of my initial impressions.


A Little About PHP
==================

PHP is a programming language originally created for writing web pages. It falls in to
roughly the same category of language features as [Perl][], [Python][], and [JavaScript][].
I will mainly be describing it relative to my experience of programming in Python.

Language quirks
---------------


PHP interestingly combines the two main data structures built in to scripting languages in to one array datatype: to get the effect of a list you use `array(23, $foo, 'bar')`, to get a dictionary you use `array('foo' => 42, 'bar' => 69)`, and there are special rules for what happens if you combine the two in one array. This is either ingenious or dumb; I haven’t decided which.

<div class="wide_photo_right">
	<a href="http://www.flickr.com/photos/pdc/2707519742/" title="Pondfest 2 by Damian Cugley, on Flickr"><img src="http://farm4.static.flickr.com/3067/2707519742_087e03a90b_m.jpg" width="240" height="240" alt="Pondfest 2" /></a>
</div>

PHP has a couple of important flaws. First, as well as implicitly creating local variables
when you assign to them, as Python does, it also implicitly creates variables when you
first read from them. This means that if you write

	function calculate_quintessence($foo) {
		$result = complicated_calculation($foo);
		return $resukt;
	}

then your function always returns NULL; this will cause a bug that only manifests 500 lines later when `$quintessence` is unexpectedly null. The Python equivalent would throw an exception because you tried to use an uninitialized variable.

Second, there is no modularization. All functions are global, so they all have to start with some module-specific prefix to prevent clashes. This makes your code rather long-winded as you have a lot of `foobar_do_this(foobar_get_that())`. It also means the built-in functions—and there are many—are a chaotic mixture of names that get longer the more recently the function was added to the core.

HTML
----

What makes PHP
HTML-specific is a special construct `?>...<?php` for emitting HTML direct in to the current page:

	if ($is_logged_in) {
		?>
	<p>
		Welcome, <?php
		print $user_name;
		?>!
	</p><?php
	}

This is only useful in direct code, not in function definitions. For simple applications of PHP, the whole site is written in this style, with almost no function definitions—and this results in an enormous ball of [hair][] that is hard to
maintain. In a structured system like Drupal you hardly ever use direct HTML (unless
writing themes).

Note that PHP treats HTML code as unstructured character data: it does not have any concept
of HTML elements and attributes, and can do nothing to protect you against mismatched tags
or other HTML syntax errors. Neither can it parse and process XML or HTML by default; there
are extensions that handle XML, but they are not considered core to the language.


Drupal
======


The Drupal system is a triumph of architecture over the deficiencies of its implementation
language. 

<div class="wide_photo_right">
	<a href="http://www.flickr.com/photos/pdc/2707521106/" title="Pondfest 3 by Damian Cugley, on Flickr"><img src="http://farm4.static.flickr.com/3227/2707521106_495775e224_m.jpg" width="240" height="240" alt="Pondfest 3" /></a>
</div>

As a CMS it starts out very basic, but allows features to be added by installing a
bewildering array of **[modules][]**. You even need to install (or at least enable) several
modules to get what my boss thinks of as the usual CMS features like categories and content
types with additional fields.  You can also change the appearance by switching between **themes**—for example, the primary links might be shown as buttons along the top of the page, or as tabs underneath the heading, depending on the theme you choose.

The architectural goodness comes in to play when you are creating extensions of the your own—that is, when using it as the core of a web application.

Modules and Hooks
-----------------

We wanted to allow users to create new sorts of data, so we needed to write our own module,
This is pretty straightforward [tutorial on creating modules][1] that got me up to speed on
Drupal’s conventions for code organization and hooks from a standing start in no time.

Hooks are just functions following a particular  name pattern. For example, the hook for your module to report which blocks it provides is `hook_block`, and to implement it you just define a function called `foo_block` (where `foo` is the name of the module). This tends to mean that a module is a collection of oddly named functions that don’t directly reference each other, since they are designed to be called by the system at various points.

Themes
------

Drupal’s approach to generating the HTML of the page is layered: one part of your module creates PHP data structures describing what is desired (e.g., nested arrays representing a menu structure, or nested arrays representing the items on a form), and **theme hooks** are used to translate these data structures in to HTML. The HTML is assembled bottom-up: when translating a menu, first menu-item links are formatted with the `menu_item_link` hook, then the `menu_item` hook is invoked with the formatted link as an argument, and finally the `menu` hook is invoked with the formatted menu items as a parameter.  Eventually the menu is assembled in to a block with a block hook and this goes in to the page via the `page` hook. You tweak the output by defining overrides for the individual hooks, leaving the rest with the system- or module-defined defaults. 

<div class="wide_photo_right">
<a href="http://www.flickr.com/photos/pdc/2706698603/" title="Pondfest 1 by Damian Cugley, on Flickr"><img src="http://farm4.static.flickr.com/3058/2706698603_bf01f4d62f_m.jpg" width="240" height="240" alt="Pondfest 1" /></a>
</div>

It follows that what my boss thinks of as a template actually comprises two parts: a content-type definition that says what extra fields (if any) the article needs over and above the usual, and (possibly) theme hooks to tweak it is displayed.

The theme system is very flexible, and it has taken me a little while to work my way
through it (in the two to three weeks I have been working on Drupal so far). The main
confusion is working out which theme hooks are applicable when; there is a module called
[devel][2] that can give you important hints, but it breaks on the HTML I am working on (possibly because my HTML has the Drupal-conventional CSS classes stripped out in favour of our designer’s).

One thing I have not worked out yet is what you do if you need context-sensitive theming:
the bottom-up nature of the process means that when you are formatting a menu item you
don’t know whether it is in the main menu or the side menu, and if they require different
HTML, this is a problem. The correct solution is to use the same HTML and make the
different appearances happen in CSS, but when we are working from HTML supplied by a
designer, we do not have the freedom to do that.

The other thing that foxed me is the system of [suggestions][]. For hours I tried to find a reliable way for a page template (`page.tpl.php` file) to determine whether it was showing one article or an index page; it turns out the correct solutions is to add two more files, `page-front.tpl.php` and `page-node.tpl.php`,as these override the default template file under those conditions. Obvious in retrospect.

Theming doco:

- [Theme Guide][];
- [Core templates][]—you override these by creating a same-named file in the theme’s directory;
- [Suggestions][] implemented by core themes;
- [Default theme implementations][]—you override these by creating a function in `template.php` with the `theme_` prefix changed to the theme name;
- [Theming the Maintenance Page][];
- [Default baseline variables][]—meaning variables available in all template files.

Form API
--------

Drupal has a Form API that builds on the theming ideas and takes them further. The form as a while is represetned as one giant array of arrays, with each form item represented by an array like

	array(
		'#type' => 'textfield', 
		'#default_value' => 'Hello, world',
		'#max_length' => 64,
		… more attributes …
	)

and further grouped in to fieldsets and so on. As well as using theme hooks to translate the form items in to HTML and assemble those in to the finished form—complete with fancy collapsable fieldsets and stuff—it also handles the submission of the form the next time the page is processed, plugging the submitted values in to the data structure for your own processing.

<div class="wide_photo_right">
<a href="http://www.flickr.com/photos/pdc/2136255783/" title="Glamour Chair and Evil Ice-Cream Cone by Damian Cugley, on Flickr"><img src="http://farm3.static.flickr.com/2009/2136255783_9e9a4c5041_m.jpg" width="240" height="180" alt="Glamour Chair and Evil Ice-Cream Cone" /></a>
</div>

Things get a little more complicated when you want the form layout to be different from the
default one. For example, for our stuff we often wanted to have *n* repeated sets of fields
to be shown as rows in a matrix rather than as individually labelled items. To do this you
add `#theme` attributes to the array representing the group of items, which involves
inventing *new* theme hooks, specific to your requirements. The new theme function can use the built-in theme hooks to format the items, and only has to worry about supplying the HTML that produces the table row or whatever.

The payback for all this abstraction is that it is possible to write a module that supplies
some forms that can be slotted in to radically different-looking websites without looking
out of place. It might be considered overkill when (as we are) the form is intended to be
used in one website only, but in the end we have gone along with the Forms conventions so
as to be able to exploit the other functionality that comes ‘for free’ with it.

Not to mention we cannot trust our customer not to rebrand (or have a rebranding thrust upon
them) during the lifetime of the project. It may be that the extra flexibility pays off
eventually.

- [Form API Quick Start](http://api.drupal.org/api/file/developer/topics/forms_api.html)
- [Form generation](http://api.drupal.org/api/group/form_api/6)
- [Form API Reference](http://api.drupal.org/api/file/developer/topics/forms_api_reference.html)



Database Access
---------------

Drupal inherited a slightly stupid database API from PHP. I am used to the Python style (documented in [PEP 249][]) which goes something like:

	c = con.cursor()
	c.callproc('check_login ?, ?', (login, pwd))
	row = c.fetchone()
	if row:
		uid, real_name = row

<div class="wide_photo_right">
		<a href="http://www.flickr.com/photos/pdc/2388769321/" title="Robot Brain Shavings by Damian Cugley, on Flickr"><img src="http://farm3.static.flickr.com/2251/2388769321_6706fbac2a_m.jpg" width="240" height="180" alt="Robot Brain Shavings" /></a>
</div>

The point here is that the `user` and `pwd` parameters are passed via the database API;
correct quoting is not an issue because they are never spliced in to the SQL string. The
API also understands stored procedures if the database supports them. The PHP equivalent
goes something like this:

	$c = db_query('select uid, real_name from users where login = \'%s\' and pwd = \'%s\'',
		login, pwd);
	if ($user = db_fetch_object($c)) {
		$uid = $user->uid;
		$real_name = $user->real_name;
	}

This obviously inherits its conventions from when PHP used `sprintf` to generate SQL
clauses and was open to [SQL injection][] attacks. This has been mitigated in Drupal by
having it process string-valued parameters by doubling the quotes in them, but it still
works by creating a SQL string and sending that to the database. At the very least this is
denying some databases opportunities for optimization.

Drupal attempts some database-independence through the [Schema API][], which generates and
checks the intended database schema of your module against what is actually to be found in
the database. It lacks support for date-time datatypes the database may supply; the
convention in the PHP world is that you instead store a UNIX timestamp (number of seconds
since 1 January 1970) in an integer-valued field and convert it when needed.

Impressions
=====

As a CMS, Drupal starts simple and makes it easy to extend its functionality by adding modules. 

<div class="wide_photo_right">
<a href="http://www.flickr.com/photos/pdc/108171976/" title="Playmozilla made from Playmobil by Damian Cugley, on Flickr"><img src="http://farm1.static.flickr.com/51/108171976_05552cc86f_m.jpg" width="240" height="180" alt="Playmozilla made from Playmobil" /></a>
</div>

As a programming platform it is pretty good, and is probably as good a development
environment as could be expected given that it is based on a language like PHP. (Often my
biggest blockers are trying to guess what function name PHP will have used for some common
and obvious bit of functionality, like deleting an item from an array.)

For an application not needing the CMS features I would prefer a Python web framework; if I
were developing some application from scratch I would personally consider starting with
WSGI or something based on the Google App Engine conventions. But for writing a web
application that gets stuck on the side of a site that is mostly about information, blogs,
or forums, Drupal’s CMS features give you a basic framework and set of URL conventions that
are a good starting point.



  [Drupal]: http://drupal.org/
  [modules]: http://drupal.org/project/Modules
  [Theme Guide]: http://drupal.org/theme-guide
  [Core templates]: http://drupal.org/node/190815
  [suggestions]: http://drupal.org/node/190815#template-suggestions
  [Theming the maintenance page]: http://drupal.org/node/195435
  [Default baseline variables]: http://drupal.org/node/226776
  [Default theme implementations]: http://api.drupal.org/api/group/themeable/6
  [content-management system]: http://en.wikipedia.org/wiki/Content_management_system
  [PHP]: http://php.net/
  [Python]: http://python.org/
  [Perl]: http://www.perl.org/
  [JavaScript]: http://en.wikipedia.org/wiki/JavaScript
  [PEP 249]: http://www.python.org/dev/peps/pep-0249/
  [SQL injection]: http://en.wikipedia.org/wiki/SQL_injection
  [hair]: http://www.retrologic.com/jargon/H/hair.html
  [Schema API]: http://drupal.org/node/146843
  [1]: http://drupal.org/node/206753
  [2]: http://drupal.org/project/devel