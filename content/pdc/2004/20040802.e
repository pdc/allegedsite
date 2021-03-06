Title: Demand-dialled modem configuration on Debian (Sarge)
Image: ../icon-64x64.png
Date: 20040802
Topics: modem debian

Debian GNU/Linux has excellent configuration dialogues for almost every
aspect of the newly installed operating system. One fly in the ointment
is that -- just as when I installed Red Hat 6.1 six years ago -- they do
not account for people who might want their sysem to automatically dial
up to the internet on demand. (For the sake of Google, I mention the
terms
_auto-dial_, _autodial_, and _intermittent connection_.) 

Nowadays if one is configuring a PPP connection, chances are excellent
that one's ISP is the other peer, in which case demand-dial is surely
the obvious choice (unless there is some subtle problem with it I am unaware
of). As it is it seems the only way is, after running `pppconfig`, to
enable demand-dialling, one must read the `pppd` documentation and then
edit `/etc/ppp/peers/provider` by hand to add `demand` and `idle`
keywords. 

One great advantage of demand-dialling is that it simplifies the rest of
the configuration. For example, I use *my* modem to connect to [Demon
Internet][1] to collect mail and for that I need to set my PPP
connection to (a) not be `defaultroute`, and (b) to route packets for
[Demon's SMTP servers][2] to the modem (rather than via my broadband
gateway). This is because Demon uses SMTP to send me my mail, triggered
by my modem dial-up, and restricted to the modem connection for security
reasons. 

Now *without* demand dialling, this is tricky: you cannot use Debian's
standard repository for network info, `/etc/network/interfaces`, because
the `pppd` command cannot instantly enable the interface, and so the
`on` commands in the `interfaces` file will fail; as a result, I was
instructed to create scripts in `/etc/ppp/if-up.d`, which is a
nontrivial proposition. I wasted several evenings over this (and
eliminating red herrings like `wvdial`). But with demand dialling, I can
create routes via `/etc/network/interfaces` and it all just works. Yay!

Now all I need to do is add a configuration file for hot-plug events
(my modem is on a PC Card) and add a `cron` job to ping
`demon-du.demon.co.uk` once a day to cause the demand dialler to dial
Demon.

  [1]: http://www.demon.net/
  [2]: http://www.demon.net/helpdesk/faq/server_address.shtml "Server addresses for Demon Internet"
