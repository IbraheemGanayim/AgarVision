# Import necessary modules
import base64
from ast import List
from collections import OrderedDict
import json
import string
from Domain.Schemas.Base import baseEntity, globalDateTimeFormat
from Infrastructure.firebase.config import database
from Domain.Helpers.json import convert, convertOrderdDictToList, toJson
from datetime import datetime, timedelta


# Define a custom function for sorting experiments by creation date
def myFunc(e):
    try:
        # Attempt to parse the 'createdDate' field as a datetime object
        return datetime.strptime(e["createdDate"], globalDateTimeFormat())
    except:
        # If parsing fails, return a default date
        return datetime.fromisocalendar(1970, 12, 5)


# Function to retrieve experiments associated with a user
def getExperiments(userId) -> string:
    # Retrieve experiments from the database for the given user ID
    result = convertOrderdDictToList(
        database()
        .child("epxeriments")
        .order_by_child("createdBy")
        .equal_to(userId)
        .get()
        .val()
    )
    # Sort the experiments based on the custom function 'myFunc'
    result.sort(key=myFunc, reverse=True)
    # Convert the sorted result to JSON format
    return toJson(result)


# Function to add a new experiment
def addNewExperiment(experiment):
    # Ensure the experiment follows the base schema
    experiment = baseEntity(experiment)
    # Set a default thumbnail for the experiment
    experiment["thumbnail"] = "experiment.jpg"
    # Push the new experiment data to the database
    database().child("epxeriments").push(experiment)
    # Return the added experiment
    return experiment


# Function to retrieve plates associated with an experiment
def getExperimentPlates(experiment_id) -> string:
    # Retrieve plates data from the database for the specified experiment
    return convert(
        database().child("epxeriments").child(experiment_id).child("plates").get().val()
    )
def getExperimentPlate(experiment_id,plate_id) -> string:
    # Retrieve plates data from the database for the specified experiment
    return database().child("epxeriments").child(experiment_id).child("plates").child(plate_id).get().val()


# Function to add a new plate to an experiment
def addNewPlate(experiment_id, plate):
    # Ensure the plate follows the base schema
    plate = baseEntity(plate)
    # Push the new plate data to the database under the specified experiment
    database().child("epxeriments").child(experiment_id).child("plates").push(plate)
    # Convert the added plate to JSON format
    return toJson(plate)


# Function to delete a plate from an experiment
def deletePlate(experiment_id, plate_id):
    # Remove the plate data from the database under the specified experiment
    database().child("epxeriments").child(experiment_id).child("plates").child(
        plate_id
    ).remove()
