# -*- coding: utf-8 -*-
"""
Created on Wed Nov  2 17:55:44 2022

@author: Simaan
"""
import numpy as np
import argparse
import imutils
import cv2
import cv2
import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans

x = [4, 5, 10, 4, 3, 11, 14 , 6, 10, 12]
y = [21, 19, 24, 17, 16, 25, 24, 22, 21, 21]


  


def removeUnclosedCountours(im):
    im2 = im.copy()
    mask = np.zeros((np.array(im.shape)+2), np.uint8)
    cv2.floodFill(im, mask, (0,0), (255))
    im = cv2.erode(im, np.ones((3,3)))
    im = cv2.bitwise_not(im)
    im = cv2.bitwise_and(im,im2)
    return im

def printShape(contour,img):
    # cv2.approxPloyDP() function to approximate the shape 
    approx = cv2.approxPolyDP( 
        contour, 0.01 * cv2.arcLength(contour, True), True) 
      
    # using drawContours() function 
    # cv2.drawContours(img, [contour], 0, (0, 0, 255), 5) 
  
    # finding center point of shape 
    M = cv2.moments(contour) 
    if M['m00'] != 0.0: 
        x = int(M['m10']/M['m00']) 
        y = int(M['m01']/M['m00']) 
  
    # putting shape name at center of each shape 
    if len(approx) == 3: 
        cv2.putText(img, 'Triangle', (x, y), 
                    cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 2) 
  
    elif len(approx) == 4: 
        cv2.putText(img, 'Quadrilateral', (x, y), 
                    cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 2) 
  
    elif len(approx) == 5: 
        cv2.putText(img, 'Pentagon', (x, y), 
                    cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 2) 
  
    elif len(approx) == 6: 
        cv2.putText(img, 'Hexagon', (x, y), 
                    cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 2) 
  
    else: 
        cv2.putText(img, 'circle', (x, y), 
                    cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 2) 
        
        
def getAgarArea(image_orig):
    # colorOfBackgroundOfAgar = (67,117,132)
    # colorOfBackgroundOfAgar = (63,119,138)
    colorOfBackgroundOfAgar = (22,122,167)
     
    range = 40
    image_contours = image_orig.copy()
    h,w = image_contours.shape[:2]
    upper = np.array([colorOfBackgroundOfAgar[0] + range, colorOfBackgroundOfAgar[1] + range, colorOfBackgroundOfAgar[2] + range])
    lower = np.array([colorOfBackgroundOfAgar[0] - range, colorOfBackgroundOfAgar[1] - range, colorOfBackgroundOfAgar[2] - range])
    image_contours = cv2.blur(image_contours,(10,10))
    image_mask = cv2.inRange(image_contours,lower,upper)
    image_res = cv2.bitwise_and(image_contours, image_contours, mask = image_mask)
    image_gray = cv2.cvtColor(image_res, cv2.COLOR_BGR2GRAY)
    # image_gray = cv2.GaussianBlur(image_gray, (5, 5), 0)
    image_edged = cv2.Canny(image_gray, 50, 100)
    image_edged = cv2.dilate(image_edged, None, iterations=2)

    image_edged = cv2.erode(image_edged, None, iterations=1)
    crc2 = cv2.HoughCircles(image_edged, cv2.HOUGH_GRADIENT, 2, 1000, param1=10, param2=10, minRadius=200, maxRadius=1000)
    if crc2 is not None:

                # Convert the coordinates and radius of the circles to integers
                crc2 = np.round(crc2[0, :]).astype("int")

                # For each (x, y) coordinates and radius of the circles
                for (row, col, r) in crc2:
                    
                    # Draw the circle
                    if(col>=800 or row >=800):
                        continue
                    # value = image_mask[col][row]
                    mask2 = np.zeros((h,w), np.uint8)
                    cv2.circle(mask2, (row, col), r-20, (255,255,255), -1) 
                    # cv2.bitwise_not(mask2)
                    mask2 = 255-mask2
                    return mask2
    return None
