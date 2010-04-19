Title: TurboGears and Uploading Pictures
Date: 20060307
Topics: turbogears forms
Icon: ../icon-64x64.png

[TurboGears][] and the [Python Imaging Library][] make writing
applications that allow the reader to upload
pictures a snap—which is a refreshing change.

Capturing Uploads the CherryPy Way
-----

Most web-server frameworks make handling uploaded files difficult. Often this is
because they were originally designed to make the more common case in mind: form
items whose values are strings. When they add the ability to handle file
uploads, it often looks like an afterthought. Microsoft’s ASP library required
third-party extensions, I seem to recall; ASP .NET supplies for parameters as a
statically typed, string-valued dictionary, so file uploads have to be done
through an entirely separate interface—and so on.

TurboGears, through [CherryPy][], makes uploads easy. In fact it uses the same
mechanism to pass uploaded files as any other form parameter:

    @turbogears.expose(html="picky2.templates.addpicture")
    def filepic(self, id, pic):
	    ... process the arguments ...
		return dict(...)

In order to work out why the `pic` parameter is different, you need have to look
at the template that contains the form for uploading pictures:

    ...
    <h2>Add a picture</h2>
    <form action="filepic?id=${panel.id}" method="post"
            enctype="multipart/form-data" id="filepic">
        ...
        <label for="pic">Picture file:</label> ...
        <input type="file" name="pic" id="pic"/>
       ...
    </form>

The essential differences are (1) the `enctype` attribute on the `form` element,
and (2) an `input` element with `type="file"` and, in this case, the name `pic`.

These changes mean that the argument `pic` passed to my method `filepic` is an
object rather than just a string. Its properties are sketchily documented as
part of Python’s [cgi module][] and in section 3.1.6 of [Chapter 3][] of the CherryPy
book. It has three interesting member variables:

  - `file`: a file-like object from which we can read the data;
  - `filename`: the name used for this file on the user’s computer; and
  - `type`: the MIME media-type of the file, as reported by the user’s computer.

The next two sections outline how I process the file in my toy application.
None of this is particilary profound, so bored readers will probably want to
skip it.


Storing the Picture Once it Has Arrived
-----

Let’s step through the `filepic` method in order. In the Picky2 game, pictures
are uploaded as candidates for a panel.  Our database model includes `Panel` and
`Picture` classes, and we pass the identifier of the current panel as one of the
parameters. The first thing we do is retrieve our person and panel info from the
database:

    def filepic(self, id, pic):
        pers = authentication.getLoggedInUser()
        panel = model.Panel.get(id)
        ...

We could store the picture directly in the database. At work, we always end up
doing that, because we a re terrified that one day we might need to migrate the
application to a different server, and would have to remember to copy the files
as well as the database itself, which apparently is an easy thing for database
admins to forget. Nevertheless for Picky2, I intend to keep metadata in the
database and store the picture data on disc. So I need to generate a file name
for it.

<div class="small_photo_right">
	<a href="http://www.flickr.com/photos/pdc/107119756/" title="Pink Bird Nest"><img src="http://static.flickr.com/52/107119756_c749e8a574_m.jpg" width="180" height="240" alt=""  /></a>
</div>

You will recall that the upload object is supplied with a `filename` parameter,
and it would be nice if we could reuse that (if only during the debugging phase
of development). Of course, the file name supplied is in the form understood by
the user’s computer: it might be `/Users/pdc/Pictures/bird.jpg` or
`C:\Documents and Settings\pdc.OCC\My Documents\My Pictures\bird.jpg`. Also,
in the context of a jam-comics web game, players are likely to create files with
obvious names like `panel.jpg`, which will cause clashes—it would be tragic if
somone’s picture was clobbered because someone later on used the same name and
our server overwrote it.

We concoct a probably-unique file name for use on the web server from a
combination of the following:

  - The date of upload (turned in to a directory name like `2006/03/07/`);

  - The identity of the uploader (munged into a directory  name, so that
    `http://example.org/jsmith` becomes `example.org-jsmith`);

  - The last component of the file name from the user’s home computer (so the
    examples I gave above end up with `bird.jpg`).

This gives something like `2006/03/07/example.org-jsmith/bird.jpg`. The reason
for the directory structure is that eventually we might have hundreds or
thousands of pictures, and keeping them all in one directory might make looking
up files inefficient. (I am admittedly anticipating scaleability issues that are
unlikely to manifest given how obscure my game will be; and besides,
[ReiserFS][] has BTree-based directories that do not degrade in performance when
they have enormous numbers of files.)

