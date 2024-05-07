
# import numpy as np
# import cv2

# img = cv2.imread('cct1.jpeg')

# gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

# blurred = cv2.medianBlur(gray, 25) #cv2.bilateralFilter(gray,10,50,50)
# lower =np.array([19,19,19])
# upper =  np.array([ 125,125,125])

# # find the colors within the specified boundaries
# image_mask = cv2.inRange(img, lower, upper)
# gray[image_mask==0]=[255]
# minDist = 10
# param1 = 20 #500
# param2 = 20 #200 #smaller value-> more false circles
# minRadius =0
# maxRadius = 20 #10

# # docstring of HoughCircles: HoughCircles(image, method, dp, minDist[, circles[, param1[, param2[, minRadius[, maxRadius]]]]]) -> circles
# circles = cv2.HoughCircles(gray, cv2.HOUGH_GRADIENT, 1, minDist,param1=param1,param2=param2, minRadius=minRadius, maxRadius=maxRadius)

# if circles is not None:
#     circles = np.uint16(np.around(circles))
#     for i in circles[0,:]:
#         cv2.circle(img, (i[0], i[1]), i[2], (0, 255, 0), 2)
# print("circles: ")
# print(circles)

# # Show result for testing:
# cv2.imshow('img', img)
# cv2.waitKey(0)
# # -*- coding: utf-8 -*-
# """
# Bacteria counter
 
#     Counts blue and white bacteria on a Petri dish
 
#     python bacteria_counter.py -i [imagefile] -o [imagefile]
 
# @author: Alvaro Sebastian (www.sixthresearcher.com)
# """
 