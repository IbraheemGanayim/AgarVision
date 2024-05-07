import 'dart:convert';
import 'dart:io';

import 'package:agar_vision/schema/Experiment.dart';
import 'package:agar_vision/services/Authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../AppConstants.dart'; // A class that contains constant values
import '../../helpers/Printer.dart'; // A class that provides a println method
import '../../main.dart'; // The main function of the app
import '../../schema/Plate.dart'; // A class that represents a plate
import '../../schema/PlatePredictionResult.dart'; // A class that represents the prediction result of a plate

class ExperimentService {
  // A static method that returns a Future of a list of Experiment objects
  static Future<List<Experiment>> getExperiments() async {
    var uri = Uri.parse("${AppConstants.baseUrl}/api/experiments");

    var response = await httpAuthorizedClient.get(uri);
    Printer.println(response); // Print the response object
    dynamic result = json.decode(response.body);
    var map = (result as List)
        .map((e) => Experiment.fromJson(e as Map<String, dynamic>));
    return map
        .toList(); // Convert the JSON data to a list of Experiment objects
  }

  // A static method that returns a Future of a Map<String, dynamic> object
  static Future<Map<String, dynamic>> getExperimentResults(
      String experimentId) async {
    var uri = Uri.parse(
        "${AppConstants.baseUrl}/api/experiments/$experimentId/result");

    var response = await httpAuthorizedClient.get(uri);
    Printer.println(response); // Print the response object
    dynamic result = json.decode(response.body);
    return result; // Return the JSON data as a Map<String, dynamic> object
  }

  // A static method that returns a FutureBuilder widget
  static FutureBuilder<String?> getExperimentThumbnail(String? image) {
    return FutureBuilder(
      future: AuthenticationService.instance()
          .getToken(), // Get the authentication token
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Image.network(
                "${AppConstants.baseUrl}/api/experiment/image/$image",
                headers: {
                  HttpHeaders.authorizationHeader: "Bearer ${snapshot.data}"
                }, // Add the authentication token to the headers
                width: 60.0,
                height: 60.0,
                fit: BoxFit.cover,
              )
            : new CircularProgressIndicator(); // Show a loading indicator if the token is not yet available

        ///load until snapshot.hasData resolves to true
      },
    );
  }

  // A static method that returns an Image widget
  static Image getPlateImage(
      {required String experimentId,
      required Plate plate,
      double? width = 60.0,
      double? height = 60.0}) {
    String token = AuthenticationService.token!; // Get the authentication token
    return Image.network(
      "${AppConstants.baseUrl}/api/experiment/$experimentId/plates/img/${plate.image}",
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token"
      }, // Add the authentication token to the headers
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }

  // A static method that returns a Future<PlatePredictionResult> object
  static Future<PlatePredictionResult> getPredictedPlateImage(
      {required String experimentId,
      required Plate plate,
      double? width = 60.0,
      double? height = 60}) async {
    var uri = Uri.parse(
        "${AppConstants.baseUrl}/api/predict/plates/$experimentId/${plate.plateId}");

    var response = await httpAuthorizedClient.get(uri);
    Printer.println(response); // Print the response object
    dynamic result = json.decode(response.body);
    return PlatePredictionResult.fromJson(
        result); // Convert the JSON data to a PlatePredictionResult object
  }

  // A static method that returns a Future<List<Plate>> object
  static Future<List<Plate>> getExperimentPlates(String experimentId) async {
    var uri = Uri.parse(
        "${AppConstants.baseUrl}/api/experiments/$experimentId/plates");

    var response = await httpAuthorizedClient.get(uri);
    Printer.println(response); // Print the response object
    dynamic result = json.decode(response.body);
    var map = (result as List).map((e) => Plate.fromJson(e));
    return map.toList(); // Convert the JSON data to a list of Plate objects
  }

  // A static method that adds a new experiment with the given name
  static Future<bool> addNewExperiment(String name) async {
    Map data = {"name": name};
    var body = json.encode(data);
    var uri = Uri.parse("${AppConstants.baseUrl}/api/experiments");

    var response = await httpAuthorizedClient.post(uri, body: body);
    dynamic result = json.decode(response.body);
    Printer.println(result.toString());
    return response.statusCode ==
        200; // Return true if the request is successful
  }

  // A static method that returns a pretty JSON string of the given JSON object
  static String getPrettyJSONString(dynamic jsonObject) {
    var encoder = new JsonEncoder.withIndent("     ");
    return encoder.convert(jsonObject);
  }

  // A static method that adds a new plate to the given experiment
  static Future<Plate> addNewPlate(
      String experimentId, AddNewPlate newPlate) async {
    var body = getPrettyJSONString(newPlate.toJson());

    var uri = Uri.parse(
        "${AppConstants.baseUrl}/api/experiments/$experimentId/plates");

    var response = await httpAuthorizedClient.post(uri, body: body);

    Printer.println(response.body);
    dynamic result = json.decode(response.body);

    return Plate.fromJson(result); // Convert the JSON data to a Plate object
  }

// A static method that deletes a plate from the given experiment
  static Future<bool> deletePlate(String experimentId, String plateId) async {
    var uri = Uri.parse(
        "${AppConstants.baseUrl}/api/experiments/$experimentId/plates/$plateId");

    var response = await httpAuthorizedClient.delete(uri);
    dynamic result = json.decode(response.body);
    Printer.println(result.toString());
    return response.statusCode ==
        200; // Return true if the request is successful
  }
}
