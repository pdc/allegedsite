TItle: 1024x768@85 please
Topics: x11 debian
Date: 20040731
Image: ../icon-64x64.png

This is the first time I have used a Linux system with a display
manager -- that is, a program whose job it is to run X and log me in. I
have run the xserver-xfree86 configuration many times in an attempt to
persuade it that my monitor can handle a refresh rate over 70 Hz. 
At 70
Hz I find the shimmering of the display uncomfortable.
Checking the file 
`/etc/X11/XFree86-4` it definitely appears to have changed. But how do
I restart X so that it takes notice of the 
new configuration file? 

There is no option in GDM to restart X. There is an option to reboot the
computer, but that is not what I want. In the end it seems that 'logging
out' of X and back in again resets the server. I know this, because it
has regressed from allowing 1024x768 at 70 Hz to 
only allowing 640x480 at 60 Hz. At this resolution, many KDE
configuration panels are larger than the screen itself, which is a bit
silly.


