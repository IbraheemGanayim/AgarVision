# Import necessary libraries
import base64  # for base64 encoding and decoding
import math  # for mathematical operations
import re  # for regular expressions


# Function to get the file format from a file name
def getFileFormat(name):
    """
    Returns the file format (extension) from a given file name.

    Args:
        name (str): The file name

    Returns:
        str: The file format (extension)
    """
    return name.split(".")[-1]


# Function to decode base64 data with optional alternative characters
def decode_base64(data, altchars=b"+/"):
    """
    Decodes base64 data with optional alternative characters.

    Args:
        data (bytes): The base64 encoded data
        altchars (bytes, optional): Alternative characters to use for decoding. Defaults to b'+/'.

    Returns:
        bytes: The decoded data
    """
    # Normalize the data by removing any characters that are not valid base64 characters or alternative characters
    data = re.sub(rb"[^a-zA-Z0-9%s]+" % altchars, b"", data)
    # Calculate the missing padding characters
    missing_padding = len(data) % 4
    # Add padding characters if necessary
    if missing_padding:
        data += b"=" * (4 - missing_padding)
    # Decode the base64 data using the alternative characters
    return base64.b64decode(data, altchars)


# Function to create an image file from base64 encoded content
def createImageFromBase64(name, base64Content):
    """
    Creates an image file from base64 encoded content.

    Args:
        name (str): The file name for the image
        base64Content (str): The base64 encoded image content
    """
    with open(name, "wb") as image_file:
        # Pad the base64 content to ensure it's a multiple of 4 characters
        base64Content = base64Content.ljust(
            (int)(math.ceil(len(base64Content) / 4)) * 4, "="
        )
        # Check if the base64 content has a "base64," prefix
        if "base64," in base64Content:
            # Extract the encoded string from the base64 content
            encoded_string = base64.b64decode(base64Content.split("base64,")[1])
        else:
            # Decode the base64 content directly
            encoded_string = base64.b64decode(base64Content)
        # Write the decoded image data to the file
        image_file.write(encoded_string)


# Function to create a base64 encoded image from a file path
def createBase64ImageFromPath(path):
    """
    Creates a base64 encoded image from a file path.

    Args:
        path (str): The file path of the image

    Returns:
        bytes: The base64 encoded image data
    """
    with open(path, "rb") as f:
        # Read the image file and encode it as base64
        encoded_image = base64.b64encode(f.read())
    return encoded_image
