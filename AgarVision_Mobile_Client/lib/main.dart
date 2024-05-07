import 'package:agar_vision/screens/experiments.dart';
import 'package:agar_vision/screens/login.dart';
import 'package:agar_vision/services/Authentication.dart';
import 'package:agar_vision/services/interceptors/ContentTypeInterceptor.dart';
import 'package:agar_vision/services/interceptors/JWTInterceptor.dart';
import 'package:agar_vision/services/interceptors/RefreshTokenInterceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'AppLocale.dart';

// Creates an instance of an authorized HTTP client with interceptors for
// JWT, refresh token, and content type.
final httpAuthorizedClient = InterceptedClient.build(interceptors: [
  JWTInterceptor(),
  RefreshTokenInterceptor(),
  ContentTypeInterceptor()
]);

// Creates an instance of an authorized HTTP client with only the JWT interceptor.
final httpAuthorizedClientNoContentType = InterceptedClient.build(
  interceptors: [JWTInterceptor()],
);

// Provides application settings, such as the navigator state and authentication token.
class AppSettings {
  static GlobalKey<NavigatorState> navigatorState = GlobalKey<NavigatorState>();
  static String? token;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Checks if the user is logged in and navigates to the appropriate screen.
  AuthenticationService.instance().isLoggedIn().then((value) {
    if (value != null) {
      runApp(MyApp(root: const Experiments()));
    } else {
      runApp(MyApp(root: const LoginPage(title: 'Login')));
    }
  });
}

// Defines the main application widget.
class MyApp extends StatelessWidget {
  final Widget root;
  final FlutterLocalization localization = FlutterLocalization.instance;

  // Initializes the localization instance.
  MyApp({super.key, required this.root});

  void initState() {
    localization.init(
      mapLocales: [
        const MapLocale('en', AppLocale.EN),
        const MapLocale('km', AppLocale.KM),
        const MapLocale('ja', AppLocale.JA),
      ],
      initLanguageCode: 'en',
    );
    localization.onTranslatedLanguage = _onTranslatedLanguage;
  }

  // Called when the language is translated.
  void _onTranslatedLanguage(Locale? locale) {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgarVision',
      debugShowCheckedModeBanner: false,
      navigatorKey: AppSettings.navigatorState,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green, background: Colors.white),
        useMaterial3: true,
      ),
      home: root,
      // supportedLocales: localization.supportedLocales,
    );
  }
}
