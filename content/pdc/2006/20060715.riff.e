Title: The RIFF that is known is not the true RIFF
Date: 20060715
Icon: ../icon-64x64.png
Topics: riff graphics futility corelpainter conversion

In my [previous rant][prev] I mention a file format called RIFF. Why can't I
just google for a RIFF converter? Here's why.

The underlying syntax of most multimedia on Microsoft Window systems is called
[RIFF][2] (Resource Interchange File Format: the most redundant acronym for a
format I have yet encountered), so if you google for 'RIFF converter' you find
audio software that understands 'RIFF MIDI' or 'WAV (RIFF)'. Some lists of file
suffixes or file formats eroneously describe `.rif` as being RIFF in this sense.

How do I know this is not the format used by Corel in RIFF files? Here's a
simple program for checking, based on [some random description of RIFF
format][3]:

    import struct

    input = open('1a1', 'rb')
    try:
        hdr = input.read(4)
        chunkLen, = struct.unpack('<i', input.read(4))
        
        input.seek(0, 2)
        fileLen = input.tell()
        
        if hdr != 'RIFF':
            print 'Header should be RIFF but was instead', repr(hdr)
        if chunkLen != fileLen - 8:
            print 'This is not a RIFF file: chunkLen is %s but file length is %s' % (chunkLen, fileLen)
    finally:
        input.close()

Needless to say, my `.rif` files do not pass this simple test.

The origin of the Painter RIFF format is probably Raster Image File Format,
mentioned on the [list of formats understood by GIFConverter][4]. The devisor,
Mark Zimmer of Fractal Design Software co-wrote the original Painter ([Corel
painter][5] started life as Fractal Design Painter). The problem here is that,
at the time GIFConverter was written, Painter did not support layers or vector
graphics: it was just a flat image. These have been added either as extensions
to the original RIFF format or as a new format. Thus [GraphicConverter US][6]
(bundled with Mac OS X) lists RIFF as a format, but says that my `.rif` files
are in an unknown format.

The upshot of this is that, when someone asks '[how can I convert my RIFF
files][7]', some smartarse googles for 'RIFF convert to PSD' and finds [Graphics
File Formats FAQ (Part 2 of 4): Image Conversion and Display Programs][8], which
mentions support for the obsolete form of RIFF, which is of no use to me or
anyone else.

  [2]: http://en.wikipedia.org/wiki/RIFF
  [3]: http://www.daubnet.com/formats/RIFF.html
  [4]: http://www.kamit.com/gifconverter/doc/gifc-Support.html#Heading186
  [5]: http://en.wikipedia.org/wiki/Corel_Painter "Wikipedia entry for Corel Painter"
  [6]: http://www.lemkesoft.com/en/gcabout_formats.htm
  [7]: http://www.photoshoptechniques.com/forum/showthread.php?t=19362
  [8]: http://www.faqs.org/faqs/graphics/fileformats-faq/part2/
  [prev]: 07/14.html "Cannot convert Corel Painter RIFF to GIF"
