#!/usr/bin/python

import io
import os
import sys

"""Adobe Illustrator and Sketch differ in how they translate CMYK to RGB.
This script takes two raster images of the same SVG file
which differ only in CMYK model, and attempts to generate a
simple map from RGB triplets in the 'bad' colours to the 'good' colours."""


class QuickAndDirtyImage:
    """Represents a PPM file. It must be in raw mode!"""

    def __init__(self, file_name):
        self.load(file_name)

    def load(self, file_name):
        """Read data from specified file."""
        print(file_name + ":")
        input = open(file_name, "rb")

        magic = input.read(2)
        if magic == "P6" or magic == "P3":
            self.data = input.read()  # everything except the P6
            self.pos = 1  # skip 1st whitespace character
            self.width = self._nextNum()
            self.height = self._nextNum()
            self.maxVal = self._nextNum()
            if self.maxVal < 256:
                self.pixel = self._pixel1
            else:
                self.pixel = self._pixel2

            if magic == "P3" and self.maxVal < 256:
                # We must convert the graphics data from ASCII to binary.
                ss = io.StringIO()
                for i in range(0, self.width * self.height * 3):
                    n = self._nextNum()
                    ss.write(chr(n))
                self.data = ss.getvalue()
                assert len(self.data) == self.width * self.height * 3
                ss.close()
                self.pos = 0
        assert self.width > 0
        assert self.height > 0
        assert self.pos >= 0
        assert self.pos + self.width * self.height * 3 <= len(self.data)

    def _nextNum(self):
        """Scan for a number.
        The number may be preceeded by whitespace intermingled with comments.
        Comments start with a hash and end at the end of the line.
        One whitespace character following the number is also consumed."""
        d = self.data
        l = len(d)
        p = self.pos
        while (d[p] <= " " or d[p] == "#") and p < l:
            if d[p] == "#":
                # Skip all of the comment.
                p = p + 1
                while d[p] != "\n" and p < l:
                    p = p + 1
            p = p + 1

        beg = p
        while d[p] in "0123456789" and p < l:
            p = p + 1
        # pos points to first character that isn't a dight.
        val = int(d[beg:p])

        # Now skip the whitespace char following the number.
        assert p == l or d[p] <= " "
        self.pos = p + 1

        return val

    def _pixel1(self, x, y):
        """Return the colour of the pixel at (x, y).
        Returns a 3-tuple."""
        off = self.pos + (y * self.width + x) * 3
        assert off + 3 <= len(self.data)

        return tuple(map(ord, self.data[off : off + 3]))


def make_cmap(bad, good, cmap={}):
    """Generate a cmap dictionary from 2 images, one bad and one good."""
    xf = float(good.width) / bad.width
    yf = float(good.height) / bad.height
    for y in range(0, bad.height):
        # if y % 50 == 0: print y
        ygood = int(y * yf)
        for x in range(0, bad.width):
            xgood = int(x * xf)
            b = bad.pixel(x, y)
            g = good.pixel(xgood, ygood)
            if b in cmap:
                cmap[b][g] = cmap[b].get(g, 0) + 1
            else:
                cmap[b] = {g: 1}
    print("Generated CMAP with", len(cmap), "entries.")
    return cmap


def write_cmap(map, output):
    """Write the map as a CMAP file --
    one line per entry, with the bad and good colours as hexadecimal rrggbb."""
    items = list(cmap.items())
    items.sort()
    for bad, dict in items:
        for good, cnt in list(dict.items()):
            output.write("%02x%02x%02x %02X%02X%02X %d\n" % (bad + good + (cnt,)))


def rrggbb_to_rgb(rrggbb):
    r = int(rrggbb[0:2], 16)
    g = int(rrggbb[2:4], 16)
    b = int(rrggbb[4:6], 16)
    return r, g, b


def read_cmap(input, map):
    """Read in a CMAP file."""
    for line in input.readlines():
        pos = line.find("#")
        if pos >= 0:
            line = line[:pos]
        line = line.strip()
        if line:
            xs = line.split()
            bad, good, cnt = xs
            bad = rrggbb_to_rgb(bad)
            good = rrggbb_to_rgb(good)
            cnt = int(cnt)
            if bad not in map:
                map[bad] = {good: cnt}
            elif good not in map[bad]:
                map[bad][good] = cnt
            else:
                map[bad][good] += cnt


if __name__ == "__main__":
    # dir = 'F:\\tarot'
    dir = "."

    cmap = {}
    cmapName = os.path.join(dir, "tmp.cmap")
    if os.path.exists(cmapName):
        input = open(cmapName, "rt")
        read_cmap(input, cmap)
        input.close()
        print("Read", len(cmap), "CMAP entries from", cmapName)

    for arg in sys.argv[1:]:
        b = arg
        if arg[-4:] == ".ppm":
            b = arg[:-4]
        bad = QuickAndDirtyImage(os.path.join(dir, b + ".sk.ppm"))
        good = QuickAndDirtyImage(os.path.join(dir, b + ".ppm"))
        cmap = make_cmap(bad, good, cmap)

    cmapName = os.path.join(dir, "tmp.cmap")
    output = open(cmapName, "wt")
    write_cmap(cmap, output)
    output.close()
    print("Wrote CMAP to", cmapName)
