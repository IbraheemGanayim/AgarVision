# Import necessary modules
from io import BytesIO
import os
import threading
import uuid
from Domain.Helpers.files import createImageFromBase64, getFileFormat
from Infrastructure.firebase.config import storage

# Initialize locks for thread safety
lock = threading.Lock()
lock2 = threading.Lock()
lock3 = threading.Lock()


# Function to retrieve the experiment thumbnail image from Firebase storage
def getExperimentThumbnailImage(imageName):
    # Ensure thread safety with lock
    with lock:
        # Generate a unique temporary file path
        ImageTempPath = str(uuid.uuid4()) + "." + getFileFormat(imageName)
        destTemporaryFile = os.path.dirname(os.path.abspath(__file__))
        destTemporaryFile = os.path.join(destTemporaryFile, ImageTempPath)

        # Download the image from Firebase storage
        storage().download(path="experiments/" + imageName, filename=destTemporaryFile)

        # Open the temporary file and read its contents into a BytesIO buffer
        fh = open(destTemporaryFile, "rb")
        buf = BytesIO(fh.read())
        fh.close()

        # Remove the temporary file
        os.remove(destTemporaryFile)

    # Return the buffer containing the image data
    return buf


# Function to retrieve the plate thumbnail image from Firebase storage
def getPlateThumbnailImage(experiment_id, imageName):
    # Ensure thread safety with lock
    with lock2:
        # Download the plate image and return its path
        destTemporaryFile = downloadPlateThumbnailImageAndReturnPath(
            experiment_id, imageName
        )

        # Open the downloaded file, read its contents into a BytesIO buffer, and close the file
        fh = open(destTemporaryFile, "rb")
        buf = BytesIO(fh.read())
        fh.close()

        # Remove the downloaded file
        os.remove(destTemporaryFile)

    # Return the buffer containing the image data
    return buf


# Function to download the plate thumbnail image and return its path
def downloadPlateThumbnailImageAndReturnPath(experiment_id, imageName):
    # Ensure thread safety with lock
    with lock3:
        # Generate a unique temporary file path
        ImageTempPath = str(uuid.uuid4()) + "." + getFileFormat(imageName)
        destTemporaryFile = os.path.dirname(os.path.abspath(__file__))
        destTemporaryFile = os.path.join(destTemporaryFile, ImageTempPath)

        # Download the plate thumbnail image from Firebase storage
        storage().download(
            path="experiments/" + experiment_id + "/plates/" + imageName,
            filename=destTemporaryFile,
        )

    # Return the path of the downloaded file
    return destTemporaryFile


# Function to upload the plate image in base64 format to Firebase storage
def uploadPlateBase64ImageToBucket(experiment_id, imageBase64):
    # Ensure thread safety with lock
    with lock:
        # Generate a unique temporary file path
        ImageTempPath = str(uuid.uuid4()) + ".png"

        # Create an image from the base64 string and save it to a temporary file
        createImageFromBase64(ImageTempPath, imageBase64)

        # Upload the temporary file to Firebase storage under the specified path
        storage().child(
            "experiments/" + experiment_id + "/plates/" + ImageTempPath
        ).put(ImageTempPath)

        # Remove the temporary file
        os.remove(ImageTempPath)

    # Return the path of the uploaded file
    return ImageTempPath