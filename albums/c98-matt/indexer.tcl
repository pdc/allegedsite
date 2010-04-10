#!/bin/sh
# -*-tcl-*- \
exec "wish" "$0" "$@"

# Time-stamp: <pdc 1998-04-25>
set version 1.06
wm title . "CAPTION97 Pictures $version"

cd [file dirname $argv0]

option add {*Scrollbar.borderWidth} 1 startupFile
option add {*Scrollbar.elementBorderWidth} 2 startupFile
option add {*highlightThickness} 0 startupFile

pack [frame .statusFrame -relief raised -bd 1]\
	-in . -side top -fill x
image create photo myImage
pack [frame .imageFrame -relief raised -bd 1]\
	-in . -expand 1 -fill both
pack [frame .buttonFrame -relief raised -bd 1]\
	-in . -side bottom -fill x

#
#  Image subwindow
#
# list of pictures:
pack [frame .picsFrame -relief sunken -bd 1]\
	-in .imageFrame -side left -fill both -padx 4 -pady 4
pack [label .picsLabel -text Pictures -anchor w]\
	-in .picsFrame -side top -fill x
pack [scrollbar .picsYscroll\
	-orient vert -command ".pics yview"]\
	-in .picsFrame -side right -fill y
pack [scrollbar .picsXscroll\
	-orient horiz -command ".pics xview"]\
	-in .picsFrame -side bottom -fill x
pack [listbox .pics -relief sunken -bd 1 -width 8 \
	-exportselection 0 -selectmode single \
	-xscrollcommand {.picsXscroll set}\
	-yscrollcommand {.picsYscroll set} \
	]\
	-in .picsFrame -fill y -expand 1

# the image:
pack [label .image -image myImage -relief sunken -bd 1]\
	-in .imageFrame -side left -fill both -expand 1 -padx 4 -pady 4

# list of people
pack [frame .peopleFrame -relief sunken -bd 1]\
	-in .imageFrame -side top -fill both -expand 1 -padx 4 -pady 4
pack [label .peopleLable -text People -anchor w]\
	-in .peopleFrame -side top -fill x -ipadx 4
pack [scrollbar .peopleYscroll -orient vert\
	-command ".people yview"]\
	-in .peopleFrame -side right -fill y
pack [scrollbar .peopleXscroll -orient horiz\
	-command ".people xview"]\
	-in .peopleFrame -side bottom -fill x
pack [text .people -width 25 -height 4 -relief sunken -bd 1 \
	-wrap none -setgrid 1\
	-xscrollcommand {.peopleXscroll set}\
	-yscrollcommand {.peopleYscroll set}]\
	-in .peopleFrame -fill both -expand 1

# additional description
pack [frame .descFrame -relief sunken -bd 1]\
	-in .imageFrame -side top -fill both -expand 1 -padx 4 -pady 4
pack [label .descLabel -text Description -anchor w]\
	-in .descFrame -side top -fill x -ipadx 4
pack [scrollbar .descYscroll -orient vert\
	-command ".desc yview"]\
	-in .descFrame -side right -fill y
pack [text .desc -width 25 -height 8 -relief sunken -bd 1 \
	-setgrid 1 -wrap word\
	-yscrollcommand {.descYscroll set}]\
	-in .descFrame -fill both -expand 1

pack [frame .scoreFrame]\
	-in .imageFrame -side top -fill x -padx 2 -pady 2
pack [label .scoreLabel -text Score: -anchor w]\
	-in .scoreFrame -side left -fill y -padx 2 -pady 2
tk_optionMenu .score score "(not set)" Good Keep Discard
pack .score -in .scoreFrame -fill y -padx 2 -pady 2

bind .pics <ButtonRelease-1> {
    setPic [.pics get [.pics curselection]]
}

