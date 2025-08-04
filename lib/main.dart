import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:weather_app/screens/auth_screen.dart';
import 'package:weather_app/screens/weather_screen.dart';
import 'package:weather_app/screens/history_screen.dart';
import 'package:weather_app/screens/account_screen.dart';

import 'package:weather_app/services/auth_service.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/models/weather_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Attempt to fetch default weather for London
  Weather defaultWeather = Weather(
    cityName: 'London',
    temperature: 20.0,
    condition: 'Clouds',
    icon: '02d',
    humidity: 65,
    windSpeed: 5.5,
    lastUpdated: DateTime.now(),
  );

  try {
    defaultWeather = await WeatherService(
      apiKey: '8bbd47e936fda67e8974acbfb1b8c887',
    ).getWeather('London');
  } catch (e) {
    print('Error loading default weather: $e');
    // Uses hardcoded defaultWeather above
  }

  runApp(MyApp(defaultWeather: defaultWeather));
}

class MyApp extends StatelessWidget {
  final Weather defaultWeather;
  final AuthService? authService; // Allow dependency injection

  const MyApp({
    Key? key,
    required this.defaultWeather,
    this.authService, // Optional parameter for testing
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use injected service or create default instance
    final auth = authService ?? AuthService();

    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true, // Enable Material 3 design
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: auth.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            );
          }
          return snapshot.hasData
              ? WeatherScreen(
                  initialWeather: defaultWeather,
                  key: const ValueKey('weatherScreen'),
                )
              : AuthScreen(key: const ValueKey('authScreen'));
        },
      ),
      routes: {
        '/auth': (context) => AuthScreen(key: const ValueKey('authRoute')),
        '/weather': (context) => WeatherScreen(
          initialWeather: defaultWeather,
          key: const ValueKey('weatherRoute'),
        ),
        '/history': (context) =>
            HistoryScreen(key: const ValueKey('historyRoute')),
        '/account': (context) =>
            AccountScreen(key: const ValueKey('accountRoute')),
      },
    );
  }
}
