import unittest
import cv2
import numpy as np
from rangepicker import (
    remove_unclosed_contours,
    print_shape,
    get_agar_area,
    cut_out,
    is_circle,
    count_colonies,
)

class TestImageFunctions(unittest.TestCase):
    def setUp(self):
        # Initialize the image
        self.image = cv2.imread("test_image.jpg")

    def test_remove_unclosed_contours(self):
        # Test removing unclosed contours
        gray = cv2.cvtColor(self.image, cv2.COLOR_BGR2GRAY)
        ret, thresh = cv2.threshold(gray, 127, 255, 0)
        contours, hierarchy = cv2.findContours(
            thresh, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
        im_contours = cv2.drawContours(self.image.copy(), contours, -1, (0, 0, 255), 3)
        im_no_unclosed_contours = remove_unclosed_contours(im_contours)
        self.assertFalse(np.any(np.where(im_no_unclosed_contours == [0, 0, 255])))

    def test_print_shape(self):
        # Test printing the shape and center point of a contour
        gray = cv2.cvtColor(self.image, cv2.COLOR_BGR2GRAY)
        ret, thresh = cv2.threshold(gray, 127, 255, 0)
        contours, hierarchy = cv2.findContours(
            thresh, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
        im_contours = cv2.drawContours(self.image.copy(), contours, -1, (0, 0, 255), 3)
        print_shape(contours[0], im_contours)
        self.assertTrue(np.any(np.where(im_contours == [0, 0, 255])))

    def test_get_agar_area(self):
        # Test getting the agar area
        agar_plate_mask = get_agar_area(self.image)
        self.assertTrue(np.all(agar_plate_mask == [255, 255, 255]))

    def test_cut_out(self):
        # Test cutting out a region of interest from an image
        roi = self.image[100:200, 100:200]
        mask = np.zeros(self.image.shape[:2], dtype=np.uint8)
        mask[100:200, 100:200] = 255
        im_cut_out = cut_out(self.image, mask)
        self.assertTrue(np.all(im_cut_out == roi))

    def test_is_circle(self):
        # Test checking if a contour is a circle
        gray = cv2.cvtColor(self.image, cv2.COLOR_BGR2GRAY)
        ret, thresh = cv2.threshold(gray, 127, 255, 0)
        contours, hierarchy = cv2.findContours(
            thresh, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
        center, radius = is_circle(contours[0])
        self.assertIsNotNone(center)
        self.assertIsNotNone(radius)

    def test_count_colonies(self):
        # Test counting colonies
        image = cv2.imread("test_colonies.jpg")
        lower = np.array([0, 0, 0])
        upper = np.array([255, 255, 255])
        counts = count_colonies(image, lower, upper)
        self.assertEqual(counts, (10, 20, 30))

if __name__ == "__main__":
    unittest.main()