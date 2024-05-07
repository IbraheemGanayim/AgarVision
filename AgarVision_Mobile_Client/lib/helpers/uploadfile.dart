// Import necessary libraries
import 'dart:convert';
import 'package:agar_vision/AppConstants.dart'; // Assuming this contains base URL
import 'package:path/path.dart'; // For getting the filename from the path
import 'dart:io'; // For File class
import 'package:http/http.dart' as http; // For making HTTP requests

// Define an asynchronous function to upload a file
Upload(File imageFile) async {
  try {
    // Create a new ByteStream from the image file
    var stream = http.ByteStream(imageFile.openRead())..cast();

    // Define the URI for the API endpoint
    var uri = Uri.parse("${AppConstants.baseUrl}/api/predict/upload");

    // Create a new MultipartRequest to send the file
    var request = http.MultipartRequest("POST", uri);

    // Get the length of the file
    var length = await imageFile.length();

    // Create a new MultipartFile to include in the request
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    // Note: The 'file' parameter should match the name expected by the server

    // Add the MultipartFile to the request
    request.files.add(multipartFile);

    // Send the request and wait for a response
    var response = await request.send();

    // Print the status code of the response
    print(response.statusCode);

    // Decode the response body and print it
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  } catch (e) {
    // If an error occurs, print it
    print(e);
  }
}