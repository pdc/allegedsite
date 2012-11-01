
proc defAbbr {abbr title {uri {}}} {
    if {[string length $uri] == 0} {
	proc $abbr {} [list return [abbr* title=$title $abbr]]
    } else {
	proc $abbr {} "
	proc $abbr {} {return {[abbr* title=$title $abbr]}}
	return {[a $uri [abbr* title=$title $abbr]]}
	"
    }
}

defAbbr API "Application Programming Interface"
defAbbr DOM "Document Object Model"
defAbbr DTD "XML Document-Type Definition"
defAbbr HTML "Hypertext Mark-up Language" http://www.w3.org/MarkUp/
defAbbr ISO "International Organization for Standardization"
defAbbr JPEG "Joint Photographic Expert Group"
defAbbr LTM "Linear Topic Map" http://www.ontopia.net/download/ltm.html
defAbbr NN "Netscape Navigator"
defAbbr PNG "Portable Network Graphics" http://www.w3.org/TR/REC-png-multi.html
defAbbr PSI "Published-Subject Indicator"
defAbbr RDF "Resource-Description Framework"
defAbbr RFC "Request for Comments"
defAbbr SGML "Standardized Generalized Mark-up Language"
defAbbr SMIL "Synchronized Multimedia Integration Language" http://www.w3.org/AudioVideo
defAbbr SS "Site Summary"
defAbbr SVG "Scalable Vector Graphics" "http://www.w3.org/Graphics/SVG/"
defAbbr SVGZ "Scalable Vector Graphics, compressed with ZIP"
defAbbr URI "Uniform Resource Identifier"
defAbbr URN "Uniform Resource Name"
defAbbr URL "Uniform Resource Locator"
defAbbr VB "Microsoft Visual Basic"
defAbbr VBScript "Microsoft Visual Basic Scripting Edition"
defAbbr W3C  "World-Wide Web Consortium" "http://www.w3.org/"
defAbbr XHTML "XML Hypertext Mark-up Language" http://www.w3.org/TR/xhtml1/
defAbbr XML "Extensible Mark-up Language" http://www.w3.org/XML/
defAbbr XSLT "Extensible-Stylesheet-Language Transform"
defAbbr XSS "XML Site Syndication" http://www.alleged.org.uk/pdc/2002/xss/
