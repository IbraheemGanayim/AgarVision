from __future__ import print_function
import cv2 as cv
import numpy as np
import argparse
import random as rng
rng.seed(12345)
def thresh_callback(val):
    threshold = val
    # Detect edges using Canny
    canny_output = cv.Canny(src_gray, threshold, threshold * 2)
    # Find contours
    contours, hierarchy = cv.findContours(canny_output, cv.RETR_TREE, cv.CHAIN_APPROX_SIMPLE)
    # Draw contours
    drawing = np.zeros((canny_output.shape[0], canny_output.shape[1], 3), dtype=np.uint8)
    for i in range(len(contours)):
        color = (rng.randint(0,256), rng.randint(0,256), rng.randint(0,256))
    cv.drawContours(drawing, contours, i, color, 2, cv.LINE_8, hierarchy, 0)
    # Show in a window
    cv.imshow('Contours', drawing)
# Load source image
parser = argparse.ArgumentParser(description='Code for Finding contours in your image tutorial.')
parser.add_argument('--input', help='Path to input image.', default='C:\\Users\\Simaan\\Documents\\GitHub\\AgarVision_Server\\Infrastructure\\image_recognition\\IMG_2709_q3.jpg')
args = parser.parse_args()
src = cv.imread(cv.samples.findFile(args.input))
if src is None:
 print('Could not open or find the image:', args.input)
 exit(0)
# Convert image to gray and blur it
src_gray = cv.cvtColor(src, cv.COLOR_BGR2GRAY)
src_gray = cv.blur(src_gray, (3,3))
# Create Window
source_window = 'Source'
cv.namedWindow(source_window)
cv.imshow(source_window, src)
max_thresh = 255
thresh = 100 # initial threshold
cv.createTrackbar('Canny Thresh:', source_window, thresh, max_thresh, thresh_callback)
thresh_callback(thresh)
cv.waitKey()
# import cv2
# import numpy as np

# # Load image, grayscale, median blur, Otsus threshold
# image = cv2.imread('C:\\Users\\Simaan\\Documents\\GitHub\\AgarVision_Server\\Infrastructure\\image_recognition\\IMG_2709_q3.jpg')
# gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
# blur = cv2.medianBlur(gray, 11)
# thresh = cv2.threshold(blur, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)[1]

# # Morph open 
# kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (5,5))
# opening = cv2.morphologyEx(thresh, cv2.MORPH_OPEN, kernel, iterations=3)

# # Find contours and filter using contour area and aspect ratio
# cnts = cv2.findContours(opening, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
# cnts = cnts[0] if len(cnts) == 2 else cnts[1]
# for c in cnts:
#     peri = cv2.arcLength(c, True)
#     approx = cv2.approxPolyDP(c, 0.04 * peri, True)
#     area = cv2.contourArea(c)
#     if len(approx) > 5 and area > 1000 and area < 500000:
#         ((x, y), r) = cv2.minEnclosingCircle(c)
#         cv2.circle(image, (int(x), int(y)), int(r), (36, 255, 12), 2)

# cv2.imshow('thresh', thresh)
# cv2.imshow('opening', opening)
# cv2.imshow('image', image)
# cv2.waitKey()  