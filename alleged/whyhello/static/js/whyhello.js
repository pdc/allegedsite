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

                var details = $('<small>').appendTo(articleElt);
                $('<a>').attr({
                    href: 'http://twitter.com/' + (isRetweet ? other : 'damiancugley') + '/status/' + tweet.id,
                    title: when
                }).text(whenFormatted + ' ').append('on Twitter <b>#</b>').appendTo(details);

                twitterItem.append(articleElt);

                if (++tweetCount >= maxTweets) {
                    break;
                }
            }
        }
    });
});