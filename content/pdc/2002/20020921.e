<!-- -*-HTML-*- -->
<entry date="20020921" icon="../icon-64x64.png">
  <h>Time to add a second Ethernet card?</h>
  <body>
    <p>
      My network at home uses what is now old-fashioned coax with BNC
      connectors.  New computers&mdash;such as, for example, a
      visiting iBooks&mdash;only have connectors for new-style cat-5e
      cables.  Rather than replace my entire home network, I&rsquo;m
      experimenting with a second
      <abbr title="Network Interface Card">NIC</abbr> and a crossover
      cable.  This means powering down my desktop (uptime: up 170
      days, 15:55).  
    </p>
    <p>
      <em>Update:</em>
      some hours later I&nbsp;have managed to get my <em>first</em>
      card working again, after Red Hat&rsquo;s auto-configuration
      clobbered my settings!  My attempts to load the module for
      card #2 so far unsuccessful.  I have downloaded a newer kernel
      (I&nbsp;was running 2.2.12, this is 2.2.22),
      which is currently compiling.  Maybe it will do better.
      &para; It has now finished after 15&frac12; minutes.
      I&nbsp;will not try rebooting until tomorrow, however.
    </p>
    <p>
      <em>Update (Sunday):</em>
      Turns out that kernel 2.2.22 hangs on boot-up.  Argh.
      Returned to 2.2.12 for now.
      On the
      otherhand, I&nbsp;discovered that <code>make modules
      modules_install</code> is different from merely <code>make
      modules_install</code>.  It appears that the install target does
      not imply actually building the modules?  Anyway, I&nbsp;did
      this and I&nbsp;now have an <code>rtl2039.o</code> that can be
      loaded with <code>modprobe</code>.  Alas! trying to bring up the
      interface complains of a &lsquo;Resource temporarily
      unavailable&rsquo;, which I&nbsp;take to mean that the card
      needs to have an <abbr title="interrupt request">IRQ</abbr>
      assigned to it, something that may be doable through the BIOS?
      Something to try later in the week.
      I&nbsp;have other things to do today.
    </p>
  </body>
  <dc:subject>network</dc:subject>
  <dc:subject>hardware</dc:subject>
</entry>
