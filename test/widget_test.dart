import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/screens/auth_screen.dart';
import 'package:weather_app/screens/weather_screen.dart';
import 'package:weather_app/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

class MockUser extends Mock implements User {}

void main() {
  late MockAuthService mockAuthService;
  final mockWeather = Weather(
    cityName: 'London',
    temperature: 20.0,
    condition: 'Clouds',
    icon: '02d',
    humidity: 65,
    windSpeed: 5.5,
    lastUpdated: DateTime.now(),
  );

  setUp(() {
    mockAuthService = MockAuthService();
  });

  testWidgets('Should show AuthScreen when not authenticated', (tester) async {
    // Arrange
    when(
      () => mockAuthService.authStateChanges,
    ).thenAnswer((_) => Stream.value(null));

    // Act
    await tester.pumpWidget(
      MyApp(defaultWeather: mockWeather, authService: mockAuthService),
    );

    // Assert
    expect(find.byType(AuthScreen), findsOneWidget);
  });

  testWidgets('Should show WeatherScreen when authenticated', (tester) async {
    // Arrange
    when(
      () => mockAuthService.authStateChanges,
    ).thenAnswer((_) => Stream.value(MockUser()));

    // Act
    await tester.pumpWidget(
      MyApp(defaultWeather: mockWeather, authService: mockAuthService),
    );
    await tester.pump(); // Needed for stream to emit

    // Assert
    expect(find.byType(WeatherScreen), findsOneWidget);
  });
}
