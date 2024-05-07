// Import necessary testing libraries and the file to be tested
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agar_vision/screens/login.dart';

void main() {
  // Group of tests for the Login screen
  group('Login', () {
    // Test to check if the Login screen is rendered correctly
    testWidgets('renders Login screen', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Login()));
      expect(find.byType(Login), findsOneWidget);
    });

    // Test to check if the email input field is rendered correctly
    testWidgets('renders email input field', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Login()));
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });

    // Test to check if the password input field is rendered correctly
    testWidgets('renders password input field', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Login()));
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    // Test to check if the login button is rendered correctly
    testWidgets('renders login button', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Login()));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    // Test to check if the app navigates to the Experiments screen when the login button is tapped
    testWidgets('navigates to Experiments screen on successful login', (WidgetTester tester) async {
      // Mock the AuthenticationService to simulate a successful login
      final authenticationService = AuthenticationService();
      when(authenticationService.login(any, any)).thenAnswer((_) async => true);

      await tester.pumpWidget(MaterialApp(home: Login()));
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.byType(Experiments), findsOneWidget);
    });

    // Test to check if the app shows an error message when the login fails
    testWidgets('shows error message on failed login', (WidgetTester tester) async {
      // Mock the AuthenticationService to simulate a failed login
      final authenticationService = AuthenticationService();
      when(authenticationService.login(any, any)).thenAnswer((_) async => false);

      await tester.pumpWidget(MaterialApp(home: Login()));
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text('Login failed'), findsOneWidget);
    });
  });
}