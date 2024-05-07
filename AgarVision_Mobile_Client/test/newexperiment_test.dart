// Import necessary testing libraries and the file to be tested
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agar_vision/services/backend/ExperimentService.dart';
import 'package:agar_vision/screens/NewExperiment.dart';

void main() {
  // Group of tests for the NewExperiment screen
  group('NewExperiment', () {
    // Test to check if the NewExperiment screen is rendered correctly
    testWidgets('renders NewExperiment screen', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: NewExperiment(context: tester.binding.window.context)));
      expect(find.byType(NewExperiment), findsOneWidget);
    });

    // Test to check if the app bar is rendered correctly
    testWidgets('renders app bar', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: NewExperiment(context: tester.binding.window.context)));
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('New experiment'), findsOneWidget);
    });

    // Test to check if the help dialog is rendered correctly
    testWidgets('renders help dialog', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: NewExperiment(context: tester.binding.window.context)));
      await tester.tap(find.byIcon(Icons.help));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text("Help"), findsOneWidget);
    });

    // Test to check if the experiment name input field is rendered correctly
    testWidgets('renders experiment name input field', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: NewExperiment(context: tester.binding.window.context)));
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
    });

    // Test to check if the "ADD" button is rendered correctly
    testWidgets('renders ADD button', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: NewExperiment(context: tester.binding.window.context)));
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('ADD'), findsOneWidget);
    });

    // Test to check if the app shows an error message when the experiment name is empty
    testWidgets('shows error message when experiment name is empty', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: NewExperiment(context: tester.binding.window.context)));
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.text('Name is required.'), findsOneWidget);
    });

    // Test to check if the app navigates to the previous page when the "ADD" button is tapped
    testWidgets('navigates to previous page when ADD button is tapped', (WidgetTester tester) async {
      // Mock the ExperimentService to simulate a successful experiment creation
      final experimentService = ExperimentService();
      when(experimentService.addNewExperiment(any)).thenAnswer((_) async => true);

      await tester.pumpWidget(MaterialApp(home: NewExperiment(context: tester.binding.window.context)));
      await tester.enterText(find.byType(TextField), 'Test Experiment');
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(NewExperiment), findsNothing);
    });
  });
}