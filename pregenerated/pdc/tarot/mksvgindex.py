# Time-stamp: <pdc 2002-07-25>

"""Generate SVG files that form an index to the Alleged Tarot 2002.

These are intended to work in browsers like Batik,
which understand static SVG and links, but lack JavaScript and SMIL support.
"""

import codecs
import re
import sys

templ = """<?xml version="1.0"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN"
    "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"
    [
    <!ENTITY linkStyle "font-family: Even; fill: blue">
    <!ENTITY menuLinkStyle "font-family: Even; font-size: 13px; fill: blue; text-decoration: underline">
    <!ENTITY menuSelStyle "font-family: Even; font-size: 13px; fill: black; text-decoration: none">
    ]>
<svg
    viewBox="0 0 650 510"
     xmlns="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink"
>
    <title>Third attempt at an SVG-powered index of the Alleged Tarot 2002</title>
    <defs>
        <font id="font-1" horiz-adv-x="12">
            <font-face
                font-family="Even"
                font-weight="normal"
                units-per-em="18"
                horiz-origin-x="1.5"
                horiz-adv-x="10"
                cap-height="12"
                x-height="9"
                ascent="12"
                descent="0"
                alphabetic="0" mathematical="6"
                ideographic="6" hanging="6">
            </font-face>
            <missing-glyph horiz-adv-x="11"
                    d="M1,0  v12  h9  v-12  z
                    M1.75,0.75  h7.5  v10.5  h-7.5 z"/>
            <glyph unicode=" " horiz-adv-x="6" d=""/>
            <glyph unicode="!" horiz-adv-x="3.5"
                    d="M1,0  v1.5  h1.5  v-1.5  z
                    M1,3  v9  h1.5  v-9  z"/>
            <glyph unicode=":" horiz-adv-x="4"
                    d="M1,0 h2 v2  h-2  z
                    M1,6  h2 v2  h-2  z"/>
            <glyph unicode=";" horiz-adv-x="4"
                    d="M1,2  h2  v-2  q0,-2 -2,-2  v1
                    q1,0 1,0.5  0,0.5 -1,0.5  z
                    M1,6  h2 v2  h-2  z"/>
            <glyph unicode="0" horiz-adv-x="11"
                    d="M5.5,-0.25  Q10,-0.25 10,5.825
                    Q10,12.25 5.5,12.25  Q1,12.25 1,5.825
                    Q1,-0.25 5.5,-0.25  z
                    M5.5,1.25  Q2.5,1.25 2.5,5.825
                    Q2.5,10.75 5.5,10.75  Q8.5,10.75 8.5,5.825
                    Q8.5,1.25 5.5,1.25  z
                    "/>
            <glyph unicode="." horiz-adv-x="4"
                    d="M1,0 h2 v2  h-2  z"/>
            <glyph unicode="," horiz-adv-x="4"
                    d="M1,2  h2  v-2  q0,-2 -2,-2  v1
                    q1,0 1,0.5  0,0.5 -1,0.5  z"/>
            <glyph unicode="a" horiz-adv-x="11"
                    d="M5.5,8  q-4.5,0 -4.5,-4  t4.5,-4.25
                    q3,0 3,1.75  v-1.5  h1.5  v7
                    q0,5.25 -4.5,5.25
                    q-2.5,0 -3.5,-1.5  v-1.5  q1,1.5 3.5,1.5
                    q3,0  3,-3  z
                    M8.5,6.25  v-3.25  q0,-1.75 -3,-1.75
                    t-3,2.75 3,2.5 z"/>
            <glyph unicode="c" horiz-adv-x="12"
                    d="M1,5.825
                    Q1,12 6.5,12.25
                    q3.5,0 4.5,-1.5  v-1.5  q-2,1.5 -4.5,1.5
                    Q2.5,10.75 2.5,5.825  2.5,1.25 6.5,1.25
                    q2.5,0 4.5,1.5  v-1.5   q-1,-1.5 -4.5,-1.5
                    Q1,-0.25 1,5.825  z"/>
            <glyph unicode="d" horiz-adv-x="11.5"
                    d="M1,0  H4.5
                    Q11,0 11,5.825  11,12 4.5,12
                    H1  z
                    M2.5,1.5  V10.5  H4.5
                    Q9.5,10.5  9.5,5.825  9.5,1.5 4.5,1.5
                    z"/>
            <glyph unicode="e" horiz-adv-x="13"
                    d="M12,5  q0,7 -5.5,7.25  t-5.5,-6.25 5.5,-6.25
                    q3.5,0 4.5,1.5  v1.5  q-2,-1.5 -4.5,-1.5
                    q-4,0 -4,3.75  z
                    M2.5,6.5  q0,4.25 4,4.25 t4,-4.25  z"/>
            <glyph unicode="f" horiz-adv-x="8"
                    d="M1,0  h1.5  v5  h4  v1.5  h-4  v4  h5  v1.5  h-6.5  z"/>
            <glyph unicode="g" horiz-adv-x="12"
                    d="M1,5.825
                    Q1,12 6.5,12.25
                    q3.5,0 4.5,-1.5  v-1.5  q-2,1.5 -4.5,1.5
                    Q2.5,10.75 2.5,5.825  2.5,1.25 6.5,1.25
                    9,1.25 9.5,2.75
                    V5  h-3  V6.5  h4.5  V1.25
                    q-1,-1.5 -4.5,-1.5
                    Q1,-0.25 1,5.825  z"/>
            <glyph unicode="h" horiz-adv-x="11"
                    d="M1,0  v12  h1.5  v-5.25  h6  v5.25  h1.5  v-12
                    h-1.5  v5.25  h-6  v-5.25  z"/>
            <glyph unicode="i" horiz-adv-x="4.5"
                    d="M1.5,0  h1.5  v12  h-1.5  z"/>
            <glyph unicode="j" horiz-adv-x="8"
                    d="M0,1  Q1,-0.25 3,-0.25
                    Q7,-0.25 7,5.75  V12  h-1.5  V5.75
                    Q5.5,1.25 3,1.25  Q1,1.25 0,2.5  Z"/>
            <glyph unicode="k" horiz-adv-x="11"
                    d="M1,0 L1,12 L2.5,12 L2.5,6.75 L8.5,12 L10.5,12 L4.175,6.5 L11,0 L9,0 L2.5,6.25 L2.5,0 z"/>

            <glyph unicode="l" horiz-adv-x="8"
                    d="M1,0  v12  h1.5  v-10.5  h5.5  v-1.5  z"/>
            <glyph unicode="m" horiz-adv-x="18"
                    d="M1,0  V12  h1.5  v-2
                    Q3,12.25 5.325,12.25  9.75,12.25 9,6.75
                    8.25,12.25 12.625,12.25   17,12.25 17,5.825
                    V0  h-1.5  V5.85
                    Q15.5,10.75 12.625,10.75  9.75,10.75 9.75,5.85
                    V0  h-1.5  V5.85
                    Q8.25,10.75 5.325,10.75  3,10.75 2.5,8
                    V0  z"/>
            <glyph unicode="n" horiz-adv-x="11"
                    d="M1,0  V12  h1.5  v-2
                    Q3,12.25 5.5,12.25  10,12.25 10,5.825
                    V0  h-1.5  V5.85
                    Q8.5,10.75 5.5,10.75  3,10.75 2.5,8
                    V0  z"/>
            <glyph unicode="o" horiz-adv-x="13"
                    d="M6.5,-0.25  Q12,-0.25 12,5.825
                    Q12,12.25 6.5,12.25  Q1,12.25 1,5.825
                    Q1,-0.25 6.5,-0.25  z
                    M6.5,1.25  Q2.5,1.25 2.5,5.825
                    Q2.5,10.75 6.5,10.75  Q10.5,10.75 10.5,5.825
                    Q10.5,1.25 6.5,1.25  z"/>
            <glyph unicode="p" horiz-adv-x="10.5"
                    d="M1,0  H2.5  V4.5  H4.5
                    Q10,4.5 10,8.25  10,12 4.5,12
                    H1  z
                    M2.5,6  V10.5  H4.5
                    Q8.5,10.5  8.5,8.25  8.5,6 4.5,6
                    z"/>
            <glyph unicode="q" horiz-adv-x="13"
                    d="M6.5,-0.25
                    Q8,-0.25 9.5,0.5  11,-0.25 12.5,-0.25
                    V1.25  Q11,1.25 10.75,1.7  Q12,3 12,5.825
                    Q12,12.25 6.5,12.25  Q1,12.25 1,5.825
                    Q1,-0.25 6.5,-0.25  z
                    M6.5,1.25  Q2.5,1.25 2.5,5.825
                    Q2.5,10.75 6.5,10.75
                    Q10.5,10.75 10.5,5.825

                    Q10.5,4 9.75,3  Q8.5,5 5.25,5
                    V3.5  Q8,3.5 8.5,1.75
                    Q8,1.25 6.5,1.25  z"/>

            <glyph unicode="r" horiz-adv-x="10"
                    d="M1,0  V12  H2.5  V9.5
                    Q4,12.25 9,12.25  V10.75
                    Q4,10.75 2.5,7.5
                    V0  z"/>
            <glyph unicode="s" horiz-adv-x="11"
                    d=" M9.27632,10.75 Q7.77632,12.25 5.25,12.25
                     Q0.75,12.25 0.75,8.9 Q0.75,5.55 5.25,5.55
                     Q8.5,5.55 8.5,3.4 Q8.5,1.25 5.25,1.25
                     Q2.5,1.25 1,2.75 V1.25 Q2.5,-0.25 5.25,-0.25
                     Q10,-0.25 10,3.4 Q10,7.05 5.25,7.05
                     Q2.25,7.05 2.25,8.9 Q2.25,10.75 5.25,10.75
                     Q7.77632,10.75 9.27632,9.25z"/>
            <glyph unicode="t" horiz-adv-x="11"
                    d="M6.25,0  V10.5  H10  V12  H1  V10.5  H4.75  V0  z"/>
            <glyph unicode="u" horiz-adv-x="12"
                    d="M11,12  V0  h-1.5  v+1
                    Q8,-0.25 5.5,-0.25  1,-0.25 1,5.825
                    V12  h1.5  V5.85
                    Q2.5,1.25 5.5,1.25  8,1.25 9.5,3
                    V12  z"/>
            <glyph unicode="v" horiz-adv-x="12"
                    d=" M0.5,12 L5.5,0 H6.5 L11.5,12
                    H10.1154 L6,2.12308 L1.88462,12z"/>
            <!-- slope = 0.375 -->
            <!-- stroke horiz thickness = 1.6 -->
            <!-- stroke thickness = 1.49813 -->
            <!-- top vertex wd = 1.2 -->
            <glyph unicode="w" horiz-adv-x="18"
                    d="M0,12
                    L4.5,0
                    L5.5,0
                    L9,9.33333
                    L12.5,0
                    L13.5,0
                    L18,12
                    L16.4,12
                    L13,2.93333
                    L9.6,12
                    L8.4,12
                    L5,2.93333
                    L1.6,12
                    z"/>
# t = 1.33233979136
# u = 1.6182885906
# v = 6.24981371088
<glyph unicode="x" horiz-adv-x="12"
    d=" M0.5,0 L5.19086,6.24981 L0.875,12
     H2.49329 L6,7.32787 L9.50671,12
     H11.125 L6.80914,6.24981 L11.5,0
     H9.88171 L6,5.17176 L2.11829,0z"/>

                <!-- en dash -->
                <glyph unicode="&#x2013;" horiz-adv-x="9"
                    d="M0.5,5.25  h8  v1.5  h-8  z"/>
                <!-- em dash -->
                <glyph unicode="&#x2014;" horiz-adv-x="18"
                    d="M1,5.25  h16  v1.5  h-16  z"/>

        </font>
    </defs>
    <rect x="-50" y="-50" width="750" height="610"
            stroke="none" fill="#990000" />
    <rect x="50" y="50" width="550" height="410"
            stroke="#F0DD66" stroke-width="5" fill="#99CCFF"/>
@CARDS@
</svg>
"""