# load the image
def cut_out(image, mask):
    if type(image) != np.ndarray:
        raise TypeError("image must be a Numpy array")
    elif type(mask) != np.ndarray:
        raise TypeError("mask must be a Numpy array")
    elif image.shape != mask.shape:
        raise ValueError("image and mask must have the same shape "+str(image.shape)+"!="+str(mask.shape))

    return np.where(mask==0, (0,0,0), image)
def isCicrle(cnt,image,minRadiusToBeIncluded=5):
    # approx = cv2.approxPolyDP(cnt, .03 * cv2.arcLength(cnt, True), True)
    area = cv2.contourArea(cnt)
    (cx, cy), radius = cv2.minEnclosingCircle(cnt)
    circleArea = radius * radius * np.pi
    ratioOfAreas=area/circleArea
    # cv2.circle(image, (int(cx), int(cy)),int(radius), (255,0,0), 4) 
    # # if(radius<minRadiusToBeIncluded):
    # cv2.putText(image, "{:.0f}/{:.0f} {:.0f}".format(area,circleArea,radius), (int(cx-20), int(cy)), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 1)

    if ratioOfAreas > 0.3 and radius>=minRadiusToBeIncluded:
        return (cx, cy), radius
    return None
def count(image_orig_mat,lower,upper,drops_centers,dst_image_path,debug=False):
    image_orig = image_orig_mat.copy()

    counter = {}
    kernel = np.ones((5,5),np.uint8)

    height_orig, width_orig = image_orig.shape[:2]
    oroignal_image_mask = cv2.inRange(image_orig.copy(),lower,upper)

    # output image with contours
    # agarPlateMasked = getAgarArea(image_orig.copy())
    # oroignal_image_mask[agarPlateMasked==255]=0
    if(debug==True):
        cv2.imshow('oroignal_image_mask1',oroignal_image_mask)
    oroignal_image_mask = cv2.morphologyEx(oroignal_image_mask, cv2.MORPH_CLOSE, kernel)  
    image_contours = image_orig.copy()
    # image_contours=np.where(agarPlateMasked==0, (0,0,0), image_contours)
    black_pixels = np.where(
    (image_contours[:, :, 0]< 80
    
    ) & 
    (image_contours[:, :, 1] <80
    
    ) & 
    (image_contours[:, :, 2] <80
    
    )
    )
    image_contours[black_pixels] = (63,119,138)
    # image_contours[agarPlateMasked]= (0,0,0)
    # image_contours = np.dstack((image_contours, agarPlateMasked))

    # image_contours = cut_out(image_contours,agarPlateMasked)
 
    # image_contours[agarPlateMasked == 255] = (0,0,0)

    # allplace = np.all(agarPlateMasked == 255, axis = 0)
    # image_contours[allplace] = (0,0,0)
    # image_contours = cv2.blur(image_contours,(10,10))
    image_mask = cv2.inRange(image_contours,lower,upper)
    # thresh = cv2.threshold(image_mask, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)[1]

    # # Morph open 
    kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (5,5))
    outline = cv2.morphologyEx(image_mask, cv2.MORPH_GRADIENT, kernel, iterations=2)
    # outline = cv2.dilate(outline, kernel, iterations=5)
    outline = cv2.erode(outline, kernel, iterations=1)
    if(debug==True):
        cv2.imshow('outline',outline)
    closing = cv2.morphologyEx(outline, cv2.MORPH_CLOSE, kernel, iterations=5)
    opening = cv2.morphologyEx(closing, cv2.MORPH_OPEN, kernel, iterations=5)

    if(debug==True):
        # cv2.imshow('oroignal_image_mask',oroignal_image_mask)
        cv2.imshow('closing',closing)

        # cv2.imshow('image_mask',image_mask)
  

    # set those pixels to white
    avg=0
    cntall=0
    # copy of original image
    # image_to_process = image_orig.copy()

    # initializes counter
    counter = 0

    # apply the mask
    image_res = cv2.bitwise_and(image_contours, image_contours, mask = image_mask)

    ## load the image, convert it to grayscale, and blur it slightly
    image_gray = cv2.cvtColor(image_res, cv2.COLOR_BGR2GRAY)
    # image_gray = cv2.GaussianBlur(image_gray, (5, 5), 0)

    # perform edge detection, then perform a dilation + erosion to close gaps in between object edges
    image_edged = cv2.Canny(image_gray, 100, 200)
    image_edged = cv2.dilate(image_edged, None, iterations=1)
    image_edged = cv2.erode(image_edged, None, iterations=1)

    image_edged = removeUnclosedCountours(image_edged)
    if(debug==True):
        cv2.imshow('opening',opening)
    # h,w = image_orig.shape[:2]
    # mask = np.zeros((h,w), np.uint8)

    # find contours in the edge map
    cnts = cv2.findContours(image_edged.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[0]
    # cnt = max(cnts, key=cv2.contourArea)
    # cv2.drawContours(mask, [cnt], 0, 255, -1)

    # loop over the contours individually


    # plt.plot(range(1,11), inertias, marker='o')
    # plt.title('Elbow method')
    # plt.xlabel('Number of clusters')
    # plt.ylabel('Inertia')
    # plt.show()
    circlesXCoordinates = []
    circlesYCoordinates = []
    for c in cnts:
     
        # if the contour is not sufficiently large, ignore it
        contourArea = cv2.contourArea(c)
        if contourArea < 15:
            continue
        if contourArea > 5000:
            print(cv2.contourArea(c), cv2.arcLength(c,True))
            # continue
        # printShape(c,image_contours)
        # compute the Convex Hull of the contour
        hull = cv2.convexHull(c)
        result = isCicrle(c,image_contours)
        if(result!=None):
            (cx,cy),radius = result
            circlesXCoordinates.append(cx)
            circlesYCoordinates.append(cy)
            cv2.drawContours(image_contours,[hull],0,(0,255,0),1)
        # else:
        #     cv2.drawContours(image_contours,[hull],0,(255,255,255),2)

       

        # print

        # cv2.putText(image_contours, "{:.0f}".format(cv2.contourArea(c)), (int(hull[0][0][0]), int(hull[0][0][1])), cv2.FONT_HERSHEY_SIMPLEX, 0.65, (255, 255, 255), 2)
        # cv2.imshow("c {}".format(counter),c)

    # Detect circles in the image
    # crc = cv2.HoughCircles(image_mask, cv2.HOUGH_GRADIENT, 1, 10, param1=10, param2=10, minRadius=1, maxRadius=20)
    crc2 = cv2.HoughCircles(image_edged, cv2.HOUGH_GRADIENT, 1, 10, param1=10, param2=10, minRadius=1, maxRadius=20)
    if crc2 is not None:

            # Convert the coordinates and radius of the circles to integers
            crc2 = np.round(crc2[0, :]).astype("int")

            # For each (x, y) coordinates and radius of the circles
            for (row, col, r) in crc2:
                
                # Draw the circle
                # cv2.circle(image_edged, (x, y), r, (255,255,255), 4)
                if(col>=800 or row >=800):
                    continue
                value = opening[col][row]
                if value>=200:
                    counter += 1
                    cntall+=1
                    # avg+=contourArea
                    cv2.circle(image_orig, (row, col), r, (255,255,0), 4) 
                # else:
                #     if value<=10:
                #         cv2.circle(image_contours, (row, col), r, (0,0,0), 1) 
                #     else:
                #         cv2.circle(image_contours, (row, col), r, (0,0,0), 10) 
                # cv2.putText(image_contours, "{:.0f}".format(value), (int(row), int(col)), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2)


    toltHeight = int(height_orig/3)
    toltWidth = int(width_orig/3)


    # Print the number of colonies of each color
    print("{} colonies".format(counter))
    # Writes the output image
    # print("avg area "+str((avg/cntall)))
    for c in  drops_centers:
        cv2.circle(image_orig, (c[0], c[1]), 50, (255,255,0), -1) 
    if(debug==True):
        cv2.imshow("image_contours",image_contours)
        cv2.imshow("image_orig",image_orig) 

    if(debug==True):
        cv2.imshow("image_edged",image_edged)
    # circlesXCoordinates=circlesXCoordinates[1:2]
    # circlesYCoordinates=circlesYCoordinates[1:2]
    data = list(zip(circlesXCoordinates, circlesYCoordinates))
    print("height:" +str(height_orig))
    print("width:" +str(width_orig))
    kmeans = KMeans(n_clusters=3,init=drops_centers,max_iter=300,n_init=1)
    kmeans.fit(drops_centers)
    counts = list((0,0,0))

    try:
        labels = kmeans.predict(data)
        if(debug==True):

            plt.gca().invert_xaxis()
            
            plt.axis([0, height_orig, 0, width_orig])
            plt.gca().invert_yaxis()
            for c in  drops_centers:
                plt.plot(c[0], c[1], "s") 
            print(labels)
            plt.scatter(circlesXCoordinates, circlesYCoordinates, c=labels)
            plt.show()
        for item in labels:
            counts[item-1]=counts[item-1]+1
    except:
        counts = list((0,0,0))
 
    return counts

maxr=0
minr=255
maxg=0
ming=255
maxb=0
minb=255

# mouse callback function
def pick_color(event,x,y,flags,param):
    global selected
    global maxr
    global minr
    global maxg
    global ming
    global maxb
    global minb
    global image_hsv
    if event == cv2.EVENT_LBUTTONDOWN:
        range = 50
    if event == cv2.EVENT_RBUTTONDOWN:
        range=100
    if( event != cv2.EVENT_RBUTTONDOWN and  event != cv2.EVENT_LBUTTONDOWN):
        return
    print(x,y)
    pixel = image_hsv[y,x]
    if(pixel[0]>maxr):
        maxr=pixel[0]
    if(pixel[1]>maxg):
        maxg=pixel[1]
    if(pixel[2]>maxb):
        maxb=pixel[2]
    if(pixel[0]<minr):
        minr=pixel[0]
    if(pixel[1]<ming):
        ming=pixel[1]
    if(pixel[2]<minb):
        minb=pixel[2]
    # pixel = (24,123,255)
    upper =np.array([pixel[0] + 50, pixel[1] + range, pixel[2] + 40])
    lower = np.array([pixel[0] - 50, pixel[1] - range, pixel[2] - 40])
    print(maxr,minr,maxg,ming,maxb,ming)
    # upper = np.array([27, 149, 255])
    # lower = np.array([21, 100, 105])
    # lower =   np.array([63+50,119+50,138+50])
    print("lower upper")
    print(pixel, lower, upper)
 
    # selected=np.concatenate((selected,image_mask))
    # selected=  np.add(selected,image_mask)
    image_mask = cv2.inRange(image_hsv,lower,upper)
    cv2.imshow("mask",image_mask)

    # cv2.imshow("mask",selected)
    initial_centers = np.array([[400*2, 400], [400, 400*2],[400*2, 400*2]])  # Example centers
    count(image_hsv,lower,upper,initial_centers,"")
    # count2(image_hsv,selected)
def sumwhite(arr1,arr2):
    for i in range(len(arr1)):
        for j in range(len(arr1[0])):
            if(arr2[i][j]>=100):
                arr1[i][j]=arr2[i][j]
def subwhite(arr1,arr2):
    for i in range(len(arr1)):
        for j in range(len(arr1[0])):
            if(arr2[i][j]==255):
                arr1[i][j]=0
  
# def count2(img,image_mask):
#         img = img.copy()
#         image_mask = image_mask.copy()
#         gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

#         blurred = cv2.bilateralFilter(gray,10,50,50)

#         # find the colors within the specified boundaries
#         # image_mask = cv2.inRange(img, lower, upper)
#         gray[image_mask==0]=[0]
#         gray[image_mask>0]=[255]

#         minDist = 20
#         param1 = 50 #500
#         param2 = 30 #200 #smaller value-> more false circles
#         minRadius =0
#         maxRadius = 210 #10
#         countColonies=0
#         # docstring of HoughCircles: HoughCircles(image, method, dp, minDist[, circles[, param1[, param2[, minRadius[, maxRadius]]]]]) -> circles
#         circles = cv2.HoughCircles(blurred, cv2.HOUGH_GRADIENT, 1, minDist,param1=param1,param2=param2, minRadius=minRadius, maxRadius=maxRadius)
#         if circles is not None:
#             circles = np.uint16(np.around(circles))
#             for i in circles[0,:]:
#                 countColonies=countColonies+1
#                 if gray[i[0], i[1]]==255:
#                     cv2.circle(img, (i[0], i[1]), i[2], (0, 255, 0), 2) 
#                 if gray[i[0], i[1]]<=10:
#                     cv2.circle(img, (i[0], i[1]), i[2], (0, 255, 255), 1) 
#                 else:
#                     cv2.circle(img, (i[0], i[1]), i[2], (255, 0, 0), 1) 

#         print("count 2:")
#         print (countColonies
#                )
#         cv2.imwrite("output222.jpeg",img)
#         cv2.imwrite("gray.jpeg",gray)
#         # cv2.imshow("blurred",blurred)
def avg(list):
    return int(sum(list)/len(list))
def detectLines(image):
      # Grayscale conversion
    full_height_orig, full_width_orig =image.shape[:2]
    half_full_height_orig, half_full_width_orig = int(full_height_orig/2), int(full_width_orig/2)
    # try:
    #     part_height, part_width = int(full_height_orig/15), int(full_width_orig/15)
        
    #     gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    #     cv2.imshow('gray',gray)
    #     # Canny edge detection
    #     edges = cv2.Canny(gray, 150, 160, apertureSize=3)
    #     # clear top right and left sides
    #     edges[0:half_full_height_orig-part_height,0:half_full_width_orig-part_width]=0
    #     edges[0:half_full_height_orig-part_height,half_full_width_orig+part_width:full_width_orig]=0
    #     # clear bottom right and left sides
    #     edges[half_full_height_orig+part_height:full_height_orig,0:half_full_width_orig-part_width]=0
    #     edges[half_full_height_orig+part_height:full_height_orig,half_full_width_orig+part_width:full_width_orig]=0

    #     cv2.imshow('edges',edges)

    #     # Hough Line Transform
    #     lines = cv2.HoughLines(edges, 1, np.pi / 180, 200)

    #     # list = [1,1.5,2]
    #     # for i in range(len(list)):
    #     #     lines = cv2.HoughLines(edges, list[i], np.pi / 180, 200)
    #     #     if((lines!=None) and (lines.size==4)):
    #     #         break
    #     #     else:
    #     #         continue
                

    #     # Iterate through each detected line
    #     verticalLines = []
    #     horizontalLines= []
    #     resultLines = []
    #     for line in lines:
    #         rho, theta = line[0]
    #         degree = theta*(180/np.pi)
    #         thresh=2
    #         if(degree>90+thresh and degree<(180-thresh)):
    #             continue
    #         if(degree>thresh and degree<90-thresh):
    #             continue
    #         ver_hor = 'vertical'
    #         if(degree>=90-thresh and degree<=90+thresh):
    #             ver_hor='horizontal'

    #         print(degree)
    #         # Convert polar coordinates to Cartesian coordinates
    #         a = np.cos(theta)
    #         b = np.sin(theta)
    #         x0 = a * rho
    #         y0 = b * rho
    #         x1 = int(x0 + full_height_orig * (-b))
    #         y1 = int(y0 + full_height_orig * (a))
    #         x2 = int(x0 - full_height_orig * (-b))
    #         y2 = int(y0 - full_height_orig * (a))
    #         # resultLines.append(((min(x1,x2), min(y1,y2)), (max(x1,x2), max(y1,y2))))
    #         if(degree>=90-thresh and degree<=90+thresh):
    #             horizontalLines.append(((x1, y1), (x2, y2),ver_hor))
    #         else:
    #             verticalLines.append(((x1, y1), (x2, y2),ver_hor))
    #         resultLines.append(((x1, y1), (x2, y2),ver_hor))
    #         # Draw lines on the original image
    #     q1x=avg([verticalLines[0][0][0],verticalLines[0][1][0],verticalLines[1][0][0],verticalLines[1][1][0]])
    #     q1y=avg([horizontalLines[0][0][1],horizontalLines[0][1][1],horizontalLines[1][0][1],horizontalLines[1][1][1]])

    #     print(resultLines)
    #     cv2.rectangle(image, (0, 0), (q1x, q1y), color=(255,255,255), thickness=3)
    #     cv2.rectangle(image,  (0, q1y), (q1x, full_height_orig), color=(255,0,0), thickness=3)
    #     cv2.rectangle(image,  (q1x, q1y), (full_width_orig, full_height_orig), color=(255,255,0), thickness=3)
    #     cv2.rectangle(image,  (q1x, 0), (full_width_orig, q1y), color=(255,0,255), thickness=3)
    # except:
    q1x=half_full_height_orig
    q1y=half_full_height_orig
    # cv2.rectangle(image, (0, 0), (q1x, q1y), color=(255,255,255), thickness=3)
    # cv2.rectangle(image,  (0, q1y), (q1x, full_height_orig), color=(255,0,0), thickness=3)
    # cv2.rectangle(image,  (q1x, q1y), (full_width_orig, full_height_orig), color=(255,255,0), thickness=3)
    # cv2.rectangle(image,  (q1x, 0), (full_width_orig, q1y), color=(255,0,255), thickness=3)
    # for line in resultLines:
    #     image[0:line[0][0],0:line[0][1]]=0
    #     if( line[2]=='vertical'):
    #         cv2.line(image, line[0], line[1], (255, 0, 255), 2)
    #     else:
    #         cv2.line(image, line[0], line[1], (255, 0, 0), 2)
    return ((0, 0), (q1x, q1y)),((0, q1y), (q1x, full_height_orig)),((q1x, q1y), (full_width_orig, full_height_orig)),((q1x, 0), (full_width_orig, q1y))

def countFirstQuarter(first_quater,lower,upper,dst_image_path):
    image = first_quater#cv2.cvtColor(first_quater,cv2.COLOR_BGR2HSV)
    height_orig, width_orig = image.shape[:2]
    toltHeight = int(height_orig/3)
    toltWidth = int(width_orig/3)
    initial_centers = np.array([[toltHeight*2, toltWidth], [toltHeight, toltWidth*2],[toltHeight*2, toltWidth*2]])  # Example centers
    return count(image,lower,upper,initial_centers,dst_image_path,debug=False)
def countSecondQuarter(first_quater,lower,upper,dst_image_path):
    image = first_quater#cv2.cvtColor(first_quater,cv2.COLOR_BGR2HSV)
    height_orig, width_orig = image.shape[:2]
    toltHeight = int(height_orig/3)
    toltWidth = int(width_orig/3)
    initial_centers = np.array([[toltHeight, toltWidth], [toltHeight*2, toltWidth],[toltHeight*2, toltWidth*2]])  # Example centers
    return count(image,lower,upper,initial_centers,dst_image_path,debug=False)

def countThirdQuarter(third_quater,lower,upper,dst_image_path):
    image = third_quater#cv2.cvtColor(third_quater,cv2.COLOR_BGR2HSV)
    height_orig, width_orig = image.shape[:2]
    toltHeight = int(height_orig/3)
    toltWidth = int(width_orig/3)
    initial_centers = np.array([[toltHeight, toltWidth], [toltHeight*2, toltWidth], [toltHeight, toltWidth*2]])  # Example centers
    return count(image,lower,upper,initial_centers,dst_image_path,debug=False)


def countForthQuarter(third_quater,lower,upper,dst_image_path):
    image =third_quater#cv2.cvtColor(third_quater,cv2.COLOR_BGR2HSV)
    height_orig, width_orig = image.shape[:2]
    toltHeight = int(height_orig/3)
    toltWidth = int(width_orig/3)
    initial_centers = np.array([[toltHeight, toltWidth], [toltHeight, toltWidth*2], [toltHeight*2, toltWidth*2]])  # Example centers
    return count(image,lower,upper,initial_centers,dst_image_path,debug=False)

def main():
    import sys
    global image_hsv, pixel # so we can use it in mouse callback

    # image_src = cv2.imread("C:\\Users\\Simaan\\Documents\\GitHub\\Colony-Counter-with-python\\cct1.jpeg")
    
    # image_src = cv2.imread("C:\\Users\\Simaan\\Downloads\\WhatsApp Image 2024-04-12 at 22.24.33_4.jpeg")
    # image_src = cv2.imread("C:\\Users\\Simaan\\Documents\\GitHub\\AgarVision_Server\\Infrastructure\\ml-prediction\\datasets\\IMG_0064.jpg")
    image_src = cv2.imread("C:\\Users\\Simaan\\Downloads\\experiments_-NxJPvq3Zm8duqVi7EcZ_plates_1aaa8d15-e6a4-4ad5-9dc8-6fcefb16c889.png")
    full_height_orig, full_width_orig =image_src.shape[:2]
    half_height = int(full_height_orig/2)
    half_height = int(half_height-full_width_orig/2)
    # Process the image to count items (e.g., colonies of bacteria)
    x = image_src[half_height:half_height+full_width_orig,0:full_width_orig]
    cv2.imshow('s',cv2.resize(x, (800, 800)))
    cv2.waitKey(0)
    return
    if image_src is None:
        print ("the image read is None............")
        return
    full_height_orig, full_width_orig =image_src.shape[:2]
    half_full_height_orig, half_full_width_orig = int(full_height_orig/2), int(full_width_orig/2)
    image_src = cv2.resize(image_src, (800, 800))                # Resize image
    image_hsv = image_src
    # image_hsv = cv2.cvtColor(image_src,cv2.COLOR_BGR2HSV)

    first_quater_cord,second_quater_cord,third_quater_cord,forth_quater_cord=detectLines(image_src)
    first_quater = image_src[first_quater_cord[0][1]:first_quater_cord[1][1],first_quater_cord[0][0]:first_quater_cord[1][0]]
    second_quater = image_src[second_quater_cord[0][1]:second_quater_cord[1][1],second_quater_cord[0][0]:second_quater_cord[1][0]]
    third_quater = image_src[third_quater_cord[0][1]:third_quater_cord[1][1],third_quater_cord[0][0]:third_quater_cord[1][0]]
    forth_quater = image_src[forth_quater_cord[0][1]:forth_quater_cord[1][1],forth_quater_cord[0][0]:forth_quater_cord[1][0]]
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
    cv2.namedWindow('hsv')
    cv2.setMouseCallback('hsv', pick_color)
    # image_hsv = cv2.cvtColor(first_quater,cv2.COLOR_BGR2HSV)

    pixel = (100,110,187) 
    range = 40
    lower = np.array([44,124,133])
    upper =np.array([ 144,224,213])
    # print(maxr,minr,maxg,ming,maxb,ming)
    # upper = np.array([27, 149, 255])
    # lower = np.array([21, 100, 105])
    # lower =   np.array([63+50,119+50,138+50])
    print(pixel, lower, upper)
 
    # selected=np.concatenate((selected,image_mask))
    # selected=  np.add(selected,image_mask)
    # cv2.imshow("mask",image_mask)

    # cv2.imshow("mask",selected)
    countFirstQuarter(first_quater,lower,upper,"quaerter1.jpg")
    countSecondQuarter(second_quater,lower,upper,"quaerter2.jpg")
    countThirdQuarter(third_quater,lower,upper,"quaerter3.jpg")
    countForthQuarter(forth_quater,lower,upper,"quaerter4.jpg")

    # now click into the hsv img , and look at values:

    cv2.imshow("hsv",image_hsv)

    cv2.waitKey(0)
    cv2.destroyAllWindows()

if __name__=='__main__':
    main()


