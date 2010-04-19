Title: History meme
Topics: bash meme
Date: 2008-04-16
Icon: ../icon-64x64.png

This is one for people with a Unix-like operating system at home:

	$ history  | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
	141 make
	94 cd
	30 ls
	27 open
	24 python
	23 ~/Projects/updateAlleged
	23 ./totuschin
	21 mv
	20 xsltproc
	10 man

The two non-standard commands are `updateAlleged`, which downloads some Atom and RSS feeds
that are inputs to the program that generates [my home
page](http://www.alleged.org.uk/pdc/), and `totuschin`, which is a script for uploading an
updated version of one of my web sites to my ISP’s server (which is called `tuschin`). Each
site’s staging area has a different `totuschin` script.

The `open` command is used on Mac OS X to open a document in whatever is the usual editor (as one had double-clicked on it in a Finder window). So I often use `open index.html` to preview an HTML document before publishing it.