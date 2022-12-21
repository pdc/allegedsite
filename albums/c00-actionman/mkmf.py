import os, glob, string

mfBody = """
.SUFFIXES:\t.png .jpg

all:\t\t$(pngFiles:.png=.jpg)

clean:
\trm -f $(pngFiles:.png=.jpg)

.png.jpg:
\tpngtopnm $< | pnmscale -xysize 450 450 | cjpeg -progressive >$@
"""

os.system("cp -p /tmp/action??.png .")
print("Copied action??.png")

files = glob.glob("action*.png")
out = open("Makefile", "w")
out.write("# Automatically generated\n")
out.write("pngFiles\t= %s\n" % string.join(files, "\\\n\t\t"))
out.write(mfBody)
out.close()

print("Wrote make rules to Makefile.")
