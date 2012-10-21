# Definitions for displaying albums using TclHTML.

# A file containing a definition for the Tcl variable albumTitles.
# This is indexed by albumId.
source $albumsDir/albums.data


# log --
#  Print a progress message.
proc log {text} {
    puts $text
}

# fileNameFromName --
#  Return the file name for this person's page.
proc fileNameForPerson {per} {
    global peopleNames
    return [fileNameForName $peopleNames($per)]
}

proc fileNameForName {name} {
    global peopleNames

    set name [string tolower [string trim [join $name " "]]]
    if {[string compare $name ""] == 0} {
	set name things
    }
    if {[string compare $name ?] == 0} {
	set name unknown
    }

    regsub -all " " $name - name
    regsub -all "\['()]" $name "" name

    # Remove accented letters...
    regsub -all "\[\300-\305\340-\345]" $name a name
    regsub -all "\[\306\346]" $name ae name
    regsub -all "\[\307\347]" $name c name
    regsub -all "\[\310-\313\350-\353]" $name e name
    regsub -all "\[\314-\317\354-\357]" $name i name
    regsub -all "\[\320\360]" $name dh name; # eth
    regsub -all "\[\321\361]" $name n name
    regsub -all "\[\322-\326\330\362-\366\370]" $name o name
    regsub -all "\[\331-\334\371-\374]" $name u name
    regsub -all "\[\335\375]" $name y name ; # y with acute
    regsub -all "\[\336\376]" $name th name ;# thorn
    regsub -all "\[\337]" $name ss name ;# Eszet
    regsub -all "\[\377]" $name y name ; # y with two dots
    regsub -all "&scaron;" $name s name ; # s with caron


    return $name.html
}

########################################################################


# readScoresFile -- 
#  Scan the socres file and deposit information in diovers arrays
proc readScoresFile {fileName} {
    global pictureScores
    set in [open $fileName r]
    while {[gets $in line] >= 0} {
	set xs [split $line :]
	set pic [lindex $xs 0]
	set score [lindex $xs 1]

	# convert the score from a keyword to a number
	set n [lsearch {Discard Keep Good} $score]
	if {$n > 0} {
	    set pictureScores($pic) $n
	}
    }
    close $in
}

proc readPeopleFile {fileName} {
    global pictureScores peoplePictures picturePeople peopleNames
    set in [open $fileName r]
    while {[gets $in line] >= 0} {
	set xs [split $line :]
	set pic [lindex $xs 0]

	# skip all pictures that aren't at least "Keep"
	if {![info exists pictureScores($pic)] || $pictureScores($pic) < 1} {
	    continue
	}

	set gn [lindex $xs 1]
	set sn [lindex $xs 2]

	set peopleNames($sn.$gn) [string trim "$gn $sn"]
	lappend peoplePictures($sn.$gn) $pic
	lappend picturePeople($pic) $sn.$gn

	# keep a note of the best picture of that person
	if {![info exists peoplePictures($sn.$gn/icon)]\
    		|| $peoplePictures($sn.$gn/score) < $pictureScores($pic)} {
	    set peoplePictures($sn.$gn/icon) $pic
	    set peoplePictures($sn.$gn/score) $pictureScores($pic)
	}
    }
    close $in
}

proc readDescsFile {fileName} {
    global pictureScores pictureDescs
    set in [open $fileName r]
    while {[gets $in line] >= 0} {
	set xs [split $line :]
	set pic [lindex $xs 0]
	if {![info exists pictureScores($pic)] || $pictureScores($pic) < 1} {
	    continue
	}
	set desc  [lindex $xs 1]
	lappend pictureDescs($pic) $desc
    }
    close $in
    foreach pic [array names pictureDescs] {
	set pictureDescs($pic) [join $pictureDescs($pic) "\n<br />"]
    }
}

# Ensure that all the picture files have been copied to
# the destination directory, and that icons hgave all been generated.
proc generatePictures {} {
    global srcDir dstDir pictureScores peoplePictures peopleNames picturePeople

    foreach pic [array names pictureScores] {
	set dstFile [file join $dstDir $pic.jpg]
	if {![file exists $dstFile]} {
	    log "generatePictures: copying $pic"
	    file copy [file join $srcDir $pic.jpg] $dstFile
	}

	set dstFile [file join $dstDir $pic-thumb.jpg]
	if {![file exists $dstFile]} {
	    log "generatePictures: $dstFile"

	    exec djpeg [file join $srcDir $pic.jpg] |\
		    pnmscale -xysize 100 100  |\
		    cjpeg -quality 75 -optimize > $dstFile 2> tmp.log
	}
    }
}

