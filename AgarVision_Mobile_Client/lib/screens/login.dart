// Import necessary Flutter and Dart libraries and local files
import 'package:agar_vision/components/FutureTextButton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/Authentication.dart';
import 'experiments.dart';
import 'dart:async';

// Define a StatefulWidget to manage the login page state dynamically
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// State class for LoginPage where the mutable state and business logic reside
class _LoginPageState extends State<LoginPage> {
  // TextEditingControllers to manage the text field inputs
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Message to display as feedback to the user
  String _message = "";

  @override
  void initState() {
    super.initState();
    // Automatically perform login if in debug mode for testing purposes
    if (kDebugMode) {
      performLogin(context, "smaan.1997@gmail.com", "test122");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color.fromARGB(255, 207, 255, 215), // Light green background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/agarvision_title.PNG', // Logo or title image
                      height: 100,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _message,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Username",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true, // Hides the password input
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Password",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    FutureTextButton(
                        text: "Login",
                        onPress: () {
                          // Trigger login action when credentials are submitted
                          if (_usernameController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty) {
                            return performLogin(
                                context,
                                _usernameController.text,
                                _passwordController.text);
                          } else {
                            setState(() {
                              _message = "Invalid Credentials!";
                            });
                            return Future(() => true);
                          }
                        }),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        // Show a dialog for registration or additional information
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Notice"),
                              content:
                                  const Text("Only officials are allowed."),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Closes the dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        "or Register",
                        style: TextStyle(
                          color: Colors.green[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // Perform login using the Authentication service
  Future<void> performLogin(
      BuildContext context, String emailAddress, String password) async {
    AuthenticationService auth = AuthenticationService.instance();
    final e = await auth.login(emailAddress, password);
    // Handle the different outcomes of the login attempt
    if (e == null) {
      displayMessage(context, 'Unexpected error');
      return;
    }
    if (e['code'] == 'valid-credential') {
      navigateToHome(context);
      return;
    }
    if (e['code'] == 'user-not-found' || e['code'] == 'invalid-credential') {
      displayMessage(context, 'Invalid Username or Password.',
          color: Colors.red);
    } else if (e['code'] == 'wrong-password') {
      displayMessage(context, 'Wrong password provided for that user.',
          color: Colors.red);
    } else if (e['code'] == 'invalid-email') {
      displayMessage(context, 'Invalid email', color: Colors.red);
    } else {
      displayMessage(context, e['code'], color: Colors.red);
    }
  }

  // Navigate to the home screen after successful login
  void navigateToHome(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          settings: const RouteSettings(name: "experiments"),
          builder: (context) => const Experiments()),
    );
  }

  // Display a message using a SnackBar
  void displayMessage(BuildContext context, String message,
      {Color color = Colors.black}) {
    var snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: color),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
