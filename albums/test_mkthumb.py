#!/usr/bin/env python
"""
test_mkthumb.py

Created by Damian Cugley on 2010-04-08.
Copyright (c) 2010 __MyCompanyName__. All rights reserved.
"""

import unittest

from mkthumb import *


class TestMkThumb(unittest.TestCase):
    def setUp(self):
        pass

    def test_file_dimen(self):
        self.assertEqual((413, 280), file_dimens("c99-matt/windingup-leaving.jpg"))

    def test_landscape_thumbnail_meet(self):
        expected = [["pamscale", "-xyfit", "200", "200"]]
        actual = thumbnail_pipeline(
            "c99-matt/windingup-leaving.jpg", (200, 200), "meet"
        )
        self.assertEqual(expected, actual)

    def test_landscape_thumbnail_slice(self):
        expected = [
            ["pamscale", "-xyfill", "200", "200"],
            ["pnmcut", "47", "0", "200", "200"],
        ]
        actual = thumbnail_pipeline(
            "c99-matt/windingup-leaving.jpg", (200, 200), "slice"
        )
        self.assertEqual(expected, actual)

    def test_portrait_thumbnail_meet(self):
        expected = [["pamscale", "-xyfit", "200", "200"]]
        actual = thumbnail_pipeline(
            "c99-matt/pubfridaynight-adrian.jpg", (200, 200), "meet"
        )
        self.assertEqual(expected, actual)

    def test_portrait_thumbnail_slice(self):
        expected = [
            ["pamscale", "-xyfill", "200", "200"],
            ["pnmcut", "0", "47", "200", "200"],
        ]
        actual = thumbnail_pipeline(
            "c99-matt/pubfridaynight-adrian.jpg", (200, 200), "slice"
        )
        self.assertEqual(expected, actual)

    def test_suffixize(self):
        expected = "c99-matt/thumbs/pubfridaynight-adrian-s200.jpeg"
        actual = thumbnail_file_name(
            "c99-matt/pubfridaynight-adrian.jpg", "c99-matt/thumbs", (200, 200), "slice"
        )
        self.assertEqual(expected, actual)

    def test_suffixize(self):
        expected = "c99-matt/thumbs/pubfridaynight-adrian-200w.jpeg"
        actual = thumbnail_file_name(
            "c99-matt/pubfridaynight-adrian.jpg", "c99-matt/thumbs", (200, 1), "overlap"
        )
        self.assertEqual(expected, actual)

    def test_suffixize(self):
        expected = "c99-matt/thumbs/pubfridaynight-adrian-140h.jpeg"
        actual = thumbnail_file_name(
            "c99-matt/pubfridaynight-adrian.jpg", "c99-matt/thumbs", (1, 140), "overlap"
        )
        self.assertEqual(expected, actual)


if __name__ == "__main__":
    unittest.main()
