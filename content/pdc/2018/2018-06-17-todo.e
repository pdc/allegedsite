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

## Done

Main things to update:

* [Porting my Blog to Python 3][part1]
    * Port blog to Python&thinsp;3
    * Create Python&thinsp;3 virtualenv on the server
    * Address the issue with Fabric 1 not supprting Python&thinsp;3
* [Store Config in the Environment][part2]
    * Stop storing separate settings file for production: use environment instead
* [Let’s Try Gunicorn Instead][part3]
    * Address the issue with uWSGI not respecting Python version of virtualenv
* [Django Upgrade][part4]
    * Port blog to recent Django
* [No More Project Wonderful][part5]
    * Remove [Project Wonderful][] box (it’s already de-listed)
    * Use cache-busting URLs for style files so they can have longer expiry times.
* [Servers Need Locale][part6]
    * Fix old photo albums
* [Let’s Encrypt with Certbot][part7]
    * Support HTTPS-by-default

## To do

* Get other sites to work with HTTPS (some HTTP links are broken)
* See whether it it is straightforward to uprade to HTTP2
* Do I want to keep the Twitter button? Add a Mastodon button?
* Redo navigation to be less annoying
* [SVG fonts are no longer supoorted][2]
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
  [part4]: 07/14.html
  [part5]: 07/15.html
  [part6]: 07/16.html
  [part7]: 07/21.html
  [2]: https://www.w3.org/TR/SVG2/changes.html#fonts
