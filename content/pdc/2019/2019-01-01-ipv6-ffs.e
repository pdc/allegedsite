Title: IPv6 Wastes More of My Time
Date: 2019-01-01
Topics: deployment ipv6 nginx

Because of IPv6 I have wasted hours trying to get ooble.uk certified by Let’s Encrypt.


# Let’s Encrypt and Certbot

This is the system for automatically obtaining TLS certificates so your web
site can support access over HTTPS instead of HTTP. IT is part of an effort to
get sites to use HTTPS everywhere, making it harder to spy on what sites you visit.

This works using the ACME protocol by having me run a program Certbot modify
my NGINX setup to prove to the certification-cereating machinery that I
actually control the server `ooble.uk`. It creates files on my sever and tells
the remote server to read them via HTTP.


# What Went Wrong

When it tried to verify my site I got this baffling message:

    IMPORTANT NOTES:
     - The following errors were reported by the server:

       Domain: ooble.uk
       Type:   unauthorized
       Detail: Invalid response from
       http://ooble.uk/.well-known/acme-challenge/bXdTW9PsdQ2mljLSHsjv6Lh7ksvgCyDm6g784ecGm6I:
       "<html>\r\n<head><title>404 Not Found</title></head>\r\n<body
       bgcolor=\"white\">\r\n<center><h1>404 Not
       Found</h1></center>\r\n<hr><center>"

       [… three more of the same …]

       To fix these errors, please make sure that your domain name was
       entered correctly and the DNS A/AAAA record(s) for that domain
       contain(s) the right IP address.

I tried again using manual mode. This works by instructing you the human to do
the changes it would have made before sending the signal to the certifying
server. After much tedious copying of files and checking the special URLs
worked as expected I set it verifying again, and got the same messages as
above.

This was crazy: the ACME server was getting a 404 from a URL that I could
verify with `curl` on my Macbook, or `wget` on my Ubuntu server, not to
mention in my web browser.


# Root Cause

It seems that two things were happening that I had not expected.

First, my other sites were originally set up with both IPv4 and IPv6 support.
Certbot saw this and told the ACME server and it therefore tried to access my
special URLs over the IPv6 network; and

Second, because I had not included explicit `listen` directives in the
`ooble.uk` confiuguration, it used a default which meant it was not listening
on IPv6.

I could show this using the `-6` command-line option to `wget`: this
constrains it to IPv6 in the same way and also got a 404.


# Fix

The fix for this was to add the `listen` directive. And then change it several
times because

* If you specify `listen` attributes then they must all match (which is odd given if you omit the directive it does not use that common value as the default); and

* it seems to want an exact token-for-token match, so did not like `listen 80` but wanted
`listen *:80` and did not like `listen [::]:80 ipv6only=on` but insisted on
`listen [::]:80` (which surely has the same effect as `ipv6only` is on by default).

So after several iterations of permuting the configuration file I managed to
get it to work with IPv6, and hence could run the `certbot` command that does
everything automatically.


# Conclusion

Once again IPv6 demonstrates its ability to waste sysadmins’ time.
