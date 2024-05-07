import 'dart:convert';
import 'package:agar_vision/components/FutureTextButton.dart';
import 'package:agar_vision/components/select_plate_part.dart';
import 'package:agar_vision/schema/Experiment.dart';
import 'package:agar_vision/screens/plate_resultsNEW.dart';
import 'package:agar_vision/services/backend/ExperimentService.dart';
import 'package:flutter/material.dart';
import '../schema/Plate.dart';
import 'set_params.dart';

void main() {
  runApp(NewPlateDetail(
      currentExperiment: Experiment(
          name: "test",
          id: "-NrPTx-ndFhdGrjUqNAY",
          createdBy: "smaan",
          createdDate: DateTime.now(),
          thumbnail: 'output.jpeg'),
      plateImageBase64:
          "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"));
}

// This is a stateful widget that represents a new plate detail.
// ignore: must_be_immutable
class NewPlateDetail extends StatefulWidget {
  // The current experiment.
  Experiment currentExperiment;
  // The base64 encoded string of the plate image.
  String plateImageBase64;

  // The constructor for NewPlateDetail.
  NewPlateDetail(
      {required this.currentExperiment, required String this.plateImageBase64});

  @override
  // This method creates the state for this widget.
  // ignore: library_private_types_in_public_api
  _NewPlateDetailState createState() => _NewPlateDetailState();
}

// This is the state for the NewPlateDetail widget.
class _NewPlateDetailState extends State<NewPlateDetail> {
  // The selected agar type.
  String _agarType = 'MRS';
  // The count of bacteria.
  // int _count = 1;
  // A list of bacteria items.
  final List<BacteriaItem> _bacteriaItems = [
    // BacteriaItem(name: 'Bacteria #1'),
    BacteriaItem(name: 'Choose Bacteria  '),
  ];

  Map<int, PlatePart> parts = Map();

  SelectPlateController part1 = new SelectPlateController();
  SelectPlateController part2 = new SelectPlateController();
  SelectPlateController part3 = new SelectPlateController();
  SelectPlateController part4 = new SelectPlateController();


  @override
  // This method builds the widget tree for this widget.
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Plate', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              // Show a dialog with instructions.
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Instructions"),
                    content: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align content to the left
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("To create a new plate:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("\n1. Choose the bacteria type to look for."),
                        Text(
                            "2. Enter the example and dilution for each quarter."),
                        Text(
                            "3. Choose a count strategy (Auto, Manual, or Deshe) for each quarter."),
                        Text(
                            "4. If the count strategy is Manual, enter the colony count for each drop."),
                        Text("\nHit Save to start analysis.",
                            style: TextStyle(fontWeight: FontWeight.bold)),
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10.0),
                  // Display selected bacteria options
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _bacteriaItems,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Divider(
                    color: Colors.grey, // Color of the divider
                    thickness: 1.0, // Thickness of the divider
                    indent: 20, // Left indentation
                    endIndent: 20, // Right indentation
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Quarters Params',
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  
                  const Divider(
                    color: Colors.green, // Color of the divider
                    thickness: 3.0, // Thickness of the divider
                    indent: 20, // Left indentation
                    endIndent: 20, // Right indentation
                  ),
                  const SizedBox(height: 16.0),
                  SelectPlatePart(index: 1,controller: part1,text:"LT"),
                  const Divider(
                    color: Colors.green, // Color of the divider
                    thickness: 1.0, // Thickness of the divider
                    indent: 20, // Left indentation
                    endIndent: 20, // Right indentation
                  ),
                  SelectPlatePart(index: 2,controller: part2,text:"LB"),
                  const Divider(
                    color: Colors.green, // Color of the divider
                    thickness: 1.0, // Thickness of the divider
                    indent: 20, // Left indentation
                    endIndent: 20, // Right indentation
                  ),
                  SelectPlatePart(index: 3,controller: part3,text:"RB"),
                  const Divider(
                    color: Colors.green, // Color of the divider
                    thickness: 1.0, // Thickness of the divider
                    indent: 20, // Left indentation
                    endIndent: 20, // Right indentation
                  ),
                  SelectPlatePart(index: 4,controller: part4,text:"RT"),
                ],
              ),
            ),
          ),
          Container(
            width: 250,
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureTextButton(
                text: "Save",
                onPress: () async {
                  // Your save button's onPressed function
                  var plate = getCurrentPlate();
                  try {
                    var value = await ExperimentService.addNewPlate(
                        widget.currentExperiment.id, plate);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TheResultNEW(
                          image: Image.memory(
                              base64Decode(widget.plateImageBase64)),
                          currentExperiment: widget.currentExperiment,
                          plate: plate.toPlateViewModel(value.image),
                        ),
                      ),
                    );
                  } catch (e) {
                    // Handle exceptions or errors if necessary
                  }
                },
                icon: const Icon(Icons.save, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // This method returns the current plate.
  AddNewPlate getCurrentPlate() {
    refreshParts();
    return AddNewPlate(
        image: widget.plateImageBase64,
        bacteria:
            _bacteriaItems.map((item) => item.selectedBacteriaType()).toList(),
        parts: parts.entries.map((e) => e.value).toList(),
        type: _agarType);
  }

  void refreshParts() {
    parts.clear();
    parts.putIfAbsent(0, () => part1.getPlatePart());
    parts.putIfAbsent(1, () => part2.getPlatePart());
    parts.putIfAbsent(2, () => part3.getPlatePart());
    parts.putIfAbsent(4, () => part4.getPlatePart());

  }
}

// This is a stateful widget that represents a single bacteria item.
// ignore: must_be_immutable
class BacteriaItem extends StatefulWidget {
  final String name;

  BacteriaItem({Key? key, required this.name}) : super(key: key);
  // The state for this widget.
  var _bacteriaItemState = _BacteriaItemState();

  @override
  // This method creates the state for this widget.
  _BacteriaItemState createState() {
    return _bacteriaItemState;
  }

  // This method returns the selected bacteria type.
  String selectedBacteriaType() {
    return _bacteriaItemState._selectedType;
  }
}

// This is the state for the BacteriaItem widget.
class _BacteriaItemState extends State<BacteriaItem> {
  // The selected bacteria type.
  String _selectedType = 'A';

  @override
  // This method builds the widget tree for this widget.
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.name + " ",
          style: const TextStyle(fontSize: 20.0),
          textAlign: TextAlign.center,
        ),
        DropdownButton<String>(
          value: _selectedType,
          onChanged: (String? value) {
            setState(() {
              _selectedType = value!;
            });
          },
          items: const [
            DropdownMenuItem(
              value: 'A',
              child: Text('Type A'),
            ),
            DropdownMenuItem(
              value: 'B',
              child: Text('Type B'),
            ),
            DropdownMenuItem(
              value: 'C',
              child: Text('Type C'),
            ),
          ],
        )
      ],
    ));
  }
}

// This is a placeholder class for PlatePartButton.
class PlatePartButton {}
