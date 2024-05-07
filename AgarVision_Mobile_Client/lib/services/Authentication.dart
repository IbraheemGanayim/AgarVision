import 'dart:convert';
import 'dart:io';
import 'package:agar_vision/main.dart'; // The main function of the app
import 'package:flutter/cupertino.dart'; // A widget toolkit for iOS
import 'package:flutter/material.dart'; // A widget toolkit for mobile and web
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // A package for secure storage
import 'package:http/http.dart' as http; // A package for making HTTP requests

import '../AppConstants.dart'; // A class that contains constant values
import '../helpers/Printer.dart'; // A class that provides a println method
import '../screens/login.dart'; // A screen for user login

class AuthenticationService {
  // A private constructor to prevent instantiation from outside the class
  AuthenticationService._privateConstructor();

  // A singleton instance of the class
  static AuthenticationService? _instance;

  // A factory constructor to create or return the singleton instance
  factory AuthenticationService() =>
      _instance ??= AuthenticationService._privateConstructor();

  // A FlutterSecureStorage instance for secure storage of the authentication token
  final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

  // A static getter for the authentication token
  static String? token;

  // A method to get the authentication token
  Future<String?> getToken() async {
    token = await storage.read(key: "JWT_TOKEN");

    return token;
  }

  // A method to set the authentication token
  Future<void> setToken(String? value) async {
    token = value;
    AppSettings.token = token; // Update the token in the AppSettings class
    await storage.write(
        key: "JWT_TOKEN", value: value); // Store the token in secure storage
  }

  // A method to set the refresh token
  Future<void> setRefreshToken(String? value) async {
    await storage.write(
        key: "JWT_REFRESH_TOKEN",
        value: value); // Store the refresh token in secure storage
  }

  // A method to get the refresh token
  Future<String?> getRefreshToken() async {
    return await storage.read(key: "JWT_REFRESH_TOKEN");
  }

  // A method to get the Android options for the FlutterSecureStorage
  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  // A static getter for the instance of the class
  static AuthenticationService instance() {
    _instance ??= AuthenticationService._privateConstructor();
    return _instance!;
  }

  // A static widget for the logout button
  static Widget logOutButton() {
    return IconButton(
      onPressed: () {
        AuthenticationService.instance().logout();
      },
      icon: const Icon(Icons.logout),
    );
  }

  // A method to check if the user is logged in
  Future<bool> isLoggedIn() async {
    String? token = await getToken();
    if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  // A method to refresh the access token
  Future<bool> refreshAccessToken() async {
    try {
      var uri = Uri.parse("${AppConstants.baseUrl}/api/auth/refresh");

      var refreshToken =
          await AuthenticationService.instance().getRefreshToken();
      var response = await http.post(uri, headers: {
        "Content-Type": "application/json",
        HttpHeaders.authorizationHeader: 'Bearer $refreshToken'
      });
      Printer.println(response);
      dynamic result = json.decode(response.body);
      if (result['code'] == 'valid-credential') {
        await setToken(result['token']);
      }
      return true;
    } catch (e) {
      Printer.println(e);
      return false;
    }
  }

  // A method to log in the user with the given username and password
  Future<dynamic> login(String username, String password) async {
    try {
      var uri = Uri.parse("${AppConstants.baseUrl}/api/auth/login");

      // Update to server containet ip
      // var uri = Uri.parse("http://172.17.0.2:5000/api/auth/login");

      Map data = {"email": username, "password": password};
      var body = json.encode(data);

      var response = await http.post(uri,
          headers: {"Content-Type": "application/json"}, body: body);
      Printer.println(response);
      dynamic result = json.decode(response.body);
      if (result['code'] == 'valid-credential') {
        await setToken(result['token']);
        await setRefreshToken(result['refresh_token']);
      }
      return result;
    } catch (e) {
      Printer.println(e);
      return null;
    }
  }

  // A method to log out the user
  Future<void> logout() async {
    await setToken(null);
    routeToLogin();
  }

  // A static method to route to the login screen
  static void routeToLogin() {
    var route = MaterialPageRoute(
        settings: const RouteSettings(name: "login"),
        builder: (context) => const LoginPage(title: "login"));
    Navigator.pushAndRemoveUntil(AppSettings.navigatorState.currentContext!,
        route, (Route<dynamic> route) => false);
  }
}

// A class to represent an authenticated user
class Authenticated {
  late String _token;

  Authenticated({required String token}) {
    _token = token;
  }

  String token() {
    return _token;
  }
}