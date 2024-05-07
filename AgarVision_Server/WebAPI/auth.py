# Import necessary modules and libraries
import datetime
import json
from flask import Response, jsonify
from flask.views import MethodView, View
from flask_jwt_extended import (
    create_access_token,
    create_refresh_token,
    get_jwt_identity,
    jwt_required,
)
from Domain.Schemas.User import UserSchema
from Infrastructure.firebase.authentication import checkEmailAndPassword
from WebAPI.common.JsonSeriazable import JsonSeriazable
from flask_smorest import Blueprint, abort

# Define a Flask Blueprint for authentication related routes
bp = Blueprint("auth", __name__)


# Define the login route and logic
@bp.route("/api/auth/login")
class Auth(MethodView):
    # Using UserSchema to validate and deserialize input data
    @bp.arguments(UserSchema)
    def post(self, user):
        try:
            # Authenticate user by checking email and password
            auth = checkEmailAndPassword(user["email"], user["password"])
            # Create JWT access token and refresh token upon successful authentication
            access_token = create_access_token(identity=user["email"], fresh=True)
            refresh_token = create_refresh_token(identity=user["email"])
            # Return tokens and a success message
            return {
                "token": access_token,
                "refresh_token": refresh_token,
                "message": "User is valid",
                "code": "valid-credential",
            }, 200
        except:
            # Handle failed authentication
            return {
                "token": None,
                "refresh_token": None,
                "message": "Invalid credentials",
                "code": "invalid-credential",
            }, 200


# Define the route for token refresh
@bp.route("/api/auth/refresh")
class RefreshToken(MethodView):
    # Ensure only requests with a valid refresh token can access this route
    @jwt_required(refresh=True)
    def post(self):
        # Retrieve the identity from the existing refresh token
        email = get_jwt_identity()
        # Create a new access token
        access_token = create_access_token(identity=email, fresh=False)
        # A more complete implementation would verify the email is still valid before issuing a new access token
        # Return the new access token with a success message
        return {
            "token": access_token,
            "message": "User is valid",
            "code": "valid-credential",
        }, 200