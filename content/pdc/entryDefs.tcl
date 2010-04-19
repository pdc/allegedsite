# Time-stamp: <pdc 2004-06-29>

# Definitions for working with 'entries' --
# a chronologically organized set of short articles,
# mainly pointers to other content
# (as a kind of web log).

# Entries are stored in files with names ending in '.e'.
# The first 8 characters must be the date, as in 20020415.
# They are stored in dirs anmed after the year, thus 2002/20020415.e
 
# On the web these are presented in 'archives',
# with one archive page per month of entries
# (in the older years this ends up with some archives
# containing only a single entry, but I can't be bothered
# to special-case this any more).  Archives are named
# YYYY/MM where MM is a 2-digit month number (Jan = 1).
# Archive names map on to URLs by adding .html.

# From May 2003 the archive name is YYYY/MM/DD

namespace eval Log {
    namespace export \[a-z]*

    # List of all .e files, most recent first.
    set scriptDir [file dirname [info script]]
    variable allEntries [glob [file join $scriptDir */*.e]]
    set allEntries [lsort -decreasing $allEntries]

    # Generate mapping from archive names to entries.
    variable allEntries
    foreach entry $allEntries {
	set arName [entryNameRetArName $entry]
	lappend arEntries($arName) $entry
    }

    switch -regexp [file tail [htmlOption subDir]] {
	^\[0-1\]\[0-9\]\$ {
	    set pref ../../
	}
	19.. - 20.. {
	    set pref ../
	}
	pdc {
	    set pref ""
	}
	default {
	    set pref ../../pdc/
	}
    }

    variable monthNames {Zero January February March April May June\
	    July August September October November December}
    variable monthAbbrs {Z Jan. Feb. Mar. April May June\
	    July Aug. Sept. Oct. Nov. Dec.}

    variable nexpanded 1

    variable topicTitles

    variable ljTitleComments

    variable headingKeys
    array set headingKeys {
	image icon
	title h1
	topics subjects
	link href
    }
    
    variable absoluteUriPat "^\[a-z]+://|^/"
    
    variable tagline "Damian Cugley\u2019s web site"

    source ${pref}lj.data
}

# Given an entry name (= file name),
# load the relevant data from that file in to the array named arrayName.
proc Log::entryNameLoadToArrayName {fileName arrayName} {
    variable ljTitleComments
    variable ljCounts

    upvar infos $arrayName


    puts "$fileName:"
    set in [open $fileName r]
    fconfigure $in -encoding utf-8
    set text [read $in]
    close $in

    if {[regexp "^\\s*<" $text]} {
	entryNameLoadXmlToArrayName $fileName $text infos
    } else {
	entryNameLoadTextToArrayName $fileName $text infos
    }

    # Information stored externally to the entry file itself.
    set e e[file tail [file root $fileName]]
    if {[info exists ljTitleComments($infos(h1))]} {
	set infos(ljComment) $ljTitleComments($infos(h1))
    } else {
	catch {
	    unset infos(ljComment)
	}
    } 
    if {[info exists ljCounts($e)]} {
	set infos(ljCount) $ljCounts($e)
    } else {
	catch {
	    unset infos(ljCount)
	}
    }
}

# Helper for the above for the XML flavour
proc Log::entryNameLoadXmlToArrayName {fileName text arrayName} {
    variable pref
    variable ljTitleComments
    variable ljCounts

    upvar infos $arrayName

    regsub -all "\\." $pref "\\\\." prefRe

    if {"[file tail $fileName]" > "20020413.e"} {
 	# New files use URIs relative to the year directory.
	# This follows the convention that URIs are relative
	# to the dir the file is in.
	# (Loosly speaking; URIs are not really file names.)
	set p "$pref[string range [file tail $fileName] 0 3]"
	set pRe "$prefRe[string range [file tail $fileName] 0 3]"
	regsub -all  "(icon|src|href)=\"" $text "\\1=\"$p/" text
	regsub -all "\"$pRe/http:" $text "\"http:" text
	regsub -all "\"$pRe//" $text "\"/" text
    } elseif {[string compare $pref ""] != 0} {
	# Older files use URIs relative to the directory 'pdc'.
	regsub -all  "(icon|src|href)=\"" $text "\\1=\"$pref" text
	regsub -all "\"${prefRe}http:" $text "\"http:" text
	regsub -all "\"$prefRe/" $text "\"/" text
    }

    foreach attName {date icon href} {
	catch {
	    unset infos($attName) 
	}
	regexp "$attName=\"(\[^\"\]+)\"" $text "" infos($attName)
    }
    regexp "<h1?>(.*)</h1?>" $text "" infos(h1)
    regexp "<body>\n*(.*)\n*</body>" $text "" body

    # Munge body to add interior links
    set idBase e[string range [file tail $fileName] 0 end-2]
    set p [string first <h2> $body]
    set rn 97			;# ASCII 'a'
    while {$p >= 0} {
	incr p 3
	set r [format %c $rn]
	set body [string replace $body $p $p " id=\"$idBase$r\"> "]
	incr rn
	set p [string first <h2> $body $p]
    }

    set infos(body) $body

    set infos(subjects) {}
    set matches [regexp -all -inline "<dc:subject>(\[^<>\]*)</dc:subject>" $text]
    foreach {m g} $matches {
	lappend infos(subjects) $g
    }
}

proc Log::entryNameLoadTextToArrayName {fileName text arrayName} {
    variable pref
    variable ljTitleComments
    variable ljCounts
    variable headingKeys

    upvar infos $arrayName
    foreach attName {date icon href} {
	catch {
	    unset infos($attName) 
	}
    }
    set infos(subjects) ""

    # regexpts used for processing URIs
    regsub -all "\\." $pref "\\\\." prefRe
    set p "$pref[string range [file tail $fileName] 0 3]"
    set pRe "$prefRe[string range [file tail $fileName] 0 3]"


    # We process the text line by line.
    set lines [split $text \n]

    # First scan the header approximately RFC-822 style.
    set line [lindex $lines 0]
    set lines [lrange $lines 1 end]
    while {[string compare $line ""] != 0} {
	set pos [string first : $line]
	set key [string tolower [string trim \
		[string range $line 0 [expr $pos - 1]]]]
	set val [string trim \
		[string range $line [expr $pos + 1] end]]
	if {[info exists headingKeys($key)]} {
	    set key $headingKeys($key)
	}

	# Munge relative URIs.
	if {[lsearch -exact {icon href} $key] >= 0} {
	    set val $p/$val
	    regsub  "$pRe/http:" $val "http:" val
	    regsub -all "$pRe//" $val "/" val
	}

	set infos($key) $val

	# Ready for next loop.
	set line [lindex $lines 0]
	set lines [lrange $lines 1 end]
    }

    set body [markdownToHtml [join $lines \n]]

    # URIs are interpreted relative to the year directory.
    # This follows the convention that URIs are relative
    # to the dir the file is in.
    # (Loosly speaking; URIs are not really file names.)
    regsub -all "(icon|src|href)=\"" $body "\\1=\"$p/" body
    regsub -all "\"$pRe/http(s?):" $body "\"http\\1:" body
    regsub -all "\"$pRe//" $body "\"/" body

    set infos(body) $body
}

# Given text in Markdown format, return HTML.
# Also does some punctuation processing.
proc markdownToHtml {text} {
    set text [exec markdown.py << $text]
    regsub -all "(\[ \t\r\n])(<\[^<>]*>)*'" $text "\\1\\2\u2018" text
    regsub -all "'" $text "\u2019" text
    regsub -all -- "---" $text "\u2014" text
    regsub -all -- "--" $text "\u2013" text
    return $text
}

# Given an archive name,
# generate the HTML file containing the
# text of all entries that belong therein.
# 
# This proc is invoked in the dir of the archive.
# E.g., for archive 2002/04, it is invoked 
# while in the directory 2002.
# For the archive 2003/05/20, it is involved
# from the directory 2003/05
proc Log::arNameGenerate {arName} {
    variable arEntries
    variable pref
    variable tagline

    if {"$arName" < "2003/05/01"} {
	regexp "(....)/(..)" $arName dummy year mon
	set fileName $mon.html
    } else {
	regexp "(....)/(..)/(..)" $arName dummy year mon day
	set fileName $day.html
    }
    
    set entries $arEntries($arName)
    # Get the title from the sole entry, if there is only one entry.
    if {[llength $entries] == 1} {
	entryNameLoadToArrayName [lindex $entries 0] infos
        set title $infos(h1)
        set h1 $title
    } else {
        set title [arNameRetTitle $arName]
        set h1 "$title (Damian Cugley's archive)"
    }

    beginDocument -file $fileName {
	title "$title - Damian Cugley - Alleged Literature"
        pdcMetadata $entries
    }

    beginBody
    # h1 $h1
    h1 "Alleged Archive"
    p id=tagline $tagline

    arNameEmitEntryList $entries $arName

    endBody
    endDocument
}

# Given a list of entries,
# generate the HTML that describes them.
proc Log::arNameEmitEntryList {entries {arName ""}} {
    variable pref
    variable topicTitles
    variable nexpanded

    # Is this a daily archive?
    set isArchive [expr {"$arName" != ""}]
    set isDaily [string match */*/* $arName]

    # If it is a daily archive, expand all entries.
    # Otherwise, expand $nexpanded entries and the rest are titles.
    if {$isArchive || [llength $entries] <= $nexpanded} {
	set expandedEntries $entries
	set unexpandedEntries {}
    } else {
	set expandedEntries [lrange $entries 0 [expr $nexpanded - 1]]
	set unexpandedEntries [lrange $entries $nexpanded end]	
    }

    foreach entry $expandedEntries {
	entryNameLoadToArrayName $entry infos
	set d $infos(date)
	set e [file root $entry]
	div class=entry {
            # It used to be the case that 
            #   Daily page with one entry uses that entry's name as page title.
            # Now archive pages have a standardized h1 and put the article title in h2 like everywhere else.
            if {1 || !$isDaily || [llength $entries] > 1} {
                h2 "[a* name=e[file tail $e] $infos(h1)]"
            }

	    if {1 || !$isDaily} {
                # No need to repeat date as it is in the trail at top of page.
		p class=details "
		[clock format [clock scan $d] -format "%e %B %Y"]
		"
	   }
           
           arNameEmitEntryDetails $arName $e details infos
           
           div class=content {
                if {[info exists infos(href)]} {
                    set img [a $infos(href) [img $infos(icon) class=initial alt= align=left]]
                } elseif {[string equal [string range $infos(icon) end-16 end] ../icon-64x64.png]} {
                    set img ""
                } else {
                    set img [img $infos(icon) alt= align=left]
                }
                
                if {[llength $entries] > 1} {
                    # Demote h2s in the article because articles are 
                    # headed by h2s in the output. 
                    regsub -all "</h2>" $infos(body) "</h3>" b
                    regsub -all "<h2" $b "<h3" b
                } else {
                    set b $infos(body)
                }
                
                regsub -all "\\&rsquo;" $b "\u2019" b
                regsub -all "\\&lsquo;" $b "\u2018" b
                regsub -all "\\&mdash;" $b "\u2014" b
                if {[regexp <p> $b]} {
                    regsub <p> $b "<div>$img</div><p class=\"first\">" b
                    emitVerbatim $b
                } else {
                    div {
                        emit $img
                    }
                    p "class=first only" "$img$b"
                }
           }

	    if {$isArchive} {
		emitReferrers
	    }
	}
    }

    if {[llength $unexpandedEntries] > 0} {
	h2 "Older entries"
	ul {
	    foreach entry $unexpandedEntries {
		entryNameLoadToArrayName $entry infos
		set d $infos(date)
		set e [file root $entry]
		push li
		set f [entryNameRetArName $e].html
		emit [a* href=$pref$f#e[file tail $e] \
			"title=Permanent URL for this entry" $infos(h1)]
		if {!$isDaily} {
		    emit [clock format [clock scan $d] -format "%e %B %Y"]
		}
		pop
	    }
	}
    }
}

proc Log::entryEmitMetadata {e} {
    variable pref
    variable absoluteUriPat
    
    set metaName [file rootname $e].meta
    if {[file exists $metaName]} {
    
        set input [open $metaName r]
        while {[gets $input line] >= 0} {
            if {[regexp "Link: <(.*)>(; .*)" $line dummy uriref atts]} {
                if {[regexp $absoluteUriPat $uriref]} {
                    set args [list "$uriref"]
                } else {
                    set p "$pref[string range [file tail $e] 0 3]"
                    set args [list "$p/$uriref"]
                }
                foreach keyval [split $atts ";"] {
                    if {[string compare [string trim $keyval] ""] == 0} {
                        continue
                    }
                    regexp "(.*)=(.*)" $keyval dummy key val
                    set val [string trim $val]
                    if {[string match "\".*\"" $val]} {
                        set val [string range $val 1 end-1]
                    }
                    lappend args [string trim $key]=$val
                }
                eval link $args
            }
        }
        close $input
    }
}

proc Log::arNameEmitEntryDetailsOld {arName e className infosName} {
    variable pref
    upvar $infosName infos
    
    if {[info exists infos(ljComment)]} {
        push p class=$className
        set inp 1
        set u "$infos(ljComment)"
        if {[info exists infos(ljCount)]} {
            p "class=$className ljComments"  "[a $u "Comment on LiveJournal ($infos(ljCount))"]"
        } else {
            emit "[a $u "Comment on LiveJournal"]"
        }
    }
    if {[llength $infos(subjects)] > 0} {
        if {$inp} {
            emit "|"
        } else {
            push p class=$className
            set inp 1
        }
        set links {}
        foreach topic $infos(subjects) {
            if {[info exists topicTitles($topic)]} {
                set topicTitle $topicTitles($topic)
            } else {
                set topicTitle $topic
            }
            if {[string match $topic.html [htmlInfo outFileName]]} {
                lappend links [strong $topicTitle]
            } elseif {[file tail [htmlOption subDir]] == 2003} {
                lappend links [a $topic.html $topicTitle]
            } else {
                lappend links [a ${pref}2003/$topic.html $topicTitle]
            }
        }
        emit [join $links ", "]
    }

    if {$inp} {
        emit "|"
    } else {
        push p class=$className
        set inp 1
    }
    if {[string compare $arName ""] == 0} {
        set f [entryNameRetArName $e].html
        emit [a* href=$pref$f#e[file tail $e] \
                "title=Permanent URL for this entry" #]
    } else {
        emit [a* href=#e[file tail $e] \
                "title=Permanent URL for this entry" #]
    }

    if {$inp} {
        pop
    }
}

proc Log::arNameEmitEntryDetails {arName e className infosName} {
    variable pref
    variable topicTitles
    upvar $infosName infos
    
    if {[info exists infos(ljComment)]} {
        push p "class=$className ljComment"
        set u "$infos(ljComment)"
        if {[info exists infos(ljCount)]} {
            emit  "[a $u "Comment on LiveJournal ($infos(ljCount))"]"
        } else {
            emit "[a $u "Comment on LiveJournal"]"
        }
        pop
    }
    
    if {[llength $infos(subjects)] > 0} {
        div class=details {
            h3 Topics
            ul "class=topics" {
                foreach topic $infos(subjects) {
                    if {[info exists topicTitles($topic)]} {
                        set topicTitle $topicTitles($topic)
                    } else {
                        set topicTitle $topic
                    }
                    if {[string match $topic.html [htmlInfo outFileName]]} {
                        li [strong $topicTitle]
                    } elseif {[file tail [htmlOption subDir]] == 2003} {
                        li [a $topic.html $topicTitle]
                    } else {
                        li [a ${pref}2003/$topic.html $topicTitle]
                    }
                }
            }
        }
    }

    push p "class=details permalink"
    if {[string compare $arName ""] == 0} {
        set f [entryNameRetArName $e].html
        emit [a* href=$pref$f#e[file tail $e] \
                "title=Permanent URL for this entry" #]
    } else {
        emit [a* href=#e[file tail $e] \
                "title=Permanent URL for this entry" #]
    }
    pop
}

proc Log::yearGenerate {thisYear} {
    variable monthNames
    variable monthAbbrs
    variable arEntries 
    variable tagline

    beginDocument {
	title "$thisYear - Damian Cugley - Alleged Literature"
        pdcMetadata
    }

    beginBody

    h1 "Archives for $thisYear"
    p id=tagline $tagline

    set firstYear 1997
    set finalYear [clock format [clock seconds] -format %Y]
    
    table cellspacing=4 {
	tr {
	    for {set y $firstYear} {$y <= $finalYear} {incr y} {
		if {$y == $thisYear} {
		    th class=highlight $y
		} else {
		    th $y
		}
	    }
	}
	    
	for {set m 1} {$m <= 12} {incr m} {
	    set mon [format %02d $m]
	    set monName [abbr* title=[lindex $monthNames $m] \
		    [lindex $monthAbbrs $m]]
	    tr {
		for {set y $firstYear} {$y <= $finalYear} {incr y} {
		    if {$y == $thisYear} {
			push td class=highlight 
		    } else {
			push td
		    }
		    if {[info exists arEntries($y/$mon)]} {
			if {$y == $thisYear} {
			    emit [a $mon.html $monName]
			} else {
			    emit [a ../$y/$mon.html $monName]
			}
		    } else {
			emit [nbsp]
		    }

		    pop
		}
	    }
	}
    }

    endBody

    endDocument
}

proc Log::yearMonthGenerate {thisYear thisMonth} {
    variable monthNames
    variable monthAbbrs
    variable arEntries 
    variable tagline

    # Find the list of entries
    set pat [format $thisYear/%02d/* $thisMonth]
    set entries {}
    foreach arName [lsort -dec [array names arEntries $pat]] {
	eval lappend entries $arEntries($arName)
    }
    
    beginDocument {
	title "[lindex $monthNames $thisMonth] $thisYear - Damian Cugley - Alleged Literature"
        pdcMetadata $entries
    }

    beginBody
    
    h1 "Archives for [lindex $monthNames $thisMonth] $thisYear"
    p id=tagline $tagline
    
    arNameEmitEntryList $entries
    
    endBody
    endDocument
}

proc Log::loadTopicsData {fileName} {
    variable topicTitles
    
    set in [open $fileName r]
    while {[gets $in line] >= 0} {
	regsub "#.*" $line "" line
	if {[regexp "(.*):(.*)" $line dummy topic title]} {
	    set topic [string trim $topic]
	    set title [string trim $title]
	    set topicTitles($topic) $title
	}
    }
}

Log::loadTopicsData ${Log::pref}2003/subjects.data
