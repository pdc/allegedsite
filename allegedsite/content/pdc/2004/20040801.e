Title: Uploading from OS X
Icon: ../icon-64x64.png
Topics: osx expect tcl
Date: 20040801

If you are reading this on-line then I have finally managed to alter my
[Expect][1] script to work with the Mac OS X version of `ftp`. This is part
of the long drawn-out battle to transfer my projects to my PowerBook so
that my old desktop (circa 1998) can be repurposed.

Background: The way I write this site involves creating a working copy
on my local system, so I can check it before I upload it to the real
server. The program for doing the upload is a [Tcl][3] script using [Don
Libes][2]'s Expect extension to control the FTP program. My script walks
the directory structure of my working copy, and issues FTP commands to
upload the files that have been changed.

I got Expect by dint of installing the new [TclTkAqua-Batteries
Included][4]
distribution of Tcl.

Apple's FTP program (really I suppose I should say BSD's) rather threw me because it starts in 'passive' mode.
My script swiches on passive mode, since that's generally a good idea.
The problem
is that `ftp` uses the same command to turn an option off (if it is on)
as turns it on when it is off. To allow for different FTP programs to have different 
default states, I wrote a routine that issues the
`passive` command, and examines the resulting message to determine
whether this resulted in switching it on or off, and reissues the
command if necessary to get the result I want.

Apple's FTP has a cute feature that
displays a progress indicator (a line of asterisks) as it uploads large files. My
program interpreted the unexpected text as an error message and gave
up.
It took me a while to work out what was happenign because it only balked
at large files -- short transfers did not get the progress indicator.
So today I wrote more code to try to turn this option off. 

Now it works fine. Except that partway through pointlessly uploading a
whole slew of files that are in fact already uploaded but have the wrong
timestamps my ethernet is suddenly failing. When this happens I find I
cannot `ping` anything on the network.  I wonder if this is a
hardware fault, as unplugging the ethernet cable and plugging it in
again makes the problem go away.

I just managed to get it to work by running `ping` continuously in
another window. Did this help or was it coincidence? Sigh.

  [1]: http://expect.nist.gov/ "Expect is a tool for automating interactive applications"
  [2]: http://www.mel.nist.gov/msidstaff/libes/
  [3]: http://www.tcl.tk/ "Tcl Developer Exchange"
  [4]: http://tcltkaqua.sourceforge.net/ "TclTkAqua project on Sourceforge"
