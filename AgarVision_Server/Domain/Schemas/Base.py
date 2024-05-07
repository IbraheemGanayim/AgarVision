# Import necessary libraries
from datetime import datetime  # for working with dates and times
from flask_jwt_extended import (
    get_jwt_identity,
)  # for getting the current user's identity from a JWT


# Function to add common fields to an entity
def baseEntity(entity):
    """
    Adds common fields to an entity.

    Args:
        entity: The entity to add fields to

    Returns:
        dict: The entity with common fields added
    """
    entity["createdBy"] = (
        get_jwt_identity()
    )  # set the creator of the entity to the current user
    entity["createdDate"] = datetime.utcnow().strftime(
        globalDateTimeFormat()
    )  # set the creation date of the entity to the current UTC time
    return entity


# Function to get the global date-time format
def globalDateTimeFormat():
    """
    Returns the global date-time format.

    Returns:
        str: The date-time format
    """
    return "%Y%m%dT%H%M%S"  # the date-time format is YYYY-MM-DDTHH:MM:SS
