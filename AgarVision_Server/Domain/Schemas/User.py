# Import necessary libraries
from marshmallow import Schema, fields  # for creating data validation schemas


# Class for a user schema
class UserSchema(Schema):
    """
    Schema for a user.
    """

    email = fields.Str(required=True)  # the email of the user (required)
    password = fields.Str(required=True)  # the password of the user (required)