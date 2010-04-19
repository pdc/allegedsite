<!-- -*-HTML-*- -->
<entry date="20030313" icon="rtl8139.jpg">
  <h>Second network card</h>
  <body>
    <p>
      A while back <a
      href="../2002/09.html#e20020921">I&nbsp;installed a second
      Ethernet card in my Linux box</a> and could not get it to work
      before the iBook returned to where it belonged.  Having had
      another  notebook computer visiting us last night, I finally got
      the thing up and running.
    </p>
    <p>
      All in all it was a simple matter of:
    </p>
    <ul>
      <li>
        Wasting time examining the floppy supplied with the card for
        evidence of a program for setting the card&rsquo;s <abbr
        title="Interrupt ReQuest number">IRQ</abbr>.
      </li>
      <li>
        Downloading <a
        href="http://www.scyld.com/diag/"><code>rtl8139-diag.c</code></a>
        and running it.  It informs me in no uncertain terms that
        I&nbsp;need to visit the <abbr title="Basic Input-Output
        System">BIOS</abbr> settings.  The error message has the
        important hint that there is no way to do this other than the
        BIOS set-up panel itslef.
      </li>
      <li>
        Shutting down the operating system so I could do this little
        thing.  Fiddling with the BIOS always makes me nervous, but
        after a couple of attempts I&nbsp;managed to get it working.
        I&nbsp;knew this when I&nbsp;rebooted Linux and it detected
        and activated the second network interface automatically.
      </li>
      <li>
        Changed the network settings for the borrowed laptop.  Poked
        it some more until it believed that the network was there and
        it was possible to ping back and forth along the wire.
      </li>
      <li>
        Changed Internet Explorer&rsquo;s own special control panel
        for the automatic dial-up.  One of the options makes it so
        that it does not dial up if there already is a working
        network.  Duh.  Now <abbr title="Microsoft Internet
        Explorer">MSIE</abbr> can visit <code>http://10.0.0.1/</code>
        but cannot resolve domain names.
      </li>
      <li>
        Changed my <a
        href="http://cr.yp.to/djbdns/run-cache-x.html"><code>dnscache</code></a>
        settings to permit my newly created
        <code>192.168.100.0/24</code> network to use it.  (A simple
        matter of <code>touch
        /services/dnscache/root/ip/192.168.100</code>, as it turns
        out.)
      </li>
    </ul>
    <p>
      At this point it was possible to browse the <abbr
      title="World-Wide Web">WWW</abbr> from the laptop.  Yay.
    </p>
  </body>
  <dc:subject>network</dc:subject>
  <dc:subject>djbdns</dc:subject>
</entry>
