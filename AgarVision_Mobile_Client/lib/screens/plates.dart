import 'package:agar_vision/schema/Experiment.dart';
import 'package:agar_vision/schema/Plate.dart';
import 'package:agar_vision/screens/experiments.dart';
import 'package:agar_vision/screens/plate_resultsNEW.dart';
import 'package:agar_vision/screens/take_plate_picture.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart'; // A package for displaying skeleton screens
import '../services/backend/ExperimentService.dart'; // A service for interacting with the backend
import 'login.dart'; // A screen for the login page

// The PlatesPage widget displays a list of plates associated with a specific experiment.
// ignore: must_be_immutable
class PlatesPage extends StatefulWidget {
  Experiment currentExperiment; // The current experiment

  PlatesPage({super.key, required this.currentExperiment});

  // This method creates and returns a State object for this widget.
  @override
  State<StatefulWidget> createState() {
    return _PlatesPageState();
  }

  // A method to retrieve the plates of the current experiment from the backend.
  Future<List<Plate>> getExperimentPlates() async {
    return await ExperimentService.getExperimentPlates(currentExperiment.id);
  }
}

// The _PlatesPageState class is the private implementation of the PlatesPage.
class _PlatesPageState extends State<PlatesPage> {
  _PlatesPageState(); // Constructor

  bool _loading = false; // A flag to check if the data is still loading
  List<Plate> plates = []; // A list to store the plates
  int _keyCounter = 0; // A counter to generate unique keys for each plate

  // This method is called right after the widget is inserted in the tree.
  @override
  void initState() {
    _loading = true; // Set loading to true
    widget.getExperimentPlates().then((value) => {
          _loading = false,
          plates = value,
          setState(() {})
        }); // Get the plates from the backend and update the state
    super.initState();
  }

  // This method builds and returns the widget tree of the PlatesPage.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('Experiments plates',
                style: TextStyle(
                    color: Colors.white))), // The title of the app bar
        backgroundColor: Colors.green, // The background color of the app bar
        leading: IconButton(
          // The back button
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Experiments()), // Navigate back to the Experiments screen
            );
          },
        ),
        actions: [
          // Actions on the right side of the app bar
          IconButton(
            icon: Icon(
              Icons.help,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Help'), // The title of the dialog
                    content: Text(
                        'Click on a plate to view count results\nor Click the + button to add a new plate.\nSwipe plate right to delete.'), // The content of the dialog
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginPage(
                        title:
                            'Login')), // Navigate to the Login screen and remove all existing routes from the stack
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        // The body of the PlatesPage
        children: [
          Expanded(
              child: Skeletonizer(
                  enabled: _loading,
                  child:
                      list())), // Display a skeleton screen while loading the data
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // The floating action button
        onPressed: () {
          // Navigate to the TakePlatePicturePage when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TakePlatePicturePage(
                  currentExperiment: widget.currentExperiment),
            ),
          );
        },
        backgroundColor: Colors.green, // The background color of the button
        foregroundColor: Colors.white, // The foreground color of the button
        child: const Icon(Icons.add), // The icon of the button
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerFloat, // The location of the button
    );
  }

  // A method to build a list of plates
  Widget list() {
    if (_loading) {
      // If the data is still loading, display a list of skeleton tiles
      return ListView.builder(
          itemCount: 7,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text('Item number $index as title'),
                subtitle: const Text('Subtitle here'),
                trailing: const Icon(Icons.ac_unit),
              ),
            );
          });
    }
    return emptyTextOrList(); // Otherwise, display the list of plates
  }

  // A method to build an empty text or the list of plates
  Widget emptyTextOrList() {
    if (plates.isEmpty) {
      // If the list of plates is empty, display an empty text
      return const Column(children: [
        const SizedBox(height: 20),
        Center(
          child: Text("Empty list, press \"+\" to add a new plate"),
        )
      ]);
    }
    // Otherwise, display the list of plates
    return ListView.builder(
      itemCount: plates.length,
      itemBuilder: (context, index) {
        final key = _generateKey(); // Generate a unique key for each plate
        return Dismissible(
          key: Key(key.toString()), // Use the key to identify the plate
          direction: DismissDirection
              .startToEnd, // The direction to swipe to dismiss the plate
          background: Container(
            color: Colors.red, // The background color of the dismissible
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Icon(Icons.delete, color: Colors.white),
              ),
            ),
          ),
          onDismissed: (direction) {
            // Show a confirmation dialog when the plate is dismissed
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('This action cannot be undone.'),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Text('Cancel'),
                      onPressed: () {
                        setState(() {}); // Update the state to keep the plate
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Text('Delete'),
                      onPressed: () {
                        // Delete the plate when the button is pressed
                        setState(() {
                          plates.removeAt(
                              index); // Remove the plate from the list
                        });
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: GestureDetector(
            onTap: () async {
              // Navigate to the PlateResultsNEW screen when the plate is tapped
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TheResultNEW(
                        image: Image.network(plates[index].image),
                        currentExperiment: widget.currentExperiment,
                        plate: plates[index]),
                  ));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  leading: ClipRRect(
                      // Display the image of the plate
                      borderRadius: BorderRadius.circular(8.0),
                      child: ExperimentService.getPlateImage(
                          experimentId: widget.currentExperiment.id,
                          plate: plates[index])),
                  title: Text(plates[index].type +
                      " | " +
                      plates[index].bacteria.join(
                          ", ")), // Display the type and bacteria of the plate
                  subtitle: Text(plates[index]
                      .createdDate
                      .toLocal()
                      .toString()), // Display the creation date of the plate
                  trailing: PopupMenuButton<int>(
                    // Display a popup menu when the user taps the three dots button
                    itemBuilder: (context) => [
                      PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 1) {
                        // Show a confirmation dialog when the user selects "Delete" from the popup menu
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Are you sure?'),
                              content: Text('This action cannot be undone.'),
                              actions: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    setState(
                                        () {}); // Update the state to keep the plate
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  child: Text('Delete'),
                                  onPressed: () {
                                    // Delete the plate when the button is pressed
                                    setState(() {
                                      plates.removeAt(
                                          index); // Remove the plate from the list
                                    });
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // A method to generate a unique key
  int _generateKey() {
    _keyCounter++; // Increment the counter
    return _keyCounter; // Return the counter
  }
}