import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agar_vision/screens/result_page.dart';
import 'package:agar_vision/schema/Experiment.dart';
import 'package:agar_vision/schema/Plate.dart';

void main() {
  group('TheResultNEW', () {
    // Test to check if the TheResultNEW widget renders correctly
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: TheResultNEW(
          image: Image.asset('assets/image.png'),
          plate: Plate(),
          currentExperiment: Experiment(),
        ),
      ));

      // Check if the ResultPage widget is present
      expect(find.byType(ResultPage), findsOneWidget);
    });
  });

  group('ResultPage', () {
    // Test to check if the ResultPage widget renders correctly
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ResultPage(
          image: Image.asset('assets/image.png'),
          plate: Plate(),
          currentExperiment: Experiment(),
        ),
      ));

      // Check if the Scaffold widget is present
      expect(find.byType(Scaffold), findsOneWidget);
      // Check if the AppBar widget is present
      expect(find.byType(AppBar), findsOneWidget);
      // Check if the Card widget is present
      expect(find.byType(Card), findsOneWidget);
      // Check if the GridView widget is present
      expect(find.byType(GridView), findsOneWidget);
      // Check if the ElevatedButton widget is present
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    // Test to check if the help dialog is displayed when the help button is pressed
    testWidgets('displays help dialog when help button is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ResultPage(
          image: Image.asset('assets/image.png'),
          plate: Plate(),
          currentExperiment: Experiment(),
        ),
      ));

      // Tap the help button
      await tester.tap(find.byIcon(Icons.help));
      await tester.pumpAndSettle();

      // Check if the AlertDialog widget is present
      expect(find.byType(AlertDialog), findsOneWidget);
      // Check if the text "Help" is present
      expect(find.text("Help"), findsOneWidget);
    });

    // Test to check if the export results button is displayed
    testWidgets('displays export results button', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ResultPage(
          image: Image.asset('assets/image.png'),
          plate: Plate(),
          currentExperiment: Experiment(),
        ),
      ));

      // Check if the ElevatedButton widget is present
      expect(find.byType(ElevatedButton), findsOneWidget);
      // Check if the text "Export Results" is present
      expect(find.text("Export Results"), findsOneWidget);
    });
  });
}