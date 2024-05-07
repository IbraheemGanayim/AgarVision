import numpy as np
import argparse
import imutils
import cv2
from colorthief import ColorThief
def add_matrices(matrix1, matrix2):
    rows = len(matrix1)
    columns = len(matrix1[0])
    
    # Create a result matrix filled with zeros
    result = [[0 for _ in range(columns)] for _ in range(rows)]
    
    # Iterate over the elements and perform addition
    for i in range(rows):
        for j in range(columns):
            result[i][j] = matrix1[i][j] + matrix2[i][j]
    
    return result

COLOR_NAMES = ['red', 'orange', 'yellow', 'green', 'cyan', 'blue', 'purple']

COLOR_RANGES_HSV = {
    "red": [(0, 50, 10), (10, 255, 255)],
    "orange": [(10, 50, 10), (25, 255, 255)],
    "yellow": [(25, 50, 10), (35, 255, 255)],
    "green": [(33, 40,73), (138,123,114)],
    "cyan": [(80, 50, 10), (100, 255, 255)],
    "blue": [(100, 50, 10), (130, 255, 255)],
    "purple": [(130, 50, 10), (170, 255, 255)]
}
def getDominantColor(roi):
    roi = np.float32(roi)

    criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 10, 1.0)
    K = 4
    ret, label, center = cv2.kmeans(roi, K, None, criteria, 10, cv2.KMEANS_RANDOM_CENTERS)

    center = np.uint8(center)
    res = center[label.flatten()]
    res2 = res.reshape(roi.shape)

    pixelsPerColor = []
    for color in COLOR_NAMES:
        mask = getMask(res2, color)
        greyMask = cv2.cvtColor(mask, cv2.COLOR_BGR2GRAY)
        count = cv2.countNonZero(greyMask)
        pixelsPerColor.append(count)

    return COLOR_NAMES[pixelsPerColor.index(max(pixelsPerColor))]


def getMask(frame, color):
    blurredFrame = cv2.GaussianBlur(frame, (3, 3), 0)
    hsvFrame = cv2.cvtColor(blurredFrame, cv2.COLOR_BGR2HSV)
    cv2.imwrite("output2_hsv.jpeg",hsvFrame)

    
    colorRange = COLOR_RANGES_HSV[color]
    lower = np.array(colorRange[0])
    upper = np.array(colorRange[1])

    colorMask = cv2.inRange(hsvFrame, lower, upper)
    # colorMask = cv2.bitwise_and(blurredFrame, blurredFrame, mask=colorMask)

    return colorMask
# image_orig = cv2.imread("C:\\Users\\Simaan\\Documents\\GitHub\\Colony-Counter-with-python\\cct1.jpeg")
# cv2.imwrite("output2_mask.jpeg",getMask(image_orig,'green'))
# # getDominantColor(image_orig)
# MY_COLOR_NAMES = ['blue','green','cyan']
# blue = getMask(image_orig,'blue')
# green = getMask(image_orig,'green')
# cyan = getMask(image_orig,'cyan')
# mask3 = add_matrices(blue, green)
# mask3 = add_matrices(mask3, cyan) 
# # mask3 = cv2.bitwise_or(blue,green)
# # mask3 = cv2.bitwise_or(mask3,cyan)

# cv2.imwrite(f'output2_mask_all.jpeg',mask3)

# path ='C:\\Users\\Simaan\\Documents\\GitHub\\Colony-Counter-with-python\\cct1.jpeg'
# color_thief = ColorThief(path)
# dominant_color = color_thief.get_color(quality=1)
# palette = color_thief.get_palette(color_count=6)

# print(dominant_color)
# print(palette)