SVG = "http://www.w3.org/2000/svg"
XLINK = "http://www.w3.org/1999/xlink"
rankNames = [
    "ace",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "ten",
    "page",
    "knight",
    "queen",
    "king",
]
suitNames = ["wands", "cups", "swords", "coins"]
trumpsNames = [
    "0-fool",
    "i-magician",
    "ii-papess",
    "iii-empress",
    "iiii-emperor",
    "v-pope",
    "vi-lovers",
    "vii-chariot",
    "viii-justice",
    "viiii-hermit",
    "x-wheel",
    "xi-strength",
    "xii-hanged",
    "xiii-death",
    "xiiii-temperance",
    "xv-devil",
    "xvi-tower",
    "xvii-star",
    "xviii-moon",
    "xviiii-sun",
    "xx-judgement",
    "xxi-world",
]
trumpsTitles = {}
for n in trumpsNames:
    xs = n.split("-")
    trumpsTitles[n] = xs[0].upper() + ". The " + xs[1].title()
trumpsTitles.update(
    {
        "viii-justice": "VIII. Justice",
        "x-wheel": "X. The Wheel of Fortune",
        "xi-strength": "XI. Strength",
        "xii-hanged": "XII. The Hanged Man",
        "xiii-death": "XIII. Death",
        "xiiii-temperance": "XIIII. Temperance",
        "xx-judgement": "XX. Judgement",
    }
)

