Title: That Cache-breaking Trick for Stylesheets With Infinite Expires Settings on Nginx
Date: 2012-09-03
Topics: nginx

If you want your web site to be fast under load (which I theoretically do, even if none of my personal sites have exactly made the big time yet), then one thing you do is set a long expiry time on your static assets like stylesheets. But when you change the files punters do not see the new version for days. Here’s the simple trick for getting around this without being wildly inefficient.

The problem starts with assets like stylesheets and javascript. These are often simple files—no dynamic changes based on the database or who is requesting them—and so we can speed up the appearance of the site by allowing web browsers to cache them for a long period. So I hive them out on to a separate domain (e.g., `static.caption.org` for files used by `caption.org`) with settings in Nginx like this:

    server {
        listen 80;
        server_name static.caption.org;

        location / {
            root /home/caption/static;
            gzip on;
            gzip_types text/css text/javascript;
            gzip_vary on;
            gzip_disable msie6;
            expires 7d;
            add_header Cache-Control public;
        }
    }

The `expires` line tells the recipient they can use that copy of the file for up to a week before they need to request a new copy. Some browsers may be able to take advantage of that by also caching the parsed version of the file and so save on processing time. People who get their internet access through a shared proxy (many ISPs set this up without telling you) will also benefit because the proxy can use its cached copy.

The problem is, when I want to tweak the stylesheet, it will take up to a week before the changes are visible to regular visitors. In fact the people most affected by this are the developers and the people they are trying to demonstrate the changes to (the customer, or in my case the rest of the committee). One way some web frameworks address this is to uniquify the URL by adding a fake query parameter to the HTML `link`:

    <link rel="stylesheet" type="text/css"
        href="http://static.caption.org/2012/base.css?o=2012090201">

[Google recommend against this][1] because some caches treat any URL containing a question mark as uncacheable. I could just change the file name of the stylesheet on disk, but that would be inconvenient. What I can do instead is add a rewrite rule to Nginx as follows:

    location / {
        rewrite ^(.*)\.[0-9]+\.(css|js|jpg|jpeg|png|gif)$ $1.$2 break;
        …
    }

This says that a request for `/2012/base.2012090201.css` will be rewriten to `/2012/base.css`
before it tries to find the file. In the HTML it looks like this:

    <link rel="stylesheet" type="text/css"
        href="http://static.caption.org/2012/base.2012090201.css">

Because it looks like a normal (query-string-free) URL, this is OK with Squid and other proxies.

The next stage would be to crate a custom tag that takes a file name and munges it to include the URL fingerprint automatically. As it is, I need to update the digits by hand. This is not enough of a problem with the current version to be bothered to fix.





  [1]: https://developers.google.com/speed/docs/best-practices/caching