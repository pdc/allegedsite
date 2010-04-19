<!-- -*-HTML-*- -->
<entry date="20030721" icon="picky-80x80.png" xmlns="http://www.alleged.org.uk/2003/um" xmlns:dc="http://purl.org/dc/elements/1.1">
  <h>Picky Picky Game restarted</h>
  <body>
    <p>
      We have started <a href="http://caption.org/picky/">a new Picky
      Picky Game</a> to replace <a href="07/18.html#e20030718">the one
      whose database vanished</a>.  I have added code to the server so
      that the <a
      href="http://caption.org/2003/games/static/page0.html">archive
      of the old game</a> is inserted before Page&nbsp;1 of archive of
      the new game.  The first round of candidate panels has been
      primed with the candidates from panel 25 of the old game.
    </p>
    <p>
      This was fairly straightforwrad because I has troubled to make a
      nice automated script for creating new PPG instances or fixing
      existing ones.  I&nbsp;extended this to handle the task of loading
      the recovered pictures for panel&nbsp;25 in to the new game.
      This way I was abl;e to test it on my development database at
      home before risking the production server.  The last tricky bit
      was setting up redirections so that people who has bookmarked the
      old <code>/sample/</code> URL will be directed to
      <code>/phoenix/</code> (the new game).
    </p>
    <p>
      I have also written another maintenence script that dumps the
      contents of the game to a bundle of XML files and image files.
      This can be used to back up the database, in case of future
      accidents.  I plan te extend this to allow more of te pictures
      to be served as static files rather than via my CGI script
      (which should make the server more efficient).
    </p>
  </body>
  <dc:subject>picky</dc:subject>
</entry>
