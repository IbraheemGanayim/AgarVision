// Importing necessary Dart and Flutter packages
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:agar_vision/schema/Experiment.dart';
import 'package:agar_vision/schema/Plate.dart';
import 'package:file_saver/file_saver.dart';
import 'package:path_provider/path_provider.dart';
import '../services/backend/ExperimentService.dart';
import '../schema/PlatePredictionResult.dart';
import 'plates.dart'; // Link to PlatesPage is assumed to be correct

// Define a stateless widget to initiate the result page with required data
class TheResultNEW extends StatelessWidget {
  final Image image; // Image to be displayed on the result page
  final Plate plate; // Plate data used in the experiment
  final Experiment
      currentExperiment; // Experiment data associated with this result

  // Constructor to initialize the widget with required parameters
  const TheResultNEW({
    required this.image,
    required this.plate,
    required this.currentExperiment,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MaterialApp to set the theme and home page of the app
    return MaterialApp(
      title: 'Result Page',
      debugShowCheckedModeBanner: false, // Hides the debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue, // Primary theme color
      ),
      home: ResultPage(
        image: image,
        currentExperiment: currentExperiment,
        plate: plate,
      ),
    );
  }
}

// StatefulWidget to manage the state of result data
class ResultPage extends StatefulWidget {
  final Image image;
  final Experiment currentExperiment;
  final Plate plate;

  // Constructor for initializing the stateful widget
  const ResultPage({
    required this.image,
    required this.currentExperiment,
    required this.plate,
    Key? key,
  }) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late List<Map<String, dynamic>> result; // List to hold result data
  int selectedCardIndex = 0; // Index to track the selected card in the UI

  @override
  void initState() {
    super.initState();
    result = generateResult(
        widget.plate.parts); // Generate results when the widget is initialized
  }

  // Method to generate results based on the plate data
  List<Map<String, dynamic>> generateResult(List<PlatePart> parts) {
    List<Map<String, dynamic>> result = [];
    final volumeOfCulturePlate =
        1.0; // Assuming a volume of 1mL for calculation
    int colonies = 30; // Example colonies count
    int example = 22; // Example example value (placeholder for actual data)
    int dilution = 5; // Example dilution factor
    double cfu =
        (colonies * dilution) / volumeOfCulturePlate; // Calculating CFU
    parts.asMap().forEach((index, element) {
      result.add({
        'name': 'Q${index + 1}',
        'colonies': element.dropsCount.join(","),
        'example': element.example,
        'dilution': element.dilution
      });
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis Results', style: TextStyle(color: Colors.white)),
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
              // Help dialog to explain the result parameters
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Help"),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Here's what each quarter parameter means:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("\nColonies: Number Of Detected Colonies."),
                        Text("\nExample: Example of the bacteria drop."),
                        Text("\nDilution: Dilution of the bacteria drop."),
                        Text("\nCFU: (# of colonies * dilution ) / example."),
                        Text("\n\nClick Export Result to export report.",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: const Text("OK"),
                        onPressed: () =>
                            Navigator.of(context).pop(), // Closes the dialog
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<PlatePredictionResult>(
        future: ExperimentService.getPredictedPlateImage(
            experimentId: widget.currentExperiment.id,
            plate: widget.plate,
            height: null,
            width: null),
        builder: (BuildContext context,
            AsyncSnapshot<PlatePredictionResult> snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.done) {
            result = generateResult(snapshot.data!.QuartersResults);
            return Column(children:view(snapshot.data!));
          } else {
            return Center(
                child: CircularProgressIndicator());
          }
        },
      )
    );
  }
  List<Widget> view(PlatePredictionResult data){
    return <Widget>[
      Flexible(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                        child: Image.memory(base64Decode(
                            data.resultImageBas64))
                    ),
                    ListTile(
                      title: Text(widget.plate.bacteria[0]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Agar Type: ${widget.plate.type}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: getChildren()),
            ],
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            minimumSize: Size.fromHeight(50),
          ),
          onPressed: () async {
            // Show the "Are you sure?" dialog
            bool? shouldExport = await showDialog<bool?>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Export Results?'),
                  content:
                  const Text('This will export the results to a file.'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop(
                            false); // Close the dialog and return false
                      },
                    ),
                    TextButton(
                      child: const Text('Export'),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(true); // Close the dialog and return true
                      },
                    ),
                  ],
                );
              },
            );

            // If the user clicked "Yes", proceed with exporting the results
            if (shouldExport ?? false) {
              // Create a string to hold the results
              String resultsString = result.map((entry) {
                return 'Name: ${entry['name']}\nColonies: ${entry['colonies']}\nExample: ${entry['example']}\nDilution: ${entry['dilution']}\nCFU: ${entry['cfu']}\n';
              }).join('\n');

              // Convert the string to bytes
              Uint8List bytes = utf8.encode(resultsString);

              // Get the directory where we can save the file
              String? directory;
              if (!kIsWeb) {
                directory = (await getApplicationDocumentsDirectory()).path;
              }

              // Save the file
              String? filePath = await FileSaver.instance.saveFile(
                  name: 'results',
                  bytes: bytes,
                  ext: 'txt',
                  mimeType: MimeType.text,
                  filePath: directory);

              // Show a dialog to indicate that the file has been created
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Notice"),
                    content: Text(
                        "Results have been exported to a file at $filePath."),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("OK"),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: const Text('Export Results'),
        ),
      )
    ];
  }
  Widget platePartView(dynamic item) {
    if (item == null)
      return Card(

        child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(''),
          const SizedBox(height: 8),
          Text(''),
          const SizedBox(height: 4),
          Text(''),
          const SizedBox(height: 4),
          Text(''),
        ],
      ));
    return Card(

        child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(item['name'], style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Colonies: ${item['colonies']}'),
        const SizedBox(height: 4),
        Text('Example: ${item['example']}'),
        const SizedBox(height: 4),
        Text('Dilution: ${item['dilution']}'),
      ],
    ));
  }

  List<Widget> getChildren() {
    List<Widget> results = [];
    results.add(platePartView(getOrNull(result, 0)));
    results.add(platePartView(getOrNull(result, 2)));
    results.add(platePartView(getOrNull(result, 1)));
    results.add(platePartView(getOrNull(result, 3)));
    return results;
  }

  dynamic getOrNull(List<Map<String, dynamic>> result, int i) {
    if (result.length > i)
      return result[i];
    else
      return null;
  }
}
