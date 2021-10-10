from PIL import Image
import sys

im = Image.open("screen.png")
pix = im.load()

total = 0
count = 0

def avg(a):
    return (a[0] + a[1] + a[2])/3

for x in range (0, im.size[0], 20):
    for y in range (0, im.size[1], 20):
        total += avg(pix[x,y])
        count += 1

if (total / count) > 5:
    sys.exit(1)