opts = {"base": "http://www.alleged.org.uk/pdc/tarot/", "dir": "F:/tarot"}

cardAdvX = 130
cardAdvY = 170
cardsPerRow = 5


def dictSub(dict, m):
    key = m.group(0)[1:-1]
    return dict[key]


atRe = re.compile(r"@[A-Z]+@")

cardTempl = """
    <a id="templ" xlink:show="new" xlink:href="@BASE@@CARD@-card3.svg">
            <g transform="@TRANSFORM@">
                <rect x="0" y="0" width="124" height="160" rx="5" ry="5"
                        fill="#F8F8F0" stroke="none"/>
                <image xlink:href="@CARD@-100w.png" type="image/png"
                    x="12" y="12" width="100" height="136"/>
                <text x="12" y="148" transform="rotate(270,13,148)" style="&linkStyle;">
                    @TEXT@
                </text>
                <rect x="0.25" y="0.25" width="123.5" height="159.5" rx="5" ry="5"
                        fill="none" stroke-width="0.5" stroke="#999900"/>
            </g>
        </a>
"""


def emitSuitCards(output, suit, start_x, start_y):
    """Emit SVG for all the cards of the specified suit."""
    for i in range(1, 15):
        dict = {
            "BASE": "",  # opts['base'],
            "SUIT": suitNames[suit],
        }
        dict["TEXT"] = rankNames[i - 1] + " of " + suitNames[suit]
        x = start_x + (i - 1) % cardsPerRow * cardAdvX
        y = start_y + (i - 1) / cardsPerRow * cardAdvY
        dict["TRANSFORM"] = "translate(%d,%d)" % (x, y)
        if 1 < i and i < 10:
            dict["N"] = str(i)
        else:
            dict["N"] = rankNames[i - 1]
        dict["CARD"] = suitNames[suit] + "-" + dict["N"]
        text = atRe.sub(lambda m, d=dict: dictSub(d, m), cardTempl)
        output.write(text)


