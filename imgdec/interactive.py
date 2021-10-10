"""
    NOT MY CODE; Modified from OpenCV's Template Matching guide
    https://opencv24-python-tutorials.readthedocs.io/en/stable/py_tutorials/py_imgproc/py_template_matching/py_template_matching.html

    This script outputs a matplot plot that holds the compiled
    image on the left, and the original image (albeit slightly
    miscolored) to the right with a rectangle around the spot
    that the algorithm thinks most matches the template).

    Calling it as follows: python3 interactive.py [template path] [image path]
"""

import cv2
import numpy as np
import sys
from matplotlib import pyplot as plt

img = cv2.imread(sys.argv[2],0)
img2 = img.copy()
template = cv2.imread(sys.argv[1],0)
w, h = template.shape[::-1]

# All the 6 methods for comparison in a list
methods = ['cv2.TM_CCOEFF', 'cv2.TM_CCOEFF_NORMED', 'cv2.TM_CCORR',
            'cv2.TM_CCORR_NORMED', 'cv2.TM_SQDIFF', 'cv2.TM_SQDIFF_NORMED']

for meth in methods:
    img = img2.copy()
    method = eval(meth)

    # Apply template Matching
    res = cv2.matchTemplate(img,template,method)
    min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(res)

    print("Similarity score: " + str(max_val))

    # If the method is TM_SQDIFF or TM_SQDIFF_NORMED, take minimum
    if method in [cv2.TM_SQDIFF, cv2.TM_SQDIFF_NORMED]:
        top_left = min_loc
    else:
        top_left = max_loc
    bottom_right = (top_left[0] + w, top_left[1] + h)

    cv2.rectangle(img,top_left, bottom_right, (255, 0, 0), 2)

    plt.subplot(121),plt.imshow(res)
    plt.title('Matching Result'), plt.xticks([]), plt.yticks([])
    plt.subplot(122),plt.imshow(img)
    plt.title('Detected Point'), plt.xticks([]), plt.yticks([])
    plt.suptitle(meth)

    plt.show()


