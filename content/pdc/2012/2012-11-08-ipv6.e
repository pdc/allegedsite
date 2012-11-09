Title: Jumping on the IPv6 Express
Date: 2012-11-08
Topics: ipv6

I have started configuring my web sites to work with IPv6.

# The Slowest Rollout in Internet History

The transition to IPv6 (with 128-bit addresses) [is going slowly][9]. So slowly
that there are still wiki pages enumerating IPv6-enabled web sites.

This is because of various things, one of which, [described in this ten-year-old memo][1], is that all computers connected to the public Internet need to
be reconfigured to have an IPv6 address in addition to its existing IPv4
address, and until that day, no-one can manage without an IPv4 address. This
means there is no benefit in terms of relieving the shortage until every
sysadmin has upgraded every server. This makes it hard to motivate people to
meddle with their already-working servers, especially as patchy provision
meant some  customers may lose access to your site when you do (see [IPv6
brokenness and DNS whitelisting][7]).

Having said that, peer pressure is a wonderful thing, and it turns out that
even boiling the ocean has to succeed as a strategy eventually. [According to CISCO][8], 30% of the WWW is now accessible via IPv6.

# My Migration So Far

Lucky for me, [Linode][2] and [Gandi][3] are hip to IPv6, so once I
knew what I had to do it was relatively straightforward to set things up.

The problem is, *knowing what to do was a problem*. It took me a long time to
find information on what steps I actually needed to perform: while there are
myriad web sites bewailing the imminent exhaustion of the address space and
exhorting action, there are vanishingly few on what concrete steps someone who
just happens to be running a web server should do. So here is what I did.

First, [Linode have an option to add an IPv6 address automatically][6]: you just
reboot and your server wakes up with an extra address on its network device.
(The extra reboot was  also a chance for me to learn which of my servers were still
not configured to restart automatically.)

Now on my Linode dashboard I learn that one of my Public IPs is
`2a01:7e00::f03c:91ff:fe96:cabf/64`. The `/64` confused me (were they implying
I had an entire /64 subnet?) until my lodger told me to ignore it.

It turns out [the configuration change to Nginx][5] is fairly small: you change this:

    listen 80;

to this:

    listen [::]:80;

This says to listen to all IPv6 addresses (denoted by the special address
`::`). GNU/Linux networking automagically embeds IPv4 so that someone
connecting from 11.22.33.44 would appear to Nginx to be connecting from
`::ffff:11.22.33.44`.

Now all that remained was to edit the zone files (hosted on Gandi in my case)
to add at least three new records per site:

    @ 10800 IN AAAA 2a01:7e00::f03c:91ff:fe96:cabf
    ip4 10800 IN A 109.74.196.141
    ip6 10800 IN AAAA 2a01:7e00::f03c:91ff:fe96:cabf

The first adds the new address as an alternative for the domain. All the
existing `A` records   should also have a corresponding `AAAA` record added.
The second two are synonyms that only have the IPv4 or IPv6 address associated
with them (for testing, mostly). For example, I am updating my Nginx
configuration so that `ip4.spreadsite.org` and `ip6.spreadsite.org` are
alternative names for `spreadsite.org`. You only need to use them if you want
to force routing over a particular IP version.

# Validation and Verification

The final step was finding a way to test the results, since my ISP does not
yet support IPv6 for customers, so I can’t just connect to my site and see
what happens. One way is [IPV6 Test][4], which checks the `AAAA` record is
present and the site can be contacted, but it can only check it is accessible
from its location.

The other encouraging sign that it is working is I now see Google’s bot
crawling my site from an IPv6 address.



  [1]: http://cr.yp.to/djbdns/ipv6mess.html
  [2]: http://linode.com/
  [3]: http://gandi.net/
  [4]: http://ipv6-test.com/validate.php
  [5]: http://kovyrin.net/2010/01/16/enabling-ipv6-support-in-nginx/
  [6]: http://www.linode.com/IPv6/
  [7]: http://en.wikipedia.org/wiki/IPv6_brokenness_and_DNS_whitelisting
  [8]: http://blogs.cisco.com/news/ipv6webimpact/
  [9]: http://en.wikipedia.org/wiki/IPv6_deployment#Major_milestones