def emitTrumps(output, beg, end, start_x, start_y):
    """Emit SVG for trums cards [beg:end]."""
    for i in range(beg, end):
        dict = {"BASE": "", "CARD": trumpsNames[i]}
        dict["TEXT"] = trumpsTitles[trumpsNames[i]].lower()
        x = start_x + (i - beg) % cardsPerRow * cardAdvX
        y = start_y + (i - beg) / cardsPerRow * cardAdvY
        dict["TRANSFORM"] = "translate(%d,%d)" % (x, y)
        text = atRe.sub(lambda m, d=dict: dictSub(d, m), cardTempl)
        output.write(text)


linkTempl = """
    <a xlink:href="@BASE@@FILE@.svg">
        <g transform="translate(@X@,@Y@)">
            <rect x="-10" y="-13" width="115" height="18"
                    fill="#FFFFFF" stroke="#000000" opacity="0.75"/>
            <text x="0" y="0" style="&menuLinkStyle;">
                @TEXT@
            </text>
        </g>
    </a>
"""
otherTempl = """
    <g transform="translate(@X@,@Y@)">
        <rect x="-10" y="-13" width="115" height="18"
            fill="#FFFFFF" stroke="#000000"/>
        <text x="0" y="0" style="&menuSelStyle;">
            @TEXT@
        </text>
    </g>
"""


