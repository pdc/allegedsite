# -*-tcl-*-
# Time-stamp: <pdc 2003-11-30>

set numNames {Zilch Ace Two Three Four Five Six Seven Eight Nine Ten}
set allSuits {wands cups swords coins}

# titleFor --
#  Return the title for the named card.
proc titleFor {card} {
    global cardTitles numNames
    if {[info exists cardTitles($card)]} {
	return $cardTitles($card)
    } elseif {[regexp (0|\[ivx\]+)-(.*) $card dummy num text]} {
	set text [join [split $text -] " "]
	set text [string totitle $text]
	return  "[string toupper $num]. The $text"
    } else {
	regexp (.*)-(.*) $card dummy suit num
	if {[regexp "\[0-9\]+" $num]} {
	    set num [lindex $numNames $num]
	}
	return "The [string totitle $num] of [string totitle $suit]"
    }
}

proc beginBody {{extraLink ""}} {
    push p id=trail
    ##emit "[a* href=../../ "title=Alleged Literature home page" \
    ##	    [img ../../img/alleged-03@32x16.png \
    ##	    "alt=Alleged Literature"]] &rarr;"
    emit "[a ../ "Damian Cugley"] &rarr;"
    if {[string compare [htmlInfo outFileName] index.html] != 0} {
	emit "[a ./ "Alleged Tarot 2002"] &rarr;"
    }
    if {[string compare $extraLink ""] != 0} {
	emit "$extraLink &rarr;"
    }
    pop
    push div id=body
}

proc endBody {} {
    pop
}

proc surTitle {text} {
    p id=surtitle $text
}

source [file join [file dirname [info script]] ../abbrDefs.tcl]

