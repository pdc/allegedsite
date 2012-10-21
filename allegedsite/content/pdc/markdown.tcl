# Time-stamp: <pdc 2004-05-06>

# Early attempt at Markdown in Tcl.


namespace eval markdown {
    namespace export toHtml

    set buf {}
}

proc markdown::toHtml {lines} {
    variable buf
    processLines $lines consumePar
    return [join $buf \n]
}

proc markdown::processLines {lines cmd} {
    set body ""
    set parLines {}
    set mode T
    set stack {}
    foreach line $lines {
	if {[string equal [string trim $line] ""]} {
	    if {[llength $parLines] > 0} {
		# We have just finished a block.
		# First, send the paragraph to our consumer.

		eval $cmd $mode [list [join $parLines \n]]

		# Now see if we need to change mode.
		switch -exact $mode {
		    H {
			set lastLine [lindex $parLines end]
			if {[regexp "^</\[a-zA-Z\]+>" $lastLine]} {
			    # end of HTML block
			    set mode T
			}
		    }
		}

		# Ready to start new paragraph
		set parLines {}
	    }
	    continue
	}

	if {[llength $parLines] == 0} {
	    # This is the first line of a new paragraph.

	    switch -exact $mode {
	    T {
		if {[regexp "^<(p|div|table|blockquote|ul|ol|dl|h\[1-6\])\\W" $line]} {
			# start of HTML block
			set mode H
		}
	    } elseif {[llength $parLines] == 1 \
			&& [regexp "^=+\\s*\$" $line]} {
		    append body "\n<h2>[lindex $parLines 0]</h2>\n\n"
		    set parLines []
		    continue
		} elseif {[llength $parLines] == 1 \
			&& [regexp "^-+\\s*\$" $line]} {
		    append body "\n<h3>[lindex $parLines 0]</h3>\n\n"
		    set parLines []
		    continue
		}
	    }
	}
	lappend parLines $line
    }
    if {[llength $parLines] > 0} {
	eval $cmd $mode [list [join $parLines \n]]
    }
}

proc markdown::consumePar {mode text} {
    variable buf

    switch -exact $mode {
	H {
	    lappend buf $text
	    return
	}
	T {
	    set isText 1
	    set segs {<p>}
	    set verbatim ""
	    set maybeVerbatim ""

	    # Backslash escapes for special characters.
	    #set punc "\\`*_{}[]()#.!"
	    #for {set p [string first "\\" $text]} \
	    #	    {$p >= 0} \
	    #	    {set p [string first "\\" $text [expr $p + 6]]} {
	    #	set c [scan [string index $text [expr $p + 1]] %c]
	    #	set text [string replace $text $p [expr $p + 1] \
	    #		[format "&#x%02X;" $c]]
	    #}

	    # Separate in to text and verbatim chunks at backquotes.
	    foreach seg [split $text `] {
		if {$isText} {
		    if {"$seg" == "" && [llength $segs] > 0} {
			# This happens when doubled backquotes 
			# in computer text.
			append maybeVerbatim `
		    } else {
			if {"$verbatim" != "" || "$maybeVerbatim" != ""} {
			    lappend segs "<code>[escape $verbatim$maybeVerbatim]</code>"
			    set verbatim ""
			    set maybeVerbatim ""
			}
			regsub -all "\\*\\*(\[^*\]+)\\*\\*" $seg \
				"<strong>\\1</strong>" seg
			regsub -all "\\*(\[^*\]+)\\*" $seg \
				"<em>\\1</em>" seg
			regsub -all "_(\[^*\]+)_" $seg \
				"<cite>\\1</cite>" seg
			regsub -all "\\&(?!\\w+;|#\\d+;|#x\[0-9A-Fa-f\]+;)" $seg "\\&amp;" seg
			regsub -all "<(?!/\\w+>|\\w+>|\\w+ \\w+=)" $seg "\\&lt;" seg
		    }
		    lappend segs $seg
		    set isText 0
		} else {
		    append verbatim $maybeVerbatim$seg
		    set maybeVerbatim ""
		    set isText 1
		}
	    }
	    if {"$verbatim" != ""} {
		lappend segs "<code>[escape $verbatim]</code>"
		set verbatim ""
	    }
	    lappend segs </p>
	    lappend buf [join $segs ""]
	    return
	}
    }
}

proc markdown::escape {text} {
    regsub -all "\\&" $text "\\&amp;" text
    regsub -all "<" $text "\\&lt;" text
    regsub -all ">" $text "\\&gt;" text
    return $text
}
# -*-tcl-*-

proc markdown {lines} {
    set body ""
    foreach line $lines {
	regsub -all "\\*\\*(\[^*\]+)\\*\\*" $line "<strong>\\1</strong>" line
	regsub -all "\\*(\[^*\]+)\\*" $line "<em>\\1</em>" line
	append body "$line\n"
    }
}