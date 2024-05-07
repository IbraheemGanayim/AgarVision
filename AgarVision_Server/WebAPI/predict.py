from io import BytesIO
import os
import uuid
import cv2
from flask import Response, jsonify, send_file
from flask import Blueprint
from flask_jwt_extended import get_jwt_identity, jwt_required
from Domain.Helpers.files import createBase64ImageFromPath, getFileFormat
from Domain.Helpers.json import convert
from Infrastructure.firebase.database import getExperimentPlate
from Infrastructure.firebase.storage import (
    downloadPlateThumbnailImageAndReturnPath,
    getPlateThumbnailImage,
)
from Infrastructure.image_recognition.alg1 import countCircles
from datetime import datetime
# Define a Flask Blueprint for prediction related API endpoints
bp = Blueprint("predict", __name__)


@bp.get("/api/run")
def run() -> Response:
    # Serve an image file directly
    return send_file("output.jpeg", mimetype="image/jpg")


@bp.get("/api/predict/plates/<experiment_id>/<plate_id>")
@jwt_required()
def predict_img(experiment_id, plate_id) -> Response:
    email = get_jwt_identity()
    plate = getExperimentPlate(experiment_id,plate_id)
    plate_image = plate['image']
    sum = 0  # Variable to store the total count of items detected in the image
    image = ""  # Variable to store the base64 encoded image
    plate_parts = plate['parts']
    try:
        # Attempt to download the image file for the specified plate in the experiment
        plateImagePath = downloadPlateThumbnailImageAndReturnPath(
            experiment_id, plate_image
        )
    except:
        # Fallback path if the image download fails
        plateImagePath = "no_image.png"

    try:
        # Create a temporary file path for processing
        destTemporaryFile = os.path.dirname(os.path.abspath(__file__))
        ImageTempPath = os.path.join(destTemporaryFile, str(uuid.uuid4()) + ".jpg")

        # Read the image using OpenCV
        cvSrcImage = cv2.imread(plateImagePath, cv2.IMREAD_UNCHANGED)
        full_height_orig, full_width_orig =cvSrcImage.shape[:2]
        half_height = int(full_height_orig/2)
        half_height = int(half_height-full_width_orig/2)
        # Process the image to count items (e.g., colonies of bacteria)
        cvSrcImage = cvSrcImage[half_height:half_height+full_width_orig,0:full_width_orig]

        countOfColonies = countCircles(cvSrcImage, ImageTempPath,plate_parts)
        # Convert the processed image to a base64 string
        image = createBase64ImageFromPath(ImageTempPath)

        # Clean up: remove the temporary processed image file
        os.remove(ImageTempPath)

        # # Sum up all detected items categorized by color
        # for color in countOfColonies.keys():
        #     sum += countOfColonies[color]
    except:
        # If processing fails, encode the original image path instead
        image = createBase64ImageFromPath(plateImagePath)

    # Clean up: remove the original image file after processing
    os.remove(plateImagePath)

    # Return the result as a JSON object with the base64 image and sum of detected items
    return {"resultImage": image.decode("utf-8"), "result": sum,"QuartersResults":plate_parts}
    