$(htmlFiles): ../pdcDefs.tcl ../entryDefs.tcl

index.html: *.e ../lj.data

zoe.svg: writeZoe.py
	python writeZoe.py > zoe.svg

install: install-flickr

install-flickr: flickr-badge.svg flickr-badge-to-svg.xslt
	cp -p flickr-badge.svg $(htmlDir)
	cp -p flickr-badge-to-svg.xslt $(htmlDir)

flickr-badge.svg: flickr-badge.xml flickr-badge-to-svg.xslt
	xsltproc flickr-badge-to-svg.xslt flickr-badge.xml > flickr-badge.svg

flickr-badge.xml: flickr-badge.js flickr-badge-to-xml.py 
	python flickr-badge-to-xml.py flickr-badge.js > flickr-badge.xml
