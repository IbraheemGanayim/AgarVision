# Import necessary modules from Flask and other libraries
from flask import Flask
from flask_cors import CORS
import logging
from logging.handlers import RotatingFileHandler
import os
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from Infrastructure.firebase.config import init
from flask_jwt_extended import JWTManager
from flask_smorest import Api

# Set up rate limiting for incoming requests using flask_limiter
limiter = Limiter(
    key_func=get_remote_address, default_limits=["200 per day", "50 per hour"]
)


# Function to create and configure the Flask app
def create_app():
    # Initialize the Flask app
    app = Flask(__name__)
    # Enable CORS with default settings allowing all domains for /api/ routes
    cors = CORS(app, resources={r"/api/*": {"origins": "*"}})

    # Load configuration from a file
    app.config.from_pyfile("environments/conf.cfg")
    # Setup JWT authentication manager
    jwt = JWTManager(app)

    # Import and register blueprints for different parts of the application
    from WebAPI.auth import bp as auth_bp
    from WebAPI.predict import bp as predict_bp
    from WebAPI.experiment import bp as experiment_bp

    init()
    app.register_blueprint(auth_bp)
    app.register_blueprint(experiment_bp)
    app.register_blueprint(predict_bp)

    # Apply rate limiting to the authentication blueprint
    limiter.limit("60 per minute")(auth_bp)

    # Configure logging, only if the app is not in debug mode
    if not app.debug:
        # Create a directory for logs if it does not already exist
        if not os.path.exists("logs"):
            os.mkdir("logs")
        # Set up a rotating file handler for logging
        file_handler = RotatingFileHandler(
            "logs/flask_api.log", maxBytes=10240, backupCount=10
        )
        # Define log format and add handler to app
        file_handler.setFormatter(
            logging.Formatter(
                "%(asctime)s %(levelname)s: %(message)s [in %(pathname)s:%(lineno)d]"
            )
        )
        file_handler.setLevel(logging.INFO)
        app.logger.addHandler(file_handler)

        # Set logger's level and log the application start-up message
        app.logger.setLevel(logging.INFO)
        app.logger.info("Flask API startup")

    return app
