// Time-stamp: <pdc 2003-12-03>

var XLINK = 'http://www.w3.org/1999/xlink';
var LO = 'http://www.alleged.org.uk/pdc/tarot/';
var CARD_WD = 120;
var CARD_HT = 166;
var CARD_ADV_X = 130;
var CARD_ADV_Y = 180;

var opts = {
    base: '', // http://alleged.org.uk/pdc/tarot/',
    n: 7,
    seed: 0,
    lo: 'yesno'
};

var trumpNames = [
    'fool',
    'magician',
    'papess',
    'empress',
    'emperor',
    'pope',
    'lovers',
    'chariot',
    'justice',
    'hermit',
    'wheel',
    'strength',
    'hanged',
    'death',
    'temperance',
    'devil',
    'tower',
    'star',
    'moon',
    'sun',
    'judgement',
    'world'
];

var suitNames = ['wands', 'cups', 'swords', 'coins'];
var rankNames = ['zero', 'ace', 'two', 'three', 'four', 'five', 'six', 'seven',
    'eight', 'nine', 'ten', 'page', 'knight', 'queen', 'king'];

var trumpTitles = new Array(22);
trumpTitles[8] = 'justice';
trumpTitles[10] = 'the wheel of fortune';
trumpTitles[11] = 'strength';
trumpTitles[12] = 'the hanged man';
trumpTitles[13] = 'death';
trumpTitles[14] = 'temperance';
trumpTitles[20] = 'judgement';


function rom(n) {
    if (n == 0) {
        return '0';
    }

    var s = '';
    while (n >= 10) {
        s += 'x'; n -= 10;
    }
    if (n >= 5) {
        s += 'v'; n -= 5;
    }
    while (n > 0) {
        s += 'i'; --n;
    }
    return s;
}

function cardName(i) {
    if (i < 22) {
        return rom(i) + '-' + trumpNames[i];
    }
    i -= 22;
    suit = Math.floor(i / 14);
    rank = i % 14 + 1;
    if (1 < rank && rank < 10) {
        return suitNames[suit] + '-' + rank;
    } else {
        return suitNames[suit] + '-' + rankNames[rank];
    }
}

function cardTitle(i) {
    if (i < 22) {
        if (trumpTitles[i] != null) {
            return trumpTitles[i];
        }
        return 'the ' + trumpNames[i];
    }
        i -= 22;
    suit = Math.floor(i / 14);
    rank = i % 14 + 1;
    return 'the ' + rankNames[rank] + ' of ' + suitNames[suit];
}

function shuffle(xs) {
    if (!opts.seed && opts.q) {
        var d = new Date();
        opts.seed = questionToSeed(opts.q + d.toDateString());
    }
    for (var i = 0; i < xs.length; ++i) {
        // var j = Math.floor(Math.random() * 78);
        var j = opts.seed % xs.length;
        opts.seed = (opts.seed + 2003) * 1009 % 1999;
        var x = xs[i];
        xs[i] = xs[j];
        xs[j] = x;
    }
}

function dealCard(i, x, y, r, sig) {
    var e = document.getElementById('templ');
    if (r) {
        e.setAttribute('transform', 'translate(' + x + ',' + y + ') rotate(' + r + ',60,78)');
        e.setAttribute('opacity', '0.75');
    } else {
        e.setAttribute('transform', 'translate(' + x + ',' + y + ')');
        e.setAttribute('opacity', '1');
    }

    var t = document.getElementById('templText');
    for (var c = t.firstChild; c != null; c = c.nextSibling) {
        t.removeChild(c);
    }
    t.appendChild(document.createTextNode(cardTitle(i)));

    t = document.getElementById('templSig');
    for (var c = t.firstChild; c != null; c = c.nextSibling) {
        t.removeChild(c);
    }
    t.appendChild(document.createTextNode(sig));

    var u = opts.base + cardName(i);

    t = document.getElementById('templImage');
    t.setAttributeNS(XLINK, 'xlink:href', u + '-100w.png');

    t = document.getElementById('templA');
    t.setAttributeNS(XLINK, 'xlink:href', u + '-card3.svg');

    var n = e.cloneNode(true);
    document.documentElement.appendChild(n);
}

function dealLayout(lo, cs) {
    // Find layout data and hence the card-descs for this layout.
    var lod = document.getElementById(lo);
    var cds = lod.getElementsByTagNameNS(LO, 'card');

    // Calculate size of layout.
    // These u,v are measured in card units.
    // We assume that (0, 0) is included in the spread.
    var umin = 0, umax = 0, vmin = 0, vmax = 0;
    for (var i = 0; i < cds.length; ++i) {
        var cd = cds.item(i);
        var u = parseFloat(cd.getAttribute('col'));
        var v = parseFloat(cd.getAttribute('row'));
        if (u > umax) {
            umax = u;
        } else if (u < umin) {
            umin = u;
        }
        if (v > vmax) {
            vmax = v;
        } else if (v < vmin) {
            vmin = v;
        }
    }
    var xsize = (umax - umin) * CARD_ADV_X + CARD_WD;
    var ysize = (vmax - vmin) * CARD_ADV_Y + CARD_HT;
    var x0 = (1000 - xsize) / 2 - umin * CARD_ADV_X;
    var y0 = (750 - ysize) / 2 - vmin * CARD_ADV_Y;

    // Now deal one card for each card desc.
    for (var i = 0; i < cds.length; ++i) {
        var cd = cds.item(i);
        var u = parseFloat(cd.getAttribute('col'));
        var v = parseFloat(cd.getAttribute('row'));
        var title = cd.getAttribute('title');
        var r = cd.getAttribute('rotate');

        var c = cs[i];
        dealCard(c, x0 + CARD_ADV_X * u, y0 + CARD_ADV_Y * v, r, title);
    }
}

// Convert string to random number.
function questionToSeed(s) {
    // This is basically a hash function.
    // Search the web for g_str_hash X31_HASH for a discussion.
    n = 0;
    for (var i = 0; i < s.length; i++) {
    var c = s.charCodeAt(i);
    n = (31 * n + c) & 0x7FFFFFFF;
    }
    return n;
}

function scanOpts() {
    var s;
    if (document) {
        s = document.URL;
    } else if (location) {
        s = location.href;
    }
    if (s == "") {
        return;
    }

    var p = s.indexOf('?');
    if (p < 0) {
        return;
    }

    s = s.substr(p);
    xs = s.substr(1).split('&');
    for (var i = 0; i < xs.length; ++i) {
        var p = xs[i].indexOf('=');
        if (p > 0) {
	    var k = xs[i].slice(0, p);
	    var v = xs[i].slice(p + 1);
	    opts[k] = v;
        } else {
	    opts[x] = '';
        }
    }
}


function ol () {
    scanOpts();

    var cs = new Array(78);
    for (var i = 0; i < cs.length; ++i) {
        cs[i] = i;
    }

    shuffle(cs);
    dealLayout(opts.lo, cs);
}
