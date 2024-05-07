import pyrebase

# Organization name is set for Firebase configuration
# organizationName = "wonderveggies"  # Unused, alternative configuration
organizationName = "agar-vision-dev"

# Configuration dictionary for Firebase application
config = {
  "apiKey": "AIzaSyBpnOcrgZ2fSYTQjYNIgMW2h6Zy7t0EUx0",
  "authDomain": f"{organizationName}.firebaseapp.com",
  "databaseURL": f"https://{organizationName}.firebaseio.com",
  "projectId": "agar-vision",
  "storageBucket": f"{organizationName}",
  "messagingSenderId": "102646728384",
  "appId": "1:102646728384:web:b70d980d3827c25e478f25",
  "measurementId": "G-TJTQ04V4RK",
  "serviceAccount": "Infrastructure/firebase/agar-vision-5b44db784b0e.json"
}

# Initialize the Firebase application with the specified configuration
firebase = pyrebase.initialize_app(config)


def init():
    # Function to initialize and return the Firebase application instance
    return firebase


def fireauth():
    # Function to retrieve and return the authentication service from Firebase
    return firebase.auth()


def database():
    # Function to access and return the database service from Firebase
    return firebase.database()


def storage():
    # Function to access and return the storage service from Firebase
    return firebase.storage()


# The commented-out lines below suggest a use case for uploading files to Firebase storage
# storage = firebase.storage()
# # as admin
# storage.child("images/dasdasdasdss.jpg").put("C:\\Users\\Simaan\\Documents\\GitHub\\AgarVision_Server\\WebAPI\\output.jpeg")
