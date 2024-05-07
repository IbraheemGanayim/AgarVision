import 'package:agar_vision/services/backend/ExperimentService.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NewExperiment extends StatefulWidget {
  BuildContext context;

  NewExperiment({Key? key, required this.context}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NewExperimentState createState() => _NewExperimentState();
}

class _NewExperimentState extends State<NewExperiment> {
  // Create a TextEditingController for the experiment name input field
  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String error = ""; // Initialize an error message variable
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('New experiment', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, false);
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
                            "Here are the instructions for creating a new experiment:"),
                        Text("\n1. Enter a name for the experiment."),
                        Text(
                            "2. Press the 'ADD' button to create the experiment."),
                        // Add more instructions as needed
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop(); // Closes the dialog
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
      body: Padding(
          padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
          child: Center(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextField(
                  controller:
                      _name, // Assign the TextEditingController to the input field
                  decoration: const InputDecoration(labelText: "Name"),
                ),
              ),
              Text(error) // Display the error message if it's not empty
            ],
          ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to a new page when the "+" button is pressed
          if (_name.text.isEmpty) {
            error = "Name is required."; // Set the error message
            setState(() {}); // Trigger a rebuild to display the error
            return;
          }
          await ExperimentService.addNewExperiment(_name
              .text); // Call the addNewExperiment method from ExperimentService
          Navigator.pop(context, true); // Close the current page
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: const Text("ADD"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}