def emitMenu(output, is_suit, j, start_x, start_y):
    """Generate the links to other suits' index pages."""
    for i in range(4):
        dict = {
            "BASE": "",  # opts['base'],
            "X": str(start_x),
            "Y": str(start_y + 20 * i),
            "FILE": suitNames[i],
            "TEXT": suitNames[i],
        }
        if is_suit and i == j:
            t = otherTempl
        else:
            t = linkTempl
        output.write(atRe.sub(lambda m, d=dict: dictSub(d, m), t))
    for i in range(0, 22, 12):
        dict = {
            "BASE": "",  #: opts['base'],
            "X": str(start_x),
            "Y": str(start_y + 20 * (i / 12 + 4)),
            "FILE": "trumps%d" % i,
            "TEXT": "trumps %s\u2013%s" % (rom(i), rom(min(21, i + 12 - 1))),
        }
        if not is_suit and i == j:
            t = otherTempl
        else:
            t = linkTempl
        output.write(atRe.sub(lambda m, d=dict: dictSub(d, m), t))


def rom(n):
    """Roman numerals for n.capitalize

    Forming roman numerals using IIII instead of IV,
    one of the affectations of the Allegd Tarot."""
    if n == 0:
        return "0"
    t, n = "x" * (n / 10), n % 10
    return t + "v" * (n / 5) + "i" * (n % 5)


def doSuits():
    p = templ.find("@CARDS@")
    for i in range(4):
        file_name = suitNames[i] + ".svg"
        with open(opts["dir"] + "/" + file_name, "wb") as strm:
            output = codecs.lookup("utf-8")[3](strm)
            output.write(templ[:p])
            emitSuitCards(output, i, 3, 4)
            emitMenu(output, 1, i, 540, 370)
            output.write(templ[p + 7 :])
            output.reset()
            print("Wrote SVG to", file_name)


def doTrumps():
    p = templ.find("@CARDS@")
    chunk = 12
    for i in range(0, 22, chunk):
        file_name = ("trumps%d" % i) + ".svg"
        with open(opts["dir"] + "/" + file_name, "wb") as strm:
            output = codecs.lookup("utf-8")[3](strm)
            output.write(templ[:p])
            emitTrumps(output, i, min(i + chunk, 22), 3, 4)
            emitMenu(output, 0, i, 540, 370)
            output.write(templ[p + 7 :])
            output.reset()
            print("Wrote SVG to", file_name)


for arg in sys.argv:
    pr = arg.split("=", 1)
    if len(pr) == 2:
        opts[pr[0]] = pr[1]
        print(pr[0], "=", pr[1])
    else:
        opts[pr[0]] = None

doSuits()
doTrumps()
