$(document).ready(function () {
    var monthAbbrs = 'Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec';
    function pad2(n) {
        return n < 10 ? '0' + n : n
    }
    
    var flowElt = $('#flow');
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
                var tweet = data.results[i];
                if (tweet.text.substr(0, 3) == 'RT ') {
                    // Skip my retweets since I don’t have any easy way to supply thier user icon.
                    continue;
                }
                var m = /(Mon|Tue|Wed|Thu|Fri|Sat|Sun), (\d\d?) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) (\d{4}) (\d\d:\d\d:\d\d) \+0000/.exec(tweet.created_at)
                var mon = (monthAbbrs.indexOf(m[3]) + 4) / 4;
                var when = m[4] + '-' + pad2(mon) + '-' + pad2(m[2]) + 'T' + m[5];
                var articleElt = $('<article>').attr({
                    'class': 'twitter',
                    'data-date': when
                });
                $('<img>').attr({
                    'src': tweet.profile_image_url,
                    'alt': ''
                }).appendTo(articleElt);
                var pElt = $('<p>').appendTo(articleElt).text(tweet.text);
                $(flowElt).append(articleElt);
            }
        }
    })
})