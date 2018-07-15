Title: No More Project Wonderful
Topics: projectwonderful meta
Date: 2018-07-15

I have removed the ad box powered by Project Wonderful.

Part 5 of the [Running to Stand Still][todo] series.


# Project Wonderful

This is because [Project Wonderful is shutting down][1] this summer. This is a
great pity, because it was one of the few attempts at an ethical advertising
model online. From their post:

> When we started working on Project Wonderful in early 2006, it was with the hope that online advertising could be something good, something that you'd want to see. We were always the odd company out: we didn't track readers, we didn't sell out our publishers, and we never had issues with popups, popunders, or other bad ads the plague the internet - because our technology simply wasn't built to allow for that.

Advertising companies are engaged in a destructive arms race over who can do
the most intrusive tracking of people’s habits and most intensly violate their
privacy. There is no niche for an ethical advertiser.


# Technically

As well as removing the JavaScript I had to adjust the layout of the page to
no longer accomodate a blank ad box.

This change is going to be delayed by a day because I use a 1-day cache header
on my static files. So I have taken the plunge and activated
[ManifestStaticFilesStorage][2]. This does the thing where static files gain
an extra hash in their name which varies by content, so I can give them long
expiry times because if they change their names will change.


# Lessons

There is no niche for an ethical advertiser.

Social media sites, funded by advertising, must  optimize their experience to
keep people wasting time on their site rather than someone else’s. We complain
about the changes to the timeline algorithm, but after we have complained we
have nowhere else to go so we carry on scrolling. I dread to think what they
are currently cooking up for the next iteration.

The GDPR is an attempt to stem this degeneration but it is probably too late.
Alerting people to privacy violations is all very well and good but if there
is no alternative site to switch to with a better policy, then all that
happens is we feel cross and helpless. We have no choice but to consent to
being tracked if we want to carry on as usual—which puts us in a worse
position than before.


  [todo]: 06/17.html
  [1]: https://www.projectwonderful.com/thanks.php
  [2]: https://docs.djangoproject.com/en/2.0/ref/contrib/staticfiles/#manifeststaticfilesstorage
