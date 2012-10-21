Title: OpenID on Intranets
Date: 2007-08-15
Topics: openid sso work
Icon: openid_symbol.svg

Quick answers to a couple of questions that came up when I was discussing [OpenID as part of a single-sign-on solution][1] at work.

  [1]: 08/13.html

Q. *Won’t OpenID allow people to log in using insecure authentication
servers, thus undermining the security of our system?*

A. No,
because we do not have to allow just any server to be used for OpenID.
We can restrict OpenID URIs to a white list of known good servers
through simple pattern-matching.

Q. *Our employees already have Global Employee Numbers; they won’t want to learn how to use OpenID URIs just to use your application.* 

Change the login form so that it asks for the GEN, and then adds the
and then the base address of the OpenID server automatically. E.g., they
enter `ABCD1234` and the login page expands it to
`http://openid.example.com/ABCD1234`).