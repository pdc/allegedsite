
var slideCount = 14;
var slidePixels = 560;

$(document).ready(function () {
    $('div.slide').each(function (i) {
        $(this).removeClass('slide');
        $(this).add($(this).next('p')).wrapAll('<div class="slide" />');
        var navElt = $('<div class="slide-nav">');
        if (i > 0) {
            var prevLink = $('<a href="javascript:void(0);" class="slide-prev">').text("< Prev");
            var prevIndex = i - 1;
            $(prevLink).click(function () {
                location.hash = '#slide-' + prevIndex;
                $('#slider').css('margin-left', (-prevIndex * slidePixels) + 'px');
            });
            $(navElt).append(prevLink);
        }
        if (i + 1 < slideCount) {
            var nextLink = $('<a href="javascript:void(0);" class="slide-next">').text('Next >');
            var nextIndex = i + 1;
            $(nextLink).click(function () {
                location.hash = '#slide-' + nextIndex;
                $('#slider').css('margin-left', (-nextIndex * slidePixels) + 'px');
            });
            $(navElt).append(nextLink);
        }
        $(this).after(navElt);
    });
    $('div.slide').wrapAll('<div id="slideshow"><div id="slider">');
    if (location.hash != '') {
        if (location.hash.slice(0, 7) == '#slide-') {
            var slideIndex = location.hash.slice(7);
            $('#slider').css('margin-left', (-slideIndex * slidePixels) + 'px');
        }
    }
});