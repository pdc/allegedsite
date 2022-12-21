#!/usr/bin/python

import sys

fileName = sys.argv[1]

input = open(fileName, "r")
text = input.read()
input.close()


text = text.replace("document.write('", "")
text = text.replace("');", "")

print('<badge xmlns="tag:alleged.org.uk,2004:flickr">')
print(text)
print("</badge>")
