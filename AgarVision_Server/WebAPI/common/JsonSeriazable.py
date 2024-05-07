# Import necessary libraries
import json  # for working with JSON data


# Class for a JSON serializable object
class JsonSeriazable:
    """
    Class for a JSON serializable object.
    """

    def toJSON(self):
        """
        Converts the object to a JSON string.

        Returns:
            str: The JSON string
        """
        return json.dumps(
            self,
            default=lambda o: o.__dict__,  # convert the object to a dictionary
            sort_keys=True,
            indent=4,
        )  # sort the keys and indent the JSON string