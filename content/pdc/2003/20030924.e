<!-- -*-HTML-*- -->
<entry date="20030924" icon="applescript.png" xmlns="http://www.alleged.org.uk/2003/um" xmlns:dc="http://purl.org/dc/elements/1.1/">
  <h>AppleScript: The second-worst of all scripting languages*</h>
  <body>
    <p>
      I have just wasted half an afternoon failing to write a simple
      <a href="http://apple.com/applescript/">AppleScript</a> program
      to extract information from iPhoto.  The problem is not
      actually in extracting the info.  The problem is the AppleScript
      language makes doing anything useful with the data extremely
      hard.
    </p>
    <p>
      What I want to do is this (using Python as pseudo-code):
    </p>
    <pre>output = file('mull.xml', 'w')
output.write('&lt;album>\n')
for photo in iPhoto.albums['Mull'].photos:
  output.write('    &lt;photo>\n')
  output.write('        &lt;title>' + photo.title + '&lt;/title>\n')
  output.write('    &lt;/photo>')
output.write('&lt;/album>')
output.close</pre>
    <p>
      One problem is that AppleScript has fallen for the English is
      Simple fallacy&mdash;the same one that blighted languages like
      <abbr title="Common Business-Oriented Language">COBOL</abbr> in
      the distant past. 
      To illustrate the fallacy, consider the Python statement
    </p>
    <pre>this_photo = selected_photos[i]</pre>
    <p>
      The equivalent in AppleScript is
    </p>
    <pre>set this_photo to item i of selected_photos</pre>
    <p>
      The problem is, although the &lsquo;<code>set</code>
      ... <code>to</code> ...&rsquo; is (allegedly) easy to read, it is
      not easy to write, because there are plenty of other plausible
      pseudo-English commands that should do the same thing:
    </p>
    <pre>assign item i of selected_photos to this_photo
copy item i of selected_photos to this_photo
let this_photo equal item i of selected_photos
put item i of selected_photos into this_photo
store the selected_photo number i in the variable this_photo
item i of selected_photos returning this_photo
this_photo becomes item i of selected_photos</pre>
    <p>
      Some of the above are equivalent to the <code>set</code>.  Some
      are syntactically correct but mean something subtly different
      (at least, the documentation says they are different, but
      because it is all in baby-talk, I cannot determine what the
      difference is).
      Because you can only use certain set phrases, you need to study
      a language manual to know <em>which</em> set phrases will work.
      At which point it turns out that the inclusion of pseudo-English
      synonyms and noise words makes the syntax of the language
      <em>more complex</em> and so harder to learn.
    </p>
    <p>
      The other problem with quasi-English programming languages is that
      they are stunningly verbose.  
      For example, the equivalent of the
      <code>for</code> statement above is
    </p>
    <pre>set the selected_album to the album named "Mull"
set the selected_photos to the photos of the selected_album
repeat with this_photo in the selected_photos
    ...
end repeat</pre>
    <p>
      I claim that the above epic is actually harder to read then 
      than Python&rsquo;s equivalent:
    </p>
    <pre>for this_photo in albums['Mull']:
    ...</pre>
    <p>
      A further problem is that the documentation tends to be
      inadequate, because to properly document the language would be
      to admit that it is actually complex enough to need proper
      documentation.  Instead I have been struggling with a Reference
      Manual written in baby talk which maddeningly fails to define
      exactly what some of the commands do, or what the exact syntax
      is, and so on.  The dead end I came up against in my
      self-imposed iPhoto task was when I wanted the equivalent of
    </p>
    <pre>lines.append(line)</pre>
    <p>
      which in Python adds the text stored in the variable
      <code>line</code> to the end of the list stored in the variable
      <code>lines</code>.  This is not explicitly covered in the
      documentation.  One of their examples suggests that this
      construction should do it:
    </p>
    <pre>copy this_line to the end of these_lines</pre>
    <p>
      but my attempts have all ended in cryptic error messages like
      &lsquo;Cannot assign to end of <code>these_lines</code>&rsquo;.
      So it appears I need to totally rethink the way I am processing
      the data so as to avoid having to append items to lists!
    </p>
    <p>
      None of this would be necessary were the data from iPhoto
      exposed in a format that I could process easily in Python,
      thereby removing the necessity of driving the iPhoto application
      from AppleScript.  Open data formats are a good thing, even if
      only a few people (such as me) actually need to exploit them.
    </p>
    <hr />
    <p>
      * The first worst scripting language I have encountered
      is that used by InstallShield.
    </p>
  </body>
  <dc:subject>applescript</dc:subject>
</entry>
