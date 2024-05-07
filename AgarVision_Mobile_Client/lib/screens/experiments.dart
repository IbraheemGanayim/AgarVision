// Import Flutter material design and other necessary packages
import 'package:agar_vision/schema/Experiment.dart';
import 'package:agar_vision/screens/plates.dart';
import 'package:agar_vision/services/Authentication.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../services/backend/ExperimentService.dart';
import 'newexperiment.dart';

// Define a stateless widget for the Experiments screen
class Experiments extends StatelessWidget {
  const Experiments({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp widget to include navigation, styling, and other app-wide settings
    return MaterialApp(
      title: 'Bacteria Experiment', // Title of the app seen in the task manager
      debugShowCheckedModeBanner:
          false, // Disables the debug banner for cleaner UI
      theme: ThemeData(
        primarySwatch:
            Colors.blue, // Defines the primary color of the app theme
      ),
      home: const _MyHomePage(), // Set the home page of the app
    );
  }
}

// Private StatefulWidget class for the home page
class _MyHomePage extends StatefulWidget {
  const _MyHomePage({super.key});

  @override
  // State creation method
  _MyHomePageState createState() => _MyHomePageState();

  // Asynchronous method to retrieve experiments from the backend
  Future<List<Experiment>> getExpirements() async {
    return await ExperimentService.getExperiments();
  }
}

// State class for _MyHomePage where the state management is handled
class _MyHomePageState extends State<_MyHomePage> {
  bool _loading = false; // State to track loading status
  List<Experiment> experiments = []; // List to store experiments

  @override
  void initState() {
    super.initState();
    getData(); // Load data when the widget is initialized
  }

  // Pull to refresh method to reload data
  Future<void> _pullRefresh() async {
    if (!_loading) await getData();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold provides structure for the main UI components like AppBar, FloatingActionButton, etc.
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Experiments (${experiments.length})', // Display the number of experiments
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.green, // AppBar background color
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              // Dialog to provide help information
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Help'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Click on an experiment to view its details."),
                        Text(
                            "or Click the + button to create a new experiment."),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          AuthenticationService
              .logOutButton() // Logout button from authentication service
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _pullRefresh, // Refresh action for the list
              child: Skeletonizer(
                  enabled: _loading,
                  child: list()), // Display list of experiments
            ),
          ),
          SizedBox(
              width: double.infinity, // Match the width of the parent
              height: 50,
              child:
                  refreshButtonOrNewExperiment() // Button to either refresh or add a new experiment
              )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerFloat, // Position of the floating action button
    );
  }

  // Widget to decide which button to display based on the loading state
  Widget refreshButtonOrNewExperiment() {
    return _loading ? refreshButton() : addNewExperimentButton();
  }

  // Widget for the refresh button
  Widget refreshButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        padding:
            MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
      ),
      onPressed: _pullRefresh, // Refresh data when pressed
      child: const Icon(Icons.refresh),
    );
  }

  // Widget for the button to add a new experiment
  Widget addNewExperimentButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        padding:
            MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
      ),
      onPressed: () async {
        // Navigate to add a new experiment and refresh list if a new experiment is added
        bool addedNewExperiment = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewExperiment(context: context)),
        );
        if (addedNewExperiment) await _pullRefresh();
      },
      child: const Icon(Icons.add),
    );
  }

  // Widget to display the list of experiments or a message if the list is empty
  Widget list() {
    if (_loading) {
      return ListView.builder(
          itemCount: 7, // Number of placeholders
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
    return emptyListTextOrListView();
  }

  // Widget to show an empty list message or a list view of experiments
  Widget emptyListTextOrListView() {
    if (experiments.isEmpty) {
      return const Center(
        child: Text("Empty list, press \"+\" button to add new experiments"),
      );
    }
    return ListView.builder(
      itemCount: experiments.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            // Navigate to experiment details when an item is tapped
            await Navigator.push(
              context,
              MaterialPageRoute(
                settings: const RouteSettings(name: "plates"),
                builder: (context) =>
                    PlatesPage(currentExperiment: experiments[index]),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: ExperimentService.getExperimentThumbnail(
                      experiments[index].thumbnail),
                ),
                title: Text(experiments[index].name),
                subtitle:
                    Text(experiments[index].createdDate.toLocal().toString()),
              ),
            ),
          ),
        );
      },
    );
  }

  // Asynchronous method to fetch data and update the state
  Future<List<Experiment>> getData() async {
    _loading = true;
    setState(() {}); // Trigger a rebuild
    var x = await widget.getExpirements(); // Fetch experiments
    _loading = false;
    experiments = x;
    setState(() {}); // Trigger a rebuild with new data
    return experiments;
  }
}