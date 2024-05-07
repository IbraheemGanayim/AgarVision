// Import Dart's built-in library for encoding and decoding strings, and Flutter's Material package
import 'dart:typed_data';
import 'package:agar_vision/schema/Experiment.dart';
import 'package:agar_vision/screens/plates.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'new_plate_detail.dart';
import 'dart:convert';

// StatefulWidget for capturing or selecting an image of a plate associated with an experiment
// ignore: must_be_immutable
class TakePlatePicturePage extends StatefulWidget {
  Experiment currentExperiment; // Current experiment data

  TakePlatePicturePage({required this.currentExperiment});

  @override
  _TakePlatePicturePageState createState() => _TakePlatePicturePageState();
}

class _TakePlatePicturePageState extends State<TakePlatePicturePage> {
  late CameraController
      _controller; // Controller for managing camera operations
  Future<void>? _initializeControllerFuture =
      null; // Future for initializing the camera
  bool _canUseCamera = true; // Flag to check camera availability
  String? base64Image; // Encoded string of the captured image
  int _currentCameraIndex = 0; // Index of the current camera
  int camlen = 0; // Number of available cameras

  @override
  void initState() {
    super.initState();
    // Retrieve and initialize available cameras when the widget is initialized
    availableCameras().then((cameras) {
      camlen = cameras.length;
      if (cameras.length > 1) {
        _currentCameraIndex =
            1; // Use the second camera if more than one is available
      } else {
        _currentCameraIndex = 0; // Default to the first camera
      }

      _controller =
          CameraController(cameras[_currentCameraIndex], ResolutionPreset.max);
      _initializeControllerFuture =
          _controller.initialize(); // Initialize the selected camera
    });
  }

  @override
  void dispose() {
    // Dispose the camera controller to release resources
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture; // Wait for the camera to initialize
      final XFile file = await _controller.takePicture(); // Capture the image

      final imageBytes = await file.readAsBytes(); // Read the image as bytes
      final base64Image =
          base64Encode(imageBytes); // Encode the bytes as a base64 string

      setState(() {
        this.base64Image =
            base64Image; // Update the state to display the captured image
      });

      // Navigate to the detail page with the captured image
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewPlateDetail(
            currentExperiment: widget.currentExperiment,
            plateImageBase64: base64Image,
          ),
        ),
      );
    } catch (e) {
      print('Error taking picture: $e'); // Handle errors during picture taking
    }
  }

  Future<void> _uploadPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(
        source: ImageSource.gallery); // Pick an image from the gallery

    if (file != null) {
      Uint8List imageBytes =
          await file.readAsBytes(); // Read the image file as bytes
      String base64Img =
          base64Encode(imageBytes); // Convert image to base64 string
      base64Image = base64Img;

      setState(() {});

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewPlateDetail(
            currentExperiment: widget.currentExperiment,
            plateImageBase64: base64Img,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
      future: canUseCamera(), // Check if the camera can be used
      builder: (context, snapshot) {
        _canUseCamera = snapshot.data ??
            false; // Update camera usage flag based on availability
        if (snapshot.connectionState != ConnectionState.done) {
          return CircularProgressIndicator(); // Show loading indicator while checking camera
        }
        return Scaffold(
          appBar: AppBar(
            title:
                const Text('New plate', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlatesPage(
                      currentExperiment: widget.currentExperiment,
                    ),
                  ),
                );
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.help, color: Colors.white),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Help"),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                "Here are the instructions for taking a plate picture."),
                            Text("1. Choose a camera or upload a photo."),
                            Text(
                                "2. Press the camera button to take a picture."),
                            Text(
                                "3. Press the upload button to upload a photo."),
                            Text(
                                "Make sure to align the plate according to the guide."),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Close the help dialog
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              getImageView()
            ], // Display the live camera view or the selected image
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                imageUploadOptionsButtons(), // Display buttons for camera actions
          ),
        );
      },
    );
  }

  Future<bool> canUseCamera() async {
    try {
      List<CameraDescription> cameras =
          await availableCameras(); // Retrieve available cameras
      return cameras
          .isNotEmpty; // Return true if one or more cameras are available
    } catch (e) {
      return false; // Return false if an error occurs
    }
  }

  Widget imageView(String bas64) {
    return Image.memory(
        base64Decode(bas64)); // Decode base64 string to display the image
  }

  Widget liveCameraView() {
    var screenSize = MediaQuery.of(context).size; // Obtain the screen size
    var size = screenSize.width < screenSize.height
        ? screenSize.width
        : screenSize.height;
    var previewSize = size * 0.75; // Calculate preview size based on the screen
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Display camera preview if initialized
          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipOval(
                  child: Container(
                    width: previewSize,
                    height: previewSize,
                    child: CameraPreview(_controller),
                  ),
                ),
                Positioned(
                  top: previewSize / 2,
                  left: 0,
                  right: 0,
                  child: Container(height: 2, color: Colors.white),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: previewSize / 2,
                  child: Container(width: 2, color: Colors.white),
                ),
              ],
            ),
          );
        } else {
          // Show loading indicator or error message
          return Center(
            child: snapshot.connectionState == ConnectionState.waiting
                ? CircularProgressIndicator()
                : Text('Failed to load camera',
                    style: TextStyle(color: Colors.red)),
          );
        }
      },
    );
  }

  List<Widget> imageUploadOptionsButtons() {
    List<Widget> buttons = [];
    if (_canUseCamera) {
      buttons.add(FloatingActionButton(
        onPressed: _takePicture,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: const Icon(Icons.camera_alt),
      ));
    }

    buttons.add(FloatingActionButton(
      onPressed: _uploadPhoto,
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      child: const Icon(Icons.upload_file),
    ));

    if (camlen > 1) {
      buttons.add(FloatingActionButton(
        onPressed: _switchCamera,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: const Icon(Icons.switch_camera),
      ));
    }
    return buttons;
  }

  Future<void> _switchCamera() async {
    List<CameraDescription> cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      setState(() {
        _currentCameraIndex =
            _currentCameraIndex == 0 ? 1 : 0; // Toggle camera index
      });

      _controller = CameraController(
          cameras[_currentCameraIndex], ResolutionPreset.medium);
      _initializeControllerFuture =
          _controller.initialize(); // Reinitialize the camera
    } else {
      print('No cameras available');
    }
  }

  Widget getImageView() {
    if (base64Image != null) {
      return imageView(base64Image!); // Display the captured or uploaded image
    } else {
      if (_initializeControllerFuture != null)
        return liveCameraView(); // Display the camera viewfinder
      else
        return Text("No camera available");
    }
  }
}
