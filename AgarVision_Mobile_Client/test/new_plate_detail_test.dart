import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agar_vision/components/FutureTextButton.dart';
import 'package:agar_vision/components/select_plate_part.dart';
import 'package:agar_vision/schema/Experiment.dart';
import 'package:agar_vision/screens/new_plate_detail.dart';
import 'package:agar_vision/services/backend/ExperimentService.dart';
import 'package:agar_vision/schema/Plate.dart';
import 'package:agar_vision/components/bacteria_item.dart';

void main() {
  group('NewPlateDetail', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: NewPlateDetail(
          currentExperiment: Experiment(
              name: "test",
              id: "-NrPTx-ndFhdGrjUqNAY",
              createdBy: "smaan",
              createdDate: DateTime.now(),
              thumbnail: 'output.jpeg'),
          plateImageBase64:
              "iVBORw0KGg.... (base64 encoded image data) ...GgoAQ==",
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('New Plate'), findsOneWidget);
      expect(find.byType(FutureTextButton), findsNWidgets(1));
      expect(find.byType(SelectPlatePart), findsNWidgets(4));
    });

    testWidgets('displays the correct number of bacteria items',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: NewPlateDetail(
          currentExperiment: Experiment(
              name: "test",
              id: "-NrPTx-ndFhdGrjUqNAY",
              createdBy: "smaan",
              createdDate: DateTime.now(),
              thumbnail: 'output.jpeg'),
          plateImageBase64:
              "iVBORw0KGg.... (base64 encoded image data) ...GgoAQ==",
        ),
      ));

      expect(find.byType(BacteriaItem), findsNWidgets(1));
    });

    testWidgets('displays the correct number of plate parts',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: NewPlateDetail(
          currentExperiment: Experiment(
              name: "test",
              id: "-NrPTx-ndFhdGrjUqNAY",
              createdBy: "smaan",
              createdDate: DateTime.now(),
              thumbnail: 'output.jpeg'),
          plateImageBase64:
              "iVBORw0KGg.... (base64 encoded image data) ...GgoAQ==",
        ),
      ));

      expect(find.byType(SelectPlatePart), findsNWidgets(4));
    });
  });
}