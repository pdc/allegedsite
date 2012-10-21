<!-- -*-HTML-*- -->
<entry date="20030927" icon="applescript.png" xmlns="http://www.alleged.org.uk/2003/um" xmlns:dc="http://purl.org/dc/elements/1.1/">
  <h>Moron AppleScript</h>
  <body>
    <p>
      My problem with <a
      href="http://apple.com/applescript/">AppleScript</a> is its
      patchy documentation and the needless <em>complexity</em> of its
      syntax.  I am also crippled by my two decades&rsquo; experience
      of using more consistently designed programming languages.
    </p>
    <p>
      So, for example, when faced with the task of writing a program
      that writes a few hundred lines to a file, my first idea would
      be to open the file, write each line one at a time, then close
      the file.  This way the operating system takes care of buffering
      the data in an efficient manner.  
    </p>
    <p>
      The first hurdle is how to
      get the file name!
      I wanted a way to find the user&rsquo;s home directory, so that
      I might place the output file there.
      AppleScript has some things (properties? functions?) starting
      with <code>path to</code> that supply the file names of
      folders.  I know this from one of their sample scripts, which
      uses <code>path to temporary items folder as string</code>.
      It is not described in the reference manual or any other
      documentation I have found.
      After some <em>guesswork</em> I hit upon <code>path to desktop
      folder</code>.  Not quite what I wanted, but close enough.
    </p>
    <p>
      The problem is, when I try to assign <code>file (path to desktop
      folder as string) &amp; "xyzzy.xml"</code> to a variable (which I
      will then use to open a file), I get the inscrutable error
      message &lsquo;Cannot get Macintosh
      Disk:Users:pdc:Desktop:xyzzy.xml&rsquo;.  In the end I worked
      out that my mistake was in trying to convert the name of a
      non-existing file to a file name; the construct
      &lsquo;<code>file</code> <em>fileName</em>&rsquo; is only
      permitted if (A)&nbsp;the file already exists, or (B)&nbsp;the
      command the expression is used in will create the file itself.
      Or this is my deduction after an exasperating waste of time.
    </p>
    <p>
      At this point I just had to give up on trying to work with
      AppleScript in the way I normally do programming, which is to
      work out what I want to do and then use the documentation to
      discover how to do it.  Instead I have resorted to <dfn>voodoo
      programming</dfn>: slavishly copying snippets of sample code and
      resisting the urge to modify, tweak or improve anything for fear
      of breaking the spell.  The only documentation for writing to
      files I have found on Apple&rsquo;s web site is <a
      href="http://www.apple.com/applescript/guidebook/sbrt/pgs/sbrt.11.htm">a
      subroutine for writing a whole file at once</a>.  I attempted to
      apply logic, reason and cunning to extrapolate from this a way
      to write the file piece by piece, but in the end the meaningless
      error messages mean this effort is futile.  Accumulating the
      data in memory is much less efficient, but at least I might be
      able to make it work.
    </p>
    <p>
      So, in the end, I have managed to extract information from
      iPhoto in to an XML file, and as a result am in a position to do
      the rest of the work I want in the <a
      href="http://python.org/">Python language</a>.  For which I am
      very grateful!
    </p>
    <p>
      <strong>Update:</strong>
      I spoke too soon.  The script now silently fails to write the data to the
      file.  Everything works as before, except the output file is
      empty.  How fucking pathetic is that?!
    </p>
  </body>
  <dc:subject>applescript</dc:subject>
</entry>
