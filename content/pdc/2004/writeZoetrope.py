"""Write SVG diagram of zoetrope.
Time-stamp: <pdc 2004-05-26>
"""

import math
import sys

PAGE_WIDTH = 297.0 - 2 * 7.5
PAGE_HEIGHT = 210.0 - 2 * 7.5
PREAMBLE = """<svg xmlns="http://www.w3.org/2000/svg"
        xmlns:xlink="http://www.w3.org/1999/xlink"
        viewBox="0 0 %(width).1f %(height).1f"
        width="%(width).1fmm" height="%(height).1fmm">
    <title>Zoetrope blank for CAPTION 2004</title>
    <rect x="0" y="0" width="%(width).1f" height="%(height).1f"
            fill="#FFF" stroke="none"/>
""" % {
    "width": PAGE_WIDTH,
    "height": PAGE_HEIGHT,
}

POSTAMBLE = """
</svg>
"""

MARGIN = 2.0
WIDTH = PAGE_WIDTH - 2 * MARGIN
HEIGHT = 60.0
DIVISIONS = 8
RADIUS = PAGE_WIDTH * DIVISIONS / (DIVISIONS + 1) / math.pi / 2
SLOT_WIDTH = 3.0
SLOT_HEIGHT = 0.25 * HEIGHT
NTABS = 2 * DIVISIONS
TAB_HEIGHT = 5


def writeFile(output):
    output.write(PREAMBLE)
    writeDisc(output)
    writeRect(output)
    output.write(POSTAMBLE)


def writeDisc(output):
    """Write a disc of the right size."""
    x = PAGE_WIDTH - RADIUS - MARGIN
    y = 0.5 * (PAGE_HEIGHT - HEIGHT - TAB_HEIGHT - MARGIN)
    output.write(
        '    <circle cx="%.2f" cy="%.2f" r="%.2f"\n'
        '            stroke="#000" stroke-width="0.15" fill="#FFF"/>\n' % (x, y, RADIUS)
    )
    output.write(
        '    <circle cx="%.2f" cy="%.2f" r="%.2f"\n'
        '            stroke="#000" stroke-width="0.15" fill="#FFF"/>\n' % (x, y, 1)
    )


def writeRect(output):
    x = 0.5 * (PAGE_WIDTH - WIDTH)
    y = PAGE_HEIGHT - HEIGHT - TAB_HEIGHT - MARGIN
    output.write('    <path d="M%.2f,%.2f h%.2f v%.2f\n' % (x, y, WIDTH, HEIGHT))
    tdh = TAB_HEIGHT
    tw = WIDTH / NTABS - 2 * tdh
    for i in range(NTABS):
        output.write(
            "            l-%.2f,%.2f h-%.2f l-%.2f,-%.2f\n"
            % (tdh, TAB_HEIGHT, tw, tdh, TAB_HEIGHT)
        )
    output.write(
        '            L%.2f,%.2f z"\n'
        '            stroke="#000" stroke-width="0.15" fill="#FFF"/>\n'
        % (x, y + HEIGHT)
    )

    for i in range(DIVISIONS + 1):
        rx = x + (DIVISIONS + 1 - i) * WIDTH / (DIVISIONS + 1) - SLOT_WIDTH
        ry = y + 0.5 * SLOT_HEIGHT
        output.write(
            '    <rect x="%.2f" y="%.2f" width="%.2f" height="%.2f"\n'
            '            stroke="#000" stroke-width="0.15" fill="#FFF"/>\n'
            % (rx, ry, SLOT_WIDTH, SLOT_HEIGHT)
        )


writeFile(sys.stdout)
