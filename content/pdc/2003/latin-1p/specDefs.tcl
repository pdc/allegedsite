# -*-tcl-*-
# Time-stamp: <pdc 2003-01-21>

proc beginBody {} {
    push p class=trail
    emit "[a ../../../ Alleged Literature]"
    emit ": [a ../../ Damian Cugley]"
    emit ": [a ../ 2003]"

    set fn [file tail [file root [htmlInfo outFileName]]]
    if {[string compare $fn index] != 0} {
	emit ": [a ./ Latin-1p]"
    }
    pop
    push div id=body
}

proc endBody {} {
    pop
}