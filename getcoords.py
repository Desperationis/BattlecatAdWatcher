import cv2
import numpy as np
import sys

"""
    python3 getcoords.py [template path] [image path] [min similarity score]

    Given a path to a template image, try to find the exact point on an image
    where they are more than [min similarity score] similar. This "exact point"
    is the direct center of the rectangle founded by OpenCV.

    If the similarity score is too low, this will return a exit code of 1.
    Otherwise, this will output the coordinates of the match in "x y" format.
"""


# Parse arguments
templatePath = sys.argv[1]
imagePath = sys.argv[2]
minSimilarityScore = float(sys.argv[3])

METHOD = 'cv2.TM_CCOEFF_NORMED'

# Still not completely sure what this does but I'm pretty sure it tries to find
# the matching OpenCV function to the string
funcMethod = eval(METHOD)

img = cv2.imread(imagePath,0)
img2 = img.copy()
template = cv2.imread(templatePath,0)
w, h = template.shape[::-1]
img = img2.copy()

# Apply template Matching
res = cv2.matchTemplate(img,template,funcMethod)
min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(res)

# Find center of the similar spot
top_left = max_loc
center = (top_left[0] + w / 2, top_left[1] + h / 2)

# Exit if similarity score is less than what was passed in
if max_val < minSimilarityScore:
    sys.exit(1)

print(int(center[0]), int(center[1]))
