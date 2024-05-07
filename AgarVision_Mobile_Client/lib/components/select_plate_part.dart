// ignore: must_be_immutable
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../schema/Plate.dart';


class SelectPlatePart extends StatefulWidget {
  final int index;
  SelectPlateController controller;
  String text;
  SelectPlatePart({required this.index,required this.controller,required this.text});

  @override
  // ignore: library_private_types_in_public_api
  _SelectPlatePartState createState() => _SelectPlatePartState(index: index);
}


class _SelectPlatePartState extends State<SelectPlatePart> {
  final int index;


  _SelectPlatePartState({required this.index});

  int _countMethod1 = 0; // Holds the current selection for counting method

  // Controllers for managing the text input fields
  TextEditingController example = TextEditingController();
  TextEditingController dilution = TextEditingController();

  TextEditingController drop1Count = TextEditingController();
  TextEditingController drop2Count = TextEditingController();
  TextEditingController drop3Count = TextEditingController();

  bool _showTextFields1 =
      false; // State to toggle visibility of text fields based on counting strategy
  @override
  Widget build(BuildContext context) {
    widget.controller.getPart = (){
      return  PlatePart(
          example: example.value.text,
          dilution: double.parse(dilution.value.text),
          countMethod: getCountMethod(),
          dropsCount: getDropsCount());
    };
    // Check if an icon is provided and return the appropriate button widget.
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Q${widget.index} ${widget.text}',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'example 1'),
                controller: example,
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'Dilution 1'),
                controller: dilution,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'Count Strategy',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            Radio(
              value: 0,
              groupValue: _countMethod1,
              onChanged: (value) {
                setState(() {
                  _countMethod1 = value as int;
                  _showTextFields1 = false;
                });
              },
            ),
            const Text('Auto'),
            Radio(
              value: 1,
              groupValue: _countMethod1,
              onChanged: (value) {
                setState(() {
                  _countMethod1 = value as int;
                  _showTextFields1 = true;
                });
              },
            ),
            const Text('Manual'),
            Radio(
              value: 2,
              groupValue: _countMethod1,
              onChanged: (value) {
                setState(() {
                  _countMethod1 = value as int;
                  _showTextFields1 = false;
                });
              },
            ),
            const Text('Deshe'),
          ],
        ),
        if (_showTextFields1) ...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Drop 1 Count'),
                    keyboardType: TextInputType.number,
                    controller: drop1Count,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Drop 2 Colonies'),
                    keyboardType: TextInputType.number,
                    controller: drop2Count,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Drop 3 Colonies'),
                    keyboardType: TextInputType.number,
                    controller: drop3Count,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16)
        ],
      ],
    );
  }

  // Determines the counting method based on the radio selection
  CountingMethod getCountMethod() {
    switch (_countMethod1) {
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


class SelectPlateController{
  var getPart;

  PlatePart getPlatePart(){
    return getPart();
  }
}