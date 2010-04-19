# Time-stamp: <pdc 2002-09-20>

source ../../abbrDefs.tcl
source ../../../2002/headingDefs.tcl

proc should {args} {
    return [em* class=ShouldMust "should [join $args " "]"]
}
proc must {args} {
    return [em* class=ShouldMust "must [join $args " "]"]
}
proc may {args} {
    return [em* class=ShouldMust "may [join $args " "]"]
}

proc RSS {v} {
    switch $v {
	0.9 - 1.0 {
	    return "[abbr* "title=RDF Site Summary" RSS]&nbsp;$v"
	}
	0.91 - 0.92 {
	    return "[abbr* "title=RSS" RSS]&nbsp;$v"
	}	    
	default {
	    return "[abbr* "title=Really Simple Syndication" RSS]&nbsp;$v"
	}	    
    }
}


defaultAttrs tr valign=baseline align=left
defaultAttrs th align=left

proc dcRef {key} {
    return [a* "title=$key in the Dublin Core spec" href=http://dublincore.org/documents/1999/07/02/dces [code dc:$key]]
}
