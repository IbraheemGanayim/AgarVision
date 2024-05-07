# Import the authentication module from a custom Firebase configuration library
from Infrastructure.firebase.config import fireauth

# Initialize the Firebase authentication object
auth = fireauth()


def checkEmailAndPassword(email, password):
    # Function to authenticate a user with Firebase using email and password
    # Attempts to sign in a user with the provided credentials
    user = auth.sign_in_with_email_and_password(email, password)
    # Returns the user object if authentication is successful
    return user


# The commented-out function below intended for verifying if an email is still valid based on a timestamp
# def checkValidEmail(email, lastChanged):
#     # This function appears to be incomplete or incorrectly commented
#     # It repeats the sign-in functionality instead of checking the 'lastChanged' timestamp
#     user = auth.sign_in_with_email_and_password(email, password)
#     # Ideally, it should check something related to 'lastChanged'
#     return user