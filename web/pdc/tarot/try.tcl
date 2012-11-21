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

