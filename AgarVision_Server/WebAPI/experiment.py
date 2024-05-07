# Import necessary modules and libraries
import base64
from http.client import responses
from io import BytesIO
from pathlib import Path
from flask import Response, jsonify, request, send_file
from flask.views import MethodView, View
from flask_jwt_extended import (
    create_access_token,
    get_jwt,
    get_jwt_identity,
    jwt_required,
)
from Domain.Schemas.Experiment import AddNewExperimentScheme, AddNewPlateScheme
from Domain.Schemas.User import UserSchema
from Infrastructure.firebase.authentication import checkEmailAndPassword
from Infrastructure.firebase.database import (
    addNewExperiment,
    addNewPlate,
    deletePlate,
    getExperimentPlates,
    getExperiments,
)
from Infrastructure.firebase.storage import (
    getExperimentThumbnailImage,
    getPlateThumbnailImage,
    uploadPlateBase64ImageToBucket,
)
from WebAPI.common.JsonSeriazable import JsonSeriazable
from flask_smorest import Blueprint, abort

# Define a Flask Blueprint for experiment-related API endpoints
bp = Blueprint("experiment", __name__)

import uuid


# Define routes and logic for experiment-related operations
@bp.route("/api/experiments")
class Experiments(MethodView):
    @jwt_required()
    def get(self):
        # Retrieve the email from JWT token
        email = get_jwt_identity()
        # Get experiments associated with the email
        return getExperiments(email)

    @jwt_required()
    @bp.arguments(AddNewExperimentScheme)
    def post(self, newExperiment):
        # Add a new experiment with validated data
        return addNewExperiment(newExperiment)


# Define routes for managing plates within an experiment
@bp.route("/api/experiments/<experiment_id>/plates")
class ExperimentPlates(MethodView):
    @jwt_required()
    def get(self, experiment_id):
        # Retrieve the email from JWT token
        email = get_jwt_identity()
        # Get plates associated with a specific experiment
        return getExperimentPlates(experiment_id)

    @jwt_required()
    @bp.arguments(AddNewPlateScheme)
    def post(self, plate, experiment_id):
        # Handle image upload as part of adding a new plate
        imageBase64 = plate["image"]
        imageUniqueName = uploadPlateBase64ImageToBucket(experiment_id, imageBase64)
        plate["image"] = imageUniqueName
        # Add the new plate with modified data to include uploaded image reference
        return addNewPlate(experiment_id, plate)

    @jwt_required()
    def delete(self, experiment_id, plate_id):
        # Delete a plate from a specific experiment
        deletePlate(experiment_id, plate_id)
        return {"message": "Plate deleted successfully"}


# Define route for retrieving experiment thumbnail images
@bp.route("/api/experiment/image/<name>")
class ExperimentThumbnail(MethodView):
    @jwt_required()
    def get(self, name):
        try:
            # Attempt to retrieve the thumbnail image from storage
            buf = getExperimentThumbnailImage(name)
        except:
            # Fallback image if retrieval fails
            buf = "no_image.png"
        return send_file(buf, mimetype="image/jpg")


# Define route for retrieving plate images within an experiment
@bp.route("/api/experiment/<experiment_id>/plates/img/<img>")
class PlateThumbnail(MethodView):
    @jwt_required()
    def get(self, experiment_id, img):
        try:
            # Attempt to retrieve the thumbnail image for a specific plate
            buf = getPlateThumbnailImage(experiment_id, img)
        except:
            # Fallback image if retrieval fails
            buf = "no_image.png"
        return send_file(buf, mimetype="image/jpg")
