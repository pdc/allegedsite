$(function () {
    // How many entries to show from each of the feeds.
    var maxTweets = 1;
    var maxLivejournal = 1;
    var maxGalleries = 1;
    var maxVideos = 1;
    var maxGithub = 3;

    var monthAbbrs = 'Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec';
    var monthAbbrevs = 'Jan.|Feb.|March|April|May|June|July|Aug.|Sept.|Oct.|Nov.|Dec.'.split('|');
    function pad2(n) {
        return n < 10 ? '0' + (+n) : n
    }

    // The text uses HTML escapes for ampersands etc.,
    // so I could just use jQuery’s html method here,
    // but do I want to trust Twitter to be immune to XSS attacks?
    // Instead I reverse the HTML escaping jQuery’s text method will apply.
    function unentity(text) {
        return text.replace(/&quot;/g, '"').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&amp;/g, '&');
    }

    var twitterLink = $('#twitter-link'),
        twitterItem =  twitterLink.parents('li').eq(0);
    var u = twitterLink.attr('href');
    u = 'http://search.twitter.com/search.json?q=from:' + u.replace(/^.*\//, '');
   twitterItem.addClass('loading');
    $.ajax({
        url: u,
        dataType: 'jsonp',
        success: function (data, textStatus, request) {
            twitterItem.removeClass('loading');
            var tweetCount = 0;
            for (var i in data.results) {
                var className = 'twitter';
                var tweet = data.results[i];
                var isReply = (tweet.text.substr(0, 1) == '@'),
                    isRetweet = (tweet.text.substr(0, 3) == 'RT ');
                if (isReply || isRetweet) {
                    // Skip replies since they don’t usually make sense in isolation.
                    continue;
                }
                var m = /(Mon|Tue|Wed|Thu|Fri|Sat|Sun), (\d\d?) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) (\d{4}) (\d\d:\d\d:\d\d) \+0000/.exec(tweet.created_at)
                var mon = (monthAbbrs.indexOf(m[3]) + 4) / 4;
                var when = m[4] + '-' + pad2(mon) + '-' + pad2(m[2]) + 'T' + m[5];
                var whenFormatted = m[2] + ' ' + monthAbbrevs[mon - 1] /* + ' ' + m[4] */;
                var articleElt = $('<p>').attr({
                    'class': className,
                    'data-date': when
                });
                $('<img>').attr({
                    'src': tweet.profile_image_url,
                    'alt': ''
                }).appendTo(articleElt);
                $('<p>').appendTo(articleElt).text(unentity(tweet.text));

                var details = $('<small>').appendTo(twitterItem);
                $('<a>').attr({
                    href: 'http://twitter.com/' + (isRetweet ? other : 'damiancugley') + '/status/' + tweet.id,
                    title: when
                }).text(whenFormatted + ' ').append('<b>#</b>').appendTo(details);

                twitterItem.append(articleElt);

                if (++tweetCount >= maxTweets) {
                    break;
                }
            }
            checkSliderHeight();
        }
    });

    // Now someting similar for Flickr
    var u = '/pdc/from/flickr';
    var flickrLink = $('#flickr-link'),
        flickrItem = flickrLink.parents('li').eq(0);

    flickrItem.addClass('loading');
    $.ajax({
        url: u,
        format: 'json',
        success: function (data, textStatus, request) {
            if (data && data.success) {
                var flickrCount = 0;
                for (var i in data.entryGroups) {
                    var dateData = data.entryGroups[i];
                    var date = dateData.published;
                    var entries = dateData.entries;
                    var articleElt = $('<p>').attr({
                        'data-date': date,
                        'class': 'flickr photos'
                    });
                    for (var j in entries) {
                        var entry = entries[j];

                        var photoElt = $('<a>').attr({
                            href: entry.href,
                            title: entry.title
                        });
                        $('<img>').attr({
                            src: entry.square.href,
                            alt: '[image]'
                        }).appendTo(photoElt);
                        photoElt.appendTo(articleElt);
                    }
                    articleElt.append($('<br clear="left">'));

                    var detailsElt = $('<small>').appendTo(flickrItem);
                    detailsElt.text(date.substr(8, 2) + ' ' + monthAbbrevs[date.substr(5, 2) - 1]);

                    flickrItem.append(articleElt);

                    if (++flickrCount >= maxGalleries) {
                        break;
                    }
                }
                checkSliderHeight();
            }
        }
    });

    // Helper function for adding feed item(s) to ego page.
    // Arguments --
    //     linkSelector -- how jQuery finds the A tag linking to the site
    //      urlForJsonifiedFeed -- how to download the feed
    //      maxEntries -- show at most this many items
    //      articleFromEntry -- function taking an entry & returning HTML element
    //      detailsFromEntry -- function taking entry & returning HTML element
    function addItemsFromAtom(linkSelector, urlForJsonifiedFeed, maxEntries, articleFromEntry, detailsFromEntry) {
        var linkElt = $(linkSelector),
            itemElt = linkElt.parents('li').eq(0);
        itemElt.addClass('loading');
        $.ajax({
            url: urlForJsonifiedFeed,
            format: 'json',
            success: function (data, textStatus, request) {
                itemElt.removeClass('loading').addClass('loaded');
                if (data && data.success) {
                    var n = (data.entries.length > maxEntries ? maxEntries : data.entries.length)
                    for (var j = 0; j < n; ++j) {
                        var entry = data.entries[j];
                        itemElt.append(detailsFromEntry(entry));
                        itemElt.append(articleFromEntry(entry));
                    }
                    checkSliderHeight();
                }
            }
        });
    }
    // An example implementation of a detailsFromEntry function.
    //  Returns the date & a link to the article in question.
    function clickableDateFromEntry(entry) {
        var date = entry.published;
        var detailsElt = $('<small>');
        $('<a>').attr('href', entry.href)
            .text(date.substr(8, 2) + ' ' + monthAbbrevs[date.substr(5, 2) - 1] + ' ')
            .append('<b>#</b>')
            .appendTo(detailsElt);
        return detailsElt;
    }

    addItemsFromAtom('#livejournal-link', '/pdc/from/livejournal', maxLivejournal,
        function (entry) {
            var date = entry.published;
            var articleElt = $('<article>').attr({
                'data-date': date,
                'data-id': entry.id
            });

            var headingElt = $('<h4>').appendTo(articleElt);
            var linkElt = $('<a>').attr({
                href: entry.href,
            }).text(entry.title || entry.content.substr(0, 64));
            linkElt.appendTo(headingElt);

            var contentElt = $('<p>').appendTo(articleElt);
            contentElt.text(entry.content)

            return articleElt;
        },
        clickableDateFromEntry
    );

    addItemsFromAtom('#github-link', '/pdc/from/github', maxGithub,
        function (entry) {
            var date = entry.published;
            var articleElt = $('<article>').attr({
                'data-date': date,
                'data-id': entry.id
            });

            var headingElt = $('<h4>').appendTo(articleElt);
            var linkElt = $('<a>').attr({
                href: entry.href,
            }).text(entry.title || entry.content.substr(0, 64));
            linkElt.appendTo(headingElt);

            if (typeof (entry.html) !== 'undefined') {
                var contentElt = $(entry.html);
            } else {
                var content = entry.content;
                content = content.replace(entry.title, '');
                content = content.replace(/[ADFJMONS][acbegihmlonpsrutvy]+ \d\d, \d\d\d\d/, '');
                content = content.replace(/<!-- .* -->/, '');
                content = content.replace(/View comparison for these \d+ commits »/, '');

                var contentElt = $('<p>');
                contentElt.text(content);
            }
            articleElt.append(contentElt);

            return articleElt;
        },
        clickableDateFromEntry
    );

    var useSlides = true;
    if (useSlides) {
        // Enough about feeds. How about sideshowiness?

        // Find selected slide, if any:
        var selectedID = $('#main section').eq(0).attr('id');
        var  m = /^#slide-(.*)$/.exec(location.hash);
        if (m) {
            var selectedID = m[1];
        }

        $('#main')
            .removeClass('scrolling')
            .addClass('has-slideshow');
        var slideCount =  $('#main section')
            .wrapAll('<div class="slideshow">')
            .wrap('<div class="slide">')
            .size();
        var slider = $('#main div.slideshow');
        var navBar = $('<nav>').appendTo('#main');

        $('div.slide', slider).each(function (slideIndex) {
            $(this).attr('data-slide-index', slideIndex);
        });

        // Width of the slideshow is generally 6, 9, 12, 15, or 18 units
        // where a unit is 80 pixels.
        var
            widthInUnits,
            slideWidth,
            selectedIndex;
        var marginFudge = 80,
            unitPixels = 80,
            unitQuantum = 3;

        function calculateSlideshowGeometry() {
            if (widthInUnits) {
                $('body').removeClass('units-' + widthInUnits);
            }
            widthInUnits = Math.floor(($(window).width() - marginFudge) / unitQuantum / unitPixels) * unitQuantum;
            if (widthInUnits < 9) { // TODO. Create 6- and 4-unit layouts
                widthInUnits = 9;
            } else if (widthInUnits > 18) {
                widthInUnits = 18;
            }
            $('body').addClass('units-' + widthInUnits);

            $('section', slider).width(unitPixels * widthInUnits);
            slideWidth = $('div.slide', slider).eq(0).width();
            selectedIndex = $('section#' + selectedID).parent('div.slide').attr('data-slide-index');
            slider
                .width(slideCount * slideWidth)
                .css('left', -selectedIndex * slideWidth);
            $('#main').width(slideWidth);

            checkSliderHeight();
        }

        $('.slide', slider).each(function (linkIndex) {
            var slide = $(this),
                slideID = $('section', slide).attr('id');

            var label = $('h2', slide).eq(0).text() || 'Who';
            label = label.replace(/from Damian|Alleged /, '');
            var link = $('<span>')
                .text(label)
                .click(function () {
                    selectedID = slideID;
                    location.hash = '#slide-' + selectedID;

                    selectedIndex = slide.attr('data-slide-index');
                    slider.animate({left:  -selectedIndex * slideWidth}, {duration: 300});
                    $('span.sel', navBar).removeClass('sel');
                    $(this).addClass('sel');

                    checkSliderHeight();
                })
                .appendTo(navBar);
            if (slideID == selectedID) {
                link.addClass('sel');
            }
        });

        $(window).resize(function () {
            calculateSlideshowGeometry();
        });
        calculateSlideshowGeometry();
    }

    function checkSliderHeight() {
        var height = $('#main .slideshow').height();
        $('#main').css('height', height + 5);
    }
});