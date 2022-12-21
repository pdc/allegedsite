#

import urllib.request, urllib.parse, urllib.error
import Image

input = urllib.request.urlopen("http://ariel/~pdc/2004/shadow.png")
output = file("shadow.png", "wb")
output.write(input.read())
input.close()
output.close()

im = Image.open("shadow.png")
print(im.size)
w, h = im.size
im.save("shadow.gif")
input.close()


im2 = Image.new("RGB", (2000, 20), (255, 255, 255))
im2.paste(im.crop((0, 100, w - 24, 120)), (0, 0, w - 24, 20))
im2.save("shadowleft.png")

im2 = Image.new("RGB", (2000, 200), (255, 255, 255))
im2.paste(im.crop((0, 0, w - 24, 200)), (0, 0, w - 24, 200))
im3 = im.crop((24, 0, 424, 200))
for x in range(200, 1800, 400):
    im2.paste(im3, (x, 0, x + 400, 200))
im2.save("shadowtopleft.png")

im2 = Image.new("RGB", (24, 200), (255, 255, 255))
im2.paste(im.crop((w - 24, 0, w, 200)), (0, 0, 24, 200))
im2.save("shadowtopright.png")
