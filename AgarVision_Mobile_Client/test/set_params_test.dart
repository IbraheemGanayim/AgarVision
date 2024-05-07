import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agar_vision/screens/set_params.dart';
import 'package:agar_vision/schema/PlatePart.dart';
import 'package:agar_vision/schema/CountingMethod.dart';

void main() {
  group('SetParams', () {
    // Test to check if the SetParams widget renders correctly
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SetParams(index: 0),
      ));

      // Check if the Scaffold widget is present
      expect(find.byType(Scaffold), findsOneWidget);
      // Check if the text "Set Area Parameters" is present
      expect(find.text('Set Area Parameters'), findsOneWidget);
      // Check if the AppBar widget is present
      expect(find.byType(AppBar), findsOneWidget);
      // Check if 5 TextField widgets are present
      expect(find.byType(TextField), findsNWidgets(5));
      // Check if 3 Radio widgets are present
      expect(find.byType(Radio), findsNWidgets(3));
      // Check if the ElevatedButton widget is present
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    // Test to check if the help dialog is displayed when the help button is pressed
    testWidgets('displays help dialog when help button is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SetParams(index: 0),
      ));

      // Tap the help button
      await tester.tap(find.byIcon(Icons.help));
      await tester.pumpAndSettle();

      // Check if the AlertDialog widget is present
      expect(find.byType(AlertDialog), findsOneWidget);
      // Check if the text "Help" is present
      expect(find.text("Help"), findsOneWidget);
    });

    // Test to check if the SetParams widget navigates back with a PlatePart object when the set button is pressed
    testWidgets('navigates back with PlatePart object when set button is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SetParams(index: 0),
      ));

      // Find the TextField widget for the example input
      final TextEditingController exampleController = find.byWidgetPredicate(
        (Widget widget) =>
            widget is TextField &&
            widget.decoration?.labelText == 'Example',
      ).evaluate().first as TextEditingController;
      // Find the TextField widget for the dilution input
      final TextEditingController dilutionController = find.byWidgetPredicate(
        (Widget widget) =>
            widget is TextField &&
            widget.decoration?.labelText == 'Dilution',
      ).evaluate().first as TextEditingController;
      // Find the TextField widget for the drop 1 count input
      final TextEditingController drop1CountController = find.byWidgetPredicate(
        (Widget widget) =>
            widget is TextField &&
            widget.decoration?.labelText == 'Input 1',
      ).evaluate().first as TextEditingController;
      // Find the TextField widget for the drop 2 count input
      final TextEditingController drop2CountController = find.byWidgetPredicate(
        (Widget widget) =>
            widget is TextField &&
            widget.decoration?.labelText == 'Input 2',
      ).evaluate().first as TextEditingController;
      // Find the TextField widget for the drop 3 count input
      final TextEditingController drop3CountController = find.byWidgetPredicate(
        (Widget widget) =>
            widget is TextField &&
            widget.decoration?.labelText == 'Input 3',
      ).evaluate().first as TextEditingController;

      // Enter values into the input fields
      exampleController.text = "example";
      dilutionController.text = "dilution";
      drop1CountController.text = "drop1";
      drop2CountController.text = "drop2";
      drop3CountController.text = "drop3";

      // Find the set button and tap it
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check if the navigator pops back with the correct PlatePart object
      expect(find.byType(SetParams), findsNothing);
      expect(ModalRoute.of(find.byType(SetParams)).settings.arguments,
          isA<PlatePart>()
              .having((platePart) => platePart.index, 'index', 0)
              .having((platePart) => platePart.example, 'example', 'example')
              .having((platePart) => platePart.dilution, 'dilution', 'dilution')
              .having((platePart) => platePart.countingMethod, 'countingMethod',
                  CountingMethod.fixedCount)
              .having((platePart) => platePart.drop1Count, 'drop1Count', 'drop1')
              .having((platePart) => platePart.drop2Count, 'drop2Count', 'drop2')
              .having((platePart) => platePart.drop3Count, 'drop3Count', 'drop3'));
    });
  });
}