proc setPic {newPic} {
    global curPic peoples descs fileNames score scores
    set newFile $fileNames($newPic)
    setStatus "Loading $newFile..."
    if {[string match *.jpeg $newFile] || [string match *.jpg $newFile]} {
	exec djpeg $newFile > tmp.ppm
	set newFile tmp.ppm
    }
    myImage blank
    myImage read $newFile

    updateFromWidgets
    .people delete 0.0 end
    .desc delete 0.0 end

    set curPic $newPic
    if [info exists peoples($curPic)] {
	.people insert end $peoples($curPic)
    }
    if [info exists descs($curPic)] {
	.desc insert end $descs($curPic)
    }
    if [info exists scores($curPic)] {
	set score $scores($curPic)
    } {
	set score "(not set)"
    }
    setStatus "Loaded $fileNames($curPic)"
}


proc showAllPics {} {
    global searchMode fileNames
    set files [string tolower [lsort [glob *.jpeg *.jpg *.gif"]]]
    .pics delete 0 end
    foreach file $files {
	regsub "^(.*)(\[-0-9x]*\\.jpe?g|\\.gif)" $file "\\1" pic
	set fileNames($pic) $file
	.pics insert end $pic
    }
    set searchMode {All pics}
}

proc findPersonCmd {} {
    global peoples findResult
    updateFromWidgets
    set w .findPersonDlg
    catch {destroy $w}
    toplevel $w
    wm title $w {Find person -- Damian's CAPTION97 Pictures}
    pack [frame $w.topFrame -relief raised -bd 1]\
	    -in $w -side top -fill both -expand 1
    pack [frame $w.buttonFrame -relief raised -bd 1]\
	    -in $w -fill x
    pack [frame $w.listFrame -relief sunken -bd 1]\
	    -in $w.topFrame -expand 1 -fill both -padx 4 -pady 4
    pack [scrollbar $w.listYscroll -orient vert \
	    -command "$w.list yview"]\
	    -in $w.listFrame -side right -fill y
    pack [scrollbar $w.listXscroll -orient horiz \
	    -command "$w.list xview"]\
	    -in $w.listFrame -side bottom -fill x
    pack [listbox $w.list -relief sunken -bd 1 -selectmode extended \
	    -xscrollcommand "$w.listXscroll set"\
	    -yscrollcommand "$w.listYscroll set"]\
	    -in $w.listFrame -expand 1 -fill both
    pack [button $w.okBtn -text Find -command "findPersonOkCmd $w"]\
	    -in $w.buttonFrame -side left -padx 4 -pady 4
    pack [button $w.cancelBtn -text Cancel -command "destroy $w"]\
	    -in $w.buttonFrame -side left -padx 4 -pady 4

    foreach pic [array names peoples] {
	foreach name [split [string trim $peoples($pic)] \n] {
	    lappend pics([string trim $name]) $pic
    }   }
    foreach name [lsort [array names pics]] {
	$w.list insert end $name
    }

    bind $w <Return> "$w.okBtn flash; findPersonOkCmd $w"

    set oldFocus [focus]
    set oldGrab [grab current $w]
    if {"$oldGrab" != ""} {
	set grabStatus [grab status $oldGrab]
    }
    grab set $w
    focus $w.okBtn

    tkwait window $w
    catch {focus $oldFocus}
    if {$oldGrab != ""} {
	if {"$grabStatus" == "global"} {
	    grabe -global $oldGrab
	} else {
	    grab $oldGrab
    }   }

    if [info exists findResult($w)] {
	showPeople $findResult($w) pics
    } {
	puts stderr "findResult($w) not set"
    }
}

# This is invoked when the Ok button is pressed
proc findPersonOkCmd {w} {
    global findResult
    foreach i [$w.list curselection] {
	lappend names [$w.list get $i]
    }
    if {! [info exists names]} {
	tk_dialog .message {CAPTION97 Pictures} {No names selected.} \
		Warning 0 Dismiss
	return
    }
    destroy $w
    set findResult($w) $names
    puts stderr "findResult($w)=$names"
}

proc showPeople {names picsVarName} {
    global searchMode
    upvar $picsVarName pics
    set searchMode [join $names {, }]
    if {[string length $searchMode] > 32} {
	set searchMode [string range $searchMode 0 30]...
    }
    .pics delete 0 end
    
    foreach name $names {
	foreach pic [lsort $pics($name)] {
	    lappend selPics $pic
	}
    }
    set prevPic {}
    foreach pic [lsort $selPics] {
	if {"$pic" != "$prevPic"} {
	    .pics insert end $pic
	    set prevPic pic
	}
    }
    setPic [lindex $selPics 0]
}

#
#  Buttons
#
pack [button .prevBtn -text "< Previous" -command prevCmd]\
	-in .buttonFrame -side left -padx 4 -pady 4
pack [button .nextBtn -text "Next >" -command nextCmd]\
	-in .buttonFrame -side left -padx 4 -pady 4
pack [checkbutton .autoBtn -text "Automatic every" -var auto -command autoCmd]\
	-in .buttonFrame -side left -padx 4 -pady 4
pack [entry .delay -textvar delay -relief sunken -bd 2 -width 5]\
	-in .buttonFrame -side left -padx 4 -pady 4	
pack [label .delayLabel -text seconds -anchor w]\
	-in .buttonFrame -side left -padx 4 -pady 4	

#pack [button .quitBtn -text Quit -command quitCmd]\
#	-in .buttonFrame -side right -padx 4 -pady 4
#pack [button .saveBtn -text Save -command saveCmd]\
#	-in .buttonFrame -side right -padx 4 -pady 4

	
proc quitCmd {} {
    updateFromWidgets
    savePeopleTo people.dat
    saveDescsTo descs.dat
    saveScoresTo scores.dat
    destroy .
}

proc saveCmd {} {
    updateFromWidgets
    savePeopleTo people.dat
    saveDescsTo descs.dat
    saveScoresTo scores.dat
}

proc updateFromWidgets {} {
    global peoples descs scores curPic score
    if [info exists curPic] {
	set peoples($curPic) [string trim [.people get 0.0 end]]
	set descs($curPic) [string trim [.desc get 0.0 end]]
	if {"$score" != "(not set)"} {
	    set scores($curPic) $score
	}
    }
}

proc prevCmd {} {
    global auto delay afterId
    set i [.pics curselection]
    if {"$i" == ""} {
	set i [expr [.pics size] - 1]
    } {
	.pics selection clear $i
	if {$i == 0} {
	    set i [expr [.pics size] - 1]
	} {
	    incr i -1
	}
    }
    .pics selection set $i
    .pics see $i
    setPic [.pics get $i]
    if $auto {
	set afterId [after [expr round($delay * 1000)] prevCmd]
	.prevBtn config -state disabled
	.nextBtn config -state disabled
    }
}

proc nextCmd {} {
    global auto delay afterId
    set i [.pics curselection]
    if {"$i" == ""} {
	set i 0
    } {
	.pics selection clear $i
	if {$i == [.pics size] - 1} {
	    set i 0
	} {
	    incr i
	}
    }
    .pics selection set $i
    .pics see $i
    setPic [.pics get $i]
    if $auto {
	set afterId [after [expr round($delay * 1000)] nextCmd]
	.prevBtn config -state disabled
	.nextBtn config -state disabled
    }
}

proc autoCmd {} {
    global auto afterId
    if $auto {
	setStatus {Now press Next or Previous}
    } {
	.prevBtn config -state normal
	.nextBtn config -state normal
	if [info exists afterId] {
	    after cancel $afterId
	}
    }
}


#
#  Status and Menu bar
#

pack [menubutton .file -text File -indicator on -relief raised \
	-underline 0 -menu .file.m]\
	-in .statusFrame -side left -padx 4 -pady 4
set m [menu .file.m]
$m add command -label Save -underline 0 -command saveCmd
$m add command -label Quit -underline 0 -command quitCmd

pack [label .serachLabel -text Search: -anchor w]\
	-in .statusFrame -side left -padx 4 -pady 4
pack [menubutton .search -textvar searchMode -relief raised\
	-underline 0 -indicator 1 -menu .search.m]\
	-in .statusFrame -side left -padx 4 -pady 4
set m [menu .search.m]
$m add command -label {All} -underline 0 -command showAllPics
$m add command -label {Person...} -underline 0 -command findPersonCmd

#pack [label .searchMode -textvar searchMode -anchor w -relief sunken -bd 1]\
#	-in .statusFrame -side left -padx 4 -pady 4 -fill x
pack [label .status -textvar status -anchor w -relief sunken -bd 1]\
	-in .statusFrame -padx 4 -pady 4 -expand 1 -fill x

proc setStatus text {
    global status
    set status $text
    update idletasks
}

proc savePeopleTo {fileName} {
    global peoples
    setStatus "Writing people to $fileName..."
    set out [open $fileName w]
    foreach pic [lsort [array names peoples]] {
	foreach person [split $peoples($pic) \n] {
	    if {[llength $person] == 2} {
		puts $out "$pic:[lindex $person 0]:[lindex $person 1]:"
	    } elseif {[llength $person] == 1} {
		puts $out "${pic}::[string trim $person]:"
	    } elseif {[llength $person] >= 3} {
		set lastFname [expr [llength $person] - 2]
		if [regexp "^\[a-z]" [lindex $person $lastFname]] {
		    incr lastFname -1
		}
		puts $out "$pic:[lrange $person 0 $lastFname]:[lrange \
			$person [expr $lastFname + 1] end]:"
	    }
	}
    }
    close $out
    setStatus "Wrote people to $fileName."
}

proc saveDescsTo {fileName} {
    global descs
    setStatus "Writing descriptions to $fileName..."
    set out [open $fileName w]
    foreach pic [lsort [array names descs]] {
	foreach line [split [string trim $descs($pic) \n] \n] {
	    puts $out "$pic:$line:"
	}
    }
    close $out
    setStatus "Wrote descriptions to $fileName."
}

proc saveScoresTo {fileName} {
    global scores
    setStatus "Writing scores to $fileName..."
    set out [open $fileName w]
    foreach pic [lsort [array names scores]] {
	puts $out $pic:$scores($pic):
    }
    close $out
    setStatus "Wrote scores to $fileName."
}

proc loadPeopleFrom {fileName} {
    global peoples
    if {! [file readable $fileName]} {
	setStatus "No people file found"
	return
    }
    setStatus "Reading people from $fileName..."
    set in [open $fileName r]
    while {[gets $in line] >= 0} {
	if [regexp "(.*):(.*):(.*):" $line dummy pic first last] {
	    append peoples($pic) "$first $last\n"
	}
    }
    close $in
    setStatus "Read people from $fileName"
}

proc loadDescsFrom {fileName} {
    global descs
    if {! [file readable $fileName]} {
	setStatus "No descriptions file found"
	return
    }
    setStatus "Reading descriptions from $fileName..."
    set in [open $fileName r]
    while {[gets $in line] >= 0} {
	if [regexp "(.*):(.*):" $line dummy pic line] {
	    append descs($pic) "$line\n"
	}
    }
    close $in
    setStatus "Read descriptions from $fileName"
}

proc loadScoresFrom {fileName} {
    global scores
    if {! [file readable $fileName]} {
	setStatus "No scores file found"
	return
    }
    setStatus "Reading scores from $fileName..."
    set in [open $fileName r]
    while {[gets $in line] >= 0} {
	regexp "(.*):(.*):" $line dummy pic score
	set scores($pic) $score
    }
    close $in
    setStatus "Read scores from $fileName"
}

showAllPics
loadPeopleFrom people.dat
loadDescsFrom descs.dat
loadScoresFrom scores.dat
.pics selection set 0
set delay 5
setPic [.pics get 0]

