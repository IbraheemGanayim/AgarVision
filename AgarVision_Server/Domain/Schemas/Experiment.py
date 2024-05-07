# Import necessary libraries
from marshmallow import Schema, fields  # for creating data validation schemas
from enum import Enum  # for creating enumerations


# Class for adding a new experiment schema
class AddNewExperimentScheme(Schema):
    """
    Schema for adding a new experiment.
    """

    name = fields.Str(required=False)  # the name of the experiment (optional)


# Class for a plate part schema
class PlatePart(Schema):
    """
    Schema for a plate part.
    """

    example = fields.Str(required=True)  # the example for the plate part (required)
    dilution = fields.Float(required=True)  # the dilution for the plate part (required)
    countMethod = fields.Str(
        required=True
    )  # the count method for the plate part (required)
    dropsCount = fields.List(
        fields.Float(required=True)
    )  # the drops count for the plate part (required)


# Class for adding a new plate schema
class AddNewPlateScheme(Schema):
    """
    Schema for adding a new plate.
    """

    type = fields.Str(required=True)  # the type of the plate (required)
    image = fields.Str(required=True)  # the image for the plate (required)
    bacteria = fields.List(
        fields.Str(required=True)
    )  # the bacteria for the plate (required)
    parts = fields.List(
        fields.Nested("PlatePart")
    )  # the parts for the plate (required)