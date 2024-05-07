// Import Flutter material design and schema classes
import 'package:agar_vision/schema/Plate.dart';
import 'package:flutter/material.dart';

// Define a StatefulWidget to manage the state for setting parameters for an experiment plate
// ignore: must_be_immutable
class SetParams extends StatefulWidget {
  int index; // Index to identify and manage specific experiment parameters

  SetParams({required this.index});

  @override
  _SetParamsState createState() => _SetParamsState();
}

// The state class for SetParams where the logic and UI elements are managed
class _SetParamsState extends State<SetParams> {
  int _quarterHalf = 0; // Holds the current selection for counting method

  // Controllers for managing the text input fields
  TextEditingController example = TextEditingController();
  TextEditingController dilution = TextEditingController();
  TextEditingController drop1Count = TextEditingController();
  TextEditingController drop2Count = TextEditingController();
  TextEditingController drop3Count = TextEditingController();

  bool _showTextFields =
      false; // State to toggle visibility of text fields based on counting strategy

  @override
  Widget build(BuildContext context) {
    // Structure of the page with a Scaffold widget
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Area Parameters',
            style: TextStyle(color: Colors.white)), // AppBar with a title
        backgroundColor: Colors.green, // AppBar background color
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.help), // Help icon button in the AppBar
            onPressed: () {
              // Dialog to show help instructions for setting parameters
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
                            "Here are the instructions for setting area parameters."),
                        Text("\n1. Enter the example and dilution values."),
                        Text("2. Choose a count strategy."),
                        Text("\n- For automatic counting, select 'Auto'."),
                        Text(
                            "\n- For manual counting, select 'Manual' and input the drop counts."),
                        Text("\n- For deshe counting, select 'Deshe'."),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("OK"),
                        onPressed: () => Navigator.of(context)
                            .pop(), // Close the dialog when "OK" is pressed
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
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Example'),
                    controller: example,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                      decoration: InputDecoration(labelText: 'Dilution'),
                      controller: dilution,
                      keyboardType: TextInputType.number),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Count Strategy',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Radio(
                      value: 0,
                      groupValue: _quarterHalf,
                      onChanged: (value) {
                        setState(() {
                          _quarterHalf = value as int;
                          _showTextFields =
                              false; // Toggle visibility based on strategy selection
                        });
                      },
                    ),
                    const Text('Auto'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: _quarterHalf,
                      onChanged: (value) {
                        setState(() {
                          _quarterHalf = value as int;
                          _showTextFields =
                              true; // Toggle visibility based on strategy selection
                        });
                      },
                    ),
                    const Text('Manual'),
                  ],
                ),
                if (_showTextFields) ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: 'Input 1'),
                          keyboardType: TextInputType.number,
                          controller: drop1Count,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: 'Input 2'),
                          keyboardType: TextInputType.number,
                          controller: drop2Count,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: 'Input 3'),
                          keyboardType: TextInputType.number,
                          controller: drop3Count,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16)
                ],
                Row(
                  children: [
                    Radio(
                      value: 2,
                      groupValue: _quarterHalf,
                      onChanged: (value) {
                        setState(() {
                          _quarterHalf = value as int;
                          _showTextFields =
                              false; // Toggle visibility based on strategy selection
                        });
                      },
                    ),
                    const Text('Deshe'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 40,
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      // Create a PlatePart object with all user inputs and return it to the previous screen
                      PlatePart part = PlatePart(
                          example: example.value.text,
                          dilution: double.parse(dilution.value.text),
                          countMethod: getCountMethod(),
                          dropsCount: getDropsCount());
                      Navigator.pop<PlatePart>(context,
                          part); // Use Navigator to send the PlatePart object back
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Set'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Determines the counting method based on the radio selection
  CountingMethod getCountMethod() {
    switch (_quarterHalf) {
      case 0:
        return CountingMethod.Automatic;
      case 1:
        return CountingMethod.Manual;
      case 2:
        return CountingMethod.Deshe;
      default:
        return CountingMethod.Automatic;
    }
  }

  // Constructs a list of counts for manual counting strategy
  List<int> getDropsCount() {
    if (getCountMethod() != CountingMethod.Manual) {
      return [];
    }
    return [
      int.parse(drop1Count.text),
      int.parse(drop2Count.text),
      int.parse(drop3Count.text),
    ];
  }
}
