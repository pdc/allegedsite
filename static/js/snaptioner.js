
function checkTheImageWidth(img) {
    if (img.width() > 9 * 80 - 20 && !img.is('.width-checked-nav-moved')) {
        // Image is wide enough that the navigation needs to go below it.
        $('#nav').appendTo('#content');
        $('#content').addClass('nav-below');
        img.addClass('width-checked-nav-moved');
    }
}
var img = $('#the-image img');
img.load(function () {
    checkTheImageWidth(img);
});
    
$(document).ready(function () {
    $('#other-albums:not(.other-albums-processed)')
        .addClass('other-albums-processed')
        .click(
            function () {
                $('ul', this).slideToggle();
            })
        .find('ul').hide();   
        
    
    
    checkTheImageWidth(img);
});

$(window).load(function () {
    $('.photo-list').masonry({
        singleMode: true,
        columnWidth: 240,
        resizeable: false,
        itemSelector: 'li',
        saveOptions: false
    });
});   
