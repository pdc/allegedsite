# Automatically generated
pngFiles	= action01.png\
		action02.png\
		action03.png\
		action04.png\
		action05.png\
		action06.png\
		action07.png\
		action09.png\
		action08.png\
		action11.png\
		action10.png\
		action13.png\
		action14.png\
		action15.png\
		action12.png

.SUFFIXES:	.png .jpg

all:		$(pngFiles:.png=.jpg)

clean:
	rm -f $(pngFiles:.png=.jpg)

.png.jpg:
	pngtopnm $< | pnmscale -xysize 450 450 | cjpeg -progressive >$@
