# Use the official Python 3.9 slim-buster image as the base image
FROM python:3.9-slim-buster

# Set the working directory for any RUN, CMD, ENTRYPOINT, COPY and ADD instructions that follow in the Dockerfile
WORKDIR /python-docker

# Expose port 5000 for the application
EXPOSE 5000

# Copy requirements.txt to the working directory
COPY requirements.txt requirements.txt

# Install necessary dependencies
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y

# Install the dependencies from requirements.txt
RUN pip3 install -r requirements.txt

# Create a volume to store logs
VOLUME ["/python-docker/logs"]

# Copy the current directory contents into the container at /app
COPY . .

# Run the command to start the Flask application when the container launches
CMD python3 -m flask run --host=0.0.0.0 --port=$PORT