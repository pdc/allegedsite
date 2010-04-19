<!-- -*-HTML-*- -->
<entry date="20021125" icon="../2003/picky-80x80.png">
  <h>Picky Picky Game: minimal voting</h>
  <body>
    <p>
      <em>(Sunday night.)</em>
      Still nothing up for you to see yet, I&rsquo;m afraid.  (Apart
      from anything else, I&nbsp;need to ask 
      <a href="http://www.humboldt.co.uk/">my host</a> to install a few
      Python packages...)  But I&nbsp;do do now have the start of the
      second CGI script, the one that accepts reader&rsquo;s votes for
      the current round of pictures.  These votes later are used to
      decide which picture to use for that panel of the comic strip.
    </p>

    <p>
      At present the script accepts your vote but does not display
      them in any way.
      If you vote again, your previous ballot is silently overwritten.
      I&nbsp;plan 
      to support <a href="http://www.idhop.addr.com/av/">Approval
      Voting</a> in future by having a page where you have a checkbox
      for each candidate picture and can select as many as you like.
    </p>
    <p>
      The word &lsquo;your&rsquo; is a little misleading; we use
      people&rsquo;s IP addresses as their identifiers, which sort of
      works most of the time, but means that people sharing a proxy
      server will end up sharing a vote.  The alternative (requiring
      users to register in order to vote) is not likely to work
      because noone will want to register.
    </p>
    
    <p>
      <em>Update (Monday night)</em>:
      The voting form now shows you the pictures with checkboxes.
      When you first visit the page, the picture you cloicked on is
      ticked, but then you can tick as many more as you like.  Because
      of the way HTML forms are processed, each form parameter is
      potentially a sequence anyway, so the code for each time around
      the voting form can be exactly  the same.  The code that adjusts
      the totals is very simple:
    </p>

    <pre>def vote(self, uid, pns):
    """Register a vote from the user identified by uid.

    uid is an integer, uniquely identifying a voter.
    pns is a list of picture numbers
    """
    oldPns = self.userVotes.get(uid, [])
    if pns == oldPns:
        return
    for pn in oldPns:
        self.pictures[pn].nVotes += -1
    for pn in pns:
        self.pictures[pn].nVotes += 1
    self.userVotes[uid] = pns</pre>

    <p>
      The first line retrieves that user&rsquo;s old ballot, if any.
      The first <code>for</code> statement reverses the effect (if
      any) of their former vote, the second counts the new vote.  
      Finally the &lsquo;ballot&rsquo; is saved for later.  Behind the
      scenes, <a href="http://zodb.sourceforge.net/"><abbr
      title="the Z Object Database">ZODB</abbr></a>
      takes care of reading the old data in off disc and 
      (when the transaction is committed) saving the updated
      data.
    </p>

    <p>
      My paid job involves writing a web application as well, except
      this one uses Microsoft <abbr title="Active Server
      Pages">ASP</abbr>&nbsp;.Net linked via <abbr title="Active Data
      Objects">ADO</abbr>&nbsp;.Net to Microsoft <abbr
      title="Structured Query Language">SQL</abbr>
      Server&reg;&nbsp;2000.  To do a similar job to the above
      snippet, I&nbsp;would be writing two <abbr title="Structured
      Query Language">SQL</abbr> stored procedures (one to retrieve
      the exisiting ballot, one to alter the ballot).  Invoking a
      stored procedure is several more lines of code in the <abbr
      title="C Sharp">C&#x266F;</abbr> or <abbr title="Microsoft
      Visual Basic">VB</abbr>&nbsp;.Net layer as you create a Command
      object, add parameters to it, execute it, and dispose of the
      remains.  (Or you can create DataSet objects which are even
      worse, but have specialized wizards to help you draft the code.)
      The actual algorithm (the encoding of the business logic) would
      be buried in dozens of lines of boilerplate.  By comparison, the Python+<abbr
      title="the Z Object Database">ZODB</abbr> implementation is a
      miracle of concision and clarity.  The
      <a href="http://www.zope.org/"><abbr title="Z Object Programming
      Environment">ZOPE</abbr></a> people deserve much kudos.
    </p>
  </body>
  <dc:subject>picky</dc:subject>
  <dc:subject>web</dc:subject>
</entry>
