function replaceEmbed(context$) {
    $('embed', context$).each(function(i) {
        var src = this.src;
        if (src.slice(-4) == '.svg') {
            src = src.slice(0, -4) + '-' + this.width + 'x' + this.height + '.png';
        }
        var replacement$ = $('<img>').attr({
            src: src,
            alt: this.alt,
            width: this.width,
            style: $(this).attr('style')
        });
        $(this).replaceWith(replacement$);
    });
}

function isSvgSupported() {
    /* From Mark Pilgrim’s Dive Into HTML5 <http://diveintohtml5.org/everything.html>: */
    return !!(document.createElementNS 
        && document.createElementNS('http://www.w3.org/2000/svg', 'svg').createSVGRect);
}

$(document).ready(function () {
    if (!isSvgSupported()) {
        replaceEmbed();
    }
});