proc initializeAlbum {id dirName aname occ desc kwds css beginSc endSc} {
    global srcDir dstDir thisAlbum occasion album
    set album(id) $id
    set srcDir $dirName
    set dstDir [file join [htmlOption htmlRootDir] [htmlOption subDir]]
    set album(occasion) $occ
    set album(title) $aname
    set album(description) $desc
    lappend $kwds $occ $aname
    set album(keywords) [lsort $kwds]
    set album(stylesheet) $css
    set album(beginScript) $beginSc
    set album(endScript) $endSc

    readScoresFile [file join $srcDir scores.dat]
    readPeopleFile [file join $srcDir people.dat]
    readDescsFile [file join $srcDir descs.dat]
    generatePictures
}


########################################################################

# emitPeople --
#  Create an list of links to pictures of people,
#  arranged as an HTML table.
# Arguments --
#  nCols -- Number of columns in the table
proc emitPeople {nCols} {
    global peopleNames peoplePictures

    table cols=$nCols {
	push tr align=right valign=top

	set i 0
	set lr left
	foreach per [lsort [array names peopleNames]] {
	    if {[incr i] > $nCols} {
		pop
		push tr align=$lr valign=top
		switch $lr {
		    left {
			set lr right
		    } 
		    default {
			set lr left
		}   }
		set i 1
	    }

	    push td
	    p class=td "
	    [a [fileNameForPerson $per] \
		    [img $peoplePictures($per/icon)-thumb.jpg\
		    "alt=Link to pictures of $peopleNames($per)"]<br>\
		    $peopleNames($per)]<br>"

	    pop
	}
	pop
    }
}


# emitUrlForPerson --
#  If this person has a URL, emit a paragraph.
proc emitUrlForPerson {per} {
    global peopleUrls peopleNames

    if {[info exists peopleUrls($peopleNames($per))]} {
	p class=url "
	[a $peopleUrls($peopleNames($per))\
		"$peopleNames($per) has a web site."]
	"
    }
}

# emitPicturesForPerson --
#  For each picture for the specified person,
#  emit a paragraph containing the picture and its decription.
proc emitPicturesForPerson {per} {
    global peoplePictures picturePeople pictureDescs peopleNames

    foreach pic $peoplePictures($per) {
	push p
	emit "[img $pic.jpg]<br><small>$pic</small>"
	foreach other $picturePeople($pic) {
	    if {$other == [lindex $picturePeople($pic) end]} {
		set comma "."
	    } else {
		set comma ", "
	    }
	    if {[string compare $other $per] == 0} {
		emit [strong $peopleNames($other)]$comma
	    } else {
		emit [a [fileNameForPerson $other] $peopleNames($other)]$comma
	    }
	}
	if {[info exists pictureDescs($pic)]} {
	    emit $pictureDescs($pic)
	}
	pop
    }
}

# Emit thumbnails for all pictures in alphabetcial order of picture id.
# (For numbered scans this is also chronological order.)
proc emitAllPictures {} {
    global picturePeople peopleNames pictureDescs dstDir pictureScores

    set lr left
    foreach pic [lsort [array names pictureScores]] {
	if {[file exists [file join $dstDir $pic-thumb.jpg]]} {
	    push p "class=${lr}pic pic" align=$lr
	    emit "[a $pic.html \
		    [img $pic-thumb.jpg align=$lr border=1 \
		    alt=]]"
	    # [small [em $pic]]
	} else {
	    push p
	    emit "[a $pic.html [small [em $pic]]] &#183;"
	}

	if {[info exists pictureDescs($pic)]} {
	    emit "$pictureDescs($pic)"
	}
	if {[info exists picturePeople($pic)]} {
	    emit "<br />"
	    foreach per $picturePeople($pic) {
		if {[string compare $per \
			[lindex $picturePeople($pic) end]] == 0} {
		    set comma .
		} else {
		    set comma ,
		}
		emit [a [fileNameForPerson $per] $peopleNames($per)]$comma
	    }
	}
	pop

	switch $lr {
	    left {
		set lr right
	    } 
	    default {
		set lr left
    }   }   }
}


