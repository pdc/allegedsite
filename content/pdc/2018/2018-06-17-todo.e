Title: Running to Stand Still
Topics: meta
Date: 2018-06-17

How tedious are blog posts about the process of hosting a blog! But how
pleased is 2018 me that [past me documented the process][1] since otherwise I
would have no idea where any of it is.

There are a few things that mean I need to rework my blog software, for various reasons:

* Django is transitioning to being Python-3-only, so I need to switch to Python&thinsp;3
* [Project Wonderful][] is shutting down, so I need to remove it from the layout
* It’s long past time I made this site work with HTTPS (no idea if HTTP2 an option)
* Some parts of the site using SVG have succumbed to bit-rot

## Todo List

Main things to update:

* [Porting my Blog to Python 3][part1]
    * Port blog to Python&thinsp;3
    * Create Python&thinsp;3 virtualenv on the server
    * Address the issue with Fabric 1 not supprting Python&thinsp;3
* [Store Config in the Environment][part2]
    * Stop storing separate settings file for production: use environment instead
* [Let’s Try Gunicorn Instead][part3]
    * Address the issue with uWSGI not respecting Python version of virtualenv

TODO:

* Port blog to recent Django
* Remove [Project Wonderful][] box (it’s already de-listed)
* Do I want to keep the Twitter button? Add a Mastodon button?
* Fix old photo albums
* Support HTTPS and, if it is straightforward to do so, HTTP2
* Redo navigation to be less annoying
* New style sheets because why not make more work for myself
* Look in to relme auth, webmentions, microblogging
* Update server to the latest Ubuntu LTS

I am updating this list after the fact (I did not think of all these things in
one sitting) and I will write up the steps and link to them from this page.


  [1]: ../2012/11/03.html
  [project wonderful]: https://www.projectwonderful.com/thanks.php
  [part1]: 06/24.html
  [part2]: 07/07.html
  [part3]: 07/08.html
