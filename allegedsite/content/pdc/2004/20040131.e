<!-- -*-HTML-*- -->
<entry date="20040131" icon="../icon-64x64.png" xmlns="http://www.alleged.org.uk/2003/um" xmlns:dc="http://purl.org/dc/elements/1.1/">
  <h>Saved by the DAO</h>
  <body>
    <p>
      I learned to use one of Microsoft&rsquo;s many abandoned <abbr
      title="application-programming interface">API</abbr>s this week:
      <a
      title="Migration from DAO to ADO (MSDN Library)"
      href="http://support.microsoft.com/support/kb/articles/Q233/0/02.ASP">DAO,
      the Data Access Object</a> library.
    </p>
    <p>
      It happened like this.  At work we have a client with an
      existing application that uses a Microsoft Access database.  He
      also has the interesting habit of specifying additions not in
      English but by creating sketchy database schemas in Access.  Our
      work on the next version will be using Microsoft SQL Server,
      with which I&nbsp;have some familiarity&mdash;unlike Microsoft Access
      of which I&nbsp;know nothing.  So naturally I&nbsp;was given the task of
      devising the new database definition.
    </p>
    <p>
      My first couple of weeks were very frustrating.  With SQL
      databases one can type questions in the SQL language to explore
      the relationships between database entities (they even store the
      database schema in its own database tables).  The &lsquo;easy to
      use&rsquo; query creator in Access I&nbsp;personally find
      bewildering.  It is possible to write queries in SQL, but it
      makes it plain that it does not like you to do this, and offers
      less support than, for example, Microsoft SQL Server Query
      Analyzer.  Access often fails with truly inscrutable error
      messages.
    </p>
    <p>
      I&nbsp;wanted to use a mini-program to do some of the schema
      manipulation for me.  Thus I&nbsp;needed extract information about the database definition in
      a form my program could process.  Access has a nice visual
      interface for  exploring the relationships between database
      tables, but no discernible way to extract the information in
      textual form.  There is an Upsizing Wizard for converting
      Microsoft Access files in to Microsoft SQL Server databases, but
      I&nbsp;never got it to work&mdash;supposedly installing some service
      packs should have fixed it, but no dice.  
    </p>
    <p>
      I&nbsp;had a <a href="http://python.org/">Python</a> program
      using the <abbr title="Open Database Connectivity">ODBC</abbr>
      support bundled with <a
      href="http://starship.python.net/crew/mhammond/">Mark
      Hammond&rsquo;s</a> Win32 extensions.  With this one can
      discover the columns defined for a given table.  With some blind
      poking about I&nbsp;discovered how to get a list of tables using
      <s>OLE</s> <s>ActiveX</s> <s>COM</s> Automation to talk direct
      to the Access program.  The programmer had used fairly
      consistent, stylized column names, from which my program could
      deduce a lot of the database structure.  But something in the
      combination of ODBC, Automation, Access and Python caused a lot
      of crashes, which was annoying.  Then a colleague suggested
      using DAO.
    </p>
    <p>
      DAO is one of many database libraries for windows, coming after
      ODBC and <abbr
      title="Microsoft Remote Data Objects">RDO</abbr> and before
      OLE-DB, <abbr title="Microsoft ActiveX DataObjects">ADO</abbr>,
      and ADO&nbsp;.NET.  It was created to allow users of Microsoft
      Access Basic, and then <abbr title="Microsoft Visual Basic for
      Applications">VBA</abbr>, <abbr title="Microsoft Visual Basic
      Scripting Edition">VBScript</abbr> and also <abbr
      title="Microsoft Visual Basic">VB</abbr> to manipulate Microsoft
      Access database files (they like to call it the Jet database
      engine), and extended to allow connection to any ODBC data
      source.  Nowadays a VB programmer would use a more recent
      library like ADO.  But DAO, being Jet-specific, sees all when it
      comes to Access databases.  
    </p>
    <p>
      The <a
      href="http://www.oreilly.com/catalog/progacdao/">O&rsquo;Reilly
      book</a> makes it all straightforward&mdash;there&rsquo;s a list
      of tables, and a list of &lsquo;relations&rsquo;, and it pretty
      much works as it should.  I&rsquo;m using Python with the
      Win32com support for Automation to talk to the DAO subsystem,
      without any bother and with no more crashes.  It also gives more
      precise info on the data types (ODBC says NUMBER; DAO can
      distinguish (Short) Integer, Long, Byte, etc).  Equipped with
      this information, I&nbsp;can begin analysing the database layout
      in earnest.
    </p>
  </body>
  <dc:subject>vb6</dc:subject>
  <dc:subject>dao</dc:subject>
  <dc:subject>python</dc:subject>
</entry>