This scheme does expect a given person to avoid choosing the same name on the
same day for different pictures. I ought to add something to cope with that
case—either munging the name, or refusing the upload until they change the
name. I’m not sure which.

We want to cap files saved on our system to a given maximum
size (say 50K bytes).  We do this by carefully only reading 1 byte more than the
maximum size, and rejecting files that completely fill the buffer:

        output = open(fileName, 'wb')
        try:
            size = 0
            bytes = pic.file.read(1 + MAX_FILE_SIZE)
            while bytes:
                size += len(bytes)
                if size > MAX_FILE_SIZE:
                    raise BadPictureException('Sorry, that file is too big: maximum size is %dK.'
                            % (MAX_FILE_SIZE // 1024))
                output.write(bytes)
                bytes = pic.file.read(1 + MAX_FILE_SIZE - size)
        finally:
            output.close()

This code assumes that `pic.file.read` may choose to not read all the bytes in the file in
one gulp—I have not checked whether this caution is actually required.

The important thing, though, is that if the file is too big, we throw an
exception `BadPictureException`. The above code is actually wrapped in a
`try`...`except` block, as follows:

    try:
        ... read in the file as above ...
        ... process the file ...
        return dict(...)
    except BadPictureException, err:
        # The uploaded picture was unsatisfactory; issue a message and try again.
        os.unlink(fileName)
        turbogears.flash(str(err))
        raise cherrypy.HTTPRedirect('panel?id=%d' % id)

Anywhere in the file-processing where we need to reject the upload, we raise a
`BadPictureException` with an appropriate error message. The handler for the
exception cleans up the unwanted file and redirects back to the page with the
form on it. This is an example of a function that throws exceptions that it
catches itself (so that the clean-up code need only be written once).

Processing Images
-----

We have now uploaded the picture and checked it is not too large for our disc.
Another constraint on images is that they have a maximum size on the page. We
can check this by using the [Python Imaging Library][]:

        im = Image.open(fileName)
        width, height = im.size
        if width > MAX_WIDTH:
            raise BadPictureException('Sorry, that picture is too wide: maximum is %d pixels.'
                    % MAX_WIDTH)
        if height > MAX_HEIGHT:
            raise BadPictureException('Sorry, that picture is too tall: maximum is %d pixels.'
                    % MAX_HEIGHT)

If we wanted to generate thumbnails, this is where we would do it.

At this point we have saved the user’s upload, and verified that it is
acceptable. It is time to save a pointer to the newly created file in the
database. Having added some extra classes `Picture` and `Vote` to `model.py`,
the code to do this is quite short:

    picture = model.Picture(uri=PICS_BASE_URI + picDir + name,
            width=width, height=height, panel=panel, score=1, person=pers)
    model.Vote(picture=picture, person=pers, value=1)

The second statement adds a vote from this user for their picture. Like Reddit, we
assume that people only upload panels if they think they are good enough to be
worth voting for. (They can unvote for their panel later if they really want
to.)  More on voting next episode.

Finally, like all CherryPy methods, we return a dictionary that is used by the template to
create the HTML page:

    return dict(picture=picture, panel=panel)

Ever Onwards
-----

<div>
	<a href="http://www.flickr.com/photos/pdc/103568742/" title="Pedestrian Drain 3"><img src="http://static.flickr.com/33/103568742_eaa7fec57b_m.jpg" width="240" height="180" alt="" align="left" /></a>
</div>

So it looks like I have got most of a Picky Picky Game clone together in a
couple of afternoons’ sporadic work—it has a concept of panels (even if there
is only one so far), and you can upload pictures to a panel and see them listed
with your name underneath it. What remains is voting, spawining a new panel
every week (or whatever), and arranging the most-voted pictures in to a strip.
We’ll see how I get on with that next time I have a spare afternoon...


  [Python Imaging Library]: http://www.pythonware.com/products/pil/
  [ReiserFS]: http://www.namesys.com/
  [SQLObject]: http://sqlobject.org/
  [CherryPy]: http://www.cherrypy.org/
  [TurboGears]: http://turbogears.org/
  [Chapter 3]: http://www.cherrypy.org/cherrypy-2.1.0/docs/book/chunk/ch03.html
  [cgi module]: http://docs.python.org/lib/node471.html


