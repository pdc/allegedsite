// -*-coding: UTF-8 -*-

$(document).ready(function () {
    var monthAbbrs = 'Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec';
    var monthAbbrevs = 'Jan.|Feb.|March|May|June|July|Aug.|Sept.|Oct.|Nov.|Dec.'.split('|');
    function pad2(n) {
        return n < 10 ? '0' + n : n
    }
    
    // The text uses HTML escapes for ampersands etc.,
    // so I could just use jQuery’s html method here,
    // but do I want to trust Twitter to be immune to XSS attacks?
    // Instead I reverse the HTML escaping jQuery’s text method will apply.
    function unentity(text) {
        return text.replace(/&quot;/g, '"').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&amp;/g, '&');
    }
    
    var flowElt = $('#flow');
    var insertIntoFlow = function (articleElt, when) {
        var isInserted = false;
        
        // Binary chop to find first existing article with date before this one.
        // Reverse chronological order means we insert our article before it.
        var articleElts = $(flowElt).find('article').toArray();
        var lo = 0, hi = articleElts.length;
        while (lo < hi) {
            var m = Math.floor((lo + hi) / 2);
            var existingArticle = articleElts[m];
            var then = existingArticle.getAttribute('data-date');
            if (then < when) {
                hi = m;
            } else {
                lo = m + 1;
            }
        }
        if (hi < articleElts.length) {
            articleElt.insertBefore(articleElts[hi]); 
        } else {
            $(flowElt).append(articleElt);
        }  
    };
    
    var twitterLink = $('#twitter-link');
    var u = twitterLink.attr('href');
    u = 'http://search.twitter.com/search.json?q=from:' + u.replace(/^.*\//, '');
    twitterLink.parent().addClass('loading');
    $.ajax({
        url: u,
        dataType: 'jsonp',
        success: function (data, textStatus, request) {
            twitterLink.parent().removeClass('loading');
            for (var i in data.results) {
                var className = 'twitter';
                var tweet = data.results[i];
                if (tweet.text.substr(0, 1) == '@') {
                    // Skip replies since they don’t usually make sense in isolation.
                    continue;
                }
                var isRetweet = (tweet.text.substr(0, 3) == 'RT ');
                if (isRetweet) {
                    className += ' retweet';
                } else {
                    className += ' tweet';
                }
                var m = /(Mon|Tue|Wed|Thu|Fri|Sat|Sun), (\d\d?) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) (\d{4}) (\d\d:\d\d:\d\d) \+0000/.exec(tweet.created_at)
                var mon = (monthAbbrs.indexOf(m[3]) + 4) / 4;
                var when = m[4] + '-' + pad2(mon) + '-' + pad2(m[2]) + 'T' + m[5];
                var whenFormatted = m[2] + ' ' + monthAbbrevs[mon - 1] /* + ' ' + m[4] */;
                var articleElt = $('<article>').attr({
                    'class': className,
                    'data-date': when
                });
                if (isRetweet) {
                    m = /^RT @([^:]+): (.*)$/.exec(unentity(tweet.text));
                    var other = m[1];
                    text = m[2];
                    var pElt = $('<p>').appendTo(articleElt);
                    $('<q>').text(text).appendTo(pElt);
                    pElt.append(' —');
                    $('<a>').attr('href', 'http://twitter.com/' + other).text('@' + other).appendTo(pElt);
                } else {
                    $('<img>').attr({
                        'src': tweet.profile_image_url,
                        'alt': ''
                    }).appendTo(articleElt);
                    $('<p>').appendTo(articleElt).text(unentity(tweet.text));
                }
                
                var details = $('<small>').appendTo(articleElt);
                $('<a>').attr({
                    href: 'http://twitter.com/' + (isRetweet ? other : 'damiancugley') + '/status/' + tweet.id,
                    title: when
                }).text(whenFormatted + ' ').append('on Twitter <b>#</b>').appendTo(details);
                
                insertIntoFlow(articleElt, when);
            }
        }
    });
    
    // Now someting similar for Flickr
    var u = '/pdc/from/flickr';
    var flickrLink = $('#flickr-link');
    flickrLink.parent().addClass('loading');
    $.ajax({
        url: u,
        format: 'json',
        success: function (data, textStatus, request) {
            if (data && data.success) {
                for (var i in data.entryGroups) {
                    var dateData = data.entryGroups[i];
                    var date = dateData.published;
                    var entries = dateData.entries;
                    var articleElt = $('<article>').attr({
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
                    var detailsElt = $('<small>').appendTo(articleElt);
                    detailsElt.text(date.substr(8, 2) + ' ' + monthAbbrevs[date.substr(5, 2) - 1] + ' on Flickr')
                    insertIntoFlow(articleElt, date);
                }
            }
        }
    });
    
    // Let’s try LiveJournal next
    var u = '/pdc/from/livejournal';
    var livejournalLink = $('#livejournal-link');
    livejournalLink.parent().addClass('loading');
    $.ajax({
        url: u,
        format: 'json',
        success: function (data, textStatus, request) {
            if (data && data.success) {
                for (var j = 0; j < data.entries.length; ++j) {
                    var entry = data.entries[j];
                    var date = entry.published;
                    
                    var articleElt = $('<article>').attr({
                        'class': 'livejournal entry',
                        'data-date': date,
                        'data-id': entry.id
                    });
                    
                    var headingElt = $('<b>').appendTo(articleElt);
                    var linkElt = $('<a>').attr({
                        href: entry.href,
                    }).text(entry.title || entry.content.substr(0, 64));
                    linkElt.appendTo(headingElt);
                    
                    var detailsElt = $('<small>').appendTo(articleElt);
                    detailsElt.text(date.substr(8, 2) + ' ' + monthAbbrevs[date.substr(5, 2) - 1] + ' on LiveJournal')
                    insertIntoFlow(articleElt, date);
                }         
            }
        }
    });
})