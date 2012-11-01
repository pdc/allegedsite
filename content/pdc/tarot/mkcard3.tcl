# mkcard3.tcl -- generate *-card3.svg from *.svg   -*-tcl-*-
# Time-stamp: <pdc 2003-11-29>

proc abbr* {args} {}
proc a {args} {
    return [lindex $args end]
}


source tarotDefs.tcl
source descs.tcl

proc log {text } {
    puts stderr $text
}

########################################################################
#
# New! Add descriptions to cards

proc wordLength {w} {
    # TODO. True width of word
    return [string length $w]
}

proc spaceLength {} {
    return 1
}

proc fillParagraph {maxLength ws} {
    # Simplest algorithm: take words until line would be too long
    set pss {}
    set lineLength 0
    set sl [spaceLength]
    set ls {}
    foreach w $ws {
	set wl [wordLength $w]
	if {$lineLength + $wl + $sl > $maxLength} {
	    lappend pss $ls
	    set ls [list $w]
	    set lineLength $wl
	} else {
	    lappend ls $w
	    incr lineLength [expr $wl + $sl]
	}
    }
    if {[list length $ls] > 0} {
	lappend pss $ls
    }
    return $pss
}

proc fillParagraphs {maxLength wss} {
    set psss {}
    foreach ws $wss {
	lappend psss [fillParagraph $maxLength $ws]
    }
    return $psss
}

proc em {args} {
    return [string toupper [join $args " "]]
}

proc p {text} {
    upvar currentPars currentPars
    regsub -all "\\&nbsp;" $text "\u00A0" text
    regsub -all "\\&ordm;" $text "\u00BA" text
    regsub -all "\\&ndash;" $text "\u2013" text
    regsub -all "\\&mdash;" $text "\u2014" text
    regsub -all "\\&lsquo;" $text "\u2018" text
    regsub -all "\\&rsquo;" $text "\u2019" text
    lappend currentPars $text
}

array set opts {
    maxLineLength 36
    lineHeight 14
    parSkip 14
    textHeight 200
    pageWidth 240
    textLeft 10
    textTop 25
}

proc nameDesciption {name} {
    global cardDescs currentPar opts beforeDesc afterDesc descriptionPageCount


    if {![info exists cardDescs($name)]\
	    || [string compare $cardDescs($name) ""] == 0} {
	return ""
    }

    set script $cardDescs($name)
    set currentPars {}
    eval $script

    set psss [fillParagraphs $opts(maxLineLength) $currentPars]
    set x $opts(textLeft)
    set y $opts(textTop)
    set frags {}
    set npages 1
    foreach pss $psss {
	foreach ps $pss {
	    if {$y > $opts(textHeight)} {
		set y $opts(textTop)
		incr x $opts(pageWidth)
		incr npages
	    }
	    lappend frags "<tspan x=\"$x\" y=\"$y\">[join $ps " "]</tspan>"
	    incr y $opts(lineHeight)
		
	}
	incr y $opts(parSkip)
    }
    set text "$beforeDesc\n\t\t[join $frags "\n\t\t"]\n"
    append text "\t    </text>"

    for {set i 1} {$i < $npages} {incr i} {
	set x [expr $opts(textLeft) + $opts(pageWidth) * $i + 15]
	set y [expr $opts(textTop) + $opts(textHeight)]
	append text "\n\t    <path id=\"prev$i\" d=\"M$x,$y l-15,7.5 15,7.5z\" \
		    stroke=\"#900\" stroke-width=\"2\" fill=\"#F90\"/>"
	append text "\n\t    <animateTransform attributeName=\"transform\" \
		type=\"translate\" \
		values=\"[expr $i * -$opts(pageWidth)],0;\
		[expr ($i - 1) * -$opts(pageWidth)],0\" \
		fill=\"freeze\" begin=\"prev$i.click\" dur=\"0.5s\"/>"
    } 
    for {set i 0} {$i + 1 < $npages} {incr i} {
	set x [expr $opts(textLeft) + $opts(pageWidth) * $i + 165]
	set y [expr $opts(textTop) + $opts(textHeight)]
	append text "\n\t    <path id=\"next$i\" \
		d=\"M$x,$y l15,7.5 -15,7.5z\" \
		stroke=\"#900\" stroke-width=\"2\" fill=\"#F90\"/>"
	append text "\n\t    <animateTransform attributeName=\"transform\" \
		type=\"translate\" \
		values=\"[expr $i * -$opts(pageWidth)],0;\
		[expr ($i + 1) * -$opts(pageWidth)],0\" \
		fill=\"freeze\" begin=\"next$i.click\" dur=\"0.5s\"/>"
    } 
    append text $afterDesc
    return $text
}

