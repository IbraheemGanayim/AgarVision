// Import necessary testing libraries and the file to be tested
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agar_vision/screens/experiments.dart';

void main() {
  // Group of tests for the Experiments screen
  group('Experiments', () {
    // Test to check if the Experiments screen is rendered correctly
    testWidgets('renders Experiments screen', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Experiments()));
      expect(find.byType(Experiments), findsOneWidget);
    });

    // Test to check if the AppBar with title is rendered correctly
    testWidgets('renders AppBar with title', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Experiments()));
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Experiments (0)'), findsOneWidget);
    });

    // Test to check if the help dialog is rendered correctly
    testWidgets('renders help dialog', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Experiments()));
      await tester.tap(find.byIcon(Icons.help));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    // Test to check if the logout button is rendered correctly
    testWidgets('renders logout button', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Experiments()));
      expect(find.byType(IconButton), findsOneWidget);
    });

    // Test to check if the list of experiments is rendered correctly
    testWidgets('renders list of experiments', (WidgetTester tester) async {
      // Mock the ExperimentService to return a list of experiments
      final experimentService = ExperimentService();
      when(experimentService.getExperiments()).thenAnswer((_) async => [
        Experiment(name: 'Experiment 1', createdDate: DateTime.now()),
        Experiment(name: 'Experiment 2', createdDate: DateTime.now()),
      ]);

      await tester.pumpWidget(MaterialApp(home: Experiments()));
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Experiment 1'), findsOneWidget);
      expect(find.text('Experiment 2'), findsOneWidget);
    });

    // Test to check if the empty list message is rendered correctly
    testWidgets('renders empty list message', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Experiments()));
      expect(find.text("Empty list, press \"+\" button to add new experiments"),
          findsOneWidget);
    });

    // Test to check if the app navigates to the new experiment screen when the "+" button is tapped
    testWidgets('navigates to new experiment screen', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Experiments()));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.byType(NewExperiment), findsOneWidget);
    });

    // Test to check if the app navigates to the experiment details screen when an experiment is tapped
    testWidgets('navigates to experiment details screen', (WidgetTester tester) async {
      // Mock the ExperimentService to return a list of experiments
      final experimentService = ExperimentService();
      when(experimentService.getExperiments()).thenAnswer((_) async => [
        Experiment(name: 'Experiment 1', createdDate: DateTime.now()),
      ]);

      await tester.pumpWidget(MaterialApp(home: Experiments()));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();
      expect(find.byType(PlatesPage), findsOneWidget);
    });
  });
}