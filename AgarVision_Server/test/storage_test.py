import unittest
from storage import (
    getExperimentThumbnailImage,
    getPlateThumbnailImage,
    downloadPlateThumbnailImageAndReturnPath,
    uploadPlateBase64ImageToBucket,
)
import os
import base64
from io import BytesIO

class TestImageFunctions(unittest.TestCase):
    def setUp(self):
        # Initialize the storage object
        self.storage = storage()

    def test_getExperimentThumbnailImage(self):
        # Test retrieving an experiment thumbnail image
        image_name = "test_image.jpg"
        buf = getExperimentThumbnailImage(image_name)
        self.assertIsInstance(buf, BytesIO)
        self.assertIsNotNone(buf.getvalue())

    def test_getPlateThumbnailImage(self):
        # Test retrieving a plate thumbnail image
        experiment_id = "test_experiment"
        image_name = "test_plate.jpg"
        buf = getPlateThumbnailImage(experiment_id, image_name)
        self.assertIsInstance(buf, BytesIO)
        self.assertIsNotNone(buf.getvalue())

    def test_downloadPlateThumbnailImageAndReturnPath(self):
        # Test downloading a plate thumbnail image and returning its path
        experiment_id = "test_experiment"
        image_name = "test_plate.jpg"
        dest_temporary_file = downloadPlateThumbnailImageAndReturnPath(
            experiment_id, image_name
        )
        self.assertIsInstance(dest_temporary_file, str)
        self.assertTrue(os.path.exists(dest_temporary_file))
        os.remove(dest_temporary_file)

    def test_uploadPlateBase64ImageToBucket(self):
        # Test uploading a plate image in base64 format to Firebase storage
        experiment_id = "test_experiment"
        image_base64 = base64.b64encode(b"test_image_data")
        image_path = uploadPlateBase64ImageToBucket(experiment_id, image_base64)
        self.assertIsInstance(image_path, str)
        self.assertTrue(self.storage.child(image_path).exists())

if __name__ == "__main__":
    unittest.main()