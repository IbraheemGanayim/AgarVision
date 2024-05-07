import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agar_vision/screens/take_plate_picture_page.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  group('TakePlatePicturePage', () {
    // Test to check if the TakePlatePicturePage widget renders correctly
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: TakePlatePicturePage(currentExperiment: Experiment()),
      ));

      // Check if the Scaffold widget is present
      expect(find.byType(Scaffold), findsOneWidget);
      // Check if the AppBar widget is present
      expect(find.byType(AppBar), findsOneWidget);
      // Check if the CameraPreview widget is present
      expect(find.byType(CameraPreview), findsOneWidget);
      // Check if the FloatingActionButton widgets are present
      expect(find.byType(FloatingActionButton), findsNWidgets(2));
    });

    // Test to check if the help dialog is displayed when the help button is pressed
    testWidgets('displays help dialog when help button is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: TakePlatePicturePage(currentExperiment: Experiment()),
      ));

      // Tap the help button
      await tester.tap(find.byIcon(Icons.help));
      await tester.pumpAndSettle();

      // Check if the AlertDialog widget is present
      expect(find.byType(AlertDialog), findsOneWidget);
      // Check if the text "Help" is present
      expect(find.text("Help"), findsOneWidget);
    });

    // Test to check if the camera can be used
    test('can use camera', () async {
      final canUseCameraFuture = canUseCamera();
      expect(await canUseCameraFuture, true);
    });

    // Test to check if the image can be taken
    test('takes picture', () async {
      final takePictureFuture = _takePicture();
      expect(await takePictureFuture, isNotNull);
    });

    // Test to check if the image can be uploaded
    test('uploads photo', () async {
      final uploadPhotoFuture = _uploadPhoto();
      expect(await uploadPhotoFuture, isNotNull);
    });
  });
}