set beforeDesc  {
<g transform="scale(2)">
    <g id="text" opacity="0">
	<rect x="5" y="5" width="190" height="240" rx="5" ty="5"
		fill="#FFF" stroke="#000" opacity="0.75"/>
	<g>
	    <text font-size="10" font-family="garamond, baskerville, serif" 
		   fill="#000" stroke="none">
}
set afterDesc  {
	</g>
        <g id="hideTextBtn" transform="translate(180,2.5)"
 		  fill="#F90" stroke="#900" stroke-width="1">
	    <rect x="0" y="0" width="7" height="7" />
            <path d="M1.5,1.5 L5.5,5.5 M1.5,5.5 L5.5,1.5" 
                    stroke="#C60">
                <set attributeName="stroke" to="#600" 
                        begin="hideTextBtn.mouseover"/>
                <set attributeName="stroke" to="#C60"
                        begin="hideTextBtn.mouseout"/>
            </path>
        </g>
	<animate attributeName="opacity" values="0;1" 
		begin="showTextBtn.click" dur="0.5" fill="freeze"/>
	<animateTransform attributeName="transform" type="scale"
		values="0.05;1"  additive="sum"
		begin="showTextBtn.click" dur="0.5"/>
	<animate attributeName="opacity" values="1;0" 
		begin="hideTextBtn.click" dur="0.5" fill="freeze"/>
	<animateTransform attributeName="transform" type="scale" 
		values="1;0.05" additive="sum"
		begin="hideTextBtn.click" dur="0.5"/>
    </g>
</g>
    <rect id="showTextBtn" x="10" y="10" rx="1.5" ry="1.5" width="9" height="11"
	    stroke="#900" stroke-width="1.5" fill="#F90">
	<set attributeName="opacity" to="0" begin="showTextBtn.click"/>
	<animate attributeName="opacity" to="1" fill="freeze"
                begin="hideTextBtn.click" dur="0.75"/>
    </rect>
    <g id="showTextBtnHint" opacity="0"> 
        <rect x="17" y="17" width="150" height="13" rx="1" ry="1"
	        fill="#F8F8F0" stroke="#000" stroke-width="0.5"/>
        <text x="20" y="26" fill="#009" stroke="none"
	        font-family="arial, helvetica, sans-serif" font-size="12">
    	    Click to show commentary
    	</text>
    	<set attributeName="opacity" fill="freeze"
    	        begin="showTextBtn.mouseover" to="1"/>
    	<set attributeName="opacity" fill="freeze"
    	        begin="showTextBtn.mouseout" to="0"/>
    	<set attributeName="opacity" fill="freeze"
    	        begin="showTextBtn.click" to="0"/>
    </g>
}

proc nameInsertDescription {name text} {
    set repl [nameDesciption $name]
    if {"$repl" != ""} {
	set p [string last </svg> $text]
	return "[string range $text 0 [expr $p - 1]]\n$repl\n</svg>\n"
    }
    return $text
}

########################################################################




# Convert XML attributes in to a dictionary
proc parseAtts {text arrayName} {
    upvar $arrayName atts 
    foreach {dummy name val} [regexp -all -inline \
	    "(\[:A-Za-z\]*)=\"(\[^\"\]*)\"" $text] {
	set atts($name) $val
    }
}

# Fiven a file name, return the SVG data in that file.
# The SVG is modified to be suitable for
# insertion as a replacement for the 'image' element.
# The attsName argument is an array containing attributes.
proc imageReplacement {fileName attsName} {
    upvar $attsName atts

    log " $fileName:"
    set in [open $fileName r]
    set text [read $in 2048]

    # Strip the processing instructions.
    regsub "<\\? \[^<>\]*\\?>\s*" $text "" text

    foreach attName {width height x y xmlns xmlns:xlink preserveAspectRatio} {
	if {[info exists atts($attName)]} {
	    # Replace attribute.
	    if {[regsub "(\\s+$attName=\")\[^\"\]*\"" $text\
		    "\\1$atts($attName)\"" text]} {
	    } else {
		# Insert it instead
		regsub ">" $text \
			" $attName=\"$atts($attName)\">" text
	    } 
	} else {
	    # Delete this attribute.
	    regsub "\\s+$attName=\"\[^\"\]*\"" $text "" text
	}
    }

    append text [read $in]
    close $in

    return $text
}

# Given SVG data, find <image> elements and attempt to replace them.
# Only groks a subset of SVG syntax!
proc replaceImages {text} {
    set start 1
    while {[regexp -start $start -indices "<image (\[^<>\]*)/>" \
	    $text tagRange attsRange]} {

	# Generate the replacement 'svg' element.
	set attsString [eval string range [list $text] $attsRange]
	parseAtts $attsString atts
	set svg [eval imageReplacement $atts(xlink:href) atts]

	# Replace the tag with the SVG data.
	set text [eval string replace [list $text] $tagRange [list $svg]]
	
	set start [expr [lindex $tagRange 0] + [string length $svg]]
    }

    return $text 
}

proc defineMacro {key val} {
    global macroMaps
    set macroMaps(\{\$$key\}) $val
}

proc replaceMacros1 {text} {
    global macros

    set start 1
    while {[regexp -start $start -indices "\\{\\$(\[^{}\]*)\\}" \
	    $text tagRange nameRange]} {
	set name [eval string range $text $nameRange]
	set text [eval string replace [list $text] $tagRange $macros($name)]
	
	set start [lindex $tagRange 1]
    }
}

proc replaceMacros {text} {
    global macroMaps
    return [string map [array get macroMaps] $text]
}

proc processFile {card fileName} {
    log $fileName:
    set in [open $fileName r]
    set text [read $in]
    close $in

    set text [replaceMacros $text]
    set text [replaceImages $text]
    set text [nameInsertDescription $card $text]
    puts [encoding convertto utf-8 $text]
}

proc processCard {card} {
    global reversedKeywords uprightKeywords

    defineMacro card $card
    defineMacro upright $uprightKeywords($card)
    defineMacro reversed $reversedKeywords($card)

    set title [titleFor $card]
    defineMacro title $title
    defineMacro titleLC [string tolower $title]
    defineMacro titleNoNumberLC [string tolower \
	    [join [lrange [split $title] 1 end]]]

    switch -regexp $card {
	(wands|cups|swords|coins)-(ten|[2-9]) {
	    set templ pips
	}
	default {
	    set templ trumps
    }   }
    processFile $card $templ-templ.xml
}

foreach arg $argv {
    processCard $arg
}