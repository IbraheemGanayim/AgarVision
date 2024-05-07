# Import necessary libraries
from ast import List  # for type hinting
from collections import OrderedDict  # for ordered dictionaries
import json  # for JSON encoding and decoding


# Function to convert an OrderedDict or other object to a JSON string
def convert(object) -> str:
    """
    Converts an OrderedDict or other object to a JSON string.

    Args:
        object: The object to convert

    Returns:
        str: The JSON string
    """
    result = []
    if type(object) is OrderedDict:
        # Convert the OrderedDict to a list
        result = convertOrderdDictToList(object)
    return toJson(result)


# Function to convert a JSON string to a Python object
def toJson(object) -> str:
    """
    Converts a Python object to a JSON string.

    Args:
        object: The Python object to convert

    Returns:
        str: The JSON string
    """
    return json.dumps(object)


# Function to convert an OrderedDict to a list of dictionaries
def convertOrderdDictToList(dict: OrderedDict) -> List:
    """
    Converts an OrderedDict to a list of dictionaries.

    Args:
        dict (OrderedDict): The OrderedDict to convert

    Returns:
        List: The list of dictionaries
    """
    list = []
    for key in dict:
        # Add the key as an "id" field to each dictionary
        dict[key]["id"] = key
        list.append(dict[key])
    return list