########################################################################



# albumTitle --
#  Return the human-readable title of this album.
proc albumTitle {id} {
    global albumTitles
    return $albumTitles($id)
}

# albumDir --
#  Return the directory on my disc where the working copy
# of the HTML for this album goes.
# The dir name does NOT end with a slash.
proc albumDir {id} {
    return /home/pdc/public_html/$id
}

# albumUrl --
#  Return the base URL for the album.
proc albumUrl {id} {
    switch -glob $id {
	alleged/*  {
	    return http://www.alleged.demon.co.uk/[string range $id 8 end]
	}
	tuschin/* {
	    return http://www.alleged.org.uk/[string range $id 8 end]
	}
	caption.org/* {
	    return http://caption.org/[string range $id 12 end]
	}
    }
}

# albumIds --
#  Return the list of all album ids.
proc albumIds {} {
    global albumTitles
    return [lsort [array names albumTitles]]
}

proc emitOtherAlbumsForName {myId name} {
    global albumTitles peopleNames

    set file [fileNameForName $name]
    set title [string trim [join $name " "]]

    set first 1
    foreach id [albumIds] {
	if {[string compare $id $myId] == 0} {
	    continue
	}

	set href [albumUrl $id]/$file
	if {[file exists [file join [albumDir $id] $file]]} {
	    if {$first} {
		push dl
		set first 0
	    }
	    dt "[a $href $title at [albumTitle $id]]"
	}
    }

    if {!$first} {
	pop
    }
}


########################################################################

proc emitPicturePages {{script {}}} {
    global album picturePeople peopleNames pictureDescs pictureScores

    foreach pic [array names pictureScores] {
	beginDocument -file $pic.html {
	    title "$pic - $album(title) - $album(occasion)"
	    stylesheet $album(stylesheet)
	    description $album(description)
	    eval keywords $album(keywords)
	}

	eval $album(beginScript)
	h1 $album(title)

	h2 "Picture #[em $pic]"
	push p
	emit "[img $pic.jpg]<br><small>$pic</small>"
	if {[info exists picturePeople($pic)]} {
	    foreach per $picturePeople($pic) {
		if {$per == [lindex $picturePeople($pic) end]} {
		    set comma "."
		} else {
		    set comma ", "
		}
		emit [a [fileNameForPerson $per] $peopleNames($per)]$comma
	    }
	}
	if {[info exists pictureDescs($pic)]} {
	    emit $pictureDescs($pic)
	}
	pop
	eval $album(endScript)
	endDocument
    }
}

proc emitPictureIndexPage {fileName {script {}}} {
    global album picturePeople peopleNames pictureDescs

    beginDocument -file $fileName {
	title "Picture index - $album(title) - $album(occasion)"
	stylesheet $album(stylesheet)
	description $album(description)
	eval keywords $album(keywords)
    }

    eval $album(beginScript)
    h1 $album(title)
    uplevel $script
    h2 "Picture index"

    emitAllPictures

    eval $album(endScript)
    endDocument
}

proc emitPeoplePages {{script {}}} {
    global album picturePeople peopleNames pictureDescs

    foreach per [array names peopleNames] {
	beginDocument -file [fileNameForPerson $per] {
	    title "$peopleNames($per) - $album(title) - $album(occasion)"
	    stylesheet $album(stylesheet)
	    description "$peopleNames($per) at $album(occasion).  $album(description)"
	    eval keywords $album(keywords) [list $peopleNames($per)]
	}

	eval $album(beginScript)
	h1 $album(title)

	h2 "$peopleNames($per) at $album(occasion)" 

	emitUrlForPerson $per
	emitPicturesForPerson $per
	emitOtherAlbumsForName $album(id) $peopleNames($per)

	eval $album(endScript)
	endDocument
    }
}

proc emitPeopleIndex {fileName {script {}}} {
    global album picturePeople peopleNames pictureDescs

    beginDocument -file $fileName {
	title "$album(title) - $album(occasion)"
	stylesheet $album(stylesheet)
	description $album(description)
	eval keywords $album(keywords)
    }

    eval $album(beginScript)
    h1 $album(title)

    uplevel $script

    h2 People
    emitPeople 3

    eval $album(endScript)
    endDocument
}
