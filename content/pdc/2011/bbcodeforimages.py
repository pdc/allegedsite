#!/usr/bin/env python
# encoding: utf-8
"""
bbcodeforimages.py

Created by Damian Cugley on 2011-01-23.
Copyright (c) 2011 __MyCompanyName__. All rights reserved.
"""


def bbcode_for_image(n):
    y = 2010 if n < 7 else 2011
    return (
        '[url=http://static.alleged.org.uk/pdc/{y}/frenden-{n}.png]'
        '[img]http://static.alleged.org.uk/pdc/{y}/frenden-{n}-220w.png[/img][/url]'.format(
            y=y, n=n))


def bbcode_for_images(ns):
    return ' '.join(bbcode_for_image(n) for n in ns)


def main():
    print bbcode_for_images([1, 2])


if __name__ == '__main__':
    main()
