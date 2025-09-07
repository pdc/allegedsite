#!/usr/bin/env python
"""
jpegsfromtiffs.py

Created by Damian Cugley on 2010-04-10.
Copyright (c) 2010 __MyCompanyName__. All rights reserved.
"""

import getopt
import os
import re
import sys

TIFF_DIR = "150dpi TIFFs"

not_az_re = re.compile("[^a-z0-9]")


def munge_part(part):
    return not_az_re.sub("", part.lower())


munge_exceptions = {
    "bryantalbot-flouncyshirta": "bryantalbot-flouncya",
    "bryantalbot-flouncyshirtb": "bryantalbot-flouncyb",
    "captioncrew-alexontable": "captioncrew-alextable",
    "captioncrew-drawingontanaquisshoe": "captioncrew-tanaquishoe",
    "captioncrew-gideondamian": "captioncrew-giddam",
    "captioncrew-jeremydrawinga": "captioncrew-drawinga",
    "captioncrew-jeremydrawingb": "captioncrew-drawingb",
    "captioncrew-jeremydrawingc": "captioncrew-drawingc",
    "captioncrew-sexygavin": "captioncrew-sexygav",
    "exhibition-handingoutbits": "exhibition-handingout",
    "exhibition-handingoutbitsb": "exhibition-handingoutb",
    "exhibition-jennihanging1": "exhibition-jenni1",
    "exhibition-jeremyhanging1": "exhibition-jeremy1",
    "exhibition-jeremyhanging2": "exhibition-jeremy2",
    "exhibition-lostin1999": "exhibition-lost1999",
    "guests-philgreenaway": "guests-philg",
    "guests-stevemarchanta": "guests-marchanta",
    "guests-stevemarchantb": "guests-marchantb",
    "guests-winwiacek": "guests-win",
    "guests-woodrowpaulgravette": "guests-woodspaulg",
    "stevesworkshop-stevedrawinga": "stevesworkshop-stevea",
    "stevesworkshop-stevedrawingb": "stevesworkshop-steveb",
    "terrydave-terrysuzannea": "terrydave-terrysuza",
    "terrydave-terrysuzanneb": "terrydave-terrysuzb",
    "theatreearthprime-sprayinghaira": "theatreearthprime-sprayinga",
    "theatreearthprime-sprayinghairb": "theatreearthprime-sprayingb",
    "venue-entrysign": "venue-entry",
    "venue-missioncontrol": "venue-mission",
    "venue-morrisroom": "venue-morris",
}


def munge_name(dir_name, file_name):
    result = "%s-%s" % (munge_part(dir_name), munge_part(file_name))
    return "%s.jpeg" % munge_exceptions.get(result, result)


def input_file_iter():
    for subdir in os.listdir(TIFF_DIR):
        dir_path = os.path.join(TIFF_DIR, subdir)
        if not os.path.isdir(dir_path):
            continue
        for file_name in os.listdir(dir_path):
            file_path = os.path.join(dir_path, file_name)
            if file_name.startswith("."):
                continue
            yield subdir, file_name, file_path


def bang(is_dry_run=True, is_verbose=True):
    for dir_name, file_name, file_path in input_file_iter():
        out_file = munge_name(dir_name, file_name)
        pipeline = [
            ["tifftopnm", file_path],
            ["cjpeg", "-progressive", "-outfile", out_file],
        ]
        print(
            " | ".join(
                " ".join(('"%s"' % w if " " in w else w) for w in cmd)
                for cmd in pipeline
            )
        )


help_message = """
The help message goes here.
"""


class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg


def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(argv[1:], "ho:vn", ["help", "output="])
        except getopt.error as msg:
            raise Usage(msg)

        # option processing
        is_verbose = False
        is_dry_run = True
        for option, value in opts:
            if option == "-v":
                is_verbose = True
            if option in ("-h", "--help"):
                raise Usage(help_message)
            if option in ("-o", "--output"):
                output = value

        bang(is_verbose=is_verbose, is_dry_run=is_dry_run)

    except Usage as err:
        print(sys.argv[0].split("/")[-1] + ": " + str(err.msg), file=sys.stderr)
        print("\t for help use --help", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
