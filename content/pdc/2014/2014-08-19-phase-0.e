Title: Kanbo Revivifivation Phase Zero

The aim of this exercise is to get Kanbo up to the latest platform (Django
1.6) and to get its deployment system closer to a [twelve-factor app][1].

# Django 1.4 to Django 1.6

The major changes—as discussed earlier—is changes to the details of URLconf and `{% url %}` tags, and (in some of my projects) the removal of the `markup` app.

I started as I always do by bungling the upgrade of the [virtualenv][] to the latest [PyPy][]. The lesson (which I think I learned last time and forgot) is to delete or rename the old virtual environment before creating its replacement: my first attempt ended up with an old version of `pip` which did not work and could not be upgraded.

Updating the URLconf is required because the imports used have changed since 1.4. While I was at it I decided to modernize it as best I can in anticipation of the [eventual deprecation and removal of the `patterns` function][2] and dropping of support for strings as view specs within URLconfs. I thought these were due to be deprecated in 1.7 but now it seems they will be sticking around a bit longer.

In the process I discovered to my chagrin that I have not been using some of the most useful URLconf features. One is that you can factor out common parts of URLs using `include` inline, not just by including a complete other URLconf, and  the parameters from the prefix will be passed to the view. My old code looked a bit like this:

    urlpatterns += patterns('kanbo.board.views',
        url('^bags/(?P<bag_id>\d+)/arrangement$', 'tag_arrangement', name='tag-arrangement'),
        url('^bags/(?P<bag_id>\d+)/jarrange$', 'tag_arrangement_ajax', name='tag-arrangement-ajax'),
    )

With the new system it becomes something like the following:

    from kanbo.board import views

    urlpatterns += [
        url(r'^bags/(?P<bag_id>\d+)/', include([
            url(r'^arrangement$', views.tag_arrangement, name='tag-arrangement'),
            url(r'^jarrange$', views.tag_arrangement_ajax, name='tag-arrangement-ajax'),
        ])),
    ]

The `patterns` function has been replaced by a plain list, and the strings with the view functions.

My reader may be wondering why it is that using three lines of code to define two URL patterns is better than using two, but in more complex cases factoring out the common prefix makes the whole thing easier to read and maintain.


# Ubuntu 12.04 LTS to Ubuntu 14.04.1 LTS (Trusty Tahr)

Yes, it’s been a while since I upgraded the operating system on my hobby server—657 days, according to the age of my last manual backup.  My approach to upgrading is to follow [Linode’s advice on upgrading to a new release][3] even though it still refers to the last release but one.

I followed the recipe and everything went according to plan with one exception: all my websites vanished from the internet.


## IPv6 Punishment

The big gotcha was that Nginx has changed its configuration format in a way that stopped all my sites from working. The crux is the `listen` directive. After endless trial-and-error I had it set as follows:

    listen [::]:80;

Before I upgraded, IPv4 requests would be transmorgified in to IPv6 requests at the operating-system level, and so this would make my server work both for IPv4 and IPv6 clients.

As of Nginx 1.3.x, this directive is interpreted as being IPv6-only. As a result, I had inadvertently configured my web sites to refuse connections to the >99% of the web that still uses IPv4 (presumably the <1% of the internet using IPv6 would have seen my sites fine).

After a subjective eternity of panic over my broken web sites, I discovered the new correct configuration is as follows:

    listen *:80;
    listen [::]:80;

This is more sensible in some ways (IPv4 and IPv6 specified separately), but I could not use it earlier because it didn’t work.

The upshot of all this was that I needed to update the dozen individual `.conf` file for  my servers. Fortunately `sed` can automate most of this:

    sudo sed -s '/listen \[::\]/ i\
        listen *:80;' -i.bak alleged.conf

After updating the files I did `sudo nginx -s reload` and all was well.

This is typical of the [great IPv6 transition disaster][4]: a feature change that kills all web sites that have been foolish enough to enable IPv6 support alongside IPv4 gets through because no-one really cares that much about making IPv6 work yet. We know that fusion power, electric cars, and IPv6 are the future, but the route to get there gets murkier every year.



  [1]: http://12factor.net/
  [2]: https://code.djangoproject.com/ticket/22218
  [3]: https://www.linode.com/docs/security/upgrading/how-to-upgrade-to-ubuntu-12-04-precise
  [4]: http://arstechnica.com/business/2010/09/there-is-no-plan-b-why-the-ipv4-to-ipv6-transition-will-be-ugly/
  [virtualenv]: http://virtualenv.readthedocs.org/en/latest/
  [pypy]: http://pypy.org/