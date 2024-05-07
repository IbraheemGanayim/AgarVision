# # import the necessary packages
import numpy as np
import argparse
import imutils
import cv2

from Infrastructure.image_recognition.rangepicker import countFirstQuarter, countForthQuarter, countSecondQuarter, countThirdQuarter, detectLines


COLOR_RANGES_HSV = {
    "red": [(0, 50, 10), (10, 255, 255)],
    "orange": [(10, 50, 10), (25, 255, 255)],
    "yellow": [(25, 50, 10), (35, 255, 255)],
    "green": [(33, 40,73), (138,123,114)],
    "cyan": [(80, 50, 10), (100, 255, 255)],
    "blue": [(100, 50, 10), (130, 255, 255)],
    "purple": [(130, 50, 10), (170, 255, 255)]
}

mrs_UPPER = (192,165,62)
mrs_LOWER = (292,265,162)
COLOR_NAMES = COLOR_RANGES_HSV.keys()

def removeUnclosedCountours(im):
    im2 = im.copy()
    mask = np.zeros((np.array(im.shape)+2), np.uint8)
    cv2.floodFill(im, mask, (0,0), (255))
    im = cv2.erode(im, np.ones((3,3)))
    im = cv2.bitwise_not(im)
    im = cv2.bitwise_and(im,im2)
    return im

def countCircles(src_image,dst_image_path,plate_parts):
    global mrs_LOWER,mrs_UPPER
    full_height_orig, full_width_orig =src_image.shape[:2]
    half_full_height_orig, half_full_width_orig = int(full_height_orig/2), int(full_width_orig/2)
    first_quater_cord,second_quater_cord,third_quater_cord,forth_quater_cord=detectLines(src_image)

    first_quater = src_image[first_quater_cord[0][1]:first_quater_cord[1][1],first_quater_cord[0][0]:first_quater_cord[1][0]]
    second_quater = src_image[second_quater_cord[0][1]:second_quater_cord[1][1],second_quater_cord[0][0]:second_quater_cord[1][0]]
    third_quater = src_image[third_quater_cord[0][1]:third_quater_cord[1][1],third_quater_cord[0][0]:third_quater_cord[1][0]]
    forth_quater = src_image[forth_quater_cord[0][1]:forth_quater_cord[1][1],forth_quater_cord[0][0]:forth_quater_cord[1][0]]
    # cv2.imshow('full',image_src)
    # cv2.imshow('first_quater',first_quater)
    # cv2.imshow('second_quater',second_quater)
    # cv2.imshow('third_quater',third_quater)
    # cv2.imshow('forth_quater',forth_quater)


    first_quater = cv2.resize(first_quater, (800, 800))                # Resize image
    # cv2.imshow("first_quater",first_quater)
    # cv2.imshow("second_quater",second_quater)
    # cv2.imshow("third_quater",third_quater)
    # cv2.imshow("forth_quater",forth_quater)

    ## NEW ##
    # cv2.namedWindow('hsv')
    # cv2.setMouseCallback('hsv', pick_color)
    pixel = (24,123,255)
    range = 50
    upper =np.array([pixel[0] + 1, pixel[1] + range, pixel[2] + 30])
    lower = np.array([pixel[0] - 4, pixel[1] - range, pixel[2] - 30])
    # print(maxr,minr,maxg,ming,maxb,ming)
    # upper = np.array([27, 149, 255])
    # lower = np.array([21, 100, 105])
    # lower =   np.array([63+50,119+50,138+50])
    print(pixel, lower, upper)
 
    # selected=np.concatenate((selected,image_mask))
    # selected=  np.add(selected,image_mask)
    # cv2.imshow("mask",image_mask)

    # cv2.imshow("mask",selected)
    plate_parts[0]['dropsCount']=tuple(countFirstQuarter(first_quater,lower,upper,dst_image_path))
    plate_parts[1]['dropsCount']=tuple(countSecondQuarter(second_quater,lower,upper,dst_image_path))
    plate_parts[2]['dropsCount']=tuple(countThirdQuarter(third_quater,lower,upper,dst_image_path))
    plate_parts[3]['dropsCount']=tuple(countForthQuarter(forth_quater,lower,upper,dst_image_path))
    # plate_parts[0]['dropsCount']=(66,77,80)
    # plate_parts[1]['dropsCount']=(10,50,2)
    # plate_parts[2]['dropsCount']=(3,1,2)
    # plate_parts[3]['dropsCount']=(40,11,52)
    cv2.imwrite(dst_image_path,src_image)

    return plate_parts


# # load the image
# image_orig = cv2.imread("C:\\Users\\Simaan\\Documents\\GitHub\\Colony-Counter-with-python\\cct1.jpeg")

# print(countCircles(image_orig,"output_2sdas.jpg"))