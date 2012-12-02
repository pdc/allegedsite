$(function () {
    // How many entries to show from each of the feeds.
    var maxTweets = 1;
    var maxLivejournal = 1;
    var maxGalleries = 1;
    var maxVideos = 1;

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
            }
        }
    });

    // Let’s try LiveJournal next
    var u = '/pdc/from/livejournal';
    var livejournalLink = $('#livejournal-link'),
        livejournalItem = livejournalLink.parents('li').eq(0);

    livejournalItem.addClass('loading');
    $.ajax({
        url: u,
        format: 'json',
        success: function (data, textStatus, request) {
            if (data && data.success) {
                var n = (data.entries.length > maxLivejournal ? maxLivejournal : data.entries.length)
                for (var j = 0; j < n; ++j) {
                    var entry = data.entries[j];
                    var date = entry.published;

                    var articleElt = $('<article>').attr({
                        'class': 'livejournal entry',
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

                    var detailsElt = $('<small>').appendTo(livejournalItem);
                    $('<a>').attr('href', entry.href)
                        .text(date.substr(8, 2) + ' ' + monthAbbrevs[date.substr(5, 2) - 1] + ' ')
                        .append('<b>#</b>')
                        .appendTo(detailsElt);

                    articleElt.appendTo(livejournalItem)
                }
            }
        }
    });
});