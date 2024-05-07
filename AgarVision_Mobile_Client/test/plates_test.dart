import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agar_vision/screens/plates.dart';
import 'package:agar_vision/schema/Experiment.dart';
import 'package:agar_vision/schema/Plate.dart';
import 'package:agar_vision/services/backend/ExperimentService.dart';

void main() {
  group('PlatesPage', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      final Experiment experiment = Experiment(
        name: "test",
        id: "-NrPTx-ndFhdGrjUqNAY",
        createdBy: "smaan",
        createdDate: DateTime.now(),
        thumbnail: 'output.jpeg',
      );

      await tester.pumpWidget(MaterialApp(
        home: PlatesPage(currentExperiment: experiment),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Experiments plates'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('displays the correct number of plates',
        (WidgetTester tester) async {
      final Experiment experiment = Experiment(
        name: "test",
        id: "-NrPTx-ndFhdGrjUqNAY",
        createdBy: "smaan",
        createdDate: DateTime.now(),
        thumbnail: 'output.jpeg',
      );

      final List<Plate> plates = [
        Plate(
          id: "plate1",
          experimentId: experiment.id,
          type: "type1",
          bacteria: ["bacteria1"],
          createdDate: DateTime.now(),
          image: "image1",
        ),
        Plate(
          id: "plate2",
          experimentId: experiment.id,
          type: "type2",
          bacteria: ["bacteria2"],
          createdDate: DateTime.now(),
          image: "image2",
        ),
      ];

      ExperimentService.getExperimentPlates = () async => plates;

      await tester.pumpWidget(MaterialApp(
        home: PlatesPage(currentExperiment: experiment),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(2));
    });

    testWidgets('navigates to TakePlatePicturePage when the floating action button is pressed',
        (WidgetTester tester) async {
      final Experiment experiment = Experiment(
        name: "test",
        id: "-NrPTx-ndFhdGrjUqNAY",
        createdBy: "smaan",
        createdDate: DateTime.now(),
        thumbnail: 'output.jpeg',
      );

      await tester.pumpWidget(MaterialApp(
        home: PlatesPage(currentExperiment: experiment),
      ));

      await tester.tap(find.byType(FloatingActionButton));

      await tester.pumpAndSettle();

      expect(find.byType(TakePlatePicturePage), findsOneWidget);
    